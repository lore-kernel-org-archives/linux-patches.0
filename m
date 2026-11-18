Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023140;
	b=ECC6TNmKjFR57ODj3SYXOPiGij6CvRpATFir6U89OqQHjuCrA4+2RWJe/Twg7Sf+x2sA
	 2eSQmHac3nrzA60arEvcnEIsyi9f5M0s85VAlSzl/tb9tyWFXSCvvfOc/9GpFFZhpM9an
	 +/T01edElvK0Xinrc6DJT+MskVxmkwG6+rdxYl3u3WHzKvpsmsCB07hWnsk6vdx8Kk7EW
	 E0rAjRoOj239UMhyNNnra2sNr9QCEaq5CCVZfYwjc00nRwY3UqknmhUktpCmBCa8Le0GB
	 StanhMmzvOmqG6DTE59Z+q8ZvFhRMGjgryD8tkmrXrkyep3u3O1hgrNyo7OzbQLuwuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GqIgNPXn1lOIXGrT+uODVZD1HohIfG6a1fKnwaPCIeA=;
	b=fNSlwcXBuL2lM84LrFN4Iu/fLOB6REIZqEt4FmTsZh9RLkcYcB+abVeLTvz7L1431vBQ
	 /ZmubmDEnuf7VC/DtefONSfNNM0GPsqvDjKlMH29bbb9UmHmT50sbkIGtcZ8vlAU5ZTCt
	 LIFGRDOJxpSrLk9kPLLoz2jANj8E/dpSBFk9GfrjhrT38yHmlqYL7npat9qAMVWPdHwto
	 B6Ht6wx+ucZIGUybN/ju0if8/sCtH0BgREHuglywEPNOYII20SIPyzZN4ky4Ac5MTnS7a
	 U2UZArcttW7NvQr39SGYPy8yDqR5nDFP/+Plq0zCAE81Aln5ePc/ctLVck8L+j/blNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQ28PbBM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989DC606A320;
	Wed, 18 Nov 2026 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQ28PbBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8471F000C6;
	Wed, 18 Nov 2026 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023140;
	bh=GqIgNPXn1lOIXGrT+uODVZD1HohIfG6a1fKnwaPCIeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQ28PbBMzb6y3Iqxz1fVnuvULXkVna6+XIt1GzN46yhFwK8qtkypAztD5YYNkt5m5
	 XQpz9/M4dXAAMC1Re2GUrgwaK4QROGIQIxwrdf8X0fyNP9V8jVu/B1ywbYzAx3TRz2
	 tW5QN2qILrB6hEU37ZSoqX1hLAuuRK86tI2uIAmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0263/2151] ABI: sysfs-class-infiniband: Drop the entries of the removed qib driver
Date: Wed, 18 Nov 2026 15:33:18 +0100
Message-ID: <20261118150131.381538451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 63367df6e7255067ad6a83abe0d2799dfa491876 ]

Commit 24baad32b710 ("RDMA/qib: Remove outdated driver") removed the qib
driver but left its /sys/class/infiniband/qibX/* entries in the stable
ABI file. Nothing creates those files any more.

Remove the block.

Fixes: 24baad32b710 ("RDMA/qib: Remove outdated driver")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260905092057.41306-1-kmehltretter@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/stable/sysfs-class-infiniband         | 118 ------------------
 1 file changed, 118 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-infiniband b/Documentation/ABI/stable/sysfs-class-infiniband
index 694f23a03a287..89500d064d239 100644
--- a/Documentation/ABI/stable/sysfs-class-infiniband
+++ b/Documentation/ABI/stable/sysfs-class-infiniband
@@ -422,124 +422,6 @@ Description:
 				information)
 		=============== =============================================
 
-
-sysfs interface for Intel IB driver qib
----------------------------------------
-
-What:		/sys/class/infiniband/qibX/version
-What:		/sys/class/infiniband/qibX/hw_rev
-What:		/sys/class/infiniband/qibX/hca_type
-What:		/sys/class/infiniband/qibX/board_id
-What:		/sys/class/infiniband/qibX/boardversion
-What:		/sys/class/infiniband/qibX/nctxts
-What:		/sys/class/infiniband/qibX/localbus_info
-What:		/sys/class/infiniband/qibX/tempsense
-What:		/sys/class/infiniband/qibX/serial
-What:		/sys/class/infiniband/qibX/nfreectxts
-What:		/sys/class/infiniband/qibX/chip_reset
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		=============== ======================================================
-		version:	(RO) Display version information of installed software
-				and drivers.
-
-		hw_rev:		(RO) Hardware revision number
-
-		hca_type:	(RO) Host channel adapter type
-
-		board_id:	(RO) Manufacturing board id
-
-		boardversion:	(RO) Current version of the chip architecture
-
-		nctxts:		(RO) Return the number of user ports (contexts)
-				available
-
-		localbus_info:	(RO) Human readable localbus info
-
-		tempsense:	(RO) Display temp sense registers in decimal
-
-		serial:		(RO) Serial number of the HCA
-
-		nfreectxts:	(RO) The number of free user ports (contexts)
-				available.
-
-		chip_reset:	(WO) Reset the chip if possible by writing
-				"reset" to this file. Only allowed if no user
-				contexts are open that use chip resources.
-		=============== ======================================================
-
-
-What:		/sys/class/infiniband/qibX/ports/<N>/sl2vl/[0-15]
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		(RO) The directory contains 16 files numbered 0-15 that specify
-		the Service Level (SL). Listing the SL files returns the Virtual
-		Lane (VL) as programmed by the SL.
-
-What:		/sys/class/infiniband/qibX/ports/<N>/CCMgtA/cc_settings_bin
-What:		/sys/class/infiniband/qibX/ports/<N>/CCMgtA/cc_table_bin
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		Per-port congestion control. Both are binary attributes.
-
-		=============== ================================================
-		cc_table_bin	(RO) Congestion control table size followed by
-				table entries.
-
-		cc_settings_bin (RO) Congestion settings: port control, control
-				map and an array of 16 entries for the
-				congestion entries - increase, timer, event log
-				trigger threshold and the minimum injection rate
-				delay.
-		=============== ================================================
-
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/loopback
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/led_override
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/hrtbt_enable
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/status
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/status_str
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		[to be documented]
-
-		=============== ===============================================
-		loopback:	(WO)
-		led_override:	(WO)
-		hrtbt_enable:	(RW)
-		status:		(RO)
-
-		status_str:	(RO) Displays information about the link state,
-				possible cable/switch problems, and hardware
-				errors. Possible states are- "Initted",
-				"Present", "IB_link_up", "IB_configured" or
-				"Fatal_Hardware_Error".
-		=============== ===============================================
-
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rc_resends
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/seq_naks
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rdma_seq
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rnr_naks
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/other_naks
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rc_timeouts
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/look_pkts
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/pkt_drops
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/dma_wait
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/unaligned
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		[to be documented]
-
-
 sysfs interface for Mellanox Connect-IB HCA driver mlx5
 -------------------------------------------------------
 
-- 
2.53.0



