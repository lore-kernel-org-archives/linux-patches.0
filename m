Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705667;
	b=YzQV4wRLo8zbyO/zyw/CNFBE8MhbVGr4gqT23Ti00CRfIg+hQkknNumBZbZo5GacccsG
	 Fq1WJ3l2AEQ9K/pKK1xPqmAGyj0KseT73A5DISS0C+qZG8jUu+G0FkkjPBzHE1+Oz4Hxq
	 loFNkPNtflCPB2LD3AK9NWK+172+icgxLXaV3zHem6N9vMJ5TWIxVX/kPvO2sQI71TtmT
	 tgYOBA4BYO619K71Md33WYIos6qlhNJTi2BBOL7V32+7OakKSLlG0/Cxd3Qyph3rUkiAj
	 J2qmrDVcq5AC2mXWU5yZG1ohkx9JkTBJr2StOoT2A8+ZzR1YbvoCJiNK7WR5N2MuURA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=orxylLcDhPF7+h4xpJnxeg+PYQ6An2WrTHRfraW2VHA=;
	b=1fCtw8ToyVnL0/Ft8xcKUxaDnmEW4t7pNkPPSh0cstrY3KqktcitmxB1Nr6GvqkaAp5V
	 soM6HGqu1kzJMruu7skR1tqL7r424vbCxfKvwIoHxVYrmEAJZ0UbxFWbn+G/DM85W0Vac
	 kBMgRkWZNvntJ0o7az92ZBJ7ZH+LgJyl/ni8H3zJ1ixpL26xoRnDYplmm8mUwyTQyLmLS
	 L0sY7Mmww0oHc8qF+tAL7ncGEElCrx9yEyxoRCdV+GP1/zib1VHUi/HA7OfSrSICxOnzD
	 2LiopeVPpwZ4TjyXZ/2pwSdbV7wq+S7iUXcgGpKudSVEDtHsQGQKgE//2/HefbLNZCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8ikvGNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC2D606A32E;
	Thu, 26 Nov 2026 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8ikvGNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323A21F0093C;
	Thu, 26 Nov 2026 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705667;
	bh=orxylLcDhPF7+h4xpJnxeg+PYQ6An2WrTHRfraW2VHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8ikvGNFOXj9AVU4H3e+M1EmfZauKM3pYnh5kJ1LGUUtenGdPVqIHGeQtkm5EkleR
	 ph79YMJmQBREFLOl7amQn2+0dSmfPKX7aDXqugKqg7krX4EL3bgdomZo6zptsNxyLi
	 bZntFke8QKWWo6eoyMrevuhxZwADvOG/ZRXG58AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Leonardo Costa <leonardo.costa@toradex.com>,
	Hiago De Franco <hiago.franco@toradex.com>
Subject: [PATCH 5.15 276/319] usb: gadget: f_ncm: restart the TX timer if the TX freelist is empty
Date: Thu, 26 Nov 2026 15:40:44 +0100
Message-ID: <20261126144012.983806618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -1157,6 +1157,7 @@ static enum hrtimer_restart ncm_tx_timeo
 {
 	struct f_ncm *ncm = container_of(data, struct f_ncm, task_timer);
 	struct net_device *netdev = READ_ONCE(ncm->netdev);
+	netdev_tx_t ret;
 
 	if (netdev) {
 		/* XXX This allowance of a NULL skb argument to ndo_start_xmit
@@ -1167,7 +1168,11 @@ static enum hrtimer_restart ncm_tx_timeo
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


