Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CC13ED3B2;
	Tue, 21 Jul 2026 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661761; cv=none; b=EKfuac26cqFUECwn5aHp8YqIl0a3FRDnMg+xOcGbW+YJ/EV7VIZL8yTJiEkhuuTlxXFTEEF7phNO9yxyu2WWTbUptGeoG+vm21VWzpdSRG6bpBggahTUAEv8eC808fywo2t2cj6nCh5lR9OZVjJJmcAeOS599KzUrZa/PsRveeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661761; c=relaxed/simple;
	bh=Bm+2TTx52TeArQnPHfSx2cgD8345PKvkyOfANzNqgAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcDKHKWhOA3V+3ooSF568yzFlxmhfb8quH7gmExe1dga3cn5NO2oy+eFvoeE7ONexlQD27c1icAVQRPv9ym4DJmkt0vC2W7U5WIQJhwNPBRa6IFlvJJ3bvUEEyzbskpN6KQWLX3cRyVfp52JImxr1ZjjV9bHRziCoypcOK2xTsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0yta49r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0yta49r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3471F000E9;
	Tue, 21 Jul 2026 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661760;
	bh=NwqrRtSS/YCm5yUx3lctpHWDcz9fk5hGes29bfsW+4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0yta49rxM2RtJbRh+c4gsscbSaDPOd+4fMPjoEhpCoe/aaZo3usbo0+zbph8+wvB
	 HDpDiu9JC46+2XO16SrJlx6FrHccntptQfItN/PI03MTj0TsZs+3LGLBdRMBMZZ7MQ
	 Lu9eeNttHR9HM4yvC1ossxadKKvYHxjIsJH5AnQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0135/1276] regulator: dt-bindings: mt6359: Drop regulator-name pattern restrictions
Date: Tue, 21 Jul 2026 17:09:38 +0200
Message-ID: <20260721152449.122987478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit cdc517688ffa2c30a64a20b558a9ecbf046c70f1 ]

The name of the regulator should match what the board design specifies
for the power rail. There should be no limitations on what the name can
be, and they definitely don't always follow the PMIC's own names.

Drop the restrictions on regulator-name.

Fixes: 8771456635d5 ("dt-bindings: regulator: Add document for MT6359 regulator")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20260514091520.2718987-3-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/regulator/mt6359-regulator.yaml  | 43 -------------------
 1 file changed, 43 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/mt6359-regulator.yaml b/Documentation/devicetree/bindings/regulator/mt6359-regulator.yaml
index d6b3b5a5c0b346..5e4b1e74179500 100644
--- a/Documentation/devicetree/bindings/regulator/mt6359-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6359-regulator.yaml
@@ -18,84 +18,41 @@ patternProperties:
   "^buck_v(s1|gpu11|modem|pu|core|s2|pa|proc2|proc1|core_sshub)$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^v(s1|gpu11|modem|pu|core|s2|pa|proc2|proc1|core_sshub)$"
-
     unevaluatedProperties: false
 
   "^ldo_v(ibr|rf12|usb|camio|efuse|xo22)$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^v(ibr|rf12|usb|camio|efuse|xo22)$"
-
     unevaluatedProperties: false
 
   "^ldo_v(rfck|emc|a12|a09|ufs|bbck)$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^v(rfck|emc|a12|a09|ufs|bbck)$"
-
     unevaluatedProperties: false
 
   "^ldo_vcn(18|13|33_1_bt|13_1_wifi|33_2_bt|33_2_wifi)$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^vcn(18|13|33_1_bt|13_1_wifi|33_2_bt|33_2_wifi)$"
-
     unevaluatedProperties: false
 
   "^ldo_vsram_(proc2|others|md|proc1|others_sshub)$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^vsram_(proc2|others|md|proc1|others_sshub)$"
-
     unevaluatedProperties: false
 
   "^ldo_v(fe|bif|io)28$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^v(fe|bif|io)28$"
-
     unevaluatedProperties: false
 
   "^ldo_v(aud|io|aux|rf|m)18$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^v(aud|io|aux|rf|m)18$"
-
     unevaluatedProperties: false
 
   "^ldo_vsim[12]$":
     type: object
     $ref: regulator.yaml#
-
-    properties:
-      regulator-name:
-        pattern: "^vsim[12]$"
-
-    required:
-      - regulator-name
-
     unevaluatedProperties: false
 
 additionalProperties: false
-- 
2.53.0



