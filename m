Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF38262FD6;
	Wed, 23 Apr 2025 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420861; cv=none; b=V+4jeyDjajGF98Pz9+wOCDljxyGKClYgaJ7WeOKWdm3V/HDQNC4jczvOJjia3EOADuYK3SK8YEkRszzHK/QXIbgTDZAogJttdYHNTuCWjIy/vH+LnR4YiIEgwd7XyUAc66RSLJ6dHFzSrjUJAsmY2HTU1oEYxpMSkM/2b5YjOsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420861; c=relaxed/simple;
	bh=oanoVeHRj27foJoxQalX3r6EF9F44KhrxcKMfSfIAEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOwPSIdjtMo8yiG2OfUgEAImAhxAMHO5eD9K3an3n/QhpJDiXLNI5irCKOK+O4UVqI8I9EyCHAhtwxF3MP1ENgTgU0U4qP0WTOp/llWCFqot3vxqO07XYaYdyZfKsy/jQ1xZOgo36bOYynmMCKHwvICY2LsqPoSh+HyCyT4Y2TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/9GxXW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/9GxXW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1149C4CEE2;
	Wed, 23 Apr 2025 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420861;
	bh=oanoVeHRj27foJoxQalX3r6EF9F44KhrxcKMfSfIAEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/9GxXW/B9J98xe53makTtAsfK+niXa8dIeN3oJ0Zmx7a8SwFMITAbOxP56vUXkjf
	 lFhWMGVXagRujNMgqWulBANYhGro1rj8nxtgXYNHk2LteunIqJ80UQjILb1dDJhtJF
	 kXhGKU0DxcPRSYf5q+w05hcfujpfrg4WcbrGxwik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Bauer <sbauer@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 087/291] arm64: errata: Add KRYO 2XX/3XX/4XX silver cores to Spectre BHB safe list
Date: Wed, 23 Apr 2025 16:41:16 +0200
Message-ID: <20250423142627.917619382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit 0c9fc6e652cd5aed48c5f700c32b7642bea7f453 upstream.

Qualcomm has confirmed that, much like Cortex A53 and A55, KRYO
2XX/3XX/4XX silver cores are unaffected by Spectre BHB. Add them to
the safe list.

Fixes: 558c303c9734 ("arm64: Mitigate spectre style branch history side channels")
Cc: stable@vger.kernel.org
Cc: Scott Bauer <sbauer@quicinc.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Trilok Soni <quic_tsoni@quicinc.com>
Link: https://lore.kernel.org/r/20250107120555.v4.3.Iab8dbfb5c9b1e143e7a29f410bce5f9525a0ba32@changeid
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -866,6 +866,9 @@ static bool is_spectre_bhb_safe(int scop
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A510),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A520),
 		MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_2XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{},
 	};
 	static bool all_safe = true;


