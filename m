Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6727421ABC1;
	Tue, 29 Apr 2025 17:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948865; cv=none; b=k6Vd/gJpvqd9YkO7stdHosbUueSSxY1faHe/3aaShF8pjNiBhKAxcJEv4s7DNdFI8ql6aFDGpEw9erewPTob//bJjf1OeGuWCOssUr0aL6mdki0whz2LrYkQ2VwoZnuIv3HGFXpXHVR5K/vy3R4d+LXGu4OGE1D4gAgeQus6vaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948865; c=relaxed/simple;
	bh=+40JxMBeaQW3B/SnF1t3OPOZpRRXVVb4XJrRglF77P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQdDAEhsG1NpGz0jRNOl56eOqvd56Wt+gOIO910PCJSnDOeereMgB2aPNur4WfAr40WJXZ3lEMJ/IZX/O4oUN5K+HcwAyPN40afdjyzq2dSg3giJhyPnNjnNXYpTr6BZxcCeU0NWzHUcvNc0nmOp8hfbbpyAlShthHibS1RHefE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LR9YupBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR9YupBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864F4C4CEE3;
	Tue, 29 Apr 2025 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948864;
	bh=+40JxMBeaQW3B/SnF1t3OPOZpRRXVVb4XJrRglF77P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR9YupBb5/btY550fC+Jrejrmk2Apr5qP0xsG82uzvLc47L8uADDGYGlsHK+doIQH
	 f5L0v/3Jspy3eK0wjrXzlWXj9nm8rcHyS2RFQGgBZvsLo+4eVmukV1BVRQwyGlWAWh
	 XqUPWE+rcxCKYosCKnNhT36NRKKKA4DExjZcLDLQ=
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
Subject: [PATCH 5.15 142/373] igc: handle the IGC_PTP_ENABLED flag correctly
Date: Tue, 29 Apr 2025 18:40:19 +0200
Message-ID: <20250429161129.010189155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 863669192301e..49f8b0b0e6586 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -1075,8 +1075,12 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
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
@@ -1097,6 +1101,9 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 	unsigned long flags;
 	u32 timadj;
 
+	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
+		return;
+
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
 
-- 
2.39.5



