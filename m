Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704360;
	b=yhd1XHyFlpCscQ49uNGuoMM4JRi0MgMNdqWndWTp6/PtZpUtkid124udHHSx/BSYx9y9
	 2RMc/dPe17l+2wqN7fH3Ro629Zj+GLYHhbKhUcpWyEqN1WRvovjabQ7MBTOo89ZOHHXpP
	 3vqlnK4xkRw2YnsBjcoYZnkBaCj8tc0xSghMvuauckUzLeanmc9acGWWCyJ4Typ0ZK5fY
	 HLuXVHEKlw5M9x0BTERynw+qEfD/eK05rCz+hpLEbkMcCjHd1pPMAk3d57U9lBtsFUPek
	 D3V5Bm/UrnnUt4m5miT+kFgRtjtK+aBjZFUbiJha8UoCXjqgY7fEn4fsbP7yYsLkUKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XUDhuiwR4D0qqUx9MpUtK0axTFgvCjL+TX1AF7DCqWI=;
	b=rzmFEhuLqUElJNDfQNnly3ZgFwTdEC3Qyd3LzuyZlCixnu6X0zri0DWnu0DJ5XJceTbb
	 4ysCE9FOhAKEEwbrKdgnCTVk+7hP+tDk5cyhgk1XvgNNkoE1SislkjxOTmc+d8a37GJKi
	 R1FNibKeGKDHMEMdxD3wQgrtOdGHyV2CDYOngMJm/v0E7s/wwLtn0iWmXP+jOnxbiLtK+
	 QuReowxaHstz8QbyPkhU/s51kzNuvmd1RoIPOWkDnlyCbnlEB1b1etHSkv8BINGta1Lr3
	 JmGIfeE9eZh6Na1XnRZKlkoVGVdcQalvvomE/fKnOq9cSFjPUfh0CMBtCKOXi4XTgKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgjQ6Tq7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01131606A31E;
	Thu, 26 Nov 2026 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgjQ6Tq7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A8F1F000C4;
	Thu, 26 Nov 2026 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704359;
	bh=XUDhuiwR4D0qqUx9MpUtK0axTFgvCjL+TX1AF7DCqWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgjQ6Tq7NtEFhP5vKwwQJP7sWpBF6+wLXLl11JC6ftXszKp8hc3f1Mp8XANAoMZP5
	 0tAbgagS70NByv7/7j59JqZUmqwOZKrVQ6vE7+HXzSjY5Bf69wCFRdyC6hMvMOYLjf
	 cfkqea30tP2JgQGl/J07bRaaMfBnBP4QhGROT2B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/265] regulator: qcom_spmi: Drop unnecessary of_find_property() call
Date: Thu, 26 Nov 2026 15:36:22 +0100
Message-ID: <20261126143608.753151709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 7540bd3398675e54cbd7324c47be8cd3c7a6d9c5 ]

There's no need to check for presence of "qcom,saw-reg" before parsing
it. If the property doesn't exist, parsing it will return NULL.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20240828130056.3481050-1-robh@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 053c50a70525 ("regulator: qcom_spmi: don't take a sleeping lock in the SAW IPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_spmi-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/qcom_spmi-regulator.c b/drivers/regulator/qcom_spmi-regulator.c
index e62e1d72d9439..47931ce19e439 100644
--- a/drivers/regulator/qcom_spmi-regulator.c
+++ b/drivers/regulator/qcom_spmi-regulator.c
@@ -2129,8 +2129,8 @@ static int qcom_spmi_regulator_probe(struct platform_device *pdev)
 	if (!match)
 		return -ENODEV;
 
-	if (of_find_property(node, "qcom,saw-reg", &lenp)) {
-		syscon = of_parse_phandle(node, "qcom,saw-reg", 0);
+	syscon = of_parse_phandle(node, "qcom,saw-reg", 0);
+	if (syscon) {
 		saw_regmap = syscon_node_to_regmap(syscon);
 		of_node_put(syscon);
 		if (IS_ERR(saw_regmap))
-- 
2.53.0



