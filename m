Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDC7485CD5;
	Thu, 20 Aug 2026 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247373; cv=none; b=SHKa+Jbb8Ioq3bH7KPVyB5itjgg2dAiotTjoODDhNJnyoHclaWLgeXmUIi7p9RXLjThKOdhcZNySK+4gbKfHx/pFPLqA1TAKrovKjnUq6Q5XuXzxoMLEDmn/gjjUw48MAB/vVW+F7sEvEHquokuCU2Ot8/cC6zvgVbmGxEwDcWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247373; c=relaxed/simple;
	bh=uaf5axwAZI6G2L9MQaPynNBCTi5KiC/oKjiEGaFJjPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oungFyJLadyD9Pj8UxI/jWYx4Vl79dIDXaFslXj3bzjtkJfzftY6vVT4l+jAPr+4KZup3p2FGuJHUDjBLctk0N3W6nAd7KZs9RdHW3HUEAa0MZTWxR2fpyO1Wdw0ID2COlwncnDDkSE1VM0VK6XaGEQL2dsfcjaagEEHuxN5VHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltUEqzTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltUEqzTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9FF1F000E9;
	Thu, 20 Aug 2026 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247372;
	bh=WBVZtth1vMbwT1fgmrX/PD5RrakIkukA6DemRlu2MtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltUEqzTSFZt99SrbGC/r5fwwbSp23grUJ09Bf/EhC1Jq5Ka2tv53aV5vIpyb9rWcq
	 gsrmQXYM9ucR9FsKN31xASDshFNg1OQipaXtcB9FwpM1whG/MbCSLE0E9/4taoDzrG
	 vB3trxAW5Gl2PqchGT+5TL325S3BDGZeN3WkMRSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 023/166] Input: synaptics-rmi4 - fix F55 transmitter electrode count typo
Date: Thu, 20 Aug 2026 16:54:42 +0200
Message-ID: <20260820145211.886261493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


