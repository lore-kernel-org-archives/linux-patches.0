Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015096;
	b=OcXWLymlNaJCTbBAs+XhYO4EnYvsAOuIOI1Urvr0Hv95dHTkNCveeslM3GowN666XSyu
	 RgXYCLNnThVncaZqf3P5uK875j/rMIuiuBnXPKiAzz02e1k/ckn0aeB/kO2MPj5lzXOEC
	 T1FMICaiOiw7f2hTuGTbhziYydagA4cjDE0d5F25FBJv7YoD4gWMV56TkAMmkWDgCeBIJ
	 z1UqoGPs2krlTPM5mMAoPi55xyARC4lv8LQ1ysWKZ7kUVykIN8uwHhk97lLl/Jj419f07
	 eganHpXHxkOZieL3Uw3Rf74qTg5UuWIXnicGd3CUDbH0wZaA3WmdwWjdAw/wDnHn5Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qpRqbEwBj3IWPxQqc+9qNEtynkQtkH5qw/y7rvgH86w=;
	b=RsyU6Ulhyvi+qFpuNE3FaXLmyxoslhi3+wZRQ8t8GJWNj7F1VwrTWYaT+bNLqfxMnzdf
	 NLAr+n03JIA9Ah63cqnh89vWhf7qG91QehjMjqtAzGXiPA9gM0eubwRgjC8Umlqcup6pH
	 aRJB34g5bIVAaSWqiKki8iyuJNKALcQRdp4rYfUXosxPhzzuH3mmIwi9pjhfn+7PR8+z5
	 EuUG/oaB8V1VsOhz4+JkOltws3BaUkS41Qpb1vfmSovK1O5kUFsQzQky3dbdE7ha0WOUH
	 0D7Lla8qblWzdVTsg4Ljaq0ZuPoge1x7fgkBrJwjfV/ZVv6WKHexsJ/k7XPdt3ZSGmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=slSHd8PY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FE060A2605;
	Wed, 18 Nov 2026 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=slSHd8PY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366871F01819;
	Wed, 18 Nov 2026 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015096;
	bh=qpRqbEwBj3IWPxQqc+9qNEtynkQtkH5qw/y7rvgH86w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slSHd8PY1IyfQh+OLt054GYAn9/BuNx5HXjiz7GzImI59Htrixmm+nbP7PmNQv1ZT
	 1Nv0xAwWT3QbgEXeTRiS4B//wC/6UmjFAmEKt7VKr8j/RKcNdGicYZQqZhVgkCdv0W
	 Ww9A2hQ7eWbPepDI9aMkKIxVFVfwArKxyUp4q4IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Zi <2959243019@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0051/2651] comedi: addi_apci_3xxx: fix subdevice count underallocation
Date: Wed, 18 Nov 2026 15:21:31 +0100
Message-ID: <20261118150249.794791554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Zi <2959243019@qq.com>

[ Upstream commit 3de5aa458dede472a253266d02902bd95af8e849 ]

In apci3xxx_auto_attach(), the number of subdevices is computed with

    n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao + ...

The ternary is inverted: when the board has analog input channels
(ai_n_chan != 0), it counts 0 instead of 1, so the AI subdevice that is
actually created is not accounted for. As a result
comedi_alloc_subdevices() allocates one entry too few, and the later
subdevice initialization (notably the TTL Digital I/O subdevice, which
is populated last) writes past the end of the allocated array, causing a
slab out-of-bounds write.

Flip the ternary to count 1 when ai_n_chan is non-zero and 0 otherwise,
matching the subdevice creation order in the function.

Signed-off-by: Yang Zi <2959243019@qq.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20261014101803.11036-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 656e39fedcf0 ("staging: comedi: addi_apci_3xxx: only allocate needed subdevices")
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/addi_apci_3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/addi_apci_3xxx.c b/drivers/comedi/drivers/addi_apci_3xxx.c
index 695cce1031779..1dcda82d95032 100644
--- a/drivers/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/comedi/drivers/addi_apci_3xxx.c
@@ -787,7 +787,7 @@ static int apci3xxx_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao +
+	n_subdevices = (board->ai_n_chan ? 1 : 0) + board->has_ao +
 		       board->has_dig_in + board->has_dig_out +
 		       board->has_ttl_io;
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-- 
2.53.0



