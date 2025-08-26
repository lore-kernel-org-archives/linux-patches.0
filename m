Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DE12BEFF0;
	Tue, 26 Aug 2025 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207214; cv=none; b=WBAI2x24c0JQYwqER7JutrI7USQmYr4Q8iYg/4Lk1VQtSmZH2tOLeOXqHz8levrAEGdyS3fWrGiRJgpYBecsdv1Zhg5uKoYp9Wz+zXHH7rYt9ezaDRZiTi7Dji8mkuEzPum9z16UwtRrVD6NElsObFtyVBFFOL0zRQ38MWWUxRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207214; c=relaxed/simple;
	bh=mSw3gSa1AzCnPnC3h/qhZvjbN+rLJ8a1MkX/9GIRTwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQWODqAQEhFYPPSnxK8z45qMSEoqcf68FD5KwhMz14ghZirz5M030iyWiOYmNf4mvN+Tdj8i5VO2kgXl16g9t7E8/p91oTWsgHL2r5DcboPX8W9n5LFXHsMFemyuXqGI1u7yD2ghp6m23VGJMi30UN6B9lbxHNzXRoR7m0W5SX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkpWnqGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkpWnqGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0ECC4CEF1;
	Tue, 26 Aug 2025 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207214;
	bh=mSw3gSa1AzCnPnC3h/qhZvjbN+rLJ8a1MkX/9GIRTwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkpWnqGJnFdxw41qsLlnF1EHBTgtKqpq0f9S0YlkRwyLwnb/W5nGH3zmLjtP/LKtn
	 qUPYskzT+eOpQEn0V6hpAnCYBAoSe4GX94PKmhN0lls9uRv6tWqy90WbPiWvlr/VAP
	 mec5yZ6U74zOfh1AfjgnYZ3AX5ABOnELypC8xICA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.16 095/457] mfd: mt6397: Do not use generic name for keypad sub-devices
Date: Tue, 26 Aug 2025 13:06:19 +0200
Message-ID: <20250826110939.725782152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 92ab1e41569416c639643cd75eea2379190a65f2 upstream.

Do not use "mtk-pmic-keys" when creating sub-device for the keypad to
make sure the keypad driver will only bind to the sub-device if it has
support for the variant/has matching compatible.

Cc: stable@vger.kernel.org
Fixes: 6e31bb8d3a63 ("mfd: mt6397: Add initial support for MT6328")
Fixes: de58cee8c6b8 ("mfd: mt6397-core: Add MT6357 PMIC support")
Fixes: 4a901e305011 ("mfd: mt6397-core: Add resources for PMIC keys for MT6359")
Reported-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com> # on
Link: https://lore.kernel.org/r/r4k3pgd3ew3ypne7ernxuzwgniiyvzosbce4cfajbcu7equblt@yato35tjb3lw
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/mt6397-core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/mfd/mt6397-core.c
+++ b/drivers/mfd/mt6397-core.c
@@ -136,7 +136,7 @@ static const struct mfd_cell mt6323_devs
 		.name = "mt6323-led",
 		.of_compatible = "mediatek,mt6323-led"
 	}, {
-		.name = "mtk-pmic-keys",
+		.name = "mt6323-keys",
 		.num_resources = ARRAY_SIZE(mt6323_keys_resources),
 		.resources = mt6323_keys_resources,
 		.of_compatible = "mediatek,mt6323-keys"
@@ -153,7 +153,7 @@ static const struct mfd_cell mt6328_devs
 		.name = "mt6328-regulator",
 		.of_compatible = "mediatek,mt6328-regulator"
 	}, {
-		.name = "mtk-pmic-keys",
+		.name = "mt6328-keys",
 		.num_resources = ARRAY_SIZE(mt6328_keys_resources),
 		.resources = mt6328_keys_resources,
 		.of_compatible = "mediatek,mt6328-keys"
@@ -175,7 +175,7 @@ static const struct mfd_cell mt6357_devs
 		.name = "mt6357-sound",
 		.of_compatible = "mediatek,mt6357-sound"
 	}, {
-		.name = "mtk-pmic-keys",
+		.name = "mt6357-keys",
 		.num_resources = ARRAY_SIZE(mt6357_keys_resources),
 		.resources = mt6357_keys_resources,
 		.of_compatible = "mediatek,mt6357-keys"
@@ -196,7 +196,7 @@ static const struct mfd_cell mt6331_mt63
 		.name = "mt6332-regulator",
 		.of_compatible = "mediatek,mt6332-regulator"
 	}, {
-		.name = "mtk-pmic-keys",
+		.name = "mt6331-keys",
 		.num_resources = ARRAY_SIZE(mt6331_keys_resources),
 		.resources = mt6331_keys_resources,
 		.of_compatible = "mediatek,mt6331-keys"
@@ -240,7 +240,7 @@ static const struct mfd_cell mt6359_devs
 	},
 	{ .name = "mt6359-sound", },
 	{
-		.name = "mtk-pmic-keys",
+		.name = "mt6359-keys",
 		.num_resources = ARRAY_SIZE(mt6359_keys_resources),
 		.resources = mt6359_keys_resources,
 		.of_compatible = "mediatek,mt6359-keys"
@@ -272,7 +272,7 @@ static const struct mfd_cell mt6397_devs
 		.name = "mt6397-pinctrl",
 		.of_compatible = "mediatek,mt6397-pinctrl",
 	}, {
-		.name = "mtk-pmic-keys",
+		.name = "mt6397-keys",
 		.num_resources = ARRAY_SIZE(mt6397_keys_resources),
 		.resources = mt6397_keys_resources,
 		.of_compatible = "mediatek,mt6397-keys"


