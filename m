Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052161;
	b=qofMdxaU7QKptApt2Sajs8Ls4/xe/vOAW6wB1m9KIVf/zMVlu+gqhTDu/h1HJEPDuf3/
	 0L2NG3cZfBOkJ89DEO+DsQeC/1qqW2U3OIraA8nFRxRiGiDQRsEb6QvoNa9ehnSKi1k82
	 ZstagFD2QGGT6ta7KVYDxmM2taoHNDNC67BHX8O48oUB1vWzWvWQ9k5vIvzfv5c4AY7gD
	 n9g4vNY5tYDCu/66dnnzj+bJhow1ZP0HR2W/NziVDar+g7LiXmSmXxPVXMsMU5xNQZuU7
	 6eqJ5MpcfQMFnH5jS1pATmGV/oZAxX08fhNm6fj5znuRTsgbnlSIsLAzdI8TCR+UirA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q5vWp3UuN8uXtVwLWvub/IT87a4BZfz54ivEgjb4HO0=;
	b=T/UaEBuBmfb1RX5bpY1ltCSCP4646NBUy3BJIJg623ycVxzFQkrU6seXD4K51YFWqdnp
	 lVrngL+PDW6B3pyvod+1ybzu8GoAJamfy27P5tD/fU5bL+OqfU1XUGJ8pqu/Y1wrAuYUv
	 O/fm1C6f/MHZo6gG9fERh/zr8FIXuFMk2/SkzQB59gdJrw5wSG9nfMPcBe+4ZUQChMRMV
	 q8KrO0Ptlhr9ahc1jXTCbCUfsuiSR4EkMkoJv6b1+kXnmkxnpQtw0asCDf0xwTQ4oVHwk
	 n/5MJE+GjJyjZkFRafc9NuAffU93kHSDlMNyaAqudG6Emc0Ax9iHDM/zxjWyWAiKZsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSTs4YHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B2C606A335;
	Thu, 19 Nov 2026 01:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSTs4YHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D881F000CA;
	Thu, 19 Nov 2026 01:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052160;
	bh=q5vWp3UuN8uXtVwLWvub/IT87a4BZfz54ivEgjb4HO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSTs4YHgHntiUYj7gfDeAcIb5VShbrXgvZdeXgJ3Uv+eWMgorfyVZq+3sc9FZnzwO
	 Uju18WqYa20wkd/AKzhkyOgoDz3VIViEMWcuD+ZBTcebZGnF6kBPSyNnExgCd/FhkG
	 ZeFEQHzspCmWZb/mTezrm4xRX+QJYrBJVPQHFwTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0463/2214] media: saa7146: Initialize interrupt lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:35:39 +0100
Message-ID: <20261118150029.735019447@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e07c75a6bc4adf1ed09ede31756261e2c6bdede5 ]

The saa7146 interrupt handler can call SAA7146_IER_DISABLE(), which
serializes register access with dev->int_slock. request_irq() allows the
shared handler to run before saa7146_init_one() reaches the current lock
initialization block.

Initialize dev->int_slock before requesting the interrupt so every handler
path sees an initialized lock.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/saa7146/saa7146_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index e50fa0ff7c5d5..81a94141b360b 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -352,6 +352,8 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 		goto out;
 	}
 
+	spin_lock_init(&dev->int_slock);
+
 	/* create a nice device name */
 	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
 
@@ -437,7 +439,6 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	dev->ext = ext;
 
 	mutex_init(&dev->v4l2_lock);
-	spin_lock_init(&dev->int_slock);
 	spin_lock_init(&dev->slock);
 
 	mutex_init(&dev->i2c_lock);
-- 
2.53.0



