Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063809;
	b=S+BKm9SSfaTYuEKh6cnuUwdFOGeUhZ9xXDLVgM6K+yGy7DEQ0WiMUCtCiizKLSvttUBo
	 3fcXU+pZ6xVi9jY2M8bJLAggKSa683ZI4hBJvGEtMhbNFMGWcTinpz4DyyItfN8/iPryK
	 lhTBazd7kRBVXmeG/UN/Uh4r3byC5B9cyUvVocEpJkA8wRFS22oVnJRE329PL50PU56tG
	 Y77R4y1fG0wIcj3vXOAfXYyoHGDvLddrEsJSgA2z8KarHN+6n25E68WQr8C3O/o7dKAA8
	 dYnmb+mPMXSW8Hbd03u7Vkeen0enIbmMd9iNUzKKoLRqGuwIxWj05rjDJTDbZoylvfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PceTQNVMXS1Ti+CDxul7b/WvJsq3GbmKtx1gqrZPqvc=;
	b=kb9qdKp/iEkLenPVDFR6aLLHX8AVkAbLoDfDYYtxnfW7Jnla8r1VkHbYu63KTQ2bpoUX
	 3yYgFD7SPpy/Fbupek0Q5iyKmzdiTN7UirMCVDnm3mc7fQGsS+yZP8ozpWEGaUZ1NTrpP
	 TNxwKSLUzvjJK8qSf9Uel219CQZRg12wy0PdOfbwzU7cmu82VcthPO6AtjoOrCFUXTBZ9
	 KZbkA3kaaCXp1Ern3e5ZlGBXIgu71sa3PqKcM/AMHB+JlM/YrDCIsI9DdLQehyWwzlk8w
	 W1imWQxsMKRbqn92K3e6vVWperJoT06BMOp5Rz+LLONp0xGlAyIVmdKeUrnegKKEp6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxMmHgDs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D66606EE81;
	Sat,  7 Nov 2026 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxMmHgDs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1F91F0089F;
	Sat,  7 Nov 2026 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063809;
	bh=PceTQNVMXS1Ti+CDxul7b/WvJsq3GbmKtx1gqrZPqvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxMmHgDsuLFe52v38VMLZkajPTj6wrbFhcHfanTDplkmAvwNcXwUTPUD7fPB8buXa
	 /tQ+NY1qdgc1vCzDzyi+bTG7JcAB6YViuvoG3VmzsApCWR3X+b4pd63DG9NKOu62ts
	 0LlipJizvRsLxScwb6HAhdVUHAFryvTdDq66X6nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0027/1257] media: redrat3: Ensure all urbs are suspended
Date: Sat,  7 Nov 2026 08:38:43 -0500
Message-ID: <20261107134940.155101731@linuxfoundation.org>
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

[ Upstream commit 1582f545273f2aa4eb4ee6f3a89b433f5c85c68f ]

Ensure that the learn urb is stopped before suspend.

Fixes: c49fcdde38cb ("[media] redrat3: enable carrier reports using wideband receiver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 1200fb49d8879..fc514d9f868b1 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1168,6 +1168,7 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(rr3->narrow_urb);
 	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
+	usb_kill_urb(rr3->learn_urb);
 	return 0;
 }
 
-- 
2.53.0



