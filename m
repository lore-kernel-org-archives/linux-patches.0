Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA061863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71200C433EF;
	Wed, 28 Dec 2022 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239000;
	bh=NwpmSBB8E6VbdEyBKNLEtjrA8uAaF0ZUtLvneo0GimE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzQ2wI0zGRV8/KEGR6XBlQCtCmz1PPu2bDyg0AIPLKiIm0kU6UeofKlMeJjUlVXHl
	 P+EA5Lbt9mrBOEzsCR6WqyEN8pWFOnflOjysmXBDF4rZF/d2dtxb6mBtES+wvUa43X
	 Ms/zODvT4BvUG1XUwuc0hoQjB5uEXti31+eAVVM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@huawei.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/731] selftests/efivarfs: Add checking of the test return value
Date: Wed, 28 Dec 2022 15:33:18 +0100
Message-Id: <20221228144259.187475010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhao Gongyi <zhaogongyi@huawei.com>

[ Upstream commit c93924267fe6f2b44af1849f714ae9cd8117a9cd ]

Add checking of the test return value, otherwise it will report success
forever for test_create_read().

Fixes: dff6d2ae56d0 ("selftests/efivarfs: clean up test files from test_create*()")
Signed-off-by: Zhao Gongyi <zhaogongyi@huawei.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/efivarfs/efivarfs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
index a90f394f9aa9..d374878cc0ba 100755
--- a/tools/testing/selftests/efivarfs/efivarfs.sh
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -87,6 +87,11 @@ test_create_read()
 {
 	local file=$efivarfs_mount/$FUNCNAME-$test_guid
 	./create-read $file
+	if [ $? -ne 0 ]; then
+		echo "create and read $file failed"
+		file_cleanup $file
+		exit 1
+	fi
 	file_cleanup $file
 }
 
-- 
2.35.1



