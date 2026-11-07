Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060371;
	b=h63+VYdEckLrL33MQ1gVW24R/o1IvLNjA8YDLBQywebv/rIUiav2MSyDiOklQ5/4Uwlm
	 yzgabxn2YuRj1RBD8DMSCJic+LpRWCJBoaJ/j6+R0gw8Y+AF6gbUbFtUPyKM1xFTHETFV
	 Zyl2YJ0eaVxBB9zGVdB5/Ia7FUE+THL9tBNe0IHJ4K7pxeiVRR+IdlOt/rzJdRZAOb7Kk
	 TcgXPDdGFMRj3Yx6kahzV2VwQN+nON/J4GNmXpKx5+WIe2+4l5jGNSYkBYKS2tlWMleBl
	 aziKfeZvTwHBxn+T6PLEFidV31YeOM+7Vt8MukpYLZYYLI+ZZioYZ0pglmhGsWt2AAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OMqLt6VEidPShOSkt3lbHy6u5hSWzBES/GFIIV7MzOs=;
	b=xqaqnKX+AsUY0J4FTZaxm0tTGy+Va6hVrg1LM1mUCqMzoICEhqvrEswckRKCgWI2KFPJ
	 3spNMobsPawpvuEhX5sAOWOAytTjvKMGgiX9vnPSsmmt7OibEkp3IYjN2Nd1n096AD5VB
	 vVvLX95V5cNV99myPFOJbfKvfeqZTKVJyREEEFlnKUELOW0ki0tryQbLIYgeMXQau3BkK
	 gxQKQeEYWUUrzU1A3b5p9EMv73HvHkyFoabjJDN0ch9FiQV6I8c7i0m5w8Wa7SfmanRP/
	 HXtAIPQCRMGRdK8/mtitkqFQ620kkf3zU69Ltqk76LO71j+gk2gI2dAjG8i8G6kUMxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9PnMI5Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A5606A32F;
	Sat,  7 Nov 2026 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9PnMI5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6138F1F0089F;
	Sat,  7 Nov 2026 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060370;
	bh=OMqLt6VEidPShOSkt3lbHy6u5hSWzBES/GFIIV7MzOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9PnMI5YMZAq/WrQ0YhemfdnM3wTeldBleHq2h0eVSv2gpVBjPtWCzoww4ERvQpw4
	 lvt9u5dcC4cfl7nl+1ervDohjxNR0atP81evAUD0tHiTNQwoycycTZvQ3qEwIMbNFU
	 OgT3ZSoYNwil+OOPIfngqGUPpj9PCiBjWE00c2LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0003/1257] media: saa7134: Specify rc type at rc_allocate_type()
Date: Sat,  7 Nov 2026 08:38:19 -0500
Message-ID: <20261107134939.532845012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 33154da9f78041edd93f0895a7d697c67994d75b ]

Changing the type of the rc device after allocation is ugly and
this will also break in a future commit. Ensure that the allocation
happens with the correct type in the first place.

Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 7f6680de31564..b2a2372d149a3 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -769,7 +769,8 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 
 	ir = kzalloc_obj(*ir);
-	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
+	rc = rc_allocate_device(raw_decode ?
+				RC_DRIVER_IR_RAW : RC_DRIVER_SCANCODE);
 	if (!ir || !rc) {
 		err = -ENOMEM;
 		goto err_out_free;
@@ -792,10 +793,8 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	rc->priv = dev;
 	rc->open = saa7134_ir_open;
 	rc->close = saa7134_ir_close;
-	if (raw_decode) {
-		rc->driver_type = RC_DRIVER_IR_RAW;
+	if (raw_decode)
 		rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
-	}
 
 	rc->device_name = saa7134_boards[dev->board].name;
 	rc->input_phys = ir->phys;
-- 
2.53.0



