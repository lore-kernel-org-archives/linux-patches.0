Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430C12EAEE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2okFEU84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14CFC433C7;
	Wed, 15 Nov 2023 19:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077432;
	bh=mT0LBlORao+FWIAoB4Oqkg5okfUqN+7L+DDv+GG8bAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2okFEU84oxx4F8PNzzgf5Eg3nKjyfXVh9fuUMQqGpBgybuD0sPhal1CwY2ewNI3FS
	 4D7qyec3xarhYG6BgCjz+4c3Yq/HTDGpOy+ZLJoXm703V60fKDHrf4/NMPItkNW0cb
	 5H4QV4h2gH4avpesU73u4ksE95e2UaO3FHgTJpHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/603] kunit: Fix the wrong kfree of copy for kunit_filter_suites()
Date: Wed, 15 Nov 2023 14:14:05 -0500
Message-ID: <20231115191634.147506354@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit e44679515a7b803cf0143dc9de3d2ecbe907f939 ]

If the outer layer for loop is iterated more than once and it fails not
in the first iteration, the copy pointer has been moved. So it should free
the original copy's backup copy_start.

Fixes: abbf73816b6f ("kunit: fix possible memory leak in kunit_filter_suites()")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index a037a46fae5ea..9358ed2df8395 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -243,7 +243,7 @@ kunit_filter_suites(const struct kunit_suite_set *suite_set,
 
 free_copy:
 	if (*err)
-		kfree(copy);
+		kfree(copy_start);
 
 	return filtered;
 }
-- 
2.42.0



