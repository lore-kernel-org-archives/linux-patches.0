Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5C7375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301710; cv=none; b=jN1HatNTnOW5gzeLj9J7InaHyh20qFNCLRg+kSAt8onAeKvOBxQsvY9HXy5pgOu9gLyZGcvmbZRsQLrUKcyNTSxW2LhoQ9hyOD7ssF6vcS1cuCNk4EKCoCFimFxVnAoxyWRQXEu9DAETbxyZDQ29AeozBDKfIasbYnPj/8nBSMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301710; c=relaxed/simple;
	bh=fqxRVY6vrQQzP20e2iyICzJz55/ICj+svh+tsKskA88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gcb9SjvAfr7GCeExLPvuDexV8faUb9j5IDZe2GZj1TaWCPz5+jtwXyAtfYWgvu84+QNNv5MOzZOkwO4/CNCBHQ/EorDLWoFWIAXiN1wM5GGcl3BNbS6EhRFYnP9ygdMH6tHmlT8Nnjuw23TXdt6c8B4qCs0JTOe3a60wMJnqGWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyB5+9P4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyB5+9P4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D832C116D0;
	Sat, 28 Feb 2026 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301709;
	bh=fqxRVY6vrQQzP20e2iyICzJz55/ICj+svh+tsKskA88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyB5+9P4D8RKh30LoEw5MPOLnF7fUBNBdLQrMUSKf5+CRc2f1gzcFox97v5AhRFu5
	 5fVDHDbzgSYhdCbbv3qrA7fODpNn6F955bTo0GZ4lBur+ZAN0wVYlGrm/9iOzslHdH
	 6oOFq02t7E2Uz/X7tUVWZIeEIO8OsSg9Hmt91MdHMuP7H3Tg59koqWfQHiiWKYiJ/l
	 erSj3BatSH9vZmC9IUFeDLHRPkr/hD7TYNmF7Ae8qP17Bn7jnuhcnII2FG69e42X9X
	 UEsamqiEK3648jSQm8l9Joyck6KU1mlIM2x7AwqOEU6Cvwhuw7wn7G/JaCa3zR1Y1g
	 8OTQqp6f166Kg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/385] ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property
Date: Sat, 28 Feb 2026 12:55:26 -0500
Message-ID: <20260228180011.1568201-104-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 0b2761eb1287bd9f62367cccf6626eb3107cef6f ]

The P66's device tree includes the reference design dtsi files, which
defines a node and properties for the touchpanel in the common design.
The P66 dts file then overrides all the properties to match its own
design, but as the touchpanel model is different, a different schema
is matched. This other schema uses a different name for the GPIO.

The original submission added the correct GPIO property, but did not
delete the one inherited from the reference design, causing validation
errors.

Explicitly delete the incorrect GPIO property.

Fixes: 2a53aff27236 ("ARM: dts: sun5i: Enable touchscreen on Utoo P66")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251225103616.3203473-4-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts b/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
index be486d28d04fa..428cab5a0e906 100644
--- a/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
+++ b/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
@@ -102,6 +102,7 @@ &touchscreen {
 	/* The P66 uses a different EINT then the reference design */
 	interrupts = <6 9 IRQ_TYPE_EDGE_FALLING>; /* EINT9 (PG9) */
 	/* The icn8318 binding expects wake-gpios instead of power-gpios */
+	/delete-property/ power-gpios;
 	wake-gpios = <&pio 1 3 GPIO_ACTIVE_HIGH>; /* PB3 */
 	touchscreen-size-x = <800>;
 	touchscreen-size-y = <480>;
-- 
2.51.0

