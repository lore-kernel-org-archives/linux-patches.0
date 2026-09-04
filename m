Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27047080D;
	Fri,  4 Sep 2026 05:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501477; cv=none; b=dbFzbZAv8URjDD1nqlACYQO4kgJzGR5yeD6swPXv7+4he4w2tlEX0mpeMm8+Y+wDticAUA2Pcwn2o3gW4/2UHnJuTE8nn5Q3Clhxu9wWoxEK2dOJWw2HpWpUno3UwXQypo7gxcGG6GAdIKaxzeOKtJECMM0jHNZsTWX/xZXYmXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501477; c=relaxed/simple;
	bh=Pp8PH2/uXtAZnC4SKRm+3sz55N355P/FDbBLGzggXSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPNWNVtvOZYK5FEIMnKVcxYHS1NMMLyt0/w+GwUVNzDqbmutvasJG16lMFTEl0N5iNEOusi2Bisa31uHY2/Vh8/YQlHrGvQ72nBOFod+zjo76h0VeViP1njIpfiUWuo5vDSUdBkVKWso7ZEHXsRAr7XOZp8dCBqeg/vVqru1Ujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lExZxsLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lExZxsLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86701F00A3D;
	Fri,  4 Sep 2026 05:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501475;
	bh=5E+D0vyshTjk5U83ENvHt7X4KTgRDQzorj159TUNdwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lExZxsLRibyJTKAe7J3ZEazZxLL0DjvTcdxSsm5dWx7ltxNqUkZ5nh5mKVgPOS6Vy
	 dH46+coYxHPc+gkrBAfYXwos+LLbUIgAa5U9dk6sFHZSa5z8J4MCVLZ36sxn6xb3Mh
	 tmUeJK38NtCo4TpYOk/Qlyv0iEpIMfE6U1U1TZiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 422/552] platform/x86: ISST: Validate parameter for core power state
Date: Fri,  4 Sep 2026 06:59:39 +0200
Message-ID: <20260904045800.172930111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -602,6 +602,9 @@ static bool disable_dynamic_sst_features
 #define SST_CP_PRIORITY_TYPE_START	1
 #define SST_CP_PRIORITY_TYPE_WIDTH	1
 
+#define SST_CP_MAX_ENABLE		1
+#define SST_CP_MAX_PRIORITY_TYPE	1
+
 static long isst_if_core_power_state(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -621,6 +624,10 @@ static long isst_if_core_power_state(voi
 		if (power_domain_info->write_blocked)
 			return -EPERM;
 
+		if (core_power.enable > SST_CP_MAX_ENABLE ||
+		    core_power.priority_type > SST_CP_MAX_PRIORITY_TYPE)
+			return -EINVAL;
+
 		_write_cp_info("cp_enable", core_power.enable, SST_CP_CONTROL_OFFSET,
 			       SST_CP_ENABLE_START, SST_CP_ENABLE_WIDTH, SST_MUL_FACTOR_NONE)
 		_write_cp_info("cp_prio_type", core_power.priority_type, SST_CP_CONTROL_OFFSET,


