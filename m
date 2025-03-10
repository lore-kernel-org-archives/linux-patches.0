Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DF922B5AD;
	Mon, 10 Mar 2025 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628818; cv=none; b=jyCAvucvIkPpSTlpurlUqyLMbpuhSnWGSve7QYhfOP9UEAb/PAN8tAQb22STPaU+s74RvfoI88Nw2ZxXeCmxu16+SXoTjzV6QvAqICL8mAH+p8bWn8NO+G3Dd+lnSzMQGrEUNzj7RSR2LMum6cfMNVmFeiBu6VFx7VqUilNobt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628818; c=relaxed/simple;
	bh=GdTuP4FJ03XXuwN7ylf1oUdX4l2V65XF4CR4tLSpmFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQxS1uhZaehSi51Bz3FuXm8FRH5Bcm1Xg8CuMCkEGKX6bMzmr743YLSoWM5SOD7+SFgHYcjPxCDFBFwcluG2a74kxyPOTFzel+aBJ+gUIP2YH0OCqt9tj2cxxtEESNl2BiM53J2X5pnjfxa27Uh40SL8yDwJfEUrlpJ1nrsthg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNXm45Jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNXm45Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D2AC4CEE5;
	Mon, 10 Mar 2025 17:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628818;
	bh=GdTuP4FJ03XXuwN7ylf1oUdX4l2V65XF4CR4tLSpmFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNXm45JzEXDjAQjw/PqO8JxjrNrMXW4GCc2RbSztc+i0no4y6YI8VgIi7u0/j+TGJ
	 n5AJ6kDLuvUs6+S2ugNJERA8UVxC6iWIZGfk3j+OHvRU3kdt6jmc/XK8t5Q1knKgFd
	 ukynF0IhBov/wZ1U6+3OTcO/9Duxx6GfW+GDihcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/620] regulator: dt-bindings: mt6315: Drop regulator-compatible property
Date: Mon, 10 Mar 2025 17:58:14 +0100
Message-ID: <20250310170547.475802441@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 08242719a8af603db54a2a79234a8fe600680105 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the property from the MT6315 regulator binding and its examples.

Fixes: 977fb5b58469 ("regulator: document binding for MT6315 regulator")
Fixes: 6d435a94ba5b ("regulator: mt6315: Enforce regulator-compatible, not name")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20241211052427.4178367-2-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/regulator/mt6315-regulator.yaml     | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
index 37402c370fbbc..eed0b3fa2d82c 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -30,10 +30,6 @@ properties:
         type: object
         $ref: "regulator.yaml#"
 
-        properties:
-          regulator-compatible:
-            pattern: "^vbuck[1-4]$"
-
     additionalProperties: false
 
 required:
@@ -51,7 +47,6 @@ examples:
 
       regulators {
         vbuck1 {
-          regulator-compatible = "vbuck1";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
@@ -59,7 +54,6 @@ examples:
         };
 
         vbuck3 {
-          regulator-compatible = "vbuck3";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-- 
2.39.5



