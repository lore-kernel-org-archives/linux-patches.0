Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94DF13F016;
	Tue, 23 Jan 2024 01:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972019; cv=none; b=KnO1mcgcpzRbf+V4EcTm7XImV97At176VhGq2JeVIbHq2JmtC2+DIddA52E9dEpbfTBaUEnb7zgL6j4Q6paM5ALy45zshBV4lzR8wLvXyHggbEow2af+jr05xLwrM+tzgLyZ7AvMuNHVt+qqnBPoWzeLi4ZO7lzvTt7G1cL24sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972019; c=relaxed/simple;
	bh=O8symqwPI26kRMgGrk8Cib/ZqIXESmzPkj+iSZEzi+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd4q77g/XC1hZAtfvLHeMps7bz0+PJeou8kPd7jGjLN3B5xrgU6rwAP3Yhc9LQNPE64X/9rKf82gH4CaEryzbGA1mLqWvMiwSvRYu3Krk9vaXG/NdzmsWgaa64HVEkK8+6HLXCgCwP6nZftKqUTK7La6YPjKXy0XJAgV9OQSVbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZIwBjb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZIwBjb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBD6C433C7;
	Tue, 23 Jan 2024 01:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972018;
	bh=O8symqwPI26kRMgGrk8Cib/ZqIXESmzPkj+iSZEzi+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZIwBjb+ZuGCX7hqYq/XqJycGyRzi4EVIsfj2Hg9Zom5MUtQ7QRq1u5gmKhO7IgCj
	 SArAFgLH9Il8m7zOVrLn5K71f8a1H/FtBjMDaZWOWpq3FNNSZsJlC8WA6lTWhR6FQG
	 N985uL3pyLdE0z6cO9hOCMVWf3AmaSxNhNMK/Iq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 390/417] dt-bindings: gpio: xilinx: Fix node address in gpio
Date: Mon, 22 Jan 2024 15:59:18 -0800
Message-ID: <20240122235805.274631091@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit 314c020c4ed3de72b15603eb6892250bc4b51702 ]

Node address doesn't match reg property which is not correct.

Fixes: ba96b2e7974b ("dt-bindings: gpio: gpio-xilinx: Convert Xilinx axi gpio binding to YAML")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml b/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml
index f333ee2288e7..11ae8ec3c739 100644
--- a/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml
+++ b/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml
@@ -126,7 +126,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
-        gpio@e000a000 {
+        gpio@a0020000 {
             compatible = "xlnx,xps-gpio-1.00.a";
             reg = <0xa0020000 0x10000>;
             #gpio-cells = <2>;
-- 
2.43.0



