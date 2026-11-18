Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060233;
	b=IszaN+coayt1tAd5sRl5NKBspDa5h7ykWl6js0zikFgfdEz1GiVx1xEAzbdJjKFN2UwR
	 m2bXSFdvtVOqK5HOnuTA+B5YwXCktrppU+r5s5LR38lk3OgCBre8NRmSUw/dK9fdM2DZ8
	 oBvkMmGCFFg9xCdvTQUHJx07QDlLJSRcnSL2FzYexvofVBZwzFlGfMtxHge8Y7Pdk+U4D
	 1Iz2Z+RLFcq5ZwoSPKeiyp1Q+Ah52qnlgKzEIUmTPD8kD/Gp3at0iemU9n1sB4BpEJkVW
	 WETOtKJUnBJ+dpZdFI/nssWRk059PJwT5938Bptqy14q6Gu5XqF6cg0QI+qxMtaca7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dX5aApAEZnaJLjWTrY51qLEeQqsYei5mx1cauzjtIZ8=;
	b=K7xXStqT2rCvfp8EWa9PoBCAOuMIJF7JCD29YzHBI6bZaucZDK+1LmdCz95/rJcpnFej
	 7b0/QiTHI46C9fc2W+pXDV2dSG3GJOqPOt5l/5dRRwY1DXvflFkNXACy7dkjwgPeUikte
	 H4J7tArVfgXLhTX0/tTl2J6sgW6W8YeFMhzmw0jv4UfdL6wbLb1r3q4BlfDYosfktBgr+
	 P6wEPDp1ygKSM1Lu4M/LmllcGh4s/8fKLRvjsm9HcMGFExFL73pdUobXHQ84hluyyHaAA
	 d88mFdwvuj6U2D5Vdban2SA1HDO2hnAwvtuvgNQY5WUSFWbAVCrW3qgVc5IQj9aGkpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mw0XbxPI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8A606A320;
	Thu, 19 Nov 2026 03:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mw0XbxPI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752D61F000C4;
	Thu, 19 Nov 2026 03:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060233;
	bh=dX5aApAEZnaJLjWTrY51qLEeQqsYei5mx1cauzjtIZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mw0XbxPIhw6OcKm4cGcCK4CfZrokLOJR/yY+RkR8GBMvN15Ao69l3bYJFfdyx5LD/
	 3spKNYszkNR+hrYpkV57nHWBoc6r4m/wYJcJYj+f5P64jsceV8oQRh13xF8IatnYcr
	 TWdZlPIUQ+uQjLx+yXBJ45rk4BN1ZXELKiX/sQUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Zi <2959243019@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1108/1848] comedi: addi_apci_3xxx: fix subdevice count underallocation
Date: Wed, 18 Nov 2026 15:52:26 +0100
Message-ID: <20261118150005.740504738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/comedi/drivers/addi_apci_3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
index a90d59377e187..4f6898e8827ba 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
@@ -788,7 +788,7 @@ static int apci3xxx_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao +
+	n_subdevices = (board->ai_n_chan ? 1 : 0) + board->has_ao +
 		       board->has_dig_in + board->has_dig_out +
 		       board->has_ttl_io;
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-- 
2.53.0



