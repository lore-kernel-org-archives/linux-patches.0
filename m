Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015760;
	b=u5to+1fTeoHLEbYhcPFSyvClaBqw6sGbCDUD/VSMjGqf+nQhLj8W531KXF3gkn4BXzqh
	 rIcME5Z+eZ5nLQy3xybQnEUCrTKsZamEX1VkDHmnCpU75HqjpGDWXOlCu2lzMr51UwR+6
	 +4rfnc8TKak7++vVy7zsrymIfs+/qyPeumS695ik62WzfqhL4k5kT5RDDeWWH+EFh32mk
	 JzDwa42OM8G2IahYtpALf+UvQivl6Vkt+IWefTK+yGBnIFti7xIzgyiBoXgXkuVxI7f89
	 btnbaEFN1vPPN7YKg/icDqBwGysrz1grd3KzCq0/kB1lqyzWmCwzzoIM6Ar2eN04zmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j1OzPTWcEng+1CatnEcs381HqaKr6/KLGg7G3Wkz2kI=;
	b=dxjWmsSCCdHEj+wab09KB2H+sWDgu+NV8B+CuXfVw+s9jS2jCPQ2a/1F18A7I4J7Iah6
	 U6+a+AR9O8BzynFc3DSVCDYpqwku/uzrG4MK/5H4my+Ny4enXpm5ZfbtXSubqzuvyELuO
	 tzLXvmdIqviyZ5stSvcv//KBbB4NDAQh5kpoLArwUW1ZLzcikdTJe4P1I8QpEj53SbB2P
	 DYmVRkhxi6r0x43pG2MfCIvkNzJEj08KOTDPwRGhFZ+5h/HC1a6P3OtCEc96bFk+kRBRD
	 j9CKr0HcYrX8yG7gYZ4inMPWaOcihnmkXRs16kICf8FJjsEN1lFMgRU4vwcAjV2P6eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQBFUpha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B67606A31C;
	Wed, 18 Nov 2026 15:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQBFUpha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E6B1F000C5;
	Wed, 18 Nov 2026 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015760;
	bh=j1OzPTWcEng+1CatnEcs381HqaKr6/KLGg7G3Wkz2kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQBFUphay386Z70yASueBD/8XdfeMtAbQ2vcIlTBP7VqcJI/drZ62NTRJ05dKZ9Z3
	 LMbeQtcPfzsJyn95IzvaL2MEHaUQ8ALvPEEbwJUgvYqzx67aX0nd3zMqI9a25xNNVe
	 uiDOsLSYGSEzqPNymBUP3VObON41OlLCHeNNovPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0251/2651] ABI: sysfs-class-infiniband: Drop the entries of the removed qib driver
Date: Wed, 18 Nov 2026 15:24:51 +0100
Message-ID: <20261118150256.896095988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7ba1161034291..726a38470e585 100644
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



