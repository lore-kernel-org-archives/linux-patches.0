Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620477;
	b=M9GAUy8qjOTBDF0L+Ad8Kj9Xt3NBOj4MxpOQdvoHQEAyRiIoVxLfR4r+4/aldA58H0NU
	 nDTNMNRGWOmZ+YhinEWa93mpo1+OFydHtqDAx2XOKtE1UxI925Z32VKQxYISRbv0y8kHK
	 IcErplLCGp55ROePStelkPe+EgPceFqU4B2ARpo9qdbNAG9PFtDYQcZ6RF4Q6Y9CijQeX
	 dsI3LZKFICZI841EkCMOt4MtwKh5R1gQ8M/EQUBHT+p1t/o0eJO/sfh1vpKgoIzmtwp9Z
	 ttmGHWFTUXW3sHrxSGEmz0l/jPIFU/6w+HChthyql0fjMuqOIuRpQH0prM34sJ3kKCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pqvyyk54KknM2yKY2Ap6fiaSvtycnIKI1D4T3/FW/3Y=;
	b=GibiCV9dqDw6yPyfOJJsEcdZq/Nw60wGbdiA0v2TG2Ax5oRWaMMqrDglQW8iM+JS4lWn
	 48dovtbexacWnLK2on+9Zoys1DXmjktTrPAw0BXJKq5Bs2Swer7ITobk/CcPvzEtQAi72
	 Enx18v1uvbNRRYsVaT4ZtosW5N2lNUqNI2oiEjGR1wEAkO/WQj2CM2cbEyRW4pGHPstqM
	 AZp2tOZ746on5+LBjpW17QE08HmQdEd9z135oQtNoivQfFqF0LwxGoIWujj0G2l4uuLDH
	 iI3EuiJTZW3TLbOQ0lvc/mQcfzbS/K/0yzPVgIGGDja4UF885NC3dpqK8n3W0zi3GOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPQ9mYkE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E374606A321;
	Wed, 25 Nov 2026 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPQ9mYkE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919751F000C4;
	Wed, 25 Nov 2026 15:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620477;
	bh=pqvyyk54KknM2yKY2Ap6fiaSvtycnIKI1D4T3/FW/3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPQ9mYkEwm+hopK3BgD2RNB4VYN+KdC6J6tbDBKTbp3KymkPCITEgTWON8TtYT1kI
	 yqBTeV53E4z2UmXBghYXCLXwvk7aGqzWCPO+h1KjC9vw1W5oVnFVzb46f6+7lW/yY+
	 3MVq6miDvld8+LapD3hTDjDh/vbFYKfHzAKukUuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Leonardo Costa <leonardo.costa@toradex.com>,
	Hiago De Franco <hiago.franco@toradex.com>
Subject: [PATCH 7.3 0929/1005] usb: gadget: f_ncm: restart the TX timer if the TX freelist is empty
Date: Wed, 25 Nov 2026 15:37:47 +0100
Message-ID: <20261125143843.447379552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

commit 78585f90feb3bbaf3b1c642294c8c47e451dc3cf upstream.

ncm_wrap_ntb() aggregates datagrams into a pending NTB, which is sent
either when it becomes full, or after 300us since the NTB was started,
using ndo_start_xmit() (eth_start_xmit()).

ndo_start_xmit() returns NETDEV_TX_BUSY when the TX freelist is empty.

For regular packets this is fine since the networking core will requeue
them, but for timer-flushed packets there is no logic to handle this
situation, and HRTIMER_NORESTART is returned from ncm_tx_timeout()
without checking eth_start_xmit()'s return value.

Under sustained TX saturation the request freelist is empty most of the
time. Since the timer is never restarted, small packets keep getting
accumulated into the NTB, until either TX_MAX_NUM_DPE packets are stored
or NTB_DEFAULT_IN_SIZE is reached, which is an unknown amount of time.

Check the return value of ndo_start_xmit() and restart the timer after
another 300us.

Cc: stable <stable@kernel.org>
Fixes: 6d3865f9d41f ("usb: gadget: NCM: Add transmit multi-frame.")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Tested-by: Vladyslav Tymoshchuk <tvlad744@gmail.com>
Tested-by: Leonardo Costa <leonardo.costa@toradex.com>
Reported-by: Hiago De Franco <hiago.franco@toradex.com>
Closes: https://lore.kernel.org/all/20231204183751.64202-1-hiagofranco@gmail.com/
Link: https://patch.msgid.link/20260817192638.437798-1-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1148,6 +1148,7 @@ static enum hrtimer_restart ncm_tx_timeo
 {
 	struct f_ncm *ncm = container_of(data, struct f_ncm, task_timer);
 	struct net_device *netdev = READ_ONCE(ncm->netdev);
+	netdev_tx_t ret;
 
 	if (netdev) {
 		/* XXX This allowance of a NULL skb argument to ndo_start_xmit
@@ -1158,7 +1159,11 @@ static enum hrtimer_restart ncm_tx_timeo
 		 *
 		 * This will call directly into u_ether's eth_start_xmit()
 		 */
-		netdev->netdev_ops->ndo_start_xmit(NULL, netdev);
+		ret = netdev->netdev_ops->ndo_start_xmit(NULL, netdev);
+		if (ret == NETDEV_TX_BUSY) {
+			hrtimer_forward_now(data, TX_TIMEOUT_NSECS);
+			return HRTIMER_RESTART;
+		}
 	}
 	return HRTIMER_NORESTART;
 }


