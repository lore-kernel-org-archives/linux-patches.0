Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9A33DBA1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOXhtszj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC9BC433C7;
	Wed, 15 Nov 2023 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078364;
	bh=lktR4Azq16bUmOIYoiPzoAoZRZ7JCaTp3teotlPvpGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOXhtszjvEBnUsqBs5qj1iL9haW7Ni3H/+V10C+mRGwjcKzOpzhsBcfZy3WvmNV0g
	 D+04RNEYIHb1dpPEgqZEAca31Vk0s5OYJIRyBKgmE3Gcp1o+iS80TFz0rNfiv4h6G6
	 dTcgaORhOR3h8rZqTGU2j6ZcDYQaN7REwgkyeSCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fparent@baylibre.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Rob Herring <robh@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/379] dt-bindings: mfd: mt6397: Add binding for MT6357
Date: Wed, 15 Nov 2023 14:25:18 -0500
Message-ID: <20231115192659.506746374@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit 118ee241c423636c03527eada8f672301514751e ]

Add binding documentation for the MT6357 PMIC.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
Signed-off-by: Alexandre Mergnat <amergnat@baylibre.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221005-mt6357-support-v3-1-7e0bd7c315b2@baylibre.com
Stable-dep-of: 61fdd1f1d2c1 ("dt-bindings: mfd: mt6397: Split out compatible for MediaTek MT6366 PMIC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mfd/mt6397.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/mt6397.txt b/Documentation/devicetree/bindings/mfd/mt6397.txt
index 0088442efca1a..518986c44880f 100644
--- a/Documentation/devicetree/bindings/mfd/mt6397.txt
+++ b/Documentation/devicetree/bindings/mfd/mt6397.txt
@@ -21,6 +21,7 @@ Required properties:
 compatible:
 	"mediatek,mt6323" for PMIC MT6323
 	"mediatek,mt6331" for PMIC MT6331 and MT6332
+	"mediatek,mt6357" for PMIC MT6357
 	"mediatek,mt6358" for PMIC MT6358 and MT6366
 	"mediatek,mt6359" for PMIC MT6359
 	"mediatek,mt6397" for PMIC MT6397
-- 
2.42.0



