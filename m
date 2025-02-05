Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ACA142E86;
	Wed,  5 Feb 2025 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763479; cv=none; b=XQbfKRNzTeMeANTLytJeOl3hFdiPmh5Viqo4SVhPTUVJEUV4H6505BrSx0vKCvz3gPLtmP13zDgLoGSrDqXvVpv7Re7i4mMWcC3WkGHLc64q8HO1mXkGuje6tgeQI5fs9ZngvrcMw+jw/4lsYuw9028SwRuZlo+2dhy2y/adEOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763479; c=relaxed/simple;
	bh=U2VnthXZIF7GNaG68BFIwDfT8iu1t34r7ITUdAC7mqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbN4uwx7EeuuGgwjtBe+ArVJxQFd8KDqHgZ4APvnW4buqb1FwsTpvNBpfNm5WxPWPmBR9N+d6jJWLKxzBvALK3D5oo4rN4k3oOploG7qyEKMNfMmZd4NnZMncLYYIRVx0/4OT9lfgX3KueExoj5ikrdjVVGcDi4A4mobOd/4GQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPaxcPSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPaxcPSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF280C4CED1;
	Wed,  5 Feb 2025 13:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763479;
	bh=U2VnthXZIF7GNaG68BFIwDfT8iu1t34r7ITUdAC7mqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPaxcPSn/fc5lSLGP07bhU3J47QKeg4mElAA8AM2VPEM9lKnvRLASrJ6IuxUr7dbO
	 6NdmygdS0/n+JGsC4vXQZSPpiVt4FAoQim6M+wTkkdHXumXjKYbYwnAKJU553vbQx4
	 wcT9fcucSuHHUSi0BnrD/7gAQ6kDDxVlAIPqdD0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/393] regulator: dt-bindings: mt6315: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:39:50 +0100
Message-ID: <20250205134423.009498840@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6317daf76d1fb..2bed57a347827 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -31,10 +31,6 @@ properties:
         $ref: regulator.yaml#
         unevaluatedProperties: false
 
-        properties:
-          regulator-compatible:
-            pattern: "^vbuck[1-4]$"
-
     additionalProperties: false
 
 required:
@@ -52,7 +48,6 @@ examples:
 
       regulators {
         vbuck1 {
-          regulator-compatible = "vbuck1";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
@@ -60,7 +55,6 @@ examples:
         };
 
         vbuck3 {
-          regulator-compatible = "vbuck3";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-- 
2.39.5



