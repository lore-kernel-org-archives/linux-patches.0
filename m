Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A23F889E;
	Wed, 20 May 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296088; cv=none; b=lxatvwfN0mqIvgGmxj2jLc9HpcjZ0CwoFG1BvtFTM0bn9MZH65TBjiAYpttaIpnvOz4geykEBbdd2SwV9mhTgl3Tufp17h9eEp6zN7otP207LTWq9dT9gKoWsvviyKkPpS/2TleMBsVKPhVGbeuBgQN6KeEZvJHlbxe7ZeX9BLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296088; c=relaxed/simple;
	bh=HUJsB7W4GlDX05byxb4Qm5Zsn8m1PfA8MLoKo1taScQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXoYA+2+OpYkb1ayCMzjlwpCN5nI6TAo8/vkulJd/C//nq4fR7eI/q5naNky5P22x8DFmEjYhAB1iTQzuVQd1pg9/1rDdJ/K4Te3e0C7Bn3SGNrZDJ0Vht5UDxzUVqLjS3AX5fmPLmHN3aazWCcMDbZX8Ey4Ltjwno+b6baFhbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRTrLFcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRTrLFcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6511F000E9;
	Wed, 20 May 2026 16:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296086;
	bh=pMIkQdkOR+XDKps/aQ6bEhE3vSxOnu8HmvcPah7pvqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRTrLFcAIvuoBqiO8KevG+hXV6AxGyJcFlkMEcgCez8Pe4qjGB1L97H9ypEtNgg9i
	 DaV+iDksEo+N0ckngz5fxILoanF7WmCpUU2+z1arlFGp0kesB+UgmMeyCQGuKzv0T6
	 xXgUp4FJUj6ICTA7/UoCY2GvkPWSCJczoyzkd53w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0666/1146] leds: lgm-sso: Remove duplicate assignments for priv->mmap
Date: Wed, 20 May 2026 18:15:16 +0200
Message-ID: <20260520162203.261429942@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 7186d0330c3f3e86de577687a82f4ebd96dcb5ac ]

Remove duplicate assignment of priv->mmap in intel_sso_led_probe().

Fixes: fba8a6f2263b ("leds: lgm-sso: Fix clock handling")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260226033048.3715915-1-nichen@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/leds-lgm-sso.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index 8923d2df47049..3d9ef9a54805c 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -808,8 +808,6 @@ static int intel_sso_led_probe(struct platform_device *pdev)
 
 	priv->fpid_clkrate = clk_get_rate(priv->clocks[1].clk);
 
-	priv->mmap = syscon_node_to_regmap(dev->of_node);
-
 	priv->mmap = syscon_node_to_regmap(dev->of_node);
 	if (IS_ERR(priv->mmap)) {
 		dev_err(dev, "Failed to map iomem!\n");
-- 
2.53.0



