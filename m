Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BED319753A;
	Thu,  6 Jun 2024 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682988; cv=none; b=S3QP48ZEEB+Ej61svmcsF3kVVL6y6Bx9xYd3Nv/O36NRb2Dp/+92q7OFacMwOEjNO8BcZVykixGfu7IXl/Osz9oy86SSNPhShqe4r8AteY7OML2K7UdiB3GCxNSHKvWPT6n76MXG0FsFafs0j9NBWf2H1KXU3cr98GEesfCPSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682988; c=relaxed/simple;
	bh=AGPdF9t7Pl4k1yFdXu9zzWCYFsgc8VsVhiMWzNamwV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ncp4FDw9fZVOqtHkoSp/oMQxKL2AaRhJrSr9X5PwOL+yLtL9Qz645aW4wgGpa4mLsHCq9hC4YGp9SPpIlFtBOTd7zg5ig4wC/5hWUxEsgsrqOWY6GB/QVGWJ/3xaJMp2T5BGNXl8qXvmtoGRcx01houWu51EgfTqZi1q2j5afSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z37eZB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z37eZB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3463C2BD10;
	Thu,  6 Jun 2024 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682987;
	bh=AGPdF9t7Pl4k1yFdXu9zzWCYFsgc8VsVhiMWzNamwV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Z37eZB81NYT7bZf6U6uCDLkKk9YDYFtbkwI3AzKY/5ANcIGFnd2P+3osLcBt+iRR
	 hYVz/7Eo0D5gBhhG7+SjEFr708CvOO7FYy7G/ksJ60uRPsbx7O8hXDCsN93Nc8pGVr
	 fgHOx8efJkKwwhtz2hFZUo0nrv789cz/1VoZthuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 140/374] dt-bindings: PCI: rockchip,rk3399-pcie: Add missing maxItems to ep-gpios
Date: Thu,  6 Jun 2024 16:01:59 +0200
Message-ID: <20240606131656.599880848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 52d06636a4ae4db24ebfe23fae7a525f7e983604 ]

Properties with GPIOs should define number of actual GPIOs, so add
missing maxItems to ep-gpios.  Otherwise multiple GPIOs could be
provided which is not a true hardware description.

Fixes: aa222f9311e1 ("dt-bindings: PCI: Convert Rockchip RK3399 PCIe to DT schema")
Link: https://lore.kernel.org/linux-pci/20240401100058.15749-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml b/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml
index 531008f0b6ac3..002b728cbc718 100644
--- a/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml
@@ -37,6 +37,7 @@ properties:
     description: This property is needed if using 24MHz OSC for RC's PHY.
 
   ep-gpios:
+    maxItems: 1
     description: pre-reset GPIO
 
   vpcie12v-supply:
-- 
2.43.0



