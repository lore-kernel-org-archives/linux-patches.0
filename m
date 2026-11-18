Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041208;
	b=5RG4giRU3LsD9bwWK/bmgITBv4SxCa1DftxQmLd9PJcjaqK/B4hS0yOnpbzKCVwJ7DfH
	 bkFi0WvAuG5e2T+CdzqCS1Jl4EmqAdJsfpgHCxJxKyujiBx6QPADMFv91wNjVRIdzRAxy
	 vesg1RUnqdwmhe7qrKgNBMFRtiaMLoPaYrtU8Y3KkLArK5GcOLL6q9CbFQXp7qAwYp7WX
	 8oFmxVGsSaEmO8Ut1gBU/VAnsp8HI21U2s1pW48rnSQbf+p2LyzNfUBFTccDFXpBh9HVr
	 sL5+JoQwKU8STucU6bNq1FSzQD1V7zydMcCbkIbpRNFTK0WzMluLjDjsocn8gEyK8Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=di9sRJf1HlB370WRad9gLWedCkaDwSdSIciPJtDV/Mw=;
	b=bGYW+p1tWooVVA4BGdnv6HSFcG5f23bo9mHfkVH6NmsmCscZPckCBbYudbiSGptl64/h
	 iK0tcf8KOnkDHZOVg365g4pVaNYP4CQbq2u/S5HFh1fCoi4Ho7bJ5ddNz9p0q6Wv9no2s
	 6GXYQ/SMG6qQEqI+JYXbkP2nOjfmYxy77GXf2czLfSsmYIbmX2kxBT6Zk5AymhAA71rq8
	 pw1lNvrpWAsfW8PhHvg2UZTI3HWnZ4DmT9590uBWgCL9QLzvOPRv8kBjVSTyPKAWnlCe7
	 yXJWmU8Jxmo9WUlAcg2OPMVrAnqwrC1Y5ePn7MNOT3dhUvxSvX1bkcZ15zCkGZq+eJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UeXUuxPh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462E606A320;
	Wed, 18 Nov 2026 22:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UeXUuxPh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC6E1F000C4;
	Wed, 18 Nov 2026 22:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041208;
	bh=di9sRJf1HlB370WRad9gLWedCkaDwSdSIciPJtDV/Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UeXUuxPh7Cgs+4PwZhoGQgnRm2vRl+MxRQw3O0WC3aTiAh+V00tFTQuWnhw2OEbPI
	 fA+ZM4wwLBYOIg0FLXH5b2k9cu5zzebpDHRXDyS5uzaTbpqi2nUVLHQU3xUMFPevVF
	 3jO/xP7idNWgfSUj9K4QwOA/tQmF/FS9dSWV4y1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2732/3318] mailbox: pcc: Free the channel before unmapping the shared memory
Date: Wed, 18 Nov 2026 15:55:54 +0100
Message-ID: <20261118150442.770403967@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4ac21f3fac3e8584fd395c59044a8e99ac618572 ]

I am seeing a crash on PCC that is related to a an shared memory being
unmapped before the IRQ is disabled, and the IRQ kicks in and hits the
unmapped (NULL) address. This is a summary of what I see on my box:

	scmi_protocol scmi_dev.1: Message for 1 type 0 is not expected!
	Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
	 __handle_irq_event_percpu+0x1c4/0x9e0
	 handle_irq_event+0x98/0x218
	 handle_fasteoi_irq+0x230/0x750
	 generic_handle_domain_irq+0xac/0x138
	 gic_handle_irq+0x344/0x740
	 call_on_irq_stack+0x30/0x48

The trapping store is iowrite32(SCMI_SHMEM_FLAG_INTR_ENABLED,
&shmem->header.flags), a write of 1 at offset 4 of a NULL base.

But, back to the problem, pcc_mbox_free_channel() unmaps the shared
memory and clears pchan->chan.shmem *before* freeing the IRQ (aka
calling mbox_free_channel()).

The interrupt is still live when the mapping goes away.

Free the channel first, before the memory unmap. mbox_free_channel()
calls pcc_shutdown(), which frees the platform interrupt, and then unmap
shared memory.

Fixes: 7f9e19f207be ("mailbox: pcc: Check before sending MCTP PCC response ACK")
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 6efeadf89db2b..69e545468674c 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -422,12 +422,13 @@ void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
 		return;
 	pchan_info = chan->con_priv;
 	pcc_mbox_chan = &pchan_info->chan;
+
+	mbox_free_channel(chan);
+
 	if (pcc_mbox_chan->shmem) {
 		iounmap(pcc_mbox_chan->shmem);
 		pcc_mbox_chan->shmem = NULL;
 	}
-
-	mbox_free_channel(chan);
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_free_channel);
 
-- 
2.53.0



