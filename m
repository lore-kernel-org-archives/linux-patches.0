Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DB8191F66;
	Mon, 22 Sep 2025 19:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569609; cv=none; b=dNLj5uXMjMP+USRIPChgfvwygyg/8zWipu26dWRhSpyG8JKCIXECJjLtF9Aq9HGpipvmgWvvXnemkGeg25X1XIdHSB17Xd8aWNxnMKpS0uy1ePQGheGGJ82SMR2NcHvn69wOKc6DnznhqsJYDp39PWP9VdI+2Enwd0BfWrURa2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569609; c=relaxed/simple;
	bh=z5Mzoh4EpHT7qupwkRlPNieNmHF/ForOSviCfDCz9Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/wbCaf0rkwqZpEdaGk/4+X24tEUK0LEfFIlzMV2CTG5eUa31QQ0RKah869220sZs5BISpc8c+yzw6gABeD6dF5tpG2eRNWzGsLkSYTPYZNwAIKEyUuqMUtsULJ4odf0k1Q4RA1zzmg3rqjTDkzmb8Lf+DGQVwsg6k+Wx5NcT0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciBLcIo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciBLcIo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BE5C4CEF0;
	Mon, 22 Sep 2025 19:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569608;
	bh=z5Mzoh4EpHT7qupwkRlPNieNmHF/ForOSviCfDCz9Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciBLcIo1+ZLiO9NAETHDnJwN25v1kTs0y8GN2pe5S3bHKrx1WiHjuMIgUrjyT3IhN
	 6kIsOhYro1zAi9nQ3le0uwgsen0w7kNF3t/0FTPEYY6Bxqo6qd1NVaflLZF04+GPGC
	 IHHDFRqF1j8wlEiZhgL9vAMjy0vsOKNCyF3i+1Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/61] phy: broadcom: ns-usb3: fix Wvoid-pointer-to-enum-cast warning
Date: Mon, 22 Sep 2025 21:29:41 +0200
Message-ID: <20250922192404.927856381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit bd6e74a2f0a0c76dda8e44d26f9b91a797586c3b ]

'family' is an enum, thus cast of pointer on 64-bit compile test with
W=1 causes:

  drivers/phy/broadcom/phy-bcm-ns-usb3.c:209:17: error: cast to smaller integer type 'enum bcm_ns_family' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230810111958.205705-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 64961557efa1 ("phy: ti: omap-usb2: fix device leak at unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-bcm-ns-usb3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/broadcom/phy-bcm-ns-usb3.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
@@ -206,7 +206,7 @@ static int bcm_ns_usb3_mdio_probe(struct
 	of_id = of_match_device(bcm_ns_usb3_id_table, dev);
 	if (!of_id)
 		return -EINVAL;
-	usb3->family = (enum bcm_ns_family)of_id->data;
+	usb3->family = (uintptr_t)of_id->data;
 
 	syscon_np = of_parse_phandle(dev->of_node, "usb3-dmp-syscon", 0);
 	err = of_address_to_resource(syscon_np, 0, &res);


