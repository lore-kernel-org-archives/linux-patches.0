Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061934;
	b=ShZwHeNfOx8nKPAqi5OGMWC3xNllHF50zkCjPxnThmwqPIu6tXyQ5innWunVizj16l6y
	 mGeg4mMsVZ8bFpDFjLSs7UD+2vrjvalw5aLy9PXs3lIUJq6g5JRbfjS5wBQjt9FEwcxYt
	 XO2TqJP6L3wpCCL+ArtsMxjZR18cqKzzEdyPmFDTGeHcMg4q6jgOY05XblxSjTR8hosxB
	 67v3RDP3X2yNqBk0xlgQzqNTgkzv2PljJotzdYdMexns0bQHLxLE4KqpnrIixmHbqY+16
	 BZpZSp03F5JC/4tJC97p3mPf0gjbal0JIlpgWSqrcgMJwnJ3AnwypI5/1RxY0aCXgKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mXYwWmQaX7K26jm8Euuvwe8cSm2W6lTfvgNPGL7OqLw=;
	b=YjGfPIcjI5SW2Xk32j4rRMmLnVYM2MbM/BadPsouFlg4ZLjOMcQmGDuAnlEg3ClKIcBq
	 43CT1TU55iMGvv7Lp2YoJR5reHIC1T12d0Uh6+Sckduqi/zFmo7cKevCmFHxgHLz+EwwK
	 00yDe2Vy/jDNR4ekPSYcZcoWGFORbmGzHI0Oyb1uZ9Z/Qhx0tgC3dGs/FY1OQdf0tK/Z9
	 YyXrn7hAb8HIXUl1TLGcHzeLSg29LdEkceR/Y0S/MjoTqTiPeb37W6UK2JV7004yFhuYe
	 0XPOKSqv9RhDgz0/6Phivrn0gzEkmR3Vbcyaq5m8p0bn/r8QQ+IgbSEzwKry6WNKC6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GneWUnkR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4FE606A32E;
	Sat,  7 Nov 2026 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GneWUnkR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00101F0089F;
	Sat,  7 Nov 2026 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061934;
	bh=mXYwWmQaX7K26jm8Euuvwe8cSm2W6lTfvgNPGL7OqLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GneWUnkR1icZlpWhpfuWHZZoGlMUOfZAotPELJPbNa/tfKdKvLzu6rfaNUNa9p0Cn
	 5f3ihEKe2huCzTzdx4F1lLFGFsITsR3lRKAn2nsSzste37BZc+Ftc0IOd2pJaclLhh
	 1eGWL8NOk2fKlu2pEeqk7WxbKt6I86wweVJA5V1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0937/1536] media: saa7146: Initialize interrupt lock before requesting IRQ
Date: Sat,  7 Nov 2026 08:49:13 -0500
Message-ID: <20261107135023.967440554@linuxfoundation.org>
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
index 27c53eed8fe39..e908af0693d26 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -340,6 +340,8 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 		goto out;
 	}
 
+	spin_lock_init(&dev->int_slock);
+
 	/* create a nice device name */
 	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
 
@@ -425,7 +427,6 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	dev->ext = ext;
 
 	mutex_init(&dev->v4l2_lock);
-	spin_lock_init(&dev->int_slock);
 	spin_lock_init(&dev->slock);
 
 	mutex_init(&dev->i2c_lock);
-- 
2.53.0



