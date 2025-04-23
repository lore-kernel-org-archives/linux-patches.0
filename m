Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9164517B421;
	Wed, 23 Apr 2025 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421872; cv=none; b=XtOqeoBg6gzWoi8+7HdOcidjpclYB+4tzDf5YCDUtZ+EHwX1rZK0R6FpE2V2T7Gdn03CvuaCa9UyTESRSoQu8W5g/A6RuNGjpctUPmYy9d82dBNqRvCewY0yvV+Lj1yZuUSr+2QQSEH4VJQ+khvXI29WDFtNxIg4QwvQ1rxIj64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421872; c=relaxed/simple;
	bh=nXg2PM9SySyVz5h3ny3BjpyQJdqiwHr4v21wWFt97Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah8BtVF/c4owCEwKbCrp+KAQj+Eye5IPX4MrmEGp37fqDOQcgO9atY5j1ETeHv2K9JAOtecUcyQn1eZf6o+uDcyZOSv2GFPNCEJYagZZVryy0rqIcd7RNXcbEIEqabZ2pGpkzFO3mYqRCrADSXHi/boK4Xk2FieP8gp4ZPS6gr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilS9bzRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilS9bzRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FFEC4CEE2;
	Wed, 23 Apr 2025 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421871;
	bh=nXg2PM9SySyVz5h3ny3BjpyQJdqiwHr4v21wWFt97Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilS9bzRsYwSFubDr/HHwN2C7ZOa704CzXERonRIemHxwYGQw5mS/eDNpzjFB6kSCQ
	 +d8LsjnxJG/Ijy7A9qIrNaoEfhfk5/pMHcw0wB/2/uP6l22wGyhmP98rsOXHbn7HZb
	 vUIl4abScyry3tHJRuBcAAd2Z61XVxpeRz/ytfh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 232/393] arm64: errata: Add newer ARM cores to the spectre_bhb_loop_affected() lists
Date: Wed, 23 Apr 2025 16:42:08 +0200
Message-ID: <20250423142652.975262328@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit a5951389e58d2e816eed3dbec5877de9327fd881 upstream.

When comparing to the ARM list [1], it appears that several ARM cores
were missing from the lists in spectre_bhb_loop_affected(). Add them.

NOTE: for some of these cores it may not matter since other ways of
clearing the BHB may be used (like the CLRBHB instruction or ECBHB),
but it still seems good to have all the info from ARM's whitepaper
included.

[1] https://developer.arm.com/Arm%20Security%20Center/Spectre-BHB

Fixes: 558c303c9734 ("arm64: Mitigate spectre style branch history side channels")
Cc: stable@vger.kernel.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20250107120555.v4.5.I4a9a527e03f663040721c5401c41de587d015c82@changeid
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -876,6 +876,14 @@ static u8 spectre_bhb_loop_affected(void
 {
 	u8 k = 0;
 
+	static const struct midr_range spectre_bhb_k132_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_X3),
+		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
+	};
+	static const struct midr_range spectre_bhb_k38_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A715),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A720),
+	};
 	static const struct midr_range spectre_bhb_k32_list[] = {
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
@@ -889,6 +897,7 @@ static u8 spectre_bhb_loop_affected(void
 	};
 	static const struct midr_range spectre_bhb_k24_list[] = {
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A76AE),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_GOLD),
@@ -904,7 +913,11 @@ static u8 spectre_bhb_loop_affected(void
 		{},
 	};
 
-	if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k32_list))
+	if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k132_list))
+		k = 132;
+	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k38_list))
+		k = 38;
+	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k32_list))
 		k = 32;
 	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
 		k = 24;


