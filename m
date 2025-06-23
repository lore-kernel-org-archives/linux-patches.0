Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1B34409;
	Mon, 23 Jun 2025 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714630; cv=none; b=sI8ObN+/zIl+Fdr/RtyKLPU0up9y7uRgZ0M6noTq4NVcRoModN0oaPZb8pbAUhpAPDu0b8sQfscZDdK1yWHZVIDMj0UttWIZLZ100cN2rJ5GDzFRiDSIKtNWzoYi8BylJ/UdeugVal9wRvAEh8PxZnssZrwMQ9cUDcT4OjgcKyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714630; c=relaxed/simple;
	bh=o49fWuuLEQEWuRh8jb7l5r+MWrHFhN/8+0NEAVD+uak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLK/Hxenr6KRztU2+iJ7sqiR890H2CZrkf+PkG6FhujfH+S7u3scL4vFKhFLPlV3iwvgU7e2MI4k7KgYeRfIO90PqDMlrtP+gsh8r4ok4p6iRqE/XnpbngWJz6NsoWjSbp/q6L6aZLClkIN4a8RBFZtC6QX3x6zvWH8EpKlS18c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MM9MmPgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MM9MmPgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7832C4CEEA;
	Mon, 23 Jun 2025 21:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714630;
	bh=o49fWuuLEQEWuRh8jb7l5r+MWrHFhN/8+0NEAVD+uak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MM9MmPgGXt+2ENVUahb1lbIwp1pRWJ+WYtTuiP0BC8MGXf9mi68ZRMy8/rV+fHPd5
	 cYrOtXkVzDqMClAHS/Xql4Q6cL02fTk6e02GsubHJ4LQIOQlCJ75mQ8XPFyqzIAuNN
	 8og4pj2WaELdQoNBEzh2DO2vPb1t9tiRPm8LF9/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/355] ASoC: tegra210_ahub: Add check to of_device_get_match_data()
Date: Mon, 23 Jun 2025 15:07:00 +0200
Message-ID: <20250623130633.326872710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



