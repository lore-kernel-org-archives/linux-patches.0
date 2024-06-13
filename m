Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCDF1292FF;
	Thu, 13 Jun 2024 12:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281698; cv=none; b=P9RLq7T6RvmIPVjekYMIh3bJO69oKs+5mnPsLdHI1TMYd6z0EReLnZFHtJ2/XQGCgRW7dYx8QSbSWY1EKTfbYfWUL24a8oCSSUBP/KJdnmDmFh95+AskXC8QL27R3TqxEVs7kIeRlKGanIlC4xfh+ms/ki6FwSLWhbayuImU0ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281698; c=relaxed/simple;
	bh=osvS01wPxV662ncNyGlTNt+AMwWQmGTlxbdNP+wuhNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw12uYzz5wXkoIB6JNhZP6iJ0QuTeFH+Tx4IhGIgsbok8Pe835al8XxzT45JS6jkNKEiFzlfF00qVIl0HAFBTDTMaclB7qodOwfex2ZGiSP+H01h+dVrzKdhVrPvmcHKo4khYjMxdG80V9q8lXzZkZ3Gw3COIsnQ1331LJ1P79Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csqncOV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csqncOV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3E8C2BBFC;
	Thu, 13 Jun 2024 12:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281698;
	bh=osvS01wPxV662ncNyGlTNt+AMwWQmGTlxbdNP+wuhNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csqncOV8sTkCK24zBH2dDFxp2GhLj4DjN3c42nUM1oDqf4Y1wgcdcN3Wht4otew6+
	 zAiTbGkNOXt079ucG7v4w4uPkwyimeexOh04AgmZT4kid3wa5S5zBYe9AE8AZyLxqW
	 VXmGpfvcO0gj713WFoirykVAKXhn/htcPeLsvRag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Fang <derek.fang@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/402] ASoC: dt-bindings: rt5645: add cbj sleeve gpio property
Date: Thu, 13 Jun 2024 13:29:43 +0200
Message-ID: <20240613113303.160790826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 306b38e3fa727d22454a148a364123709e356600 ]

Add an optional gpio property to control external CBJ circuits
to avoid some electric noise caused by sleeve/ring2 contacts floating.

Signed-off-by: Derek Fang <derek.fang@realtek.com>

Link: https://msgid.link/r/20240408091057.14165-2-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/rt5645.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/rt5645.txt b/Documentation/devicetree/bindings/sound/rt5645.txt
index 41a62fd2ae1ff..c1fa379f5f3ea 100644
--- a/Documentation/devicetree/bindings/sound/rt5645.txt
+++ b/Documentation/devicetree/bindings/sound/rt5645.txt
@@ -20,6 +20,11 @@ Optional properties:
   a GPIO spec for the external headphone detect pin. If jd-mode = 0,
   we will get the JD status by getting the value of hp-detect-gpios.
 
+- cbj-sleeve-gpios:
+  a GPIO spec to control the external combo jack circuit to tie the sleeve/ring2
+  contacts to the ground or floating. It could avoid some electric noise from the
+  active speaker jacks.
+
 - realtek,in2-differential
   Boolean. Indicate MIC2 input are differential, rather than single-ended.
 
@@ -68,6 +73,7 @@ codec: rt5650@1a {
 	compatible = "realtek,rt5650";
 	reg = <0x1a>;
 	hp-detect-gpios = <&gpio 19 0>;
+	cbj-sleeve-gpios = <&gpio 20 0>;
 	interrupt-parent = <&gpio>;
 	interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
 	realtek,dmic-en = "true";
-- 
2.43.0



