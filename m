Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058105;
	b=Q5EcVZXB1hPo/i6TR11qAiLG7WEJP+aehsIS9bRk0gCSVUIqdpOtBNsmchxT8IX2Bsrf
	 nHb2cKB0ASfHzNVAZverurm+2raBvCR5n7Xu8aBN41V5uRXwZs6ppco6hK/0R+srzl/Gw
	 l6yPf/Cuh7u3zNRY2WllH/5DxYmO4DJKTq+awe4ksnrD0OSf/ECduzgM58DSahrV0Cy4c
	 Fx+6w1YXFdfFBp8Nun0Ku6Nf10Dlnk3HnGjUG8a07tbXAiGhscxLbgnOQ6FLIq6tgdGKK
	 iYnCv6Ndvf33W3IH0KLRrEQY/E7pDFRHXsz0J/kbolHx8GB1WNIgmcpTu5F8es2C8cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ZMypCFYBFXeV3HW3sATWX8WcCkTlWWgmMgxhpty3Ec=;
	b=pZUvuPCud2Ua7D0hcyTdLa6VZFE6kp3KL3tjMdA+1grr4YW1j9fFmDEIUzE8VFUg0SCJ
	 n3b9BUuRXdsGJ7Y1q5pQtBy7kCr9Zm9nyKQc0YL9wLfE/3PMa7ReiI5womiWnd8DTWDHl
	 Ksnpm/O+h/i6oCfX5wOdR6Pc6aKo4XnumNDflEZQjzs04Gv1XBRKi/5DxAoKSHz8swGgt
	 y6iefi88GTtKcth3hFDSedErkqHAkDsQ9axMvDj3CN9lDOKu//Cfh0BLghrSPFJdQV1fK
	 MyflaMsp2hYTGxwEXHaQknUCWpj5CDlRPF+/Cn3Kocs3Q8p4QbmnqoCEkdXXhM++w1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQTAwaw2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDD3606A320;
	Thu, 19 Nov 2026 03:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQTAwaw2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151211F000C4;
	Thu, 19 Nov 2026 03:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058105;
	bh=3ZMypCFYBFXeV3HW3sATWX8WcCkTlWWgmMgxhpty3Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQTAwaw2R1ZJdAV+pUUvK+ssw/fOCMJR9DwdUiEMRP6AUTxHYbfHxyMISP5sWegnT
	 crbqu9V8TKszTkRkKef0aoI7K31n2u5WRmtY+yq8WrBPrxZI17KEdgagbIW26pfTtr
	 3CJ6WevGVqs2KpmveRL2GdDYNtIh7B2mASq4dyJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0368/1848] media: saa7146: Initialize interrupt lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:40:06 +0100
Message-ID: <20261118145928.796538325@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e43edb0d76f4b..4aa43e2816f97 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -352,6 +352,8 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 		goto out;
 	}
 
+	spin_lock_init(&dev->int_slock);
+
 	/* create a nice device name */
 	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
 
@@ -435,7 +437,6 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	dev->ext = ext;
 
 	mutex_init(&dev->v4l2_lock);
-	spin_lock_init(&dev->int_slock);
 	spin_lock_init(&dev->slock);
 
 	mutex_init(&dev->i2c_lock);
-- 
2.53.0



