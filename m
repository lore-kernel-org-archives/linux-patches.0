Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028801;
	b=GiocqNnpKesXcKRZxv7JuQAkgY1OU+MJlezT6OdL6aqjVN1cbvK1jvm4SVZJnk8rFshS
	 sWMXRnWpO3YEv4qcMTkBxorqE9pCm5Vhpga3CyKKsnlgOtwzGSn+t8F0eU8BC2gfMx595
	 nePI/Ymmff/PN09TRxXiUOVnZ275nsX9m+Ddu3Ar8Jhb6MEchLWIvzcIZaB3LrCd8jYAy
	 cBfUQZ5eaP0/uBi444t0ul26X/rRyUUkHKyYXNUbNsl3HEi/kdmL1tBpac6Hc2NLYdZmV
	 XwwOG2ldaG96eVXDj2LINdogAVZXNxJyEJiNZ8szfbgFzI0hLlojNIW6YS1aPZVIJWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0pnMmb0eSr/bhb0HGMo+CiSgC33haQj/bVbjkHjqS54=;
	b=rJ5yRszwJvTSP2CJh7jo0/aI+QvUZlGPtMT3H1lQCBVqzWnJPUFrGLj/P2UfFYdTDfCN
	 zQcYP+m9i4vBWGOdz0vw2NDEDuXhJwTpRRP+Uien7VeYd6FSQlO0ZJ6Zd4/jVJxQmF/ZG
	 8r8xuB/lka1zEC+3dWq14/NmEFNyL1GwgCqMr2HtmkK6fUqY9cqxJTccjobrhRTaaPfFl
	 sj10CQRDfEZf4rPWfX8Bb70P/0TBoMJsbE/yVz9IHCGKBIrp+tHhS6SadcV29L4En9IO0
	 8jhazFOEbRS/iRYxp9ZBqgB0hxTUFQDQRNMsyGcOrkSWq1vJsXBjmLln8BOqwsrhmkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdGks8yI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8AC60A2600;
	Wed, 18 Nov 2026 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdGks8yI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED25F1F000C5;
	Wed, 18 Nov 2026 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028801;
	bh=0pnMmb0eSr/bhb0HGMo+CiSgC33haQj/bVbjkHjqS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdGks8yInLD05QIwYYLvXOZQnImE0dbY84c1nZme/iaOEeqW6Zyw1W6yrIX7J0xF5
	 Mc4KkY/J6ifWlhR53gk3U2RnZoFfleANtB/2hjmwucC3yUAtfVN8s4LK4hBvaA7RsN
	 naMmSiUWNS2PT0r20R/6LX5y0fFrw5Mc2D4u70mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Zi <2959243019@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0125/1756] comedi: addi_apci_3xxx: fix subdevice count underallocation
Date: Wed, 18 Nov 2026 15:37:32 +0100
Message-ID: <20261118150013.180769734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bc72273e6a291..7355ec454cb40 100644
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



