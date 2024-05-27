Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3DC17727;
	Mon, 27 May 2024 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838411; cv=none; b=SA25XvDOrDHvB/GY4x4huQsWQMf6BjGjg/QkLqeEFT+zzs7bA99mt8Vv23Ox6MGnJ7CPKw4Fto/Qp8DBWxy84I6I6MX2pD/87PkLfhVwm8/a8iInVuR7RYiQ00LxxOUOVe4IBwyIrfs05pUIKSXhJLoVWc2l3owUQod9mLM8BTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838411; c=relaxed/simple;
	bh=xmVxuCIKP7jU963rxgXeHb/9+XupyXNQhFG5RsfSr1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLAwYpJABhcUBvXTNFnYK+Ev/gsvb0IyAxSfIU1pDIzwUd5O/Qi5SFSZbODBUzfSgXAJnUxnMq6N6jWTY/5tP0VU1HKSNr2lBrrcEu44iwLNmTKTIV65G7OYtumWOAe1HAu+KMZGMoXZBU5mqOkD/NEDbUDBDb5ZaNlg8AcxmUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sc5d0wTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sc5d0wTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51A9C2BBFC;
	Mon, 27 May 2024 19:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838411;
	bh=xmVxuCIKP7jU963rxgXeHb/9+XupyXNQhFG5RsfSr1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sc5d0wTtlniw4qJb/dDgSpGfKvYSkTJdohjZBkc5DeAZTSccNauSRswh7DQetl/cn
	 fkhpc7RUiKSwkk9KcNyVxjKmonYWTUxHkDwoTvucH5cBlQz8N/NhMyniOHU8cNOPeX
	 oN8pael4KPuGDZgI11I8YS0xsBdOQkSRWwKqvt58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 381/493] fbdev: sisfb: hide unused variables
Date: Mon, 27 May 2024 20:56:23 +0200
Message-ID: <20240527185642.736092400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 688cf598665851b9e8cb5083ff1d208ce43d10ff ]

Building with W=1 shows that a couple of variables in this driver are only
used in certain configurations:

drivers/video/fbdev/sis/init301.c:239:28: error: 'SiS_Part2CLVX_6' defined but not used [-Werror=unused-const-variable=]
  239 | static const unsigned char SiS_Part2CLVX_6[] = {   /* 1080i */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:230:28: error: 'SiS_Part2CLVX_5' defined but not used [-Werror=unused-const-variable=]
  230 | static const unsigned char SiS_Part2CLVX_5[] = {   /* 750p */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:211:28: error: 'SiS_Part2CLVX_4' defined but not used [-Werror=unused-const-variable=]
  211 | static const unsigned char SiS_Part2CLVX_4[] = {   /* PAL */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:192:28: error: 'SiS_Part2CLVX_3' defined but not used [-Werror=unused-const-variable=]
  192 | static const unsigned char SiS_Part2CLVX_3[] = {  /* NTSC, 525i, 525p */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:184:28: error: 'SiS_Part2CLVX_2' defined but not used [-Werror=unused-const-variable=]
  184 | static const unsigned char SiS_Part2CLVX_2[] = {
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:176:28: error: 'SiS_Part2CLVX_1' defined but not used [-Werror=unused-const-variable=]
  176 | static const unsigned char SiS_Part2CLVX_1[] = {
      |                            ^~~~~~~~~~~~~~~

This started showing up after the definitions were moved into the
source file from the header, which was not flagged by the compiler.
Move the definition into the appropriate #ifdef block that already
exists next to them.

Fixes: 5908986ef348 ("video: fbdev: sis: avoid mismatched prototypes")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/init301.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/sis/init301.c b/drivers/video/fbdev/sis/init301.c
index a8fb41f1a2580..09329072004f4 100644
--- a/drivers/video/fbdev/sis/init301.c
+++ b/drivers/video/fbdev/sis/init301.c
@@ -172,7 +172,7 @@ static const unsigned char SiS_HiTVGroup3_2[] = {
 };
 
 /* 301C / 302ELV extended Part2 TV registers (4 tap scaler) */
-
+#ifdef CONFIG_FB_SIS_315
 static const unsigned char SiS_Part2CLVX_1[] = {
     0x00,0x00,
     0x00,0x20,0x00,0x00,0x7F,0x20,0x02,0x7F,0x7D,0x20,0x04,0x7F,0x7D,0x1F,0x06,0x7E,
@@ -245,7 +245,6 @@ static const unsigned char SiS_Part2CLVX_6[] = {   /* 1080i */
     0xFF,0xFF,
 };
 
-#ifdef CONFIG_FB_SIS_315
 /* 661 et al LCD data structure (2.03.00) */
 static const unsigned char SiS_LCDStruct661[] = {
     /* 1024x768 */
-- 
2.43.0



