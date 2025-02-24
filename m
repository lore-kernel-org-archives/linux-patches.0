Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA822A8D0;
	Mon, 24 Feb 2025 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408798; cv=none; b=Q1zD3CXRafQ0Lc6l61xP4X7bbAg+YkxaLwdftMl8H8Oy76tVaoN5Hby3GlPWgBLMen42fKr/Q4QxkaiyP4clo5eYKMozTx06A3cp5NdDq7WUXHA6u8rLBhkn2mj5s0JZWVBQZ+pPiN72gL6sUPCvulB8hcmyuLYQ5Vv/J4xt2bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408798; c=relaxed/simple;
	bh=EH3Ciw0kbMBfPmqaxdb5m69HdHEAAHI9i38hHK0YS1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4HeYpEHSqHlJiR/D3FpyD6hN7RoaCp8mVaxaajEGSUT1SNTKIlLYJDFy+yd+XS1G6FIWx1IaHgqBznsu0xGb25TVzI+EWYUgxxSaXqmFnxq4r1IZ0fcvBQfq36JSZWel0M+INDdLb/3yQOQzGrwKazt4L9nA8e/qNrs4ZWGhmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYExAOc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYExAOc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE33AC4CEE6;
	Mon, 24 Feb 2025 14:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408798;
	bh=EH3Ciw0kbMBfPmqaxdb5m69HdHEAAHI9i38hHK0YS1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYExAOc4NL6re/sHvIR6sm2DRtYIatoTvTCbh6GLVhxwLniMeh8C6vkau3R5j8ee8
	 MUf9yaQKvn56YKOxKUMNJ+if3lC7O1jKi14FN2ikCTdAc0I7wFFwElOuJhp+VxQilR
	 pA0cPsncRmryPRt9xgRCWsYZWy2wC9+SP547/B74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Starks <jostarks@microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.13 001/138] Drivers: hv: vmbus: Log on missing offers if any
Date: Mon, 24 Feb 2025 15:33:51 +0100
Message-ID: <20250224142604.504135220@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Starks <jostarks@microsoft.com>

commit fcf5203e289ca0ef75a18ce74a9eb716f7f1f569 upstream.

When resuming from hibernation, log any channels that were present
before hibernation but now are gone.
In general, the boot-time devices configured for a resuming VM should be
the same as the devices in the VM at the time of hibernation. It's
uncommon for the configuration to have been changed such that offers
are missing. Changing the configuration violates the rules for
hibernation anyway.
The cleanup of missing channels is not straight-forward and dependent
on individual device driver functionality and implementation,
so it can be added in future with separate changes.

Signed-off-by: John Starks <jostarks@microsoft.com>
Co-developed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20250102130712.1661-3-namjain@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250102130712.1661-3-namjain@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/vmbus_drv.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2462,6 +2462,7 @@ static int vmbus_bus_suspend(struct devi
 
 static int vmbus_bus_resume(struct device *dev)
 {
+	struct vmbus_channel *channel;
 	struct vmbus_channel_msginfo *msginfo;
 	size_t msgsize;
 	int ret;
@@ -2494,6 +2495,22 @@ static int vmbus_bus_resume(struct devic
 
 	vmbus_request_offers();
 
+	mutex_lock(&vmbus_connection.channel_mutex);
+	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
+		if (channel->offermsg.child_relid != INVALID_RELID)
+			continue;
+
+		/* hvsock channels are not expected to be present. */
+		if (is_hvsock_channel(channel))
+			continue;
+
+		pr_err("channel %pUl/%pUl not present after resume.\n",
+		       &channel->offermsg.offer.if_type,
+		       &channel->offermsg.offer.if_instance);
+		/* ToDo: Cleanup these channels here */
+	}
+	mutex_unlock(&vmbus_connection.channel_mutex);
+
 	/* Reset the event for the next suspend. */
 	reinit_completion(&vmbus_connection.ready_for_suspend_event);
 


