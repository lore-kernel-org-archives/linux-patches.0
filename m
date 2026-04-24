Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAA6179A3;
	Fri, 24 Apr 2026 13:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037711; cv=none; b=CYmPHkWDXqb9qDnwQfep44S8yWTUyceOgSgvCxPtmREfDXxSAGnQ8jhdcazJF90QOpP3UxZMMvh9Xy3L2oCzgc5qi7IkUvc2X0EC6GY64qKd89Omamyh3npsOivEY7rvQZxpPDSntj2Wjt8ikDfB8p9PEeeY1Ik7WU30Y4GVvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037711; c=relaxed/simple;
	bh=dzpwnaus4zHQzUriy2Hb6dZi0uH6SfrdUqi8M3ljj1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peRDnNkg24hVeaXUFmEwx9J0IHHqfJgdGzZKayWESJix5DtqrGMJHfglaRP+es9JFvbBu6Exll/rJt4f7XNhYXymyd1fQBSMbOCqKIntJdXZ17/Riw9MJo8eYS/TP1HwXU61gdukkV3XV/lbPcTPjFceHv2QYK/0yYef+bPxEJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJHYJgyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJHYJgyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C8CC19425;
	Fri, 24 Apr 2026 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037711;
	bh=dzpwnaus4zHQzUriy2Hb6dZi0uH6SfrdUqi8M3ljj1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJHYJgyiVGQ9DXb8uFGm4QaaMzdzTbVRymql0SBUO0Z0+k9SLCxUJqNcHMn2HDh+h
	 2DAlHB9p7r6cj3qAVhst2AOXkXGVMhG0iGFKEAkUXfI/xX+iwCXxNe9+8Ul4i02Zhd
	 Avir/s9rnX5NUX5UjEHblp7DeImmNMfTm4YH1wSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/166] dt-bindings: net: Fix Tegra234 MGBE PTP clock
Date: Fri, 24 Apr 2026 15:29:14 +0200
Message-ID: <20260424132541.223703664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit fb22b1fc5bca3c0aad95388933497ceb30f1fb26 ]

The PTP clock for the Tegra234 MGBE device is incorrectly named
'ptp-ref' and should be 'ptp_ref'. This is causing the following
warning to be observed on Tegra234 platforms that use this device:

 ERR KERN tegra-mgbe 6800000.ethernet eth0: Invalid PTP clock rate
 WARNING KERN tegra-mgbe 6800000.ethernet eth0: PTP init failed

Although this constitutes an ABI breakage in the binding for this
device, PTP support has clearly never worked and so fix this now
so we can correct the device-tree for this device. Note that the
MGBE driver still supports the legacy 'ptp-ref' clock name and so
older/existing device-trees will still work, but given that this
is not the correct name, there is no point to advertise this in the
binding.

Fixes: 189c2e5c7669 ("dt-bindings: net: Add Tegra234 MGBE")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260401102941.17466-3-jonathanh@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/net/nvidia,tegra234-mgbe.yaml         | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
index 2bd3efff2485e..215f14d1897d2 100644
--- a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
+++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
@@ -42,7 +42,7 @@ properties:
       - const: mgbe
       - const: mac
       - const: mac-divider
-      - const: ptp-ref
+      - const: ptp_ref
       - const: rx-input-m
       - const: rx-input
       - const: tx
@@ -133,7 +133,7 @@ examples:
                  <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
                  <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
                  <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
-        clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+        clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
                       "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
                       "rx-pcs", "tx-pcs";
         resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
-- 
2.53.0



