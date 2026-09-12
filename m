Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A716347CA89;
	Sat, 12 Sep 2026 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232169; cv=none; b=ZlS/sB50jmYIrHB2+dLfJ2rRzDYz0r9dRvXAx1IkX64240lsWZqcAXJxoETwN1phsmQAyNbrUhI+wjUy8YbIQIE/DO/hH8KxJ08QIVABOrSD3mrOwxXA6Z1TzJ//3KmhQa7zYX+39J/LacpDpsaITa/Y2ksZveVON2mUtJBjr7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232169; c=relaxed/simple;
	bh=crQEPGif6sNiiwMVCjTR+qOgHT7zinJwp4Ip7JjkTYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6UCm4+QbZzswL5yGfbk/dtOyJ2qmniJ8ynkrXUyPxZrDTYrV/Fg5tqxh3SoY1g6WqQQq+dajCrlZc9dyWhfhh1jD3eL7HG2HILuzVQuTXFV3Ff775LhbkBQxlnZzOHN6JCkPPNVqKeZIkUbL5WifC4YQm7sRcu9RgJVYz6M7Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXVgQnCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXVgQnCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39F21F00893;
	Sat, 12 Sep 2026 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232167;
	bh=GUL4kGm5dPM2bocqEfsGT6975e8NNJcIq4pb3F4tLaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXVgQnCMsN7yaxAgsX0uoWhYNHj2LxWWFKX1bJSPkdQixuLojQh4LP0d8vntjDZDT
	 FkGFTSo4vUHW06jgV1L468gSFghWdgEvj0pKzLDLAdpEdtcd1tCGE3cuGFtSJF5rdm
	 gruFY+cATz3xPSdb2qemD0j8pNeFWPrOGc/3SqIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1145/1191] s390/con3270: move condev definition
Date: Sat, 12 Sep 2026 09:04:33 +0200
Message-ID: <20260912065613.865950650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9cab4f7d98eee90b762ffbc87055c9499d51a635 ]

Fix this for allmodconfig:

drivers/s390/char/con3270.c:43:24: error: 'condev' defined but not used [-Werror=unused-variable]
 static struct tty3270 *condev;
                        ^~~~~~

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: c17fe081ac1f ("s390/3270: unify con3270 + tty3270")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/tty3270.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index eee2030b86b3a..583f2aecbed3c 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -38,7 +38,6 @@
 
 static struct tty_driver *tty3270_driver;
 static int tty3270_max_index;
-static struct tty3270 *condev;
 static struct raw3270_fn tty3270_fn;
 
 struct tty3270_cell {
@@ -1910,6 +1909,9 @@ static void __exit tty3270_exit(void)
 }
 
 #if IS_ENABLED(CONFIG_TN3270_CONSOLE)
+
+static struct tty3270 *condev;
+
 static void
 con3270_write(struct console *co, const char *str, unsigned int count)
 {
-- 
2.53.0



