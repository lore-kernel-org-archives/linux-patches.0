Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026124;
	b=eE8OroOYcYBq1DbNWj4xRpqxJ9RDi4JNEfhMXxMxs1m+DHLR0fsiFTnLZWUxkgHbw1ic
	 /n8t0tdM5i7xdPsmcvrmZOhPspKtBh6v1vPUJdBCOgF/SDKB8lDBHrCTue13x2WqD4KQ/
	 7qoVw7ZObDz7Ltt/PcYU8uBYHhkwaf8A8bN3RI11WTXvf8+PgllvZzoN4rBiwSBiC5flX
	 tm4CsuC9w4GeUfKKGSTQD7KbU8NBeQsedX2TsmToDQ1orEVdVxJnnqrBZn8Ss9brx6DHE
	 +n5ACxfO+chvnhQclVQGYeDlRFcvIRbVd045gmDoJjFcVVe41HmdvP3JaeJU0cVMHWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lO2slhE47jxCmWQ/s1d1Yo+CY69sWmM9qBRs9uf3Tqw=;
	b=XUNtdQhXyh3OdgJWo1wNtzaT7DIjvrkGHfDxinqYeqnYS9BZ4rzYtarxWZVzacfI0Atz
	 fI0xQOCEG+gbT5lowf2wbvZbfg/+Vods8vxVTuDLXwLrkUEK+EjTr7MWUhsZD4POzkh9f
	 ZzDQs+QhOWtbiRK9w1QB1yBssmj0mgHawJnk/6rQS/4GedZ9HZD8HXEBuYIQGNVP3Bw5a
	 ztDsJg/IpmbJCTC52ZaaIqIjL6SNZkNLCiK4Rxm/JpMhdCOgwt7eFTpSv8kREXe+8N+F0
	 Cz5Dsiadn2/ANhi84kL2eAKSBFbmUmn+4poEkc3RGqtRh7alI5W869g5CHuqqVyQweA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIjYF1CO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40A1606A32C;
	Wed, 18 Nov 2026 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIjYF1CO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CEE1F000CB;
	Wed, 18 Nov 2026 18:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026124;
	bh=lO2slhE47jxCmWQ/s1d1Yo+CY69sWmM9qBRs9uf3Tqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIjYF1COd1uxKmkd6xtjCPakMPV11oB9Sf2c60sPBGy45jo4Zo4mNfaKE0xqIb1Yc
	 tPM9jMg9QX8Jik+MUJFIJg79hmiUvHRkWC2xZAle9fvYLbja9ZWXPzCC+AyPNIX4oZ
	 wHx2rYjMiSpZMzwVFyq+x6HVIs5OWe7bzsoV32rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1322/2151] mailbox: pcc: Free the channel before unmapping the shared memory
Date: Wed, 18 Nov 2026 15:50:57 +0100
Message-ID: <20261118150210.245642134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 5189791c2790d..912819bb0b665 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -411,12 +411,13 @@ void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
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



