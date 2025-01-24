Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFC1D7998
	for <patches@lists.linux.dev>; Fri, 24 Jan 2025 04:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737691729; cv=none; b=JZSQZPD2mZK30WsZObSMkcciS97PSsYMcatGeezLduq/hh5ZIolzTGgGgNEl3EAfwpFLg602g4wnbmd0j4XDu+uYFhj/V1sQr4L2SfDzrfpIOqWqGUa6I0FIQhWcI9W5aSGGj10D3u7efegTbteWG2OpqtVC4jc/NErW/hjj4kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737691729; c=relaxed/simple;
	bh=CEX9iTnWVwmw7wHb8BwrgfBevsuzLYRxQx14siwDqvk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZomGUsBaIjZSPdLuJgCcjI7cXqkzn2co5TgFutQiw0oG4CX+fByjElVbxaxFcNIS+JJjzktz+oLxoAjTmvJ/a0bQ6XFlmpAlg02V5PlaS13jWHRaJkpdEvh2Vkw7SWBHH+lWaBytC+Nq3RkueP11hCt3AP1hAF5Om2MCwweCOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RTmqozzK; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RTmqozzK"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ef72924e53so3057402a91.3
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 20:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737691727; x=1738296527; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D6e6R/iD1t4ReAa9KfZ1qSPqX0t3TQNshzKeYKkD9yY=;
        b=RTmqozzKRl+Qlwng0fuQm+pt/IndEXODKwycUuT+oQi844ZcuEfer7exjLo70Xekbm
         x4XrAc8ntdLYJ3ytW2xWPe9TN1JZuzxzpYzE1aP/T9nLADgRjwKJLNEkkcbS6w4fl7ld
         +7CijHf/h43gcFjvEww2vSel7ee52M3xHFL17KVlkbjdeOcLZm0j8QOhLbsRqVkVcQT/
         D4xdIq3Rf9itNJv6X6rf6meYDciuHh66EC6zpYVUYjasIVQp6x0myt/1vNzjYal9g8C3
         1QSdoqQqpc7RBJNU6KUkXhx27dLP3BgU/2A6EdwbwcvFOsW9YHTGZHmlUWp/NrdkF1Qn
         BJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737691727; x=1738296527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D6e6R/iD1t4ReAa9KfZ1qSPqX0t3TQNshzKeYKkD9yY=;
        b=uG7K2VYLYrQjTZOqumsMLJKHPi61QPjHIWtUpYLH/375i0OlJ05HXrfNbEdKCR60Hd
         h1rbh8jWcPhVrDAbmTF7XDtlAkLZjKC6yqCKQ3yVsMhlQKb2jd3Xv2ogds69eMyIYK05
         RgdDkWpU3MBuZMlwgX3vK2nKCaMtCgVmBnjRiyq29xbHL7hvojKgZQxE2wB1mq2g46Kg
         ChU08rAKhzo/L+tfW1nTYc9rirP32nK/3ZNtJNFtm1C4BnUpUp6b5jaxzKgzTR3VR9ER
         mUyx52DLOzxGgBsxdPJ+rVXfQoBDtyVUyYCeohZnbxyrFmbsOAHv0731cutCHOqGopG9
         EDMQ==
X-Gm-Message-State: AOJu0YxvAxUgC2jJuQ+0LVE3GCv+s/Bg/XV1DV6CqVv8sXyBH6jRu8KH
	GWmRW64Fcoe8sWoHDXfrMs/l2fKPId9yfX9Cy6EcxBRWIR9yNSr7
X-Gm-Gg: ASbGncvoo6WFgYzZ/6ep4GzbgDeagN0jmIKN/M7I2qx5sDBxWW1kwPZ18qawHK4gL+B
	NLKgO0ZZKu9UJ/cswcRZyFDBDvZ7KTP6Nm+F74GPOS3MsbYRM3IfLMMrKbWgDyoVmoUi80nvtEj
	qMrbItAycNdbrPuV+k5k59bRyGkpWdvENW/Fhu0dCL/nAO8DOFpcyL/6ShJwV24DsGnVz12UEIx
	1eCnP4gc6DG6csyD9eV+LX6yiSv3BFlOvtjaLe0XiTWRjDNUU5NaJT/IuFX75CUhVZm96TVu6yR
	9/BB0c9JFWgYwz82JaS+k8uXVbcgT7SsyL2aVuDR
X-Google-Smtp-Source: AGHT+IGKwqK3FeAP7M3pDG/EPu8XOfZtrxx0RtjPTD4kt8b1n6567njef2h1tCvlNFusMRPQtdbLkw==
X-Received: by 2002:a17:90b:2808:b0:2ee:d433:7c54 with SMTP id 98e67ed59e1d1-2f782cb61bemr40425091a91.19.1737691727590;
        Thu, 23 Jan 2025 20:08:47 -0800 (PST)
Received: from jren-d3.localdomain ([221.222.59.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa455c0sm562670a91.3.2025.01.23.20.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 20:08:47 -0800 (PST)
From: Imkanmod Khan <imkanmodkhan@gmail.com>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	alexander.deucher@amd.com,
	daniel.wheeler@amd.com,
	mario.limonciello@amd.com,
	josip.pavic@amd.com,
	aurabindo.pillai@amd.com,
	sohaib.nadeem@amd.com,
	gregkh@linuxfoundation.org,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	wayne.lin@amd.com,
	sashal@kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	charlene.liu@amd.com,
	gabe.teeger@amd.com,
	amd-gfx@lists.freedesktop.org,
	Nicholas.Kazlauskas@amd.com,
	Imkanmod Khan <imkanmodkhan@gmail.com>
Subject: [PATCH 6.1.y] drm/amd/display: fixed integer types and null check locations
Date: Fri, 24 Jan 2025 12:08:36 +0800
Message-ID: <20250124040836.7603-1-imkanmodkhan@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sohaib Nadeem <sohaib.nadeem@amd.com>

[ Upstream commit 0484e05d048b66d01d1f3c1d2306010bb57d8738 ]

[why]:
issues fixed:
- comparison with wider integer type in loop condition which can cause
infinite loops
- pointer dereference before null check

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Josip Pavic <josip.pavic@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Imkanmod Khan <imkanmodkhan@gmail.com>
---
 .../gpu/drm/amd/display/dc/bios/bios_parser2.c   | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index 4d2590964a20..75e44d8a7b40 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -1862,19 +1862,21 @@ static enum bp_result get_firmware_info_v3_2(
 		/* Vega12 */
 		smu_info_v3_2 = GET_IMAGE(struct atom_smu_info_v3_2,
 							DATA_TABLES(smu_info));
-		DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", smu_info_v3_2->gpuclk_ss_percentage);
 		if (!smu_info_v3_2)
 			return BP_RESULT_BADBIOSTABLE;
 
+		DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", smu_info_v3_2->gpuclk_ss_percentage);
+
 		info->default_engine_clk = smu_info_v3_2->bootup_dcefclk_10khz * 10;
 	} else if (revision.minor == 3) {
 		/* Vega20 */
 		smu_info_v3_3 = GET_IMAGE(struct atom_smu_info_v3_3,
 							DATA_TABLES(smu_info));
-		DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", smu_info_v3_3->gpuclk_ss_percentage);
 		if (!smu_info_v3_3)
 			return BP_RESULT_BADBIOSTABLE;
 
+		DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", smu_info_v3_3->gpuclk_ss_percentage);
+
 		info->default_engine_clk = smu_info_v3_3->bootup_dcefclk_10khz * 10;
 	}
 
@@ -2439,10 +2441,11 @@ static enum bp_result get_integrated_info_v11(
 	info_v11 = GET_IMAGE(struct atom_integrated_system_info_v1_11,
 					DATA_TABLES(integratedsysteminfo));
 
-	DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", info_v11->gpuclk_ss_percentage);
 	if (info_v11 == NULL)
 		return BP_RESULT_BADBIOSTABLE;
 
+	DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", info_v11->gpuclk_ss_percentage);
+
 	info->gpu_cap_info =
 	le32_to_cpu(info_v11->gpucapinfo);
 	/*
@@ -2654,11 +2657,12 @@ static enum bp_result get_integrated_info_v2_1(
 
 	info_v2_1 = GET_IMAGE(struct atom_integrated_system_info_v2_1,
 					DATA_TABLES(integratedsysteminfo));
-	DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", info_v2_1->gpuclk_ss_percentage);
 
 	if (info_v2_1 == NULL)
 		return BP_RESULT_BADBIOSTABLE;
 
+	DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", info_v2_1->gpuclk_ss_percentage);
+
 	info->gpu_cap_info =
 	le32_to_cpu(info_v2_1->gpucapinfo);
 	/*
@@ -2816,11 +2820,11 @@ static enum bp_result get_integrated_info_v2_2(
 	info_v2_2 = GET_IMAGE(struct atom_integrated_system_info_v2_2,
 					DATA_TABLES(integratedsysteminfo));
 
-	DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", info_v2_2->gpuclk_ss_percentage);
-
 	if (info_v2_2 == NULL)
 		return BP_RESULT_BADBIOSTABLE;
 
+	DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", info_v2_2->gpuclk_ss_percentage);
+
 	info->gpu_cap_info =
 	le32_to_cpu(info_v2_2->gpucapinfo);
 	/*
-- 
2.25.1

