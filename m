Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0B335F8B3;
	Tue,  6 Jan 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721705; cv=none; b=s7Xmk0B5IodsP69TcmhztFutp2hpVOcsEOgni4ZgmK/ENoN7AyuPSc4coJuRYGR22xlnMfMAiA00x3TrJmI1scZOmX07HlOYozuu8Oa+SS9ZiP0yd9j/Vs6ankIZ8xfAcZE75ZPAU5Ap5mzjBY95oUt9mHKLVpYkgSERy6chVTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721705; c=relaxed/simple;
	bh=Xr5ZO3Cj/JiS10xUUWbo5iY5U/zO+5mEwipgI6YI6rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcSgo5tP6zGuLBM9llPxVEpSQEFGc/jBp5FDtYiiAolKCBAOOKEXIBwIm/jDVIrtCJeJ+Hwi0CR+F2gEqFMRtXbwUlER3nkDx0Z7YbK9c2HXL2t+UDkIAoiXs52E/MCaXHetXXs+e8BexsYh1AeiWOX2QGoE8yh8RUTq5HIUgnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvgyPQXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvgyPQXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B7CC116C6;
	Tue,  6 Jan 2026 17:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721705;
	bh=Xr5ZO3Cj/JiS10xUUWbo5iY5U/zO+5mEwipgI6YI6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvgyPQXIJwD753WcPynmotO89wfXTdvUIeg7jYNdeaN7SpO1pL0D8mDGNhJx76p0K
	 +SpuouPw3kp+/LnoOj1eqVve3GID1McAcVR0d57Adq8s5lT1X+1rTcIoOeK5lN36yg
	 a1vTeqbtbJdfJfTWtOPwXen/W6//BTy89EzMdrAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/312] idpf: fix LAN memory regions command on some NVMs
Date: Tue,  6 Jan 2026 18:01:34 +0100
Message-ID: <20260106170548.586185140@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 4af1f9a47291f7d446398065e0d6eb4943f7e184 ]

IPU SDK versions 1.9 through 2.0.5 require send buffer to contain a single
empty memory region. Set number of regions to 1 and use appropriate send
buffer size to satisfy this requirement.

Fixes: 6aa53e861c1a ("idpf: implement get LAN MMIO memory regions")
Suggested-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index cbb5fa30f5a0..fc03d55bc9b9 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -1016,6 +1016,9 @@ static int idpf_send_get_lan_memory_regions(struct idpf_adapter *adapter)
 	struct idpf_vc_xn_params xn_params = {
 		.vc_op = VIRTCHNL2_OP_GET_LAN_MEMORY_REGIONS,
 		.recv_buf.iov_len = IDPF_CTLQ_MAX_BUF_LEN,
+		.send_buf.iov_len =
+			sizeof(struct virtchnl2_get_lan_memory_regions) +
+			sizeof(struct virtchnl2_mem_region),
 		.timeout_ms = IDPF_VC_XN_DEFAULT_TIMEOUT_MSEC,
 	};
 	int num_regions, size;
@@ -1028,6 +1031,8 @@ static int idpf_send_get_lan_memory_regions(struct idpf_adapter *adapter)
 		return -ENOMEM;
 
 	xn_params.recv_buf.iov_base = rcvd_regions;
+	rcvd_regions->num_memory_regions = cpu_to_le16(1);
+	xn_params.send_buf.iov_base = rcvd_regions;
 	reply_sz = idpf_vc_xn_exec(adapter, &xn_params);
 	if (reply_sz < 0)
 		return reply_sz;
-- 
2.51.0



