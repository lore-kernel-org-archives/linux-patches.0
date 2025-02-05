Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE3915198D;
	Wed,  5 Feb 2025 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764093; cv=none; b=PoaYcMGhOref//8cHVHIuL3iSEPFRURkRX1H4BduC63Vstf1B+pgidOmRh6IXCK/GHDo5bh6eY3n1dAu1qubzfg1s8zYZP8bJCsLKxRIvtYPdqU3jo1lxa7AETviyCNf0bVr/mra6eqBMd1vWmn28CZUTcFLG5IZ3vF2sqsSP7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764093; c=relaxed/simple;
	bh=H8Wi21QCKwaCUBajmHyD5ATIRRMnuXp+VQ+qxCu0a3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNZbt4ffncTKGNDpLmNNTngBy5kM9oUndFc5jP/XHN87j0DWtv3dS4xU+SKmQYHFGVVkcGBBaWFr80VkRqiPLXZ/4tEAuc4HCpo+num+8YJ+tjJYfjaTqfLLj0vJXR2B1HIgD6o8yAxsJIPs7Pyf6YUZ5Ezu9QzxzfqxqyEbMhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6/4bMhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6/4bMhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BEFC4CED1;
	Wed,  5 Feb 2025 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764093;
	bh=H8Wi21QCKwaCUBajmHyD5ATIRRMnuXp+VQ+qxCu0a3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6/4bMhlP+5HpoXa/USjabnoMLagQ9cpz906sgDfZ5Ey1xbiKibv5qpfrxWdYcJj5
	 CwQZCS+qOVaCg9K3OdUs83u8lJmpjuu0ArUDPjc+vFCTsezLSn2yWHYEnEx+cWJVd1
	 mu7IOBbzBjd+xbdnDMQrYnotvrDJQUItW9aNiDaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/393] selftests/landlock: Fix error message
Date: Wed,  5 Feb 2025 14:40:58 +0100
Message-ID: <20250205134425.623197107@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 2107c35128ad751b201eb92fe91443450d9e5c37 ]

The global variable errno may not be set in test_execute().  Do not use
it in related error message.

Cc: Günther Noack <gnoack@google.com>
Fixes: e1199815b47b ("selftests/landlock: Add user space tests")
Link: https://lore.kernel.org/r/20250108154338.1129069-21-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 720bafa0f87be..c239838c796a4 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -1861,8 +1861,7 @@ static void test_execute(struct __test_metadata *const _metadata, const int err,
 	ASSERT_EQ(1, WIFEXITED(status));
 	ASSERT_EQ(err ? 2 : 0, WEXITSTATUS(status))
 	{
-		TH_LOG("Unexpected return code for \"%s\": %s", path,
-		       strerror(errno));
+		TH_LOG("Unexpected return code for \"%s\"", path);
 	};
 }
 
-- 
2.39.5



