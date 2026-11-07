Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060756;
	b=L7zfoGswcALj6u51khzbZCvh7NNn4w5DVkyO/eyPhpU7t3uNwYOKMfdI15vTFBOusGmX
	 Mjl3xdgj92IZBETdoC16XynwhNbRg0k2Nwy1MpCCK4OLrfZtZWP7Mwh6YxyHHRw24ppxW
	 Jk0Hcw9CffjSTkxIWqqt2NM94Z/PLm0Vcn77Uixk1qkwYurjNbHrxp7BMXnk0SsXKAprb
	 ZgFo4QG6IiZr0S5WCb5gxnELWj2vp748hoiG3fJmt0GdyZ76i9sHuZhJ6nktRA+rZly5u
	 XLpu6WYnF8kZmivfxxTrIFwlMkdZexx2Guo8Q7wctK5t2Il/z6g/HkoiCOGRGDLdx9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pzGJnC36G5mjMmTkvV7VNswlkb8VJGh6NgQNAQf8pDw=;
	b=pXNEizA0L1oKTjsmEMg9aLHjVqMDfNxFSBPHQa6587BJFjEJ1+On4ZU8GUXdQwrEyNV3
	 Z0A+tyOPEzCwNnxL79ocQUOqs0lKCVXB54JsQ7LErpiNNEDomWKsg4H+VxbY8fjYOpYQr
	 mOekNPsc3Q6HzCuUNLwjE1xD1XHrC/UW1ELmiJJfF41DSv4KZlbLFopVvUmk7fECPLiab
	 MoMdcbwJzKypDP5/K9wjWP1ayGi7cFIwMjmS2wbwsJBkOWXGMu8da4kOHymPvkw9dTu4i
	 1jdVuKvwgHo7zwVHggOvuU5o0vNqPJFGmBvMGTpSYTMrz2EjaHLy5RUVvYgIEueLQTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/WbAdFw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A2A606A331;
	Sat,  7 Nov 2026 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/WbAdFw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D221F1F008A2;
	Sat,  7 Nov 2026 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060756;
	bh=pzGJnC36G5mjMmTkvV7VNswlkb8VJGh6NgQNAQf8pDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/WbAdFw0G2C5/P8OyPra89mjeVeAn26mhC5eSmh5TiBYAyomxoipIe7psmRobZR2
	 vFw7/JQRghAB5YD7x4bnsB5S6qDrwYDu4QIJd4kZRdvmhcdkRKbMdTRmOJ21EPioFB
	 Lyk7b1qp1Icekz2sKZ944FQd/HucUBQXuZWGcv4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0130/1536] media: cx18: stop VBI start-code scan before short tail
Date: Sat,  7 Nov 2026 08:35:46 -0500
Message-ID: <20261107135001.338528585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



