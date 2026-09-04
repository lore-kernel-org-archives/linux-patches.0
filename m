Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B09A41C2FF;
	Fri,  4 Sep 2026 06:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502900; cv=none; b=snI3LgJ/sOMaAoLsH3Ek8Rl1Zc0N2Xt89jBu3/UHL0PK1jgctaUUQL24KNsjquiS/ESFpMZE091oeJmnObho46Lub9dmYNa8d5G/7C1OkLrxr0Lh6+P2kdHKQL59CUNPuVdFshyxq2LBRq4Wmh3Ch0+0fp4rYf4euoMjaOusQCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502900; c=relaxed/simple;
	bh=DHQ3ZR4dT/0M+FBQWZlIVz/5Hm+c6nLpkkjsIv5NUOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mtmu3thMtEZnFFilOHWBATpXiyqozB2Y7z4LjGLYsKDtpevJKA2lb2qGLsikEznxEij32tJ11PjuCqFhbGZyvME23C6JokbfysvLvgBDsPZdyauS1wqciTBoZieVRvOd7sSTwSu2JU4/3jZOBjWXgT6kymBARUyCVgrFBYwu6/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvjVUtuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvjVUtuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962E71F00A3D;
	Fri,  4 Sep 2026 06:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502899;
	bh=bCRVNY5DAvVaKzgZrfztR4NodOM+4nGFDR9Dfj3CySM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvjVUtuIuvUL1xJknw7QzIDVGbZr4punOH3M+T2cqV+LVgevRMr6zXcGtKW+BNhLD
	 uOb+wx2D1S70e7ruqHkLqTemCwBn/7252ZY7oXtPv3mOU14AjcB59pDzM7BirSQzd0
	 dqljZUIDUr3LJgdVuMKoufI56pwqTyglg865XU/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 316/403] platform/x86: ISST: Validate parameter for frequency and priority
Date: Fri,  4 Sep 2026 07:01:59 +0200
Message-ID: <20260904045742.024199515@linuxfoundation.org>
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

commit 574b59bb4b6bfcfd1f639d02f1041b314d43a2e6 upstream.

Validate range for frequency and proportional priority while setting
CLOS parameters.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-5-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -656,6 +656,9 @@ static long isst_if_core_power_state(voi
 
 #define SST_MAX_CLOS			3
 
+#define SST_MAX_FREQ			0xff
+#define SST_CLOS_MAX_PRIORITY		0x0f
+
 static long isst_if_clos_param(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -675,6 +678,15 @@ static long isst_if_clos_param(void __us
 		if (power_domain_info->write_blocked)
 			return -EPERM;
 
+		if (!in_range(clos_param.min_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
+			return -EINVAL;
+
+		if (!in_range(clos_param.max_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
+			return -EINVAL;
+
+		if (!in_range(clos_param.prop_prio, 0, SST_CLOS_MAX_PRIORITY + 1))
+			return -EINVAL;
+
 		_write_cp_info("clos.min_freq", clos_param.min_freq_mhz,
 			       (SST_CLOS_CONFIG_0_OFFSET + clos_param.clos * SST_REG_SIZE),
 			       SST_CLOS_CONFIG_MIN_START, SST_CLOS_CONFIG_MIN_WIDTH,


