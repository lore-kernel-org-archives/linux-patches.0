Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015389;
	b=L4dr9nTrxEBhm7C7QbfuaZIy5vvggQanI1hziI4i0xY4abHYXN8f8/9+XVeOxRjXJDeT
	 046S9jKjLGxvY9N6PNaxJiG24VTyrVGMvdYJbxMpncWXjUy7E+QCXLh+cdv4KwXqIt7km
	 2AG5QtqyINwgtG2EoNwU2oejM1sVcJx0Urno6ITgJcCABv2N4KT929XtyCjU80Cm5ndyB
	 MqZqqiVVKe+MY+7tBB2ZHGo52O+kClSkuZmvMGteCDZbgzsG6vaFbsmtgDH1hrCAekquO
	 tUrI88OSvmh2wsiHh+IanJdm7exw47cvHQv5URZN/8svIeZ0DO/yjPt62Tn7cfaYghw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z8HWyIUxkBPZtS345M2nLfWK4Dlpgse+QH61F9k4As0=;
	b=g4VBp/5f9VryqrOC1Zaol6PUtZqsCJvyzLVM9ZPycn/nn7pASFdiAmKDNNYmOCyvwGRI
	 K2ROui0/uDXkeKMnt12/uFBEgHRIWrmFGQZwgmcRs8bKsauXAv++mkcAsGEfSXOMmKjZx
	 OMpoVSCjJLiayZrZ/Si+7lfAzN2ksY0bfyz18Sl2ZYc1WlFPK9EOOaRzkQKFdPSkcmfCd
	 xNsVLSpxYCf0cwNjkMfdIaRKqw8ovhbbYTZgEyqkB62C1x+z1ymkj7JHpDnQJE0KsDL+r
	 bFd6EShXtOnmoNLzqOBkAwgkpeJbHqTIDUP9edUlM3xWdr2epT2lIw7k0+HEMW/+M6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ww5I1vpd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E6E606A31C;
	Wed, 18 Nov 2026 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ww5I1vpd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7CA1F000C4;
	Wed, 18 Nov 2026 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015389;
	bh=z8HWyIUxkBPZtS345M2nLfWK4Dlpgse+QH61F9k4As0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ww5I1vpd08r+vKjaLpm2TXXf0nemdW6SXHqMxK3CvBZ6SMXExkUX7C5/u0Gz4Dw+U
	 fansTjOO4x/xL293apYOjksonpUom9ArbvEnJCBqsxolJjOA/mE6CkGmLNxij5m6WR
	 CntHI4CSMyinBk+RXf17im2HrO0bSserXTs/L+HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0119/2651] arm64: dts: apple: t6030: Fix cpus node indentation
Date: Wed, 18 Nov 2026 15:22:39 +0100
Message-ID: <20261118150252.157443292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit 1c7e2a0cfc902932da41a93202f196a2dab18b71 ]

Drop the extra space indentation of the closing brace of the cpus node.

Fixes: e81af013dbdd ("arm64: dts: apple: Initial T6030 (M3 Pro) device trees")
Reviewed-by: Janne Grunau <j@jannau.net>
Link: https://patch.msgid.link/20260830-b4-apple-dts-fixes-v1-2-cc20f8445754@kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t6030.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/apple/t6030.dtsi b/arch/arm64/boot/dts/apple/t6030.dtsi
index dda9568af11f9..5ff12edfc5532 100644
--- a/arch/arm64/boot/dts/apple/t6030.dtsi
+++ b/arch/arm64/boot/dts/apple/t6030.dtsi
@@ -208,7 +208,7 @@ l2_cache_1: l2-cache-1 {
 			cache-unified;
 			cache-size = <0x1000000>;
 		};
-	 };
+	};
 
 	timer {
 		compatible = "arm,armv8-timer";
-- 
2.53.0



