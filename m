Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0593F1A23B0;
	Wed, 23 Apr 2025 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419658; cv=none; b=N99bQXh7csQvkYQW786aVWmryUCf5Tveu2BxUkIfzeE4CZITnG3uwLH0RfxDKad5/puRrpbK6Emun9qtrkhxO3K3OFb1Ofd2R4iIriskB/I5+zkfF5vUeoiAwnmDZNc+D8PM+53DDP9JboDX86VI1NWlWf3Bb3REezmBIMMnPGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419658; c=relaxed/simple;
	bh=fb/SOm19jT0PVxHw086IJUPkXykJaIqsktCSorBFOTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9429clmihwuPDlFX/732enV1/dCrx8sUcU7j7cwn0xLpGj07wFDve5EnJt2LsDt/T+OUVo/Yfh114RCaSQpFJp4gxO6G5F3gZJb5epoT2+QSp6xQ8cXl2kasqXlF3OdBLE6CDUfn1+8Xcl8E3rkUCx446+YzO7mMJRLlRQ+qHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czFSMbYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czFSMbYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D484C4CEE2;
	Wed, 23 Apr 2025 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419657;
	bh=fb/SOm19jT0PVxHw086IJUPkXykJaIqsktCSorBFOTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czFSMbYFsGM7jCSWN0/sFoTttt1Z9s5J3FmYO/9l5zl5LhwgMbbhHD9uPPKazpXGl
	 cqlgB8jlFuYcd1lBX/4QomdU4cPxiohV9jgRW3m45LyfuDhYWRgcPIi9Xb17MTpfLw
	 KSfvBuXKdnu/UvXPE0wtX9zD06ifJ8LueTz+h8Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher S M Hall <christopher.s.hall@intel.com>,
	Corinna Vinschen <vinschen@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/223] igc: handle the IGC_PTP_ENABLED flag correctly
Date: Wed, 23 Apr 2025 16:41:48 +0200
Message-ID: <20250423142618.600534223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher S M Hall <christopher.s.hall@intel.com>

[ Upstream commit 26a3910afd111f7c1a96dace6dc02f3225063896 ]

All functions in igc_ptp.c called from igc_main.c should check the
IGC_PTP_ENABLED flag. Adding check for this flag to stop and reset
functions.

Fixes: 5f2958052c58 ("igc: Add basic skeleton for PTP")
Signed-off-by: Christopher S M Hall <christopher.s.hall@intel.com>
Reviewed-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 516abe7405dee..343205bffc355 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -1244,8 +1244,12 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
  **/
 void igc_ptp_stop(struct igc_adapter *adapter)
 {
+	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
+		return;
+
 	igc_ptp_suspend(adapter);
 
+	adapter->ptp_flags &= ~IGC_PTP_ENABLED;
 	if (adapter->ptp_clock) {
 		ptp_clock_unregister(adapter->ptp_clock);
 		netdev_info(adapter->netdev, "PHC removed\n");
@@ -1266,6 +1270,9 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 	unsigned long flags;
 	u32 timadj;
 
+	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
+		return;
+
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
 
-- 
2.39.5



