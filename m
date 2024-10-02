Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E456FB0;
	Wed,  2 Oct 2024 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880152; cv=none; b=JD8H95wEcbHtqnqSyWKbfduxLXZ2b6WOM8ooLoLIW7+qau/7Jrrc0OHqRAFBkD5bHNFRWl+ddoNPAkxSq2dEASRpJzgwCLKW/uFws11St2H68eM7pfktsAByIuDhUXoAN5wbdH124p3DQTcpDiLRoy5QHo1QISn6P49Ym8Y2rHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880152; c=relaxed/simple;
	bh=ae1wYl5s/4b20LFdbDF8pyw62c115C6RMVuZe2mflNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLICYK++ydiif9iuDsfaPqC4oUJ3gueZOppKtn/3EDxJmMPjbRHheFjkmHIKFioFoZXcUfJqJhaKPKgT4B4IiXuK1gg+3NcyYWyTYM+9ctAZgMfS89E8DTObusIK47eL5C3BTN8fB9MRt36yDnKJwXxIF6URx87KH0AevS6chCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lnp3XUet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lnp3XUet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD27C4CEC2;
	Wed,  2 Oct 2024 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880152;
	bh=ae1wYl5s/4b20LFdbDF8pyw62c115C6RMVuZe2mflNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lnp3XUetFi9KkYqARimXt8IL3g9nMFmRfuZSnLJKoR87vPC+U8kNxiEBSHfmTlgwO
	 TMDSsiNLfHf0d7D7S7URZ8GAGHq2vDwDrIJutMm1QoqS0IQ2WnKCyk4+GBYpofrvMm
	 pFiAU9J3JFMFbFdYC6yOZ+dLM9Ye0/q40/ZGriQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 360/538] dt-bindings: iio: asahi-kasei,ak8975: drop incorrect AK09116 compatible
Date: Wed,  2 Oct 2024 14:59:59 +0200
Message-ID: <20241002125806.637036825@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c7668ac67bc21aebdd8e2d7f839bfffba31b7713 ]

All compatibles in this binding without prefixes were deprecated, so
adding a new deprecated one after some time is not allowed, because it
defies the core logic of deprecating things.

Drop the AK09916 vendorless compatible.

Fixes: 76e28aa97fa0 ("iio: magnetometer: ak8975: add AK09116 support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20240806053016.6401-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
index 9790f75fc669e..fe5145d3b73cf 100644
--- a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
+++ b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
@@ -23,7 +23,6 @@ properties:
           - ak8963
           - ak09911
           - ak09912
-          - ak09916
         deprecated: true
 
   reg:
-- 
2.43.0



