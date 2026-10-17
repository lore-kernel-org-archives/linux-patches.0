Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03C39934B;
	Sat, 17 Oct 2026 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256081; cv=none; b=mdpqa2wXiSJsaiRMM5Hs9hsCo1YmnJEMewcsBI+apIgq2QcIoyHQGkLrGYG37KIEleT8p8hKY+3I9LXtWACW5l/K/WenhoEOIEWzFdYDhStelHitkwnU9BBONLwmh2cWG4elc/LDqfoVQbh+uZUluXdzKgLIccICzNCNMvongNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256081; c=relaxed/simple;
	bh=/NHAWnTz8SvWCQY3Ar3K/T4Q2EFqIYotfd1Kta8F1bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MrZZwOtZXdBq1LuMdOGPxJCvEIQdVPNCGt6KFYZ+ITRcRQ587NlKispXoAVHbaoeMniSW4EpTT+t8lZvD5m5/nILGadu6pLVokx+jfFETyBviiz3qWrnwV3tmD1DI3aHqIvRCCMQSugGnUOl2DnARs7E1R0Ujj4gjSJzAYIHVTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEG9AjoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEG9AjoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DC01F000C4;
	Sat, 17 Oct 2026 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256080;
	bh=1YmvTWmjwwjd/ZsuWc2NLutxwojn25l816CBBkujn5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEG9AjoU9mWbv4MDyKDnNDM7fszY5h6z5hUHioHgwY2XlEaKZeESUfBQ89HcEsz1x
	 TfhUrKhnLUZPhFZRgPDxCp3VlBxDY/S0I/8bPb4FrTxw1FCmx/8WkBV7UGeGbRHYlQ
	 GALfOa9hLsCb15Z2pg81yPOYfZC5Z9pmMuANFB3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0075/1674] platform/x86: ISST: Validate parameter for core power state
Date: Sat, 17 Oct 2026 17:39:07 +0200
Message-ID: <20261017160433.058317638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 1700b4f804555467b7eff58dff7acc11d508b3a1 ]

Allow only 0 or 1 for core_power enable and priority_type parameters.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-4-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ adjusted context for the missing write_blocked/CAP_SYS_ADMIN permission check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/intel/speed_select_if/isst_tpmi_core.c    | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 7a4f3086e97b2..3418a89c72042 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -450,6 +450,9 @@ static bool disable_dynamic_sst_features(void)
 #define SST_CP_PRIORITY_TYPE_START	1
 #define SST_CP_PRIORITY_TYPE_WIDTH	1
 
+#define SST_CP_MAX_ENABLE		1
+#define SST_CP_MAX_PRIORITY_TYPE	1
+
 static long isst_if_core_power_state(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -466,6 +469,10 @@ static long isst_if_core_power_state(void __user *argp)
 		return -EINVAL;
 
 	if (core_power.get_set) {
+		if (core_power.enable > SST_CP_MAX_ENABLE ||
+		    core_power.priority_type > SST_CP_MAX_PRIORITY_TYPE)
+			return -EINVAL;
+
 		_write_cp_info("cp_enable", core_power.enable, SST_CP_CONTROL_OFFSET,
 			       SST_CP_ENABLE_START, SST_CP_ENABLE_WIDTH, SST_MUL_FACTOR_NONE)
 		_write_cp_info("cp_prio_type", core_power.priority_type, SST_CP_CONTROL_OFFSET,
-- 
2.53.0



