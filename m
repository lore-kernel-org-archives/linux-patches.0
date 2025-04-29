Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D59F227E95;
	Tue, 29 Apr 2025 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948627; cv=none; b=tErbjKIL63LMBZMuuKZlHHXNKZVBv6mE46T6yJCQifdTxmMTY9EJqbhQyW/m+qVe1d+1dGKY2gzBatb4n+sCaaJztwHhlhqVcGhiu6uZfGt7x6qtVAxWT4jC8dchMZDZm1Y6UT5zhfhk4FeFnZvY1BoZMxNsosNYRR+MuhV6864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948627; c=relaxed/simple;
	bh=qWr5jns3XUmw62gcHqzOKn+OG/but6WhVn9rGDSDPOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ud2nTu0nrhpplZf9UF+aOaAMB49kzB3sBeBrOJGQfCzpw8OFT0zSjN1y+eNVM+yEMyZ2b5+6mjXkQ+zI3eoaJOd0wUb8bXahz3H0p+c984sS3vgOdtUK/ry9xgUop/iB/q4jVG59cyBoBz9NTNklCtfis9Dqq5CT20O7JQJleAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoUm/Eo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoUm/Eo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B740EC4CEE3;
	Tue, 29 Apr 2025 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948627;
	bh=qWr5jns3XUmw62gcHqzOKn+OG/but6WhVn9rGDSDPOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoUm/Eo/HeX+BYbexElolUMHtlvZTCBaL+4k8ON2TLH5NfokzIJSy4yIei3vK86Ny
	 1M6D0w91MCilyBrSnr1wj1ZH31IcLGuX8GNj64FDVrDgEgqJqmDc/w0NK7Pe2yA0DH
	 LpEEEjglLH0XfTfjrWTJiB51+7kyeQCtk3Za14Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Bauer <sbauer@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 065/373] arm64: errata: Add QCOM_KRYO_4XX_GOLD to the spectre_bhb_k24_list
Date: Tue, 29 Apr 2025 18:39:02 +0200
Message-ID: <20250429161125.810184005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit ed1ce841245d8febe3badf51c57e81c3619d0a1d upstream.

Qualcomm Kryo 400-series Gold cores have a derivative of an ARM Cortex
A76 in them. Since A76 needs Spectre mitigation via looping then the
Kyro 400-series Gold cores also need Spectre mitigation via looping.

Qualcomm has confirmed that the proper "k" value for Kryo 400-series
Gold cores is 24.

Fixes: 558c303c9734 ("arm64: Mitigate spectre style branch history side channels")
Cc: stable@vger.kernel.org
Cc: Scott Bauer <sbauer@quicinc.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Trilok Soni <quic_tsoni@quicinc.com>
Link: https://lore.kernel.org/r/20250107120555.v4.1.Ie4ef54abe02e7eb0eee50f830575719bf23bda48@changeid
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -866,6 +866,7 @@ u8 spectre_bhb_loop_affected(int scope)
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+			MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_GOLD),
 			{},
 		};
 		static const struct midr_range spectre_bhb_k11_list[] = {


