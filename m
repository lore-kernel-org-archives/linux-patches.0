Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A3E2DA757;
	Mon, 13 Apr 2026 16:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096486; cv=none; b=cg72Iod5ElPBVunhg/pJaIAUy5Rs3SmIchGSd8rV6oU8tcHl4NjLDdnJHIdG2rMXMJLYlQRO3kMhTMce77/hvRF5CxUW3k/tq4MysNrrYR+4Q6+C3U4vO3vZ2q/LUQRvugX7YelRAsLZtEXuw0UqgiOLUusHFqhoGrTyFhv32l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096486; c=relaxed/simple;
	bh=8QH9zOQpIkEnnZiMNRiY0A5SAPnVwy2dLPhOaoq7cLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbdqILjefYmwZbiuP4hAiJhj8HT0muNFrwZLoVehWBqerOjRHVzjUiEDv9vM2gZB2r8IouyBy52YyoUk3sNvFrsGwyufkSgqOFmZexsw5tjp0db1/V4NjbLddWxxQy1g4FeUDCU6/FWNv+3Eg2rPc/cC//STox3ylnIsdxmI7Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUuEwIc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUuEwIc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47958C2BCAF;
	Mon, 13 Apr 2026 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096485;
	bh=8QH9zOQpIkEnnZiMNRiY0A5SAPnVwy2dLPhOaoq7cLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUuEwIc5W5dIE6M8EvXx95ufTf3bmUpVtWtziMjXRr4N7PiCkvwMcDJayKhyWIe+e
	 RqK0ZPp7XNr15M+Cg7v5sP23gcIvoFrTYTWyVhM+5Dh74yedS3wnOdd4QbHfj1BMFf
	 4dBtwbVDjq8hzjaUNQC6XMgT9zYKZxzfww68u6gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 29/83] platform/x86/intel-uncore-freq: Handle autonomous UFS status bit
Date: Mon, 13 Apr 2026 17:59:57 +0200
Message-ID: <20260413155732.105911789@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 4ab604b3f3aa8dcccc7505f5d310016682a99d5f upstream.

When the AUTONOMOUS_UFS_DISABLED bit is set in the header, the ELC
(Efficiency Latency Control) feature is non-functional. Hence, return
error for read or write to ELC attributes.

Fixes: bb516dc79c4a ("platform/x86/intel-uncore-freq: Add support for efficiency latency control")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260325192909.3417322-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -537,6 +537,7 @@ static void set_cdie_id(int domain_id, s
 #define UNCORE_VERSION_MASK			GENMASK_ULL(7, 0)
 #define UNCORE_LOCAL_FABRIC_CLUSTER_ID_MASK	GENMASK_ULL(15, 8)
 #define UNCORE_CLUSTER_OFF_MASK			GENMASK_ULL(7, 0)
+#define UNCORE_AUTONOMOUS_UFS_DISABLED		BIT(32)
 #define UNCORE_MAX_CLUSTER_PER_DOMAIN		8
 
 static int uncore_probe(struct auxiliary_device *auxdev, const struct auxiliary_device_id *id)
@@ -598,6 +599,7 @@ static int uncore_probe(struct auxiliary
 
 	for (i = 0; i < num_resources; ++i) {
 		struct tpmi_uncore_power_domain_info *pd_info;
+		bool auto_ufs_enabled;
 		struct resource *res;
 		u64 cluster_offset;
 		u8 cluster_mask;
@@ -647,6 +649,8 @@ static int uncore_probe(struct auxiliary
 			continue;
 		}
 
+		auto_ufs_enabled = !(header & UNCORE_AUTONOMOUS_UFS_DISABLED);
+
 		/* Find out number of clusters in this resource */
 		pd_info->cluster_count = hweight8(cluster_mask);
 
@@ -689,7 +693,9 @@ static int uncore_probe(struct auxiliary
 
 			cluster_info->uncore_root = tpmi_uncore;
 
-			if (TPMI_MINOR_VERSION(pd_info->ufs_header_ver) >= UNCORE_ELC_SUPPORTED_VERSION)
+			if ((TPMI_MINOR_VERSION(pd_info->ufs_header_ver) >=
+			     UNCORE_ELC_SUPPORTED_VERSION) &&
+			    auto_ufs_enabled)
 				cluster_info->elc_supported = true;
 
 			ret = uncore_freq_add_entry(&cluster_info->uncore_data, 0);


