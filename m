Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060663;
	b=3A2yCSTRbbjiMrkE6bp/Ek13s9NtXjs//YGErFJsqnRJIaX+C4xJsQEp7ikm08U4zUKY
	 ikEylwKCDQBWgzwMcmHlR+61DjaS/9vMvTpq1097ilJb/0c9h0sK/zTdfQt6g1AXGE4yO
	 WBVHQ425zEG3H7g92/R0j/iaLvoCuegOSBmzLgets53UgDwvgbXO3EhKWqORSHOdWKEJE
	 Y9vff0XjV2P2sXLaJdcl77gmkhgB1lsbck2C2gB7h1Z0vwA23rlW4MBnWhQdynEHBFs78
	 clvHIjqcjMM07A9JDAt0Fq/yAlriEPe0lbKXxn45X1Pzkq64UR5kRZqZ7k2CFqwWGqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4zzakTDm590q7EY29tAIrIMvSOis9RcmeESQgwJ8BKM=;
	b=CuCb8LCMEfhAzo+c670n9g/SIpcvvS9nFAxu40aqWKpXtk8h0TVWH4QOVXZi2It3tbOR
	 pDIWDq+Rv/OPA/HiPVn1e61qXc0k0uHlXTVz7ZLUWwV4rh7paBSQBkORKOJ+E/6H245Up
	 XA0S4ygFPt4oJxrZrP1LDWR+zf2U6KQVGtPdSeFzP46uYnv5wAs7MuyFSxiZ3A0X4ifo3
	 hR5KT19zVrZFZB5hgVvr2VsbLN+zo8JXqO0JB84mKHLFcsqcjXvkkMu2oRRjI46mHYN9v
	 3acwXOK2G6pyeC41kCehig6gti6CSDey24/KfCTNCFIQhNcbL+k+b9sMsY4ZesUGcwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoB4ArfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01829606A32D;
	Sat,  7 Nov 2026 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoB4ArfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FC31F0089F;
	Sat,  7 Nov 2026 14:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060662;
	bh=4zzakTDm590q7EY29tAIrIMvSOis9RcmeESQgwJ8BKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoB4ArfPOE+zY/2JaY82tYUW5Uiec8J0kVUGUXcqxg9PiYBMHd1E1fHHT1sbMPwyN
	 HQxMeqPK4fzmIg4OhMIY3LIwIlgTtwOluugOF6bqpMQzYg5g/a/b7+Yrs/pvrJuZVF
	 KitAgv6dw+PV8ZY17M6wfYLoKHReUNGJmb7DM23I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingtao Cao <qingtao.cao.au@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0100/1536] bus: mhi: core: Fix sys error transition latency
Date: Sat,  7 Nov 2026 08:35:16 -0500
Message-ID: <20261107135000.478323176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f32dd0a2f218..9c86f29a29486 100644
--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -648,21 +648,13 @@ static void mhi_pm_sys_error_transition(struct mhi_controller *mhi_cntrl)
 
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



