Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD533B95FA;
	Fri,  4 Sep 2026 05:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499849; cv=none; b=BKNRehyDkxUx7itZ3xOXABsQdc22Ukk8Dg3IHm/p+OB4L84nZQC2Uf3QRB+Wb4PcNMZFODOwEPjypulVKbQZkVqPWWA36AlTYfW1Ltrg5/VsNMgrqtmJcCIqXQ9CMx2T3jytd1HE+5ZdZ/NDn53SRvzi7A3a8VHdDbNUrmPkaZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499849; c=relaxed/simple;
	bh=pAt3ZvpfhufpSLa6eudaie3Amf5kUC+TlqDoVFfQS0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBdWr7RLvSQX4Rl+VJynLltjsJSI3gVNjAwJXCTTj1230SvVQQujqSRicJ7sH3OXV2SHpi8b12lLkjBW6bB07E5iadoFCma+GEx52vwte03hBOECYtRhlQeusnb5ys3gE/i0L8zCCVrqd7R5RASx5IJjodr0qSjpg0L2khgwiFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZke85sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZke85sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE981F00A3D;
	Fri,  4 Sep 2026 05:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499847;
	bh=YIUxMdbDiNds4pyEEEQvORclAM1pC9dXWQ3XAi9LiH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZke85slQYhoIKVhkvhB9ZGiL9QoeSEunDCAUFqNgyau+OroddycG24oTw9disJW3
	 eTF/C2cRxFK5kLzNT5ATHplvo/59zs5cnk74ekvkhJVgcYvXzQpeWQCTElDBxS65oG
	 eYWogTZFdv6j0gDd5rVTEPitIfVVe9GWrXtrfC24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 562/713] platform/x86: ISST: Return error during profile addition
Date: Fri,  4 Sep 2026 06:58:50 +0200
Message-ID: <20260904045816.416660839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


