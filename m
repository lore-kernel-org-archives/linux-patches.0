Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDC21519AA;
	Wed,  5 Feb 2025 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764200; cv=none; b=QFcHuu70f7du5ghz3pmADXJFeGFKA97OPN8570RXAxRtOftSEOwGsRjDB0Tx4/X7LzJ0PG+PYGyG2VOiY8141CaS5dhpI3Sq+Fr8LaaQLK0EDUQ1VLP0HsbBV3e85Nz3MWuh9jfeIq5IxQ7rYVHjBHBqKkJDNHNRN0d5Y2hNB9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764200; c=relaxed/simple;
	bh=LyLa5/eWTP52OrtLCMV8ghVJU7mizZNWsgP7S8J0XDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1bsr80+8UW73L+Ktl2sTGkdGugtdc/9UJ/EDIGibwix/5NcNUhRRuN0sXxo8cBW9nTwNF/hJB++UMc9JmiWr+SbuHpOsYFT2HFthuEZDc8GOaHQNGgQgvt3BpUAOCxm8us0WbwVB0OVlwlWAQkzrtbZifcw249P0J89r6BcKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFCImOWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFCImOWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4FDC4CED6;
	Wed,  5 Feb 2025 14:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764200;
	bh=LyLa5/eWTP52OrtLCMV8ghVJU7mizZNWsgP7S8J0XDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFCImOWrGxzNoKEsRzqApQOIdywhRmLW20+J2i7bc/3G8mBR4Yt74qMUo435UIVUS
	 Egk9kySky+57bZyQJCZWl22n91uwILjBUYO//Ko5llHeTEy7YjfmHePG16RCqz1DbV
	 2YO8zGBy4DXI74nLFyfCBZK3G3zUxQsCGQ1jkciA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/590] regulator: dt-bindings: mt6315: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:37:33 +0100
Message-ID: <20250205134459.006920570@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cd4aa27218a1b..fa6743bb269d4 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -35,10 +35,6 @@ properties:
         $ref: regulator.yaml#
         unevaluatedProperties: false
 
-        properties:
-          regulator-compatible:
-            pattern: "^vbuck[1-4]$"
-
     additionalProperties: false
 
 required:
@@ -56,7 +52,6 @@ examples:
 
       regulators {
         vbuck1 {
-          regulator-compatible = "vbuck1";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
@@ -64,7 +59,6 @@ examples:
         };
 
         vbuck3 {
-          regulator-compatible = "vbuck3";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-- 
2.39.5



