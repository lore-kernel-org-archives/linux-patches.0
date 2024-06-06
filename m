Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C541B0120;
	Thu,  6 Jun 2024 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683358; cv=none; b=sXySzp/DDDxQmEWBlI4c5oh5vy5lG3yedUTgHMfTmuo0TIsVhfiLDJ+E4uqQ+q+n60T8VXTluvkbtvGVx05At85wABzsMJS7g05cyuBxN2XJUfDI4Pu8+4MYR2TtK3uqtjWJBuypwE7SULt9Lt9UYoIeLR2j1HvdvRsA2H2nJo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683358; c=relaxed/simple;
	bh=kVOsGCElX+uUXun82tajCgTkw27Tyua5R+P96M8wY7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdgQAgV1GjUcsXGSQQU63bF0jnXUYpD43SabiKtSsolP4o/Lu4HG7bPO6kmpqFJUEHL1U++1M8pYk3mkcG8dwOglhIFHtGIfSf4LrX4hCmxFs2VmM+PgoZjiudtWF8/Ch1exEVtPih12HAs/Vu0z6t68z/t0qstx6u5NfWV3xDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OekjxAkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OekjxAkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C0FC2BD10;
	Thu,  6 Jun 2024 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683358;
	bh=kVOsGCElX+uUXun82tajCgTkw27Tyua5R+P96M8wY7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OekjxAkjERCdOF9kW/zc1f43U+mHD1ZXaxo1lHjG+11yOxgAxCyAHNvohxKAfD73U
	 zLGeSIV9CM1dlHbW+ph+AOu3ONr7QZBRp9ejZso2leVdPQ9lrePZ5hrGl6HamVg4Fe
	 Qv5SMxvWtwTXboG0jkmVBMscdUfls591xNnYdX6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 298/744] fbdev: sisfb: hide unused variables
Date: Thu,  6 Jun 2024 15:59:30 +0200
Message-ID: <20240606131741.949332468@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



