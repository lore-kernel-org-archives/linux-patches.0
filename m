Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF661170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1BCC433C7;
	Mon, 11 Sep 2023 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442285;
	bh=LMkiRUUil1P/KMCcXLSFPV4rcsJQQo00cFdBVp5nyT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2QvvLtxfWR51utuRP9N49UnVY8E6g8e7AZlE3t1Zm21igiYu6I5g1x0xeI7G0SHs
	 0W3mQShjWdea0BuVOmjbwiLdFtsjgBUEzulUK94TiX/NgD4Vjkb2Nviw8uNIrJLBfq
	 yGU6sn+Jv0wL6N/0qGF12x+Zi9vgzZMKx/b7Y+SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 712/739] regulator: dt-bindings: qcom,rpm: fix pattern for children
Date: Mon, 11 Sep 2023 15:48:31 +0200
Message-ID: <20230911134710.968079899@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 75d9bf03e2fa38242b35e941ce7c7cdabe479961 upstream.

The "or" (|) in regular expression must be within parentheses,
otherwise it is not really an "or" and it matches supplies:

  qcom-apq8060-dragonboard.dtb: regulators-1: vdd_ncp-supply: [[34]] is not of type 'object'

Fixes: fde0e25b71a9 ("dt-bindings: regulators: convert non-smd RPM Regulators bindings to dt-schema")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230725164047.368892-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/regulator/qcom,rpm-regulator.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/regulator/qcom,rpm-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/qcom,rpm-regulator.yaml
@@ -49,7 +49,7 @@ patternProperties:
   ".*-supply$":
     description: Input supply phandle(s) for this node
 
-  "^((s|l|lvs)[0-9]*)|(s[1-2][a-b])|(ncp)|(mvs)|(usb-switch)|(hdmi-switch)$":
+  "^((s|l|lvs)[0-9]*|s[1-2][a-b]|ncp|mvs|usb-switch|hdmi-switch)$":
     description: List of regulators and its properties
     $ref: regulator.yaml#
     unevaluatedProperties: false


