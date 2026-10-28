Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216629;
	b=ZA3VCtsXkzbidepgQJVGKHWgdcjG51aUCjiczC91X/0lGyK/6VdulAAOetzZO/CEce7C
	 wYCZlR6lWpaoaZHhqQdOVJAEnTzXqzRMRDgpBt5MD1fsOQqsOKyGPrbYaKs+uymC1d7Uv
	 Tc6M9ppEdDTbj2gQMcD+obBmV2ylZ3/VhdPqTGhRHFVg8/VDEa9XrMPqKa5LczErS6Vbe
	 p67AV6/L8KXZlfAH98FVIFd0P39/vlH3i2TsLGNEHCHh8Es+nCe7p7C1jTEMwyNW+zrf2
	 PCQe5mU6Jxsw9uMUBgmn1pxcnqyS08Oa3QkV8kjAKcVeHCAk4XiylgkL5aohQYtFezA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hY3Jalp8kjqRpgLSdlziTJ1jakq6a1Fte/UW5hVjBRs=;
	b=T/tSnj7in0MV82V6TSXKO+qsFSgSVRRod6mO98pwYlXppRQU+LmK58W6CA1ZgPSoLLSF
	 X0R7Rjr0njhOebGcAm/rZnM1NQ9plIxVsKjdfUHbNhPC7Kf9uCR1jtViGd//jh/7hdRsy
	 J581RwG56toGvjAWj70mN333TZW69232VF45HSgofxH0sfI2/ajoUccDQ/D/qa3/LmnbL
	 LAHZA18dS2ByGXiwABH1qLw1gqY/KQfctHaNTx9MeHUpFbmNwfBl83rdRWmSUFtpCFhkp
	 Ncn8eRJtAR2f/gcsxTMGHAzf0lr3noKDsnb6Y2nT+PvrC0UEJXFQUH57toFPo8s4Z0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djKR3pnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E87606A31D;
	Wed, 28 Oct 2026 19:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djKR3pnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205371F01825;
	Wed, 28 Oct 2026 19:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216628;
	bh=hY3Jalp8kjqRpgLSdlziTJ1jakq6a1Fte/UW5hVjBRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djKR3pnuLfalHaDE5s4N/3qVCF9qpNn4sbqmhPgqYJTXGMpGJ4FstF1vUNaO9YBl9
	 nsuljPo7W3BZ0nTt3OCQ12C+XfGSBS9RiqvBdYPuMNpm1eZoPkUFHT/LoUqcFQrw+Y
	 TWldRFyv71CLlhaOnNqW+nLpGIFhxgEgWS7atdAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1623/1887] firmware: arm_scmi: Publish channel state before callbacks
Date: Wed, 28 Oct 2026 18:01:59 +0100
Message-ID: <20261028170536.401679119@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 0314900dcdde044af0208fed212035dbfaa55843 ]

Transport setup can enable callbacks before the setup routine returns.
mailbox_chan_setup() registers the mailbox client with
mbox_request_channel(), and the mailbox controller startup path can enable
interrupt delivery before SCMI mailbox channel state has been published.
Similarly, smc_chan_setup() requests the optional A2P completion IRQ before
the SMC transport has made its cinfo pointer visible.

If a pending or spurious callback fires in those windows, the transport RX
callback can dereference a NULL transport cinfo pointer. Publishing only
the transport-private pointer is not sufficient either: an early callback
can enter the SCMI core before scmi_chan_setup() has assigned
cinfo->handle.
The core derives scmi_info from cinfo->handle in the RX path, so a NULL
handle can still fault even when the transport-private cinfo is valid.

Assign cinfo->handle before invoking the transport setup callback. Publish
the mailbox and SMC transport-private channel state before requesting the
mailbox channels or IRQ, and clear the early-published pointers again on
setup failure. Also unwind mailbox setup devres resources on failure so an
optional RX setup error that is ignored by the core does not leave stale
transport state behind.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-1-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c  |  2 +-
 drivers/firmware/arm_scmi/mailbox.c | 16 ++++++++++++----
 drivers/firmware/arm_scmi/smc.c     | 12 +++++++-----
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 4c3677a205a8f..c88b8d4aae926 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2143,6 +2143,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	of_node_get(of_node);
 
 	cinfo->dev = &tdev->dev;
+	cinfo->handle = &info->handle;
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
 	if (ret) {
 		of_node_put(of_node);
@@ -2175,7 +2176,6 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 		return ret;
 	}
 
-	cinfo->handle = &info->handle;
 	return 0;
 }
 
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 3cd731cbe9b88..41edb639cf929 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -146,19 +146,27 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 	cl->tx_block = false;
 	cl->knows_txdone = tx;
 
+	cinfo->transport_info = smbox;
+	smbox->cinfo = cinfo;
+
 	smbox->chan = mbox_request_channel(cl, tx ? 0 : 1);
 	if (IS_ERR(smbox->chan)) {
 		ret = PTR_ERR(smbox->chan);
+		smbox->chan = NULL;
 		if (ret != -EPROBE_DEFER)
 			dev_err(cdev, "failed to request SCMI %s mailbox\n",
 				tx ? "Tx" : "Rx");
-		return ret;
+		goto err_clear_cinfo;
 	}
 
-	cinfo->transport_info = smbox;
-	smbox->cinfo = cinfo;
-
 	return 0;
+
+err_clear_cinfo:
+	cinfo->transport_info = NULL;
+	smbox->cinfo = NULL;
+	devm_iounmap(dev, smbox->shmem);
+	devm_kfree(dev, smbox);
+	return ret;
 }
 
 static int mailbox_chan_free(int id, void *p, void *data)
diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
index 7413dda373d40..d2abe71b98833 100644
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -141,6 +141,11 @@ static int smc_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 	if (ret < 0)
 		return ret;
 
+	scmi_info->func_id = func_id;
+	scmi_info->cinfo = cinfo;
+	smc_channel_lock_init(scmi_info);
+	cinfo->transport_info = scmi_info;
+
 	/*
 	 * If there is an interrupt named "a2p", then the service and
 	 * completion of a message is signaled by an interrupt rather than by
@@ -152,17 +157,14 @@ static int smc_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 				  IRQF_NO_SUSPEND, dev_name(dev), scmi_info);
 		if (ret) {
 			dev_err(dev, "failed to setup SCMI smc irq\n");
+			cinfo->transport_info = NULL;
+			scmi_info->cinfo = NULL;
 			return ret;
 		}
 	} else {
 		cinfo->no_completion_irq = true;
 	}
 
-	scmi_info->func_id = func_id;
-	scmi_info->cinfo = cinfo;
-	smc_channel_lock_init(scmi_info);
-	cinfo->transport_info = scmi_info;
-
 	return 0;
 }
 
-- 
2.53.0



