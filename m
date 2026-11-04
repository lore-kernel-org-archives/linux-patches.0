Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829483;
	b=0MYpf5eHBH+KsJ5OwqG0vl78BM+RN9n3roZ5hLXa9ECl7JBVHAEZGYW2NpdMVjZUSYMh
	 33FJIQAOMZ2gtjSIiVMsvY2cYXcr2ev28Hk+H/OJJS9PVSmN+6KBoJD8+LKJCuiJfwyM7
	 h6gGd6n1dNHBmsWp9DJ2uofGg6GjaOvtitcrcu7HQqxuJHSyhnkPbVba13cx4MaevCtRI
	 alZHJjUEI51J1kTpejblK4w9ptphud5P80fq62ne60hM34ALFTWaettM9SbsbiOR1fupg
	 0oxXBcIfJNUfjzomuCRE/KKlSWlE1z5TZkX8NHsM9fS/g38o+8ENwMbVsYQoDfif0yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W2UOj8TBj/ZVtsNDuYF9P+jyg/KYQgkJzuSw+fmBTfg=;
	b=AHCwDaq5Q4GaOCv1yOhQihtsC9Xeu5ivlY3c4L2jLoBMQPeM7TWTWgPYG+I9H9ral9ra
	 6FEfhWye2RO7zAGcKyb19DFE1UBDIDacRcHPuTqPHcZIcQldNIkAPU/uOQgdb1LHagKee
	 BrdtLR3w+b8ASWMdGSdKGQsI3/Ilzzb6uqj0XpKIj/whenk0W+dFlCi/vKu6EslFS3iq/
	 6kuGFF8fvbHC1xCAcCfwZdtyIuV1DjZPrx8jq/NBIJ/uo3xD8GnqnIQ7thXOCcF1tEAhE
	 e7LX0VGt07Gtw/jg/jKkhgt0y+G0xJ2F0fxn6mU5Oxkioip6mUUJngG0rwEDdFuF+8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g1/GT35c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72EE6082BE9;
	Wed,  4 Nov 2026 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1/GT35c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278831F000C1;
	Wed,  4 Nov 2026 21:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829482;
	bh=W2UOj8TBj/ZVtsNDuYF9P+jyg/KYQgkJzuSw+fmBTfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1/GT35cNIWuymPF0/XwCMWbGT8QeRdp1HYlVgDFBnvDLHlgJuKK4A4hWHyeYRyXY
	 8sVTLA3jqfrQLCPW0SPmcQGfFA+AHLfs95fJ/aTrxfFYw6EGL0OUN3wbhwjeE8ZI5/
	 qvhRYaBFq0aAThPeo/HaFYto8pbTSFDugqDKcfp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0153/1005] media: cx18: stop VBI start-code scan before short tail
Date: Wed,  4 Nov 2026 15:58:06 -0500
Message-ID: <20261104211048.038062878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8dc4ce3259353..3a8430f3259eb 100644
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



