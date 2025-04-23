Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5258727FD60;
	Wed, 23 Apr 2025 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419861; cv=none; b=KRgvt1HyaLm5MTgay6+poxCtXdkzw4+Nf8TzPh1jFAZkTJGFBeqLJOx7XarBatel1jMWlrb7FAtcColfYMi6dqonN8xDfjVrnilDMENoaAgWv8BfPc5b9gyGaS0oRk/C5VAMD6dz7UWfUUXvLgz6mgvXMCeie+KSjo4FwB7e3h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419861; c=relaxed/simple;
	bh=fCpXMaK2C/jnDxrmlbE27TX1N7SHsnuNMHAv2H6srYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/T3JZ43Byihom07TvMD/pcotfnsb+cvFtnVVey32dqcFR2R+C4tJ+hSZ66qt9hPVWMNU5Bik2NuGyVHAmTcVgdjo8BUtLTlQXrKVQw3x+F48RcUK36OOB9BzFcwn0Skz24wzPLAMvg73pzhtVVJJ+Ct4hHFQeGjMTmmzTZ8ohA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gv1fbu8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gv1fbu8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C072C4CEE2;
	Wed, 23 Apr 2025 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419860;
	bh=fCpXMaK2C/jnDxrmlbE27TX1N7SHsnuNMHAv2H6srYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv1fbu8/fkvXrlKBEf4aK+MkCB9ca5DvH2BKhSigrzRfu8Du65HtV6Zr6qIImfYi/
	 87ntatEQiiBeE4NfSdkDSqLpmMHKuLq4GwP7xlTwQpi+NzW7BQ3sJvE8rWq5fAX+8s
	 sRo6VITfEfzP96Vc1cWzBl/FMr+ffBLcbmAbBqOw=
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
Subject: [PATCH 6.14 036/241] igc: handle the IGC_PTP_ENABLED flag correctly
Date: Wed, 23 Apr 2025 16:41:40 +0200
Message-ID: <20250423142621.989800879@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



