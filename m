Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399D51C68A6;
	Wed, 19 Feb 2025 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955170; cv=none; b=sL5Gai6Dkkn9io9bYpSWq3ZFYP8owydL5vHKPvvIzg59tsJTweWCVYYFw1Eh6WgszKKrUOGXq0cTla3wKbB7zoGfXh7dZwWRefCdDe8e8gfTO5xWN4zSu28rLpLRJvKHUkMfH+cFEJ3MiNunDX/FQ+6qEte7nzpDqO2ia6rBWjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955170; c=relaxed/simple;
	bh=mdlD2PbwefOQqok5WiFpWCykHbp6fp+2sOS/gbUdDL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zi76adO59P7YmukDrdQit4OTWBMeA+1ry8Bt9mW4OusDBn2yKBwJewiI/21Hsl589K8YFfoyCRpaHohxE6zmTf0ri9tDpazPNcZaw4ye3TwAyM9vYakzaGbSjxGaE1RSy77l4vyPpOGVyEFb1zbkbwa7nNyQBiMGsiC6Y+yyLxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTcLM93v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTcLM93v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513F3C4CED1;
	Wed, 19 Feb 2025 08:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955169;
	bh=mdlD2PbwefOQqok5WiFpWCykHbp6fp+2sOS/gbUdDL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTcLM93vpcuMnl4B5yT2V2bw5+WBrpVijbjByKj7Azay7GHyW6TsGgJWLGhWtnLIc
	 g3AkkOSigtvB6S1xQL6Ijfl1cagvP7r8Di2LFW/CyvkE2ailMBzYDjMQNmJwS4abH+
	 2eKfuz9E2gE88glIB4/vYRpIgqcbW4Bwlu77ZRIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 154/230] regulator: qcom_smd: Add l2, l5 sub-node to mp5496 regulator
Date: Wed, 19 Feb 2025 09:27:51 +0100
Message-ID: <20250219082607.717480030@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Varadarajan Narayanan <quic_varada@quicinc.com>

commit b0eddc21900fb44f8c5db95710479865e3700fbd upstream.

Adding l2, l5 sub-node entry to mp5496 regulator node.

Cc: stable@vger.kernel.org
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://patch.msgid.link/20250205074657.4142365-2-quic_varada@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml
@@ -22,7 +22,7 @@ description:
   Each sub-node is identified using the node's name, with valid values listed
   for each of the pmics below.
 
-  For mp5496, s1, s2
+  For mp5496, s1, s2, l2, l5
 
   For pm2250, s1, s2, s3, s4, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11,
   l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22


