Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034574;
	b=pQUlSukvS+rbUWP8zPc12xk5U1HcYk4LYabTLEjrwxh5lf9I5zS8aZozjxpfB6tUL7wf
	 ljQvmoBY9gOgBnyPmUGvmfAOoQTb9G1IHbz6wwQOrcDbotEffWDzUnrRIaV3jL1oMGwaZ
	 09pYiXqAhExvgK07xml7DyYnY0Axg3xADAgsWhbvhYxxHSQ1pYHZuYcc4CkHvhE1WLfF/
	 bPoIky5QnOPBhNsUdJmrbuX1MfCHA40PJf6ndBW/k6b+qX7iKGzsjmnSVkG3Zvl7217xG
	 wgqzP80o1D4caiC6xLDyivfwx1sL/Jm3C38Oh4TS9pPJcw0pJtcDiAIW4sDuHar0LhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=j0rDv290dP9xymtucCtAuypl8Q0ChX+CSRQx++g82gU=;
	b=LlzMGetKOlMG+Ed38/HUQNeOwJpYGAjCRIjN90/JQQ0J/XweJSjewInQK2uagHm0LZbb
	 rokm+5koNnJVzH3WjviS/O3vDEnX6sp78hed2TgJyGrasF27j/uOnsLUYvRCm5GeVcZAa
	 3LEG8HG78hD4UMUEzZvCNtix62LToJp+mqkB8VVHbM/wA2VmtuqlvWadgX4OGTxKaiE05
	 OocvefOc1MVPgXSeBek+bcs49WaqBrO7fBojq04Jdm67ob7FmWajm8Z+xya2zEUvys5Hl
	 PtB7Yf6LhNk1ONdM9Z+jEN6JN8h+N4n6+RRUM37SacK3Jj83IzNLIu2+wpfWGIaF2vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGZu+bJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0C606A31C;
	Wed, 18 Nov 2026 20:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGZu+bJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC8F1F000C4;
	Wed, 18 Nov 2026 20:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034573;
	bh=j0rDv290dP9xymtucCtAuypl8Q0ChX+CSRQx++g82gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGZu+bJHH33/ns6tUcvvgE/8hOHjxcPND+xzQlFASv00IyuMXsub5mZHlQWwHGggL
	 6ZS4vdk3qvntgJqNImuKZEbYWF7Yu8P4+WZVEgYg/2S5y6gWQ5sxGA5NoRkzUs8oqA
	 oOLbP12PsyBKI856FnvknOIUBhxOIHX8lVSqLDlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0417/3318] platform/x86: ISST: Return error during profile addition
Date: Wed, 18 Nov 2026 15:17:19 +0100
Message-ID: <20261118150329.048688737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit f9a647cb8d90c09633a49a1e766e140e78012444 ]

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
[ sashal: adjusted context in the declaration hunk because sst_main() lacks the dev local and has a shorter layout in this tree; the code change itself matches upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/intel/speed_select_if/isst_tpmi_core.c         | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 5321f68dbafbc..5695b1a668cdd 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -321,7 +321,7 @@ static int sst_add_perf_profiles(struct auxiliary_device *auxdev,
 	if (!pd_info->perf_levels) {
 		pd_info->pp_header.allowed_level_mask = 0;
 		pd_info->pp_header.level_en_mask = 0;
-		return 0;
+		return -ENOMEM;
 	}
 
 	pd_info->ratio_unit = pd_info->pp_header.ratio_unit;
@@ -351,7 +351,7 @@ static int sst_add_perf_profiles(struct auxiliary_device *auxdev,
 
 static int sst_main(struct auxiliary_device *auxdev, struct tpmi_per_power_domain_info *pd_info)
 {
-	int i, mask, levels;
+	int i, ret, mask, levels;
 
 	*((u64 *)&pd_info->sst_header) = readq(pd_info->sst_base);
 	pd_info->sst_header.cp_offset *= 8;
@@ -379,8 +379,12 @@ static int sst_main(struct auxiliary_device *auxdev, struct tpmi_per_power_domai
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
-- 
2.53.0



