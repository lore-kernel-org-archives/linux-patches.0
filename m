Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8E419EEAD;
	Thu,  6 Jun 2024 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683555; cv=none; b=I0GqfJ0UftWp2MRqLeoeAWNHLR0CGZEeEe5YqOKHf90jh0VBkDKEgqS1Ijjz53X1ghHlIR8CyE3kFJw328+X0246Mlcgd7xhUaBXh9FvNk8bkCSVdwCEd3q2yJxkh+AfAKCyHjZbXH8YlzVp1l6hmbCOawUGz/80rf3yUUm2r0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683555; c=relaxed/simple;
	bh=4F9vNeEzXms5gBPDNKMuWbsWc6jQsegH3g0b//syX2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E82v7AqtqSfCoaob7mumzF5cUwAFHp9/ctxwzM2tYKSNN9vLMmVE32++4ucrT6X6mnfhgx7+sGsKDNf9bw4DFq8tTgTBuTogVLguuWCOyA6iMIbIJeHOBTh6rDUTib/oO2uW9NK/DSaBuPCh2/dv+igGKnLt0DQdd4GF66PJeck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODUxg74R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODUxg74R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6FEC2BD10;
	Thu,  6 Jun 2024 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683555;
	bh=4F9vNeEzXms5gBPDNKMuWbsWc6jQsegH3g0b//syX2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODUxg74RUn137zSG6Peto5nqCZ0YQTczlQLwQc/QASnFa8or1mhVkCJ14+RdCuhr6
	 1Di9p+nup1GMd84m0+cgSuL/+qDL9AuPti/00k/XPPNbHXKrNxULC0zVcqs7MAltNn
	 /hwJ6jp0Ts4qX8ZRnQmk2zlLBhUQ7txouVqKqs9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 497/744] dt-bindings: spmi: hisilicon,hisi-spmi-controller: fix binding references
Date: Thu,  6 Jun 2024 16:02:49 +0200
Message-ID: <20240606131748.384450114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit c6c1b27f9a9a20ad2db663628fccaed72c6a0f1f ]

Fix up the free text binding references which were not updated when
moving the bindings out of staging and which had a leading current
directory component, respectively.

Fixes: 9bd9e0de1cf5 ("mfd: hi6421-spmi-pmic: move driver from staging")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231130173757.13011-2-johan+linaro@kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240507210809.3479953-3-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/spmi/hisilicon,hisi-spmi-controller.yaml         | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml b/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
index f882903769f95..eee7c8d4cf4a2 100644
--- a/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
+++ b/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
@@ -14,7 +14,7 @@ description: |
   It is a MIPI System Power Management (SPMI) controller.
 
   The PMIC part is provided by
-  ./Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml.
+  Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml.
 
 allOf:
   - $ref: spmi.yaml#
@@ -48,7 +48,7 @@ patternProperties:
       PMIC properties, which are specific to the used SPMI PMIC device(s).
       When used in combination with HiSilicon 6421v600, the properties
       are documented at
-      drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml.
+      Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml
 
 unevaluatedProperties: false
 
-- 
2.43.0



