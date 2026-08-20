Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4EB47D92E;
	Thu, 20 Aug 2026 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244004; cv=none; b=auj10v9paf3ZyvuLP8+DSgTV35wFDPW3oEKcBHw2tZmrvXF+HtdTSDZQGr3DpNQmwQtilZLoYdGebVVremi2XHnVyY9D51OObtDtAYfemr+Ivm5/Ma/9XK3eeTtqTIKBnZV3/JIjACG2qTEk+g6TQuGhCAJ+UI7m4T9GQbyugF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244004; c=relaxed/simple;
	bh=yfWmwW/WT0QPaadtVK96aRAVYzPjmhi4y4ERHJud1lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhrSRRpsqzkn1ENdBtfYfBp8MS8XRo+1Vc+HMpmGdpctX8dE7a4XA8WalQchPyjcZbqa6cfWgIaK4kSKJU4GOasowEVZ8VzsxXgi7EmUObikK0jUZDjq2TJnfZQcmJWkrP/4HZo+/C7BcQyAhPlYITOeV6/82aGbNKtrEfVnTQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbfqOEFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbfqOEFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E091F00A3A;
	Thu, 20 Aug 2026 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244003;
	bh=Xx+u4jFj6e9wr3lng/LcIPxG0ToXAkJxn5QxdBcch2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbfqOEFaEw3/lUGFDjYEejRwcF2d2uEeJDeyY/H0dLHzI8sezCW8kiX/JZfRz7RjN
	 wkJo9CUAlWZAVBmGo9kbN8l2lvTQ4Y+LPy5pyQHnchEgu1Fb9L/4ncXB4RyUgHlugl
	 PBiZa3qjOSLBM1oQZuFo5PHfkUz7+MA0JbegHQmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 011/235] Input: synaptics-rmi4 - fix F55 transmitter electrode count typo
Date: Thu, 20 Aug 2026 16:54:07 +0200
Message-ID: <20260820145216.784163082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 6058f0fea10f3caf63a435677358d1b8e9325114 upstream.

During F55 sensor detection, the transmitter (TX) electrode count was
incorrectly assigned the value of the receiver (RX) electrode count
due to copy-paste typos.

This incorrect value was then propagated to the driver data and used
by F54 to determine the diagnostics report size. On devices with more
RX than TX electrodes, this inflated the perceived TX count, leading
to incorrect report size calculations and potential out-of-bounds
buffer accesses.

Fix the typos by correctly assigning the TX electrode counts.

Fixes: 6adba43fd222 ("Input: synaptics-rmi4 - add support for F55 sensor tuning")
Fixes: c762cc68b6a1 ("Input: synaptics-rmi4 - propagate correct number of rx and tx electrodes to F54")
Reported-by: sashiko-bot@kernel.org
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260626051802.4033172-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f55.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/rmi4/rmi_f55.c
+++ b/drivers/input/rmi4/rmi_f55.c
@@ -54,10 +54,10 @@ static int rmi_f55_detect(struct rmi_fun
 	f55->num_tx_electrodes = f55->qry[F55_NUM_TX_OFFSET];
 
 	f55->cfg_num_rx_electrodes = f55->num_rx_electrodes;
-	f55->cfg_num_tx_electrodes = f55->num_rx_electrodes;
+	f55->cfg_num_tx_electrodes = f55->num_tx_electrodes;
 
 	drv_data->num_rx_electrodes = f55->cfg_num_rx_electrodes;
-	drv_data->num_tx_electrodes = f55->cfg_num_rx_electrodes;
+	drv_data->num_tx_electrodes = f55->cfg_num_tx_electrodes;
 
 	if (f55->qry[F55_PHYS_CHAR_OFFSET] & F55_CAP_SENSOR_ASSIGN) {
 		int i, total;


