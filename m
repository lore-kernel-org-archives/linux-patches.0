Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BC3A7F4C;
	Fri,  4 Sep 2026 05:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499070; cv=none; b=j689mjFAbEYnwUudGQ26tXjyVj0RsgSOhPNJ4u66or0GX9NRm6oBss5Pyfoqm4UTDZPW3rG17i54m16y2eQ12qCyVn52wG3cpRDkWvOc4OC2HzigDgXoq1HWlNMJN/KsldpKEtI2ArzxoYqgrHRX9bR/CJbA4ClNx357bhS3nvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499070; c=relaxed/simple;
	bh=ijYrmqJecwMyw4dirumR8BU5+ju8tueT/OStItdAQ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayepfQ/S3JK9TZeyCJSocYKReyzZ1h1nUrrBeF/8ipwBcB0iJzGSq0/HK0UouhEMF4pfL9HVTdQHBv5s+dM8KSbx4/P0hXff8I0d436GF/Lqg0R5o8TxaR9MaRDHX8QDUDjQaHT2QcUOvPT5wXqTN1f1aOv7YKOvUkX8nY3cgpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4KpXpC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4KpXpC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05161F00A3D;
	Fri,  4 Sep 2026 05:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499069;
	bh=fD5+0whZFt7lJZxD9nLXxkfsNC5Wwr3HDqLol4SdIcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4KpXpC+8e9DDKp+u+yHeSrjmrWmH/bPM5WMYcyp/1La/Pwo5W5y3oVa46Zgh9ZWX
	 5YKV2VdevBaSrO3PDW/mp7PgBYYKPEstGR/M3Sn6Pud5OHPbWXzhAnqWfQa2gy1Ktz
	 L5aRln5/3iyL9UBIF8OkQpvJCZ/YgJgwdlqxO/ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 287/713] fonts: fixup font.h kernel-doc warnings
Date: Fri,  4 Sep 2026 06:54:15 +0200
Message-ID: <20260904045810.271745187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit 048ad864d61feedc24129eeb976e973edcbc3aac upstream.

Use the typedef keyword when describing a typedef.
Add the missing function return value for font_glyph_size().

Warning: include/linux/font.h:84 cannot understand function prototype:
  'typedef const unsigned char font_data_t;'
Warning: include/linux/font.h:53 No description found for return value
  of 'font_glyph_size'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/font.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/font.h
+++ b/include/linux/font.h
@@ -49,6 +49,8 @@ static inline unsigned int font_glyph_pi
  * scanlines, which is usually the glyph's height in scanlines. Fonts
  * coming from user space can sometimes have a different vertical pitch
  * with empty scanlines between two adjacent glyphs.
+ *
+ * Returns: the number of bytes per glyph
  */
 static inline unsigned int font_glyph_size(unsigned int width, unsigned int vpitch)
 {
@@ -60,7 +62,7 @@ static inline unsigned int font_glyph_si
  */
 
 /**
- * font_data_t - Raw font data
+ * typedef font_data_t - Raw font data
  *
  * Values of type font_data_t store a pointer to raw font data. The format
  * is monochrome. Each bit sets a pixel of a stored glyph. Font data does


