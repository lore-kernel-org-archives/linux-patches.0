Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213346;
	b=peDWDa9jW+0HE/cLv7N25Y/75LHfSop7Oa5Uf84FyS0/WCOqepjJC/cqbCUQKg2vYCmT
	 95/32zpvrYrseqv8Usl8obGsL2PEm67p26d/Ke22V9KTAjJVQLVs4jRFxxXh5G9v+SmIw
	 2U01c/4YkKfrrk86zwmohqj6iXw/M1fqGxTjqhiCLbmgUmWcPJfOcrVl5KDj9afYo9Yxv
	 RGxQMJKAkfIQ0gtv7B5XVQIT0et/InmGQlw2Dq/8prr/Isg/y2hldtI9hkrXV/girrS/E
	 3wTGIvrdeLlE2r0xxcxBgfsTw8rCF411AGQBL4BPhefy0sFTdRPtgXLHHOKHFtYXaSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZqrKgAUc7zdNvyUHtzQtHvk9IYLOZYeMziyfpxp/F6c=;
	b=SFXrCe4qhpDRRML/He84YiNrZZZgtqPfeHiWcEG54JxLsw7Sm3WURtj1fNeYP0XORWzm
	 BV495hOK0xhbM0n8YaV5/4YRfruORf0NQOO/qHLVPlc8s3WuubuLNYjFf0/ncEzxALVNX
	 +/2JcvQye2QVtAFjuwf/fSpSujzSvBKdovijnEEtAD0v7egm+EKteKAyseH+CDt7vWgYF
	 Ztqs4RG08h+VpBx8Vz5mXFzxDYZoA1rXOq8OvQbWI6K20g5NoczrarWGaPHJiV6yn3228
	 eNtT26XOAtfOALZG1WcozN7HPPmDssHsglAWD0i4tuSBgDv1R7L0Ccv8698NLkZ7QSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtLponbV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC240606A31A;
	Wed, 28 Oct 2026 18:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtLponbV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38F61F01829;
	Wed, 28 Oct 2026 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213345;
	bh=ZqrKgAUc7zdNvyUHtzQtHvk9IYLOZYeMziyfpxp/F6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtLponbVhGXCn2n2EpG60iD/HLuHW89oTdKRFXOeaKhgdY4wZiNx2V7o+MWMDy4lM
	 rd8PHw9+HyMJr1AwC0g/LfFTzKDlB4MCEsXnWKdohXX52RGKk39Y2zvgmpyRUAPHLR
	 qwT11LcC58DjpEs/yz8BaXvlDaG6x0VRKagOoJb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0472/1887] Bluetooth: RFCOMM: free the skb when the DLC has no owner
Date: Wed, 28 Oct 2026 17:42:48 +0100
Message-ID: <20261028170509.981747323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Maxim Skokov <skokovmaksimevg@gmail.com>

commit 9d1afbf60ed53c5b051cd124153e0ae3078c8b93 upstream.

rfcomm_recv_data() hands the skb to d->data_ready() and returns 0
without freeing it, so the callback owns the skb from that point on.
The tty implementation frees it when the DLC has been detached from its
device:

  static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc,
                                    struct sk_buff *skb)
  {
          struct rfcomm_dev *dev = dlc->owner;

          if (!dev) {
                  kfree_skb(skb);
                  return;
          }

The socket implementation returns without freeing it, and the skb is
leaked.

A connected DLC can have no owner: rfcomm_sock_destruct() clears
d->owner, while the DLC itself stays on the session until it is closed.
Data frames that arrive in that window still find d->state ==
BT_CONNECTED in rfcomm_recv_data() and are handed to the callback, one
leaked skb each.

The leak does not stop on its own either.  The remote runs out of
credits only once RFCOMM_RX_THROTTLED is set, and for a socket the only
place that sets it is rfcomm_sk_data_ready() itself, below the return.
rfcomm_process_dlcs() keeps granting credits, so the remote keeps
sending and the leak keeps growing.

Free the skb, as the tty side does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Closes: https://lore.kernel.org/linux-bluetooth/CABXGCsPe5wykd8Aj-hm+SJ7SGQyb8yoGNnx3XDpPmBathj+EGg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -50,8 +50,11 @@ static void rfcomm_sock_kill(struct sock
 static void rfcomm_sk_data_ready(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
 	struct sock *sk = d->owner;
-	if (!sk)
+
+	if (!sk) {
+		kfree_skb(skb);
 		return;
+	}
 
 	atomic_add(skb->len, &sk->sk_rmem_alloc);
 	skb_queue_tail(&sk->sk_receive_queue, skb);


