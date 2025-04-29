Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3ED2512D9;
	Tue, 29 Apr 2025 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946921; cv=none; b=YHLg4WCsMAgRIsdlQ9Vx+vxa5upGihR3Ljsfm+pD/s9FX7mlaQlawd5tGjeu+Iqvy4N8ARUe6vX0iYA3uMTfdeWCP2vz0wrcNbmgut+3HLF7BefGnWqdTZ/PzGZjO5GvOnPqJrb9FkiY1IpRZQcr9Wn9CqKRr2AeobqPcvBnHjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946921; c=relaxed/simple;
	bh=i86p1qkfyzGZGH6sBGvtEdpgo02Zu0d/stv+q0/1t6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBHJVdPbIFKfrnxn+sfxyXlGmuvJ49XpwqXH6uVXSnwH6Avzf+NUulGCKCeShXXTHmrXbEyYhxKL/0ZZs6M/PY94axALxH6GRq5hEEPu9Ztq9uAePlpfAc64T7/mLXBIZpplLReG49xRxzhnbCj8kJpEZ4yQs1ONEHFPmE8qL40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rb7kX2oL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rb7kX2oL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11A0C4CEEE;
	Tue, 29 Apr 2025 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946921;
	bh=i86p1qkfyzGZGH6sBGvtEdpgo02Zu0d/stv+q0/1t6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rb7kX2oLT2K4tzskyx9ftyV/KCuxM+iPG0+WlOEv2PO6muxgXeP/Ke4Q65kmQG6E2
	 V+04EKADDJPP6qE2Hl7e2wY43sVALN9OK+7xzA9ZQJje4CO0dtSBGhzFCNA4l39bAz
	 3Uy2Z33Jxbo8dkmlCRyAfsebJyehPromFR6Akj5Y=
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
Subject: [PATCH 5.10 113/286] igc: handle the IGC_PTP_ENABLED flag correctly
Date: Tue, 29 Apr 2025 18:40:17 +0200
Message-ID: <20250429161112.507496413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 25b238c6a675c..d99f597a83be5 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -578,8 +578,12 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
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
@@ -598,6 +602,9 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 	struct igc_hw *hw = &adapter->hw;
 	unsigned long flags;
 
+	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
+		return;
+
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
 
-- 
2.39.5



