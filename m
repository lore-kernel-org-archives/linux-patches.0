Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E2B1CAA95;
	Wed, 19 Feb 2025 09:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956072; cv=none; b=Me17gV/jC4vg3rHCvxHHQ41lbCj1OY8RVM1q6wxlVqp7E6GEDRPSE4eUJKGVEe68vEjZUEe5NXCakxfV22bS7xsZCHLS6hiu+ul7/vv+u2Oq3CvlzVxVOzsLgZ8GkzXTyfQlhUsTP5El2Z4SJ0WZGZbSHcHP1xXVuRUZJ1tkRug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956072; c=relaxed/simple;
	bh=H5+spaTVQFN1M8K+6KVRjp63M82RNWLUfwvTA77fOLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os9OIE0FBHu9bYP+Jg9zF/DBDNCkfVBJKEcgNqtYAApy7luubL6Wh/CifcnFuF9CezA6B/B68PL4jxqNhP17/5ueBTNozvbYWTI9vhKtEDrWYIlhrsvXPWqLL4uOUoRQo/JE+QXusMY/cXQW3/mBhAQYXL50hoDRpCYxzPMPjaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSr++9A0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSr++9A0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AAFC4CED1;
	Wed, 19 Feb 2025 09:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956072;
	bh=H5+spaTVQFN1M8K+6KVRjp63M82RNWLUfwvTA77fOLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSr++9A0kGITjTKyJZkFJxNC0v6lxBz21g/G3wsnQNvso5mDdJmpvQvqxRVbRi/RY
	 ZIbugWSrb+Ogu1S646cIhkzigu+ZgdzPKmpFPKyHqviEz/CbAMS1wRNg3NlW5s5XEZ
	 ryTSq2SVAwXurc4Y+qaSKfjdCJiRcnpY/61r0UwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/578] regulator: dt-bindings: mt6315: Drop regulator-compatible property
Date: Wed, 19 Feb 2025 09:20:59 +0100
Message-ID: <20250219082655.055751524@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index 364b58730be2b..796c09f24f3e6 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -31,10 +31,6 @@ properties:
         $ref: "regulator.yaml#"
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



