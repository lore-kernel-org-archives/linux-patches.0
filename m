Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDDA402B8C;
	Wed, 20 May 2026 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302928; cv=none; b=ImId1U2x4jw+kvhRx5ASwqRfLTk2OtQ5M5m49oukGeGbPp5Ga65EJggJP1m9hyON4YFadUJB8dzlARKVM2PBY/BWsNmwkauG9RzbrsrjSCQixusgOj/kYnKkOT09vfAEIy4k5Bnp0a60QrudE2s7jFEeSwJ6JowbIjpka7IwR2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302928; c=relaxed/simple;
	bh=sUvEfVmbOoAYnfrZafAHVBZfIJ4QO9AQTfWhHphWm40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbi+/QMxePWeLSmSk/WiKa6apY68ebxcWKKFwRhTWzQOY0fjRsbaQP7t3k0DPd+QBDc8p9ZLjVdhtrJOVLxx1pehKtDCN6REC23/AocCUFA3WMmb0JGoStHdm1jPGpqHG9aDrW3myoc1gshr9P9W7D0egihnDzQjabIFgZlaRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsCxkRCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsCxkRCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E481F00893;
	Wed, 20 May 2026 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302924;
	bh=BAF0qfqiuW1C4XEeZJC/YIGCCdGiHM1qelFVK911P5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsCxkRCgTSB4g5D3SsUAoiveZR6FjY9fD/n2VSnYepgT4xObMKUVsJy/4bb2LcHyt
	 Ix7czobXB734bXUJUlSmhmYnVs62/WXGYDr5RU0dHl26EvwitYzqeKI0biC1vVAGoj
	 6/rU6pv1E0RgmUtOAQvuttqIj0yZEMsax5PRWpdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Matt Vollrath <tactii@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 452/508] i40e: Cleanup PTP pins on probe failure
Date: Wed, 20 May 2026 18:24:35 +0200
Message-ID: <20260520162108.388570281@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Matt Vollrath <tactii@gmail.com>

commit 678b713ece1e853f11e670a84cb887c35e1381b7 upstream.

PTP pin structs are allocated early in probe, but never cleaned up.

Fix this by calling i40e_ptp_free_pins in the error path.

To support this, i40e_ptp_free_pins is added to the header and
pin_config is correctly nullified after being freed.

This has been an issue since i40e_ptp_alloc_pins was introduced.

Fixes: 1050713026a08 ("i40e: add support for PTP external synchronization clock")
Reported-by: Kohei Enju <kohei@enjuk.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Matt Vollrath <tactii@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Kohei Enju <kohei@enjuk.jp>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-2-a5ea4dc837a9@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |    1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c |    1 +
 drivers/net/ethernet/intel/i40e/i40e_ptp.c  |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1262,6 +1262,7 @@ void i40e_ptp_restore_hw_time(struct i40
 void i40e_ptp_init(struct i40e_pf *pf);
 void i40e_ptp_stop(struct i40e_pf *pf);
 int i40e_ptp_alloc_pins(struct i40e_pf *pf);
+void i40e_ptp_free_pins(struct i40e_pf *pf);
 int i40e_update_adq_vsi_queues(struct i40e_vsi *vsi, int vsi_offset);
 int i40e_is_vsi_uplink_mode_veb(struct i40e_vsi *vsi);
 int i40e_get_partition_bw_setting(struct i40e_pf *pf);
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16300,6 +16300,7 @@ err_vsis:
 	i40e_clear_interrupt_scheme(pf);
 	kfree(pf->vsi);
 err_switch_setup:
+	i40e_ptp_free_pins(pf);
 	i40e_reset_interrupt_capability(pf);
 	timer_shutdown_sync(&pf->service_timer);
 err_mac_addr:
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -937,12 +937,13 @@ int i40e_ptp_get_ts_config(struct i40e_p
  *
  * Release memory allocated for PTP pins.
  **/
-static void i40e_ptp_free_pins(struct i40e_pf *pf)
+void i40e_ptp_free_pins(struct i40e_pf *pf)
 {
 	if (i40e_is_ptp_pin_dev(&pf->hw)) {
 		kfree(pf->ptp_pins);
 		kfree(pf->ptp_caps.pin_config);
 		pf->ptp_pins = NULL;
+		pf->ptp_caps.pin_config = NULL;
 	}
 }
 


