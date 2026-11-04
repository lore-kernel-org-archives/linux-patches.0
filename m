Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829423;
	b=UybGR6Esq1COid3cRa1/6GZgl6ox/mGzLqmcXcFZ5bdyoU7eVgafSBsqnpg17Vf9sYAj
	 oBP9wG3jTXxECDFjjdg4YLXVmwAI0iZ2NplE4cveO7GvKzmcuwa8DGy+EGVVKQJW+TPsR
	 q6zBGrakobtDyrKndvihadJrK20hkUlymdpOOU3G8mQkbxQsXQlx8QqgqwsJ8fSfJakV8
	 nh4U5CFWpgm2B6bjOZUzYJrSC5UNXU7upzkyzHH2iMIFv0CAH7hF2LuQ4oMxgn1iTnqBD
	 O8teTGfKrdEX6jFflXAIz0oTLTIfs21J3E0wX2eRHpEpEC1JnRt2IGA5OC6NjmrHT6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XPBlF/VLIIzKVknLcSJ9ZGdf7FD7B8XhkJUlwcbIZF8=;
	b=SUNg29fT7LdRSMumnnPgJs491dLF83OK9MLOgVAwqgqqlcmtdEknqJKXSet+kwOWO+WE
	 svwAAKAzbNau8oTqWHFPEkEygRex7pOFQEZcxl9R2Hoki3TtJwdbaD9sJX8VMeshiDcIS
	 Xt5EMYXvjTqXa3ar1eGVK70+JAUMYKPFM6gBVxJvJLoEGmgiiDBXY7kP+4v8hw1uqimYz
	 FNdBNK9QVqSJZ411h1w4d+DvYsFpUIbwALmkcawjT3nUKZk5VB5cQvhLgCPapLb4CYd+p
	 00yI3qbD3yrsLyswAjRiAZRUKsFeR5FTBBcxb3HdgAk3FA21gtDtEgEaTJLjheGFEhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fq9IP2Df;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6142C606A850;
	Wed,  4 Nov 2026 21:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fq9IP2Df
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB6E1F00919;
	Wed,  4 Nov 2026 21:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829423;
	bh=XPBlF/VLIIzKVknLcSJ9ZGdf7FD7B8XhkJUlwcbIZF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq9IP2DfqdnY3LMDQAGfSba53XsrQ+utGKWwSKx2EzqJ2EL548L2CWtVHsFpHhZ/W
	 P1aYHpXUK56qnT27WWbu2By7AcoaGGX5I6T08y5SzwQuu3ls+ucJvrohc9JsTeRNbf
	 F8Pe4XhaIF01ulCQGl+2AS+0CeY0Xom+uvOMLcCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingtao Cao <qingtao.cao.au@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0117/1005] bus: mhi: core: Fix sys error transition latency
Date: Wed,  4 Nov 2026 15:57:30 -0500
Message-ID: <20261104211046.939314034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Qingtao Cao <qingtao.cao.au@gmail.com>

[ Upstream commit 22568e8f13a42ab69b7d624741768cbf15dded74 ]

Bring forward the idea to fix the power down latency in
mhi_pm_disable_transition() further to mhi_pm_sys_error_transition()
so that the transition into system error (triggered by AT!RESET) in the
modems won't have to return only after the timeout of up to 24 seconds.

Once the device gets reset, there is no guarantee that it will send an
interrupt to indicate the state transition. So polling is the sensible
option here.

Signed-off-by: Qingtao Cao <qingtao.cao.au@gmail.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Link: https://patch.msgid.link/20260603011333.3306102-2-qingtao.cao.au@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pm.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/bus/mhi/host/pm.c b/drivers/bus/mhi/host/pm.c
index b4ef115189b50..71bcb0f98ce6a 100644
--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -651,21 +651,13 @@ static void mhi_pm_sys_error_transition(struct mhi_controller *mhi_cntrl)
 
 	/* Trigger MHI RESET so that the device will not access host memory */
 	if (reset_device) {
-		u32 in_reset = -1;
-		unsigned long timeout = msecs_to_jiffies(mhi_cntrl->timeout_ms);
-
 		dev_dbg(dev, "Triggering MHI Reset in device\n");
 		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
 
 		/* Wait for the reset bit to be cleared by the device */
-		ret = wait_event_timeout(mhi_cntrl->state_event,
-					 mhi_read_reg_field(mhi_cntrl,
-							    mhi_cntrl->regs,
-							    MHICTRL,
-							    MHICTRL_RESET_MASK,
-							    &in_reset) ||
-					!in_reset, timeout);
-		if (!ret || in_reset) {
+		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				 MHICTRL_RESET_MASK, 0, 25000, mhi_cntrl->timeout_ms);
+		if (ret) {
 			dev_err(dev, "Device failed to exit MHI Reset state\n");
 			write_lock_irq(&mhi_cntrl->pm_lock);
 			cur_state = mhi_tryset_pm_state(mhi_cntrl,
-- 
2.53.0



