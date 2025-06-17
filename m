Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF952DFF09;
	Tue, 17 Jun 2025 16:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178426; cv=none; b=F8oZQGcEYR1KVaqYFrHH2GuE7ar86WhNNcj/dmHd6cvIVqL3F95qWJtnh43/G4te56RyFJ85lEGDKNx8KH74q2qh8z86colHHTG7Y5A+k7wV8AWdSUCoLYXwOMyIpdJTcOMaVHVjlVbkuUCaiIvq1j2DowgUVxmSnVvgonI2VMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178426; c=relaxed/simple;
	bh=wLFWEGi+evbzrvC6yk2M8ZxgK1GVCMXoUh6S6ZSl8mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vi5cvP7IhIkJPVobwcVoUnLaKyrimFR3MdkSPSybfQDKMiZZG1njdOcmMuvm5r1SCExjjdFilVWVky8qwQAh7EYeHCwfvDReG63Uuwta6IbyF7nGQB5b5xCTgHNEDy9YKnu0J7RTaZWGJY5/ciHqypsXF5G4b+PX6R7otlcLDUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3anGPDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3anGPDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F52C4CEE3;
	Tue, 17 Jun 2025 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178426;
	bh=wLFWEGi+evbzrvC6yk2M8ZxgK1GVCMXoUh6S6ZSl8mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3anGPDjFS8ijQFBMbu0cCD2Dq3NOvgne0Lhv/4YF8ngusm3sBaX6iVZvV8KKgSan
	 BH03+zlU5U9g8/5bB+mcINbcd5r70lIkLIuomD4jeJtTfedBIXyfp4bM8IvuxmfJJC
	 x0JUEqbZLFuEiwa1SkJNgE4OIACYX4Pqw4Br4RCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 458/780] mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()
Date: Tue, 17 Jun 2025 17:22:46 +0200
Message-ID: <20250617152510.130630897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b70b84556eeca5262d290e8619fe0af5b7664a52 ]

exynos_lpass_disable() is called twice in the remove function. Remove
one of these calls.

Fixes: 90f447170c6f ("mfd: exynos-lpass: Add runtime PM support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/74d69e8de10308c9855db6d54155a3de4b11abfd.1745247209.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/exynos-lpass.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/exynos-lpass.c b/drivers/mfd/exynos-lpass.c
index 6b95927e99be7..a2785ceea8bfc 100644
--- a/drivers/mfd/exynos-lpass.c
+++ b/drivers/mfd/exynos-lpass.c
@@ -141,7 +141,6 @@ static void exynos_lpass_remove(struct platform_device *pdev)
 {
 	struct exynos_lpass *lpass = platform_get_drvdata(pdev);
 
-	exynos_lpass_disable(lpass);
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		exynos_lpass_disable(lpass);
-- 
2.39.5



