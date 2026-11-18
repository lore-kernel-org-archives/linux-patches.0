Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044917;
	b=Yte2O+wO4wM1mJ7DcHPl+RGQbjA+piGEEPoD/5JZi0dV3laeZ4jQYbMgnBTzV+uFk07+
	 bdHoa6z5B3//p+/Rf52hoxT69Hobtzv0VRKQ8nLWF460pTunAktUOS7Qlf6RcPeeiQpro
	 WaTijTJr5S2Tx1Rg5pQ/GUTevjaM2T/DwGkKkPlOmW9k3zPVSRyG3ffwsGqr5BIu3sbLW
	 F5QMaA3+DU7qq7QHvcpqvyarzMO0MxkU0pFsVNj4wu4HbkyqzLZu1xNjpTyUR6YuY9mPn
	 9DJsRCEFShKbe/fW9SaGy+3mk4uS4Bj4keDBMnqmV/RRn+KK24zjmc7W/zjczOwyfow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4X+i6enL+Mgv3do6u+mZbouYBalWnrAVdNE5WM2b6U=;
	b=0Hb1dkbG1FwDfqEd/sEy+Bnvkdbthq7qVf4+Iq7bIqX5irTCRUPglk0T83eNPM8bDDQG
	 RMRe9Wiu35degEhUkHMyXqQbmz75YBWtbb6qmCdXlDNCZdIep22TTvBLabDWP8/1Mi2Gx
	 vIdEPxeNRw+Kv6Pn0/K0jZ4w7NaK9Gbbf/l07b4go7HEcOUBI/0rZUIzjizuE0gaREzH5
	 m/qAe3s7nxhZ1Vf6I8/bmPzBI3r6BjcI2zf0xbaQqNDrndMnhm06Uf9MDVvdEJ4TaHM0Q
	 iDbtx72W+q9GS9mdl225sVZzC20weG9/raf6fkjT9gNmgXidbEwoE85IPnQ052hQ3HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0J+Vzwe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ADD606A325;
	Wed, 18 Nov 2026 23:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0J+Vzwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384FD1F000C4;
	Wed, 18 Nov 2026 23:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044917;
	bh=x4X+i6enL+Mgv3do6u+mZbouYBalWnrAVdNE5WM2b6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0J+Vzwe3t89y+xv7pxiUH758ebs7owLna/ZgGDxsA4dQzcxo0vIIabVYaCWpBhBm
	 JSykisw8Rd5npRefQndHGj9L0S7aG7gDhwtXg/2dk9R5oLjpb/pYxuztyu/vgtk+rV
	 JK4hMMAWLpl9QIa1jQnX4aG5T5B8pgCwLG52QIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0739/2857] media: saa7146: Initialize interrupt lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:29:33 +0100
Message-ID: <20261118150228.159149374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/media/deprecated/saa7146/common/saa7146_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/deprecated/saa7146/common/saa7146_core.c b/drivers/staging/media/deprecated/saa7146/common/saa7146_core.c
index da21d346b8700..9debe497aea62 100644
--- a/drivers/staging/media/deprecated/saa7146/common/saa7146_core.c
+++ b/drivers/staging/media/deprecated/saa7146/common/saa7146_core.c
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



