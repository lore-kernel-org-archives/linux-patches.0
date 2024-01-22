Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DBA2114;
	Tue, 23 Jan 2024 02:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975791; cv=none; b=cqSC/tqzfaVaf+J2zv/DdAky1g229dOeiBSZiUk+DcUSsjg5jEsRmP6dUFKGP4s+0Nras1+Zu4Bky2pVqLJppT8Q/41eoAV/avqTKrSG2Q/WhGpn4NCiTt0AhiH6TO+WwbD7L9l0te7EbaB/mH5LwPDTlMp7i2sS8rsCtGNxHEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975791; c=relaxed/simple;
	bh=M25ZV1IEkHuK05dUZPGq5hFFubISw+1JmO+TYsoKFgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rmtlal15LTcY1hqBDh8O5hyhvaZejhOWZxq8uLxRtai9ecOY8xEAa+jGVRjb1ofG1JbD9hrT4628B3Vt3PLGQgGpSnQ6IrxRQnWAlm8Q8KXMT9n0CzEt5xUcmfL+Xa9z7MIlgoQdKsOaipdm+wxeqliHGyXKbDvAif3wVzpuAVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtrCW9Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtrCW9Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC837C43390;
	Tue, 23 Jan 2024 02:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975791;
	bh=M25ZV1IEkHuK05dUZPGq5hFFubISw+1JmO+TYsoKFgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtrCW9Pnz1tRkKh1sex0k1f8pF6zEmDe2PhVI++e9VU6YT9UEExeQoyNV+6bZMpRj
	 H0I4LNE29MQAmY8lALPY5hse/+TW2fbLTlRZF+8Eh/i5OcDO1G9piK9kaq2fz3bb0a
	 RLvyLEnIwRn+5MsWngrJ9++u/5gNqTCcaYBU0SzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 548/583] dt-bindings: gpio: xilinx: Fix node address in gpio
Date: Mon, 22 Jan 2024 15:59:59 -0800
Message-ID: <20240122235828.916579872@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c1060e5fcef3..d3d8a2e143ed 100644
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



