Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4BB15B984;
	Wed,  5 Feb 2025 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765994; cv=none; b=hRwNfnqXB5bAbtVBAXS0a8JtPMbBjNo94nWdTTDVnvm8gIbl+gUIzWU9UxZzs5FTRPB/LI4S6ZkSWD1kyOfFZ0/rEFGO/GYkf5VM0L4BF3i95Tzp1JPbvCtjKlWSs1C/+kmjwJEOO+f8OU/OrOiaV9S/c6O6zLfIzEkRTOcZHsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765994; c=relaxed/simple;
	bh=NFPodEiBmIzJOEwt+GZcarfny1fku8OYu1VYKLffwaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgKL91Jst2tZSVpDXg0jnnwfqKJqlf8ampX559XzpIoPEm3SA9SePKuXxThw/nlkjrgpBS2NQ9TbmI9DQvToUopZ5eUmLkwF0MLZ1iC9ObQhveTPo+RtTXZ+TgtaPBm+cGbM+F2VqsKqIMyMej5jV6eOQudCOEwnsdMJbLIMeSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qv471GTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qv471GTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E34AC4CED1;
	Wed,  5 Feb 2025 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765993;
	bh=NFPodEiBmIzJOEwt+GZcarfny1fku8OYu1VYKLffwaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qv471GTgcvDIXy6b309hu9umPhSEKAgf9o4A0dxHSeVDhDRdK5RxoZzNcjQEWHI8k
	 IfA2HlDSknBUt2YM7EQzpA7uSZSOjbxo8OACIMTz+LSdXWjRXPveMWR17lAuWn6vAw
	 99opZZqy5L9iPKPfMMeNYGa1jpvnrf8O26YUdiAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 232/623] selftests/landlock: Fix error message
Date: Wed,  5 Feb 2025 14:39:34 +0100
Message-ID: <20250205134505.101048882@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 6788762188fea..97d360eae4f69 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -2003,8 +2003,7 @@ static void test_execute(struct __test_metadata *const _metadata, const int err,
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



