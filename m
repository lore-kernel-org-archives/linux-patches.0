Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063891;
	b=YQV3Z8JrVoTO1VJdek16qHEZVVcURom6yVgWGQFapQImy46e6qg6CjzDpaTM6kvpaDUN
	 BodxlLVt/yqZFQ33oriyiv9orxAmTRnd6F147nllDb2Y3VByGhPwWDGYHb/kYzUrX2Rg7
	 F3tdXTGU0o8WRX3qxmusE/7rZjMIgu6M+9iiA3UIw6CWSRXZbt//uiX58QAsnD7GLdCDZ
	 AgJ2P2B/6BSKWpAwBeJ9MJIb0OiU8zi8wtROOIQ8kd1CxLzDsxykLmHSLjoJa4aRNScnI
	 pVNgtGk2koBu5NqZVqpNoT2YNrVVtxqHp4G1OwjvfXgEnNk9x6d0QcXsaupHTmxBzXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UjVqnk/i88jVJpV8Mog87M6X5f3AOpxAqVlynDJsuyk=;
	b=uxk8qNhdjVj1yV0J1wm0Ps9kW7COTwPBMc0Nc1xezYxWJAPKBJM2Fk49UvL6/o/NXNa4
	 iX1w5h7y/OCN10kokGJpTVPSPupXMhIhNrcr2j4xOgyQJSZwFEtBGZhZH0B4JCLe9gM8v
	 jd80CC+UuFPQYTBaoXAy9YYy/2tyLY8v3LzDuTLnTSqvfbKee2gIVnOzxvpnhQxqv+pDP
	 ACfOhsye1EW42dGYEHg3kJem+v8IV5LnPkYwn4DLTktTW1n6shQRUaeTj7CooDg2Nvv9C
	 PQOQJyTULjV/LLFwx720wL6uJfySFeEDTKKTV2oK9YOTwmNOTcUCSl1RqGoHou09NZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ommwjXKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE57606B8AD;
	Sat,  7 Nov 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ommwjXKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56771F0089F;
	Sat,  7 Nov 2026 15:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063891;
	bh=UjVqnk/i88jVJpV8Mog87M6X5f3AOpxAqVlynDJsuyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ommwjXKD11KOT7U4WBryrfPGku+azfXVM/c0tJYR2mN0iobENngQLEIqKBn47j0wl
	 XWG1MRZhoTv4d4gLMEMjnEXsx/e37cVQDGpO0fncLx1uiR+JYtYrISzad9AIrUJw6G
	 KohSKhEYdLs0Jt/XZRDFXVjAvtkJXM30FN4eeoq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0094/1257] media: saa7146: Initialize interrupt lock before requesting IRQ
Date: Sat,  7 Nov 2026 08:39:50 -0500
Message-ID: <20261107134941.959675310@linuxfoundation.org>
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
index c297d019f2b3f..70d6ca00513f8 100644
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



