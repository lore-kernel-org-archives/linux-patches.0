Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C5929B22B;
	Wed, 23 Apr 2025 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421819; cv=none; b=t3sXclYosB7D8dm3JnTmbYGS9IjQowLLAhtbbxfQycoFmlvLBM3LO1oAzvt7FzhM2InfD+F0CtY0/MCstqK7rRfOmlURe93bfH5iFFZguSOvmKCAurQLJSQ78k/aXS2wT5TF/du7gmGxRke+GYwlDOVd1TtA+cZfIVgH2nLeCZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421819; c=relaxed/simple;
	bh=BfVk0tA2+mu9MCjxK+Q1k7N2YXbHwITWAUEjV9x/SF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILJvH+lSqRXbQWQyr67rB8H9hbVyDhYP19uGBlNDh4jNibfD3rc+i2vbJRN05AFHbGevlwwXfO3hU3f1cbtOpov0hySmRA+1E3DCZlCQ+gxReUXygae5SfNjRMY630zZpu/6GB0FNu+boDsoQoJAKe7j5jgCGFZKMRjYplTF3tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaYzQ+I6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaYzQ+I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747C2C4CEE3;
	Wed, 23 Apr 2025 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421819;
	bh=BfVk0tA2+mu9MCjxK+Q1k7N2YXbHwITWAUEjV9x/SF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaYzQ+I685OZUnDfZrnRwYVwcsFCaz9Uf7Yrti4XVsxtCvh88F/UrFa3o2lZAYULT
	 XYzQc/pfsAH65rdVp8DKcEDaHABvj5h1VarY31HpE8ePlr4edtF44A2Y69LAL+G94c
	 7NZv+X5OoB5FyX4Ju2qZY6aBXaeKyq8MZ5/iOoV8=
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
Subject: [PATCH 6.1 182/291] igc: handle the IGC_PTP_ENABLED flag correctly
Date: Wed, 23 Apr 2025 16:42:51 +0200
Message-ID: <20250423142631.816493055@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5616b7f4e504f..8731e8f234946 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -1070,8 +1070,12 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
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
@@ -1092,6 +1096,9 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 	unsigned long flags;
 	u32 timadj;
 
+	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
+		return;
+
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
 
-- 
2.39.5



