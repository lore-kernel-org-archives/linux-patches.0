Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD219049B;
	Mon, 23 Jun 2025 21:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715636; cv=none; b=KQgSZ+gIURxNCJuDTA8LaIdf8+bl2Qz2j3NMl5ocG50EfrXm/Hv7b9u2bvJ0k7fqpoYCLSHBcQMC6xTRg65lSX+llOhZCJEgjuvtwttp1hcneWSE8uvM9/XJn8W+ldqG7j2NfWMroxXlpkFnVproUhvZc0r4u9ioci2IZ0Boo6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715636; c=relaxed/simple;
	bh=dxuNIAZmSmqj/IVMc23MSHv4TIjOAw8PQo88aSPCMxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEcbiREckkHDk/mDc6PKtcgufCA/j6Y1lwrKr6C9IJi1ItkKUdzkmgsjMzfnZwHOLWi64Xpl/k5b2evYMy9kVuGsW/hYwQFvgGWkH8GgPX9kt3JgWJAizsxPeVkCmF8KWzyfXKZtvrNvCFEQpe6as7pPJ8LG1x49FCSQVMcOl70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0Sxh/us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0Sxh/us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2387C4CEEA;
	Mon, 23 Jun 2025 21:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715636;
	bh=dxuNIAZmSmqj/IVMc23MSHv4TIjOAw8PQo88aSPCMxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0Sxh/uskQL2IdoqnthTUD9aRH+PUGa698i3ShjAxnS0/JXMQKFExcfVQBOsDLr+r
	 xmuEXZFYUAUfMj0NgThSxS70olUPzG/NTcf75VR/S1K+y75UvKWdKYxxjREQjOfQYs
	 TqRGbW0WJw+cu6zewXZl10jpdogZGMwgCZ3ggGrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/411] ASoC: tegra210_ahub: Add check to of_device_get_match_data()
Date: Mon, 23 Jun 2025 15:06:53 +0200
Message-ID: <20250623130640.428034033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 04cb269c204398763a620d426cbee43064854000 ]

In tegra_ahub_probe(), check the result of function
of_device_get_match_data(), return an error code in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://patch.msgid.link/20250513123744.3041724-1-ruc_gongyuanjun@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_ahub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index 1b2f7cb8c6adc..686c8ff46ec8a 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -607,6 +607,8 @@ static int tegra_ahub_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ahub->soc_data = of_device_get_match_data(&pdev->dev);
+	if (!ahub->soc_data)
+		return -ENODEV;
 
 	platform_set_drvdata(pdev, ahub);
 
-- 
2.39.5



