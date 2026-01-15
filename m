Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81803D1CD8;
	Thu, 15 Jan 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499865; cv=none; b=K3wkv+BNYI+eQtJt7bQUCMVffPf3d7QRRYgfCK4TcZPcvak+GV8O88sFJAyT7cVJ/w4dOGrHOpkDASYVb4fQgx3gEvZ2mddj6XaCnhZyMmbmTrrMjbvQL8YrzYFD1rtU6ZY998oj870foG/1hgpkrVXb3r/U6oYH5ZWLK/ZsV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499865; c=relaxed/simple;
	bh=Psrcn1SQeXh1xqMY/HpcZus42dkUn62RS3Y3Jtxdn8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhFwISIoaswwAhGe+ef+zWBjEPqmaWgTJ7SvMv+/AcCT6XCiGkcS3y4sKgxc0rFKMyrvBzRYCAFRPSx0X95GV4vuNeai6VqVnH//lq3yt5wTOQdCqwFnTjA8wtu1pYbFNz50vdcbfJhsH/7zuZrbV5OwsYI5MWMBuuNavQnPhNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BafioQSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BafioQSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E20C116D0;
	Thu, 15 Jan 2026 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499865;
	bh=Psrcn1SQeXh1xqMY/HpcZus42dkUn62RS3Y3Jtxdn8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BafioQSHGDRnrJNOOy/fyvlGRAReJ3st4xasxGuPgDqe2KxDh8yfLVx098AFUpQm8
	 rpl5NvDgfkzzw4djbgihV6DJuc5PdNQbzP3FvFuGAAdLuoer+QD77IXeXYVlkBj1Y+
	 531ox0bomaMuv29xDScyK7GBIG4oxBMpvDwt7aNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 343/451] parisc/sticore: Avoid hard-coding built-in font charcount
Date: Thu, 15 Jan 2026 17:49:04 +0100
Message-ID: <20260115164243.302820735@linuxfoundation.org>
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

commit 4497364e5f61f9e8d4a6252bc6deb9597d68bbac upstream.

sti_select_fbfont() and sti_cook_fonts() are hard-coding the number of
characters of our built-in fonts as 256. Recently, we included that
information in our kernel font descriptor `struct font_desc`, so use
`fbfont->charcount` instead of hard-coded values.

Depends on patch "Fonts: Add charcount field to font_desc".

Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/037186fb50cf3d17bb7bc9482357635b9df6076e.1605169912.git.yepeilin.cs@gmail.com
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/sticore.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -507,7 +507,7 @@ sti_select_fbfont(struct sti_cooked_rom
 			fbfont->width, fbfont->height, fbfont->name);
 			
 	bpc = ((fbfont->width+7)/8) * fbfont->height; 
-	size = bpc * 256;
+	size = bpc * fbfont->charcount;
 	size += sizeof(struct sti_rom_font);
 
 	nf = kzalloc(size, STI_LOWMEM);
@@ -515,7 +515,7 @@ sti_select_fbfont(struct sti_cooked_rom
 		return NULL;
 
 	nf->first_char = 0;
-	nf->last_char = 255;
+	nf->last_char = fbfont->charcount - 1;
 	nf->width = fbfont->width;
 	nf->height = fbfont->height;
 	nf->font_type = STI_FONT_HPROMAN8;
@@ -526,7 +526,7 @@ sti_select_fbfont(struct sti_cooked_rom
 
 	dest = nf;
 	dest += sizeof(struct sti_rom_font);
-	memcpy(dest, fbfont->data, bpc*256);
+	memcpy(dest, fbfont->data, bpc * fbfont->charcount);
 
 	cooked_font = kzalloc(sizeof(*cooked_font), GFP_KERNEL);
 	if (!cooked_font) {
@@ -661,7 +661,7 @@ static int sti_cook_fonts(struct sti_coo
 void sti_font_convert_bytemode(struct sti_struct *sti, struct sti_cooked_font *f)
 {
 	unsigned char *n, *p, *q;
-	int size = f->raw->bytes_per_char * 256 + sizeof(struct sti_rom_font);
+	int size = f->raw->bytes_per_char * (f->raw->last_char + 1) + sizeof(struct sti_rom_font);
 	struct sti_rom_font *old_font;
 
 	if (sti->wordmode)


