Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623604;
	b=X9FlBLaqOKJb9EDU+32d3TOqxltmFZRz0j3Evks0WYDKndnd1uLwqTDOoJQMVx7t8juf
	 mPRRZ/sBuH5NYAphN+twllRaZNqNwRCPlVfFFg/MFLVHpbIzBP6p5aEF+Ou/buVoQdT9P
	 9/50dDY6k6CiSdVlrZRMea5YiOE7lik4SdLQOIAD7yXAXHVpivjDuDYxRbzLAsd2o6JrH
	 Mb3XL1iFx5yjs6uqPSF1PbGGWmdq089TxAdpmwy3xsLvbH/ee4fh6/l2pO2fmvMZwRpFy
	 QbZAtd/j19Suz5/aDbTJSrsVmWXvoBNp9lMQ/x+9PyX7vjh9Q/JwBsYrL/3CU1cldoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2QGd1U2SANKP+eYGu25V9HhE3+xlqCnwXWgZdeAgfY=;
	b=BKsEbqY6lZWTsQCnqFow8mDOsjsKm17pOUKPoF5Mb1nx+PQAM/qrC3qnzNFQwxhT8rWI
	 RxEHoz+4QAfn1CxbyDG6JkrBeI6mFElS55/NcBXoPPoZa7EOvvAMKp3peGkdNgQCjHkx3
	 rn/arg1uDQaj9MaZet11gH2vhN76swuJgUA/nZEt98lkvq18ar4mJ1IKS0qK59D5wpCOa
	 cySl/4W3KEZZgJ9bruXVHFdhSMlvjPcufL9YEFiWgKSvTR7P5I+C750u3LrK+vwi4ECbv
	 HxLGaMRGxiTBq+y83FUdA219EkfpPHv8OhjFUXb9F+CG1Z1a6JdFEg2xNYPRYeANUtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AxPLpTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FB3606A31E;
	Wed, 25 Nov 2026 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AxPLpTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CB51F000C0;
	Wed, 25 Nov 2026 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623603;
	bh=R2QGd1U2SANKP+eYGu25V9HhE3+xlqCnwXWgZdeAgfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AxPLpTNOe1uyfMNZiSflaXCCNODsjUQIGh4lc5Bm//9x3qX9xvPMYj4eOfqUSFg8
	 iji2NyLCSeDUC+HxmeWMDiPMC7OXx+yQQoyIEFFpuly1mz7vlv8u4uD1J+my4iNYjx
	 6q99MFFn5BIjNcXM3FwB7tFgYbwCVVtdmX2Qg6+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Leonardo Costa <leonardo.costa@toradex.com>,
	Hiago De Franco <hiago.franco@toradex.com>
Subject: [PATCH 6.18 912/990] usb: gadget: f_ncm: restart the TX timer if the TX freelist is empty
Date: Wed, 25 Nov 2026 15:37:59 +0100
Message-ID: <20261125143843.367678242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


