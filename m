Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82AB3D903B;
	Fri,  4 Sep 2026 06:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502751; cv=none; b=TVTnb3kD9jwW4845CFSljVJ/HS8bUBaCoZiQqm+U4mboGp4qHm0fR49NCq1r160B31HM4wZgxnapeBPtFxsX4vENqnE858Lhvn2GhHlGTArlBGfJaWkfm7pQ2Ooc//q0nbaqUya56Im8OazSZsBow1ooALBcqUGNIn8TP8f8/L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502751; c=relaxed/simple;
	bh=pdDVaiKWyB/AF6JsiziURg2jfxTtwopaQ/IV2/zWzsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7t2pczy/azIWLXzALGbw/7M0xIC9kxBmsvCN5Miu/wC7d3uMoW6C4lMdUKrMJoyeGokXr7x4UYNSSs/H0SJXvEu/mqmOVwGJleOVH6wfJ9AkNUQ1l0b5F/NxIbUnkdqRJR60A2OE4znUmG4t8QRXyaEeHt/PmCiGvNe05VoV9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBqLJzM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBqLJzM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E41B1F00A3D;
	Fri,  4 Sep 2026 06:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502750;
	bh=bgw7S8F25TZBTHG5uukV1BRSqstBy/5PoAdOFP7C/OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBqLJzM7LAZgx1WAmzg4Cx+RVZoZexPWKO8ycS6mGR126yYOxw9cGDi9kvV2PcS8/
	 +W1d5f7bVdCjnFusAMWJYAif8GhxgO7QqZZSPyESL+VA5nm2At2D8u+HTyGGeCHDDM
	 yllmlHa5/Vv5Yf42FEdnsyR8ZqeWhPc8LqNtAmNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 315/403] platform/x86: ISST: Validate parameter for core power state
Date: Fri,  4 Sep 2026 07:01:58 +0200
Message-ID: <20260904045742.002916619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

commit 1700b4f804555467b7eff58dff7acc11d508b3a1 upstream.

Allow only 0 or 1 for core_power enable and priority_type parameters.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-4-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -597,6 +597,9 @@ static bool disable_dynamic_sst_features
 #define SST_CP_PRIORITY_TYPE_START	1
 #define SST_CP_PRIORITY_TYPE_WIDTH	1
 
+#define SST_CP_MAX_ENABLE		1
+#define SST_CP_MAX_PRIORITY_TYPE	1
+
 static long isst_if_core_power_state(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -616,6 +619,10 @@ static long isst_if_core_power_state(voi
 		if (power_domain_info->write_blocked)
 			return -EPERM;
 
+		if (core_power.enable > SST_CP_MAX_ENABLE ||
+		    core_power.priority_type > SST_CP_MAX_PRIORITY_TYPE)
+			return -EINVAL;
+
 		_write_cp_info("cp_enable", core_power.enable, SST_CP_CONTROL_OFFSET,
 			       SST_CP_ENABLE_START, SST_CP_ENABLE_WIDTH, SST_MUL_FACTOR_NONE)
 		_write_cp_info("cp_prio_type", core_power.priority_type, SST_CP_CONTROL_OFFSET,


