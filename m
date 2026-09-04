Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D763BCD0A;
	Fri,  4 Sep 2026 05:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501482; cv=none; b=L6kz0MiUOfA553Ei2v0mUM4u0RDHSQXvLbKnLsnO9ZoA97Kd0tb5ruy9jlCUgiz2oCGZtn7gNRQIRV2TwOo0aI5lwN5aAJfnPrF8ncPTzN9Fcv9YRfJvAL6XINUljhE8PZ+WqYFrf3275C9zRoZQoqneRH0JryMXahzpBElPDyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501482; c=relaxed/simple;
	bh=SNc1XWjE4+Hsqspjr910Zr0R7f7CRjHss914WGFZnz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+53l0DpAX1dEW2DPkcRGPhqTGTKewUfdjSJATS2Gk8hHTmpkvuR+TXmF0Hsl6UnpEJuqIAk5xFJwDaUx063klosNxlLI2RF8iU3Q8MXuHQL/p7IvZeW8OCL0NOpx1I4AF/4LzWMs9tCpscc5QRHyiHQCWAIuiya/jLHPDAGFpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7y3Tl3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7y3Tl3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907831F00A3D;
	Fri,  4 Sep 2026 05:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501480;
	bh=L4djCwzqkR7sT3jjHEVU6q2UHlpcD3aVl4WVR/SucvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7y3Tl3IfB2X/F+JCZTV94YQOOUNrIcoZnHi39+NSvIGuIOc4SoyRqT3E/6K0zdKy
	 4ArDoRDbczj7Elo8Ny2/38IZWvBjbGyBSmGW0eHhcQm2O+NKuTg+2rBL7Bg0AgDM++
	 07nul5h7fg1YiGmXYS7wONX9AREuGe7MOKS+Wb+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 424/552] platform/x86: ISST: Return error during profile addition
Date: Fri,  4 Sep 2026 06:59:41 +0200
Message-ID: <20260904045800.214785497@linuxfoundation.org>
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

commit f9a647cb8d90c09633a49a1e766e140e78012444 upstream.

If sst_add_perf_profiles() fails for memory allocation, it continues
to allow SST-CP (core-power) feature. But in practice this is not
very useful as to achieve some frequencies via SST-CP, an SST-PP
(perf-profile) level change is required.

Fixes: 0ab147bb840f ("platform/x86: ISST: Parse SST MMIO and update instance")
Cc: HyeongJun An <sammiee5311@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811222134.3912626-2-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -339,7 +339,7 @@ static int sst_add_perf_profiles(struct
 	if (!pd_info->perf_levels) {
 		pd_info->pp_header.allowed_level_mask = 0;
 		pd_info->pp_header.level_en_mask = 0;
-		return 0;
+		return -ENOMEM;
 	}
 
 	pd_info->ratio_unit = pd_info->pp_header.ratio_unit;
@@ -370,7 +370,7 @@ static int sst_add_perf_profiles(struct
 static int sst_main(struct auxiliary_device *auxdev, struct tpmi_per_power_domain_info *pd_info)
 {
 	struct device *dev = &auxdev->dev;
-	int i, mask, levels;
+	int i, ret, mask, levels;
 
 	*((u64 *)&pd_info->sst_header) = readq(pd_info->sst_base);
 	pd_info->sst_header.cp_offset *= 8;
@@ -402,8 +402,12 @@ static int sst_main(struct auxiliary_dev
 			levels = i;
 		mask <<= 1;
 	}
+
+	ret = sst_add_perf_profiles(auxdev, pd_info, levels + 1);
+	if (ret)
+		return ret;
+
 	pd_info->max_level = levels;
-	sst_add_perf_profiles(auxdev, pd_info, levels + 1);
 
 	return 0;
 }


