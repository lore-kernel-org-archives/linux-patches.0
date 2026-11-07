Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062797;
	b=TFSgSyCOdxcnjgTOptJGUyrc3yOyYn9xfb4Z9n2gUG6h3gyhilcNTvlWcl64neJz1STk
	 tPm2pDHw1d73FY1MZfvfkB5dJeAN0Cno3JJBCGyYie6+szIs+56Th5+hdxJoRwnhJ4n95
	 4/l9PzelWA+Ju4b7dtZ1QV5B7PNl8lX7DiwgGyXvVGjik/kbMvl/7wu+/N4myZd9uW0u2
	 e+he7FR9oq5efiwwJYbU7/ycA8nbdjLhMLCAzCbw/1B5BVWM9mJy1ArOvJoE54BN1FERh
	 Rw0HD1wcBjsawH7DbcPyWOyKh1nMRllGPEFpHEtOfKkwwaGbxTCmLI++m6tMDMKPHXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dOmuqP6LjLXKmejMbgN8TEgX/95sMNAeSsZUp/EdTv0=;
	b=HQ7iQZlV5ys9/Vtq0Ff0zYECSIDtr47I1H6NTGHBcnyA4wdVZp1GiLbqLsep5NFT9SsV
	 Zbsw4JfXnrvBRHrvKmvJqxwhi/u0ad80mEXs8BUYrbIF7L5atuLEk5qsqqNEciFK7LK/l
	 r17Ux7H3QM3U9SqofIxVH2Xg3EWLhXgb9bXbSqYAditsymzXpC3fh0Z4lV70DYRntBJx4
	 gQmmt2EcBKupSHDI0MaF7GjKvtm1U2JcpQLWrCBq1//3sODW+wPx79IveoYrAeVR/cWkL
	 2fJaY+tk7f5BzMcKz6U4WasYiIqUELXZqLFnjgr+gKQjdEDYdoCzwvMgrSUzFrIl3SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hq9oSHXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAAB606D804;
	Sat,  7 Nov 2026 14:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hq9oSHXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497DE1F008A2;
	Sat,  7 Nov 2026 14:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062797;
	bh=dOmuqP6LjLXKmejMbgN8TEgX/95sMNAeSsZUp/EdTv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hq9oSHXD7Ur3bMqSf5DDmFmTHOa+dfTwns+eGdyIJXCLM7cLY3JGFktz3Nw0r7jQZ
	 Joef2llBg0RT+5ZALSzilDsBehRikystZv8ie7YIrtZCeG+K4H3tAYupy6+CjKCl2J
	 EbVOKRkERETlPZGw6ciEQzo1kqrUlDRPKvMRMzo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/869] media: saa7146: Initialize interrupt lock before requesting IRQ
Date: Sat,  7 Nov 2026 08:46:05 -0500
Message-ID: <20261107134855.517035387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



