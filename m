Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035914;
	b=KCun5R9CKPt3j1MdANStm9v+fnuqOISYf9HEV+KWjXDmKeCE8s0oBhOJiExTlMfo+Dd2
	 525O19PUlYgHXM0t1JShrnYdbgQr1X/aU6u4SS5P0mcZQqCXAPLLahYdC4tgWYKEuqfJP
	 xmeD6CP/U8n1OF5ksi63Gct3K/JbKcNgPvadeteIVCd0F2vY6fItSM61l0Ze2okdrPeTT
	 lVHPzrVRE6TOcEVlOplOe7cZZ555EXjz+nqNi1XDdg8hDgCP4hq9slMnkNWG1kBBqM+p/
	 lNXSvFA5IPQpXZWEsBsGAEcfw6aP9c7KUtesutKgPdeKdRDDyr5h7I8YNxsLkqttiTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yQ48Gw34PfPAt3dtYmFHwxYIaomhKx5FbUmHKVDL4Lg=;
	b=LsNKGlYNkG5pw7glvM35L9y8d1Hye6Xtzg0jBL52TP3xEnVfUroohywPFKrO1wr5h/bV
	 0tQLih0BQuCZApTgYzSFgQuwJWcT08qWD7Qi9B4F5dB3z0F+PElSULnnmw5pX0qNLZb75
	 krm/Gtp7G6z/CYapER89Xrb/x28Jl3pCTXkQFcjBYN8ueeXuqFDDHzJPrMR5YTBsIc4D1
	 y8Inz+8MbZ4JX5VS4ecbSWOuvrZTb9ERXC8xUhX7/I6qd5rdrNK2ANKkxumSOdJjI5Wgz
	 qyJrSeItn5OGEJBNsZaZj0NIZ1tyKvLZgQ2MTrpSzqAyYnchjMNlgTGpfYsEbT/NvSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGa8kwjx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FD6606A32A;
	Wed, 18 Nov 2026 21:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGa8kwjx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B7C1F000C4;
	Wed, 18 Nov 2026 21:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035914;
	bh=yQ48Gw34PfPAt3dtYmFHwxYIaomhKx5FbUmHKVDL4Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGa8kwjxZFkgFmyASant6WWPOijDzWS5Nh69npjAGBpwtugqgiVbuejJxhMaf2tKv
	 f/80BvwpU4ve46bMNp6HKBGQQzhCH/oR9+1BmsOaFSsxzxHj5bjSMvyioC9D1RcPAI
	 D8SMo1QYtAjfAXqJv7iXhLS4hXnLA4BFgVxXdUgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0835/3318] media: saa7146: Initialize interrupt lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:24:17 +0100
Message-ID: <20261118150344.197561636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



