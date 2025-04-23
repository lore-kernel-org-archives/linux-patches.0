Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA6527FD7A;
	Wed, 23 Apr 2025 15:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420837; cv=none; b=VHZeXk+CneUnlLgflL+/vn79L84+ILD8lundOH3zl5LLO615JD/klRCOCZ6+4HSrmijXFgrHsTCjwH9kjyxXe4kzmV8eA1ObsgOTSEezRAv4VmVu1BD5ttypn84+jSM5XbR1PcqeJW0eFY74aoUFmletS86oy8x25dutLt0+Pic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420837; c=relaxed/simple;
	bh=aybqsk0sygU+NxD0f6PRZGz6GQ1Yj9rV0mQkto9SIVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khjPC7MgRLlICRY7HNKnRROJqfRdW5xTc9tyzSILXA3tghJ5iaWHdsLo5e6BZZwgR4/RG39eiIU0/l/JdaPGO8iyw1rFEt2/peux9v90I4kPgp5y4Jd8D/au71oXvD0lKJihtrj6Gvyeoi3fl7rKEs0bLEFCkkRrS0EKpjcvXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLIVQh3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLIVQh3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38668C4CEE2;
	Wed, 23 Apr 2025 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420837;
	bh=aybqsk0sygU+NxD0f6PRZGz6GQ1Yj9rV0mQkto9SIVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLIVQh3jh2oc32OO7qd72bSdtTG8UGwNPP5/ggdVhFg9gLkW/ofHJp1JiFg2eEfGZ
	 4pNALtr/tKTPS9haYkSkLC+N3F8uuI1AJq3qbkv3Vbqu81Bihor9sS+rQKHeeNVQZz
	 fLUuuZGGW3ATYKKjmr5WzIuFyOWNGW2k/DDL57UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Bauer <sbauer@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 085/291] arm64: errata: Add QCOM_KRYO_4XX_GOLD to the spectre_bhb_k24_list
Date: Wed, 23 Apr 2025 16:41:14 +0200
Message-ID: <20250423142627.838323629@linuxfoundation.org>
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
@@ -878,6 +878,7 @@ u8 spectre_bhb_loop_affected(int scope)
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+			MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_GOLD),
 			{},
 		};
 		static const struct midr_range spectre_bhb_k11_list[] = {


