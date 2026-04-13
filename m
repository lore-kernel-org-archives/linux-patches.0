Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D15A2F8BC3;
	Mon, 13 Apr 2026 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096720; cv=none; b=D9qUhO/qgUcjZFJhmT895akD/gvA4Z56GplageK4Nnf17eiQADD2o//rzRVG/Vd4kDCyQlrmKdC8jH3us/p+ECvvdLAj/Sf6mdi5DhBG+1VHLXa7vHaF7xBj20pqpsR5C/7rcZrxCVvBce1r8kq1LvxXpKREPoiJmYALjBF42B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096720; c=relaxed/simple;
	bh=tU6gp+ORps1R6z9yUsItfuZ0x3Ql2/Cp5scYWBl0+GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kslwZmiaIrqojL/cm9vTszXH67OHIkfziKkHVQrJsfqn0lEX+jTNyC9cWTaPSPBJ5X2rkT/P2vybG67hKfbA6T41xaPvQlCPX7lbXq07djDgVWna3QgZI1TVn5LFWpZT7OTjBK2JyJWwzEDDwgMCclpoXh4Rxmy4GyjPYH3cJn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9L9yneo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9L9yneo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0252FC2BCAF;
	Mon, 13 Apr 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096720;
	bh=tU6gp+ORps1R6z9yUsItfuZ0x3Ql2/Cp5scYWBl0+GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9L9yneoyXcDdS1vrq+T+kFuK7SHiWIKFrNehSNtxhzAZLcZIoPm9Rm0Sh0YSnsKR
	 Nu7fICA4bt5IOQABxrbuJUMZEZYI8GP3NHNNYTWCXeCiEJJGJrfzfMWz3GOOU/T5L4
	 N1fcZnZvEMJIZ9Ed4BgyX9ACIheB5f6kEpCM4q0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 36/70] platform/x86/intel-uncore-freq: Handle autonomous UFS status bit
Date: Mon, 13 Apr 2026 18:00:31 +0200
Message-ID: <20260413155729.530855464@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -421,6 +421,7 @@ static void remove_cluster_entries(struc
 #define UNCORE_VERSION_MASK			GENMASK_ULL(7, 0)
 #define UNCORE_LOCAL_FABRIC_CLUSTER_ID_MASK	GENMASK_ULL(15, 8)
 #define UNCORE_CLUSTER_OFF_MASK			GENMASK_ULL(7, 0)
+#define UNCORE_AUTONOMOUS_UFS_DISABLED		BIT(32)
 #define UNCORE_MAX_CLUSTER_PER_DOMAIN		8
 
 static int uncore_probe(struct auxiliary_device *auxdev, const struct auxiliary_device_id *id)
@@ -482,6 +483,7 @@ static int uncore_probe(struct auxiliary
 
 	for (i = 0; i < num_resources; ++i) {
 		struct tpmi_uncore_power_domain_info *pd_info;
+		bool auto_ufs_enabled;
 		struct resource *res;
 		u64 cluster_offset;
 		u8 cluster_mask;
@@ -531,6 +533,8 @@ static int uncore_probe(struct auxiliary
 			continue;
 		}
 
+		auto_ufs_enabled = !(header & UNCORE_AUTONOMOUS_UFS_DISABLED);
+
 		/* Find out number of clusters in this resource */
 		pd_info->cluster_count = hweight8(cluster_mask);
 
@@ -568,7 +572,9 @@ static int uncore_probe(struct auxiliary
 
 			cluster_info->uncore_root = tpmi_uncore;
 
-			if (TPMI_MINOR_VERSION(pd_info->ufs_header_ver) >= UNCORE_ELC_SUPPORTED_VERSION)
+			if ((TPMI_MINOR_VERSION(pd_info->ufs_header_ver) >=
+			     UNCORE_ELC_SUPPORTED_VERSION) &&
+			    auto_ufs_enabled)
 				cluster_info->elc_supported = true;
 
 			ret = uncore_freq_add_entry(&cluster_info->uncore_data, 0);


