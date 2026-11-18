Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051084;
	b=vnL7BHhXmJfZ2jzyPo99zboQElJhQ/P9KC4jHt2brRYe7nGNcGZZoQfj0yYGCUlCK3QB
	 voeBbeST385ftkmh4tel+d/ovDyzbacWF3x8Z8+ODd2ZeA6uRknKyANmLD+JEO43CkzAr
	 4WY0/Q+J7NEBEgW0UMto757uXLx72IlMxXT9Sg/BuyU3du8xXIFiEtpTbFLJJl9Jwndnf
	 yuKofm8JqowBjCYxCZ3hV+JfD1/SfFjqxPar3Dr+BPhK2XCdyhccMfZmoWuH1nwWP64qs
	 zFqg5Xn2z9JMBOkTtaExT4rsLYXLKuTcdRhFWBOQtdbAJVl2uORqwu4vvDw/ZtZP5+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dto12QhTsx+Z066wxQF8lovj43Rha4WhGwhcIHYhUkg=;
	b=5TK0eq/kZ+eE3ZfYLWCYi7pIwZXt4/Hn9yUwmLteRbUYJDyDbafWMhkqwKew0kXAChrP
	 FAOuY5va1PpMtXhjR9E95a5qrSTz65BSZ06Ilr8k5l7jJMiDCD+kFnTzeJakqQO9gSQHW
	 rAxClR2oIe/btKVZ0BR/XVnIRhj0qu8pJCNQgaA8SInn3RPLVVr5CSViSvOyGF9qDXEBM
	 3jkYrVU4XCkelgfuC6lHZe0X7nppoqwajzh8TemhzQ8A50QXqeqtN6xUvyzYtlLSUGep8
	 TX57pwgXi2RuAACmiHilCSh9r4+3AdcuTMd0hgUf/ya1XxTKmWjOZwZIZ6VOBvglRAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ikuAczNk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38688606A320;
	Thu, 19 Nov 2026 01:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ikuAczNk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884EC1F000C5;
	Thu, 19 Nov 2026 01:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051084;
	bh=dto12QhTsx+Z066wxQF8lovj43Rha4WhGwhcIHYhUkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikuAczNkayDNZP8I8MWT4pjc0O+FMU7uYhwi8M1CzSiyAgTUAozbS0hZPTm5C81Rh
	 A8pK1KZlDwdFItEVxT01Y3fpK0rb/2QFZgAp+VyNbjXcY3U4YxmzV3g7SC+XMMEeN6
	 7dsWYCpLSUSCmsuH/Z27FAKftqPBZPAuNKuA4Qj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0081/2214] media: cx18: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:29:17 +0100
Message-ID: <20261118150013.244189856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit bf533acaaa7dee21d49bcaabf8e813ea36bddcd8 ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx18/cx18-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
index c7cce38dd7547..38b2cfd2372c0 100644
--- a/drivers/media/pci/cx18/cx18-vbi.c
+++ b/drivers/media/pci/cx18/cx18-vbi.c
@@ -135,7 +135,7 @@ static u32 compress_sliced_buf(struct cx18 *cx, u8 *buf, u32 size,
 				    : VBI_HBLANK_SAMPLES_50HZ;
 
 	/* find the first valid line */
-	for (i = hdr_size, buf += hdr_size; i < size; i++, buf++) {
+	for (i = hdr_size, buf += hdr_size; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] &&
 		    (buf[3] == sliced_vbi_eav_rp[0] ||
 		     buf[3] == sliced_vbi_eav_rp[1]))
-- 
2.53.0



