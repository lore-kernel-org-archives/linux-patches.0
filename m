Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9832571CF;
	Thu, 17 Apr 2025 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915034; cv=none; b=hDzLzaUxFZ6+Vb/GL0VbgPAM44pMafT3l/pik/DUcJ6o9lnI6eh4/i4CxOeTZlVwfvUymoLbr+TITbr8XihouZBql9dZvlIu78y1jjD8InWvR6KQo8Kckz0hUZj0ppdPGUUcs1Hk8SB78QPtvkyWBQkTfqIO80TzD98Ykl0DBxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915034; c=relaxed/simple;
	bh=ueKJw/3spVtKIDCei/b+4nuamEbG4qPo6xdh5uyd2ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3+el1Lp8tWcBv+tNy2jZb/2iPImuyalNFAGGBVTLjp4kWx6+TevdDKY+gqnOPdkFzZnk/eUb5iq45FEfOu/mRBBb5tqrxeyuyr4/2k+xCMKwBNXP3g6N4a1FHmkFpSEnLHD12wtDDhaFMFqsIgmBmfvIfwQAZcghhxIa60Aa/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgiCK61U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgiCK61U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD82C4CEEA;
	Thu, 17 Apr 2025 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915034;
	bh=ueKJw/3spVtKIDCei/b+4nuamEbG4qPo6xdh5uyd2ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgiCK61UP+sRIh91wzKBDM0hPD+7hcl+/JFnL97vb6r69DhJ/NJXnwRJmvsH5SaOW
	 Pmrk3U1kLXn/l9GJYPt71vbSddU9MZw1ALULB1AXctki85jx/Fb3oaU7RG9ofx86Gc
	 C0png1HO1+YDYsPjpRdMx5vY26iQLKjaKw3bbyVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.13 404/414] arm64: errata: Add newer ARM cores to the spectre_bhb_loop_affected() lists
Date: Thu, 17 Apr 2025 19:52:42 +0200
Message-ID: <20250417175127.730388603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


