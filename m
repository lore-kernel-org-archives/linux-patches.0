Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0097E3D1CD8;
	Thu, 15 Jan 2026 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499863; cv=none; b=bXHwAYO1fMCpYaGcdSYtJ6iTfOIEjZjjgQ2W0z0pCxzISpRKbEFoI6B9h20zrcQgP29afTNM9h6/fSky6IcseuFpb9ht6ke5p2deXaSFXJcOFMeGZm2M+jal1LeB7uCs+emDEPEVldDD+B8/KiWXcMq9EJ020UZ6oH3ttQlip8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499863; c=relaxed/simple;
	bh=HI/n0Qd8iMJahXp+Bz2+ZY8wzDxnJ9sbhGSqzL9SrOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd5NtOnJlKHIAqbu9rzrx2SItyAbkAdZaO1ObLt4rq0OclN8qgXLhwg0ZY12tTlGAmGJoZLJCLNO3me3hNsekCGnFId5ZHrS7J5G9kYyk5hR6mSGCP5TxQsPlbuxEpBB4ajFZ75fCfLtSBTey/Sk3osfs37DQJSZXJy8gKoG93U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Be66nrd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Be66nrd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7315FC16AAE;
	Thu, 15 Jan 2026 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499862;
	bh=HI/n0Qd8iMJahXp+Bz2+ZY8wzDxnJ9sbhGSqzL9SrOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Be66nrd+NIDBcuecaEFSe28/w7J1rJA9eJd/ZqCSgiq0ExYeD6lRrN9zO0rw1KgqY
	 aTb7laGPkdhSvz64KZrTvR90UOI/tNJWACrMT2zrVY6tTuuwoRqMpMQCpQ++JB6HRH
	 HJjKkKowzPeeRaajYZA+Y2tEI7GRAFNjcWNcuSjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 342/451] Fonts: Add charcount field to font_desc
Date: Thu, 15 Jan 2026 17:49:03 +0100
Message-ID: <20260115164243.266255822@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 4ee573086bd88ff3060dda07873bf755d332e9ba upstream.

Subsystems are hard-coding the number of characters of our built-in fonts
as 256. Include that information in our kernel font descriptor, `struct
font_desc`.

Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/65952296d1d9486093bd955d1536f7dcd11112c6.1605169912.git.yepeilin.cs@gmail.com
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/font.h       |    1 +
 lib/fonts/font_10x18.c     |    1 +
 lib/fonts/font_6x10.c      |    1 +
 lib/fonts/font_6x11.c      |    1 +
 lib/fonts/font_6x8.c       |    1 +
 lib/fonts/font_7x14.c      |    1 +
 lib/fonts/font_8x16.c      |    1 +
 lib/fonts/font_8x8.c       |    1 +
 lib/fonts/font_acorn_8x8.c |    1 +
 lib/fonts/font_mini_4x6.c  |    1 +
 lib/fonts/font_pearl_8x8.c |    1 +
 lib/fonts/font_sun12x22.c  |    1 +
 lib/fonts/font_sun8x16.c   |    1 +
 lib/fonts/font_ter16x32.c  |    1 +
 14 files changed, 14 insertions(+)

--- a/include/linux/font.h
+++ b/include/linux/font.h
@@ -17,6 +17,7 @@ struct font_desc {
     int idx;
     const char *name;
     unsigned int width, height;
+    unsigned int charcount;
     const void *data;
     int pref;
 };
--- a/lib/fonts/font_10x18.c
+++ b/lib/fonts/font_10x18.c
@@ -5137,6 +5137,7 @@ const struct font_desc font_10x18 = {
 	.name	= "10x18",
 	.width	= 10,
 	.height	= 18,
+	.charcount = 256,
 	.data	= fontdata_10x18.data,
 #ifdef __sparc__
 	.pref	= 5,
--- a/lib/fonts/font_6x10.c
+++ b/lib/fonts/font_6x10.c
@@ -3083,6 +3083,7 @@ const struct font_desc font_6x10 = {
 	.name	= "6x10",
 	.width	= 6,
 	.height	= 10,
+	.charcount = 256,
 	.data	= fontdata_6x10.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_6x11.c
+++ b/lib/fonts/font_6x11.c
@@ -3346,6 +3346,7 @@ const struct font_desc font_vga_6x11 = {
 	.name	= "ProFont6x11",
 	.width	= 6,
 	.height	= 11,
+	.charcount = 256,
 	.data	= fontdata_6x11.data,
 	/* Try avoiding this font if possible unless on MAC */
 	.pref	= -2000,
--- a/lib/fonts/font_6x8.c
+++ b/lib/fonts/font_6x8.c
@@ -2571,6 +2571,7 @@ const struct font_desc font_6x8 = {
 	.name	= "6x8",
 	.width	= 6,
 	.height	= 8,
+	.charcount = 256,
 	.data	= fontdata_6x8.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_7x14.c
+++ b/lib/fonts/font_7x14.c
@@ -4113,6 +4113,7 @@ const struct font_desc font_7x14 = {
 	.name	= "7x14",
 	.width	= 7,
 	.height	= 14,
+	.charcount = 256,
 	.data	= fontdata_7x14.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_8x16.c
+++ b/lib/fonts/font_8x16.c
@@ -4627,6 +4627,7 @@ const struct font_desc font_vga_8x16 = {
 	.name	= "VGA8x16",
 	.width	= 8,
 	.height	= 16,
+	.charcount = 256,
 	.data	= fontdata_8x16.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_8x8.c
+++ b/lib/fonts/font_8x8.c
@@ -2578,6 +2578,7 @@ const struct font_desc font_vga_8x8 = {
 	.name	= "VGA8x8",
 	.width	= 8,
 	.height	= 8,
+	.charcount = 256,
 	.data	= fontdata_8x8.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_acorn_8x8.c
+++ b/lib/fonts/font_acorn_8x8.c
@@ -270,6 +270,7 @@ const struct font_desc font_acorn_8x8 =
 	.name	= "Acorn8x8",
 	.width	= 8,
 	.height	= 8,
+	.charcount = 256,
 	.data	= acorndata_8x8.data,
 #ifdef CONFIG_ARCH_ACORN
 	.pref	= 20,
--- a/lib/fonts/font_mini_4x6.c
+++ b/lib/fonts/font_mini_4x6.c
@@ -2152,6 +2152,7 @@ const struct font_desc font_mini_4x6 = {
 	.name	= "MINI4x6",
 	.width	= 4,
 	.height	= 6,
+	.charcount = 256,
 	.data	= fontdata_mini_4x6.data,
 	.pref	= 3,
 };
--- a/lib/fonts/font_pearl_8x8.c
+++ b/lib/fonts/font_pearl_8x8.c
@@ -2582,6 +2582,7 @@ const struct font_desc font_pearl_8x8 =
 	.name	= "PEARL8x8",
 	.width	= 8,
 	.height	= 8,
+	.charcount = 256,
 	.data	= fontdata_pearl8x8.data,
 	.pref	= 2,
 };
--- a/lib/fonts/font_sun12x22.c
+++ b/lib/fonts/font_sun12x22.c
@@ -6156,6 +6156,7 @@ const struct font_desc font_sun_12x22 =
 	.name	= "SUN12x22",
 	.width	= 12,
 	.height	= 22,
+	.charcount = 256,
 	.data	= fontdata_sun12x22.data,
 #ifdef __sparc__
 	.pref	= 5,
--- a/lib/fonts/font_sun8x16.c
+++ b/lib/fonts/font_sun8x16.c
@@ -268,6 +268,7 @@ const struct font_desc font_sun_8x16 = {
 	.name	= "SUN8x16",
 	.width	= 8,
 	.height	= 16,
+	.charcount = 256,
 	.data	= fontdata_sun8x16.data,
 #ifdef __sparc__
 	.pref	= 10,
--- a/lib/fonts/font_ter16x32.c
+++ b/lib/fonts/font_ter16x32.c
@@ -2062,6 +2062,7 @@ const struct font_desc font_ter_16x32 =
 	.name	= "TER16x32",
 	.width	= 16,
 	.height = 32,
+	.charcount = 256,
 	.data	= fontdata_ter16x32.data,
 #ifdef __sparc__
 	.pref	= 5,


