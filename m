Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB4A223336;
	Thu, 12 Dec 2024 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019417; cv=none; b=PFeBvi+2QTAjcIL6eJFe5ynHe3beqUTjCeDRwXICCKkADPMueMrfG3mheI54Ssmy80vly9wIkvKJMXhrKr71u36sWyLy0Ysd07TWQswSzuHcT8M3WU3v+XFLz2Q1W3SPSm5XnUoPN+qvur6Q9SGkxZbGQNZm1Nli/KjOmA7FbZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019417; c=relaxed/simple;
	bh=TNgmrpqFoHUjGrj80GrXrtSVRelknY3e+qJA9HgD/QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPNqMRI66ewlZkTSBWmhp6CJEzNhw+2ylBV9E8n058Q8wL2/JyU3R6xyWpwUAwGiJXwZbkly41cNYnNkFLoi3zd0u/CiUUlxBgWGkytVwh6Fvj8mY8IK7ZlVZXuPd1QrhwDB7Pz7QM7x5g1E7IRhFsVWOHSbzeGT5nzAiuPptnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2ElUQw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2ElUQw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2263C4CED0;
	Thu, 12 Dec 2024 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019417;
	bh=TNgmrpqFoHUjGrj80GrXrtSVRelknY3e+qJA9HgD/QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2ElUQw5yu+uW4dkriCIcfBq1eGRVr0BTt7lFGuHc+9KuDYKML1kLC/YkDn28YQwa
	 HHg/GCg5uqTyTkSso5Gn7uG/dNURIzGpYM3S0XeRBfJ0CF2mnb15pc7AaDPiNx8kwL
	 pihiZQzSASFafeAkv3tI4vtfSP/d/ofqlYkEBeXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/772] pinctrl: zynqmp: drop excess struct member description
Date: Thu, 12 Dec 2024 15:52:28 +0100
Message-ID: <20241212144358.328398827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 2a85fc7044987d751f27d7f1e4423eebbcecc2c6 ]

The 'node' member has never been part of this structure so drop its
description.

Fixes: 8b242ca700f8 ("pinctrl: Add Xilinx ZynqMP pinctrl driver support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/20241010080432.7781-1-brgl@bgdev.pl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-zynqmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-zynqmp.c b/drivers/pinctrl/pinctrl-zynqmp.c
index c98f35ad89217..5a6be66c1a0b5 100644
--- a/drivers/pinctrl/pinctrl-zynqmp.c
+++ b/drivers/pinctrl/pinctrl-zynqmp.c
@@ -45,7 +45,6 @@
  * @name:	Name of the pin mux function
  * @groups:	List of pin groups for this function
  * @ngroups:	Number of entries in @groups
- * @node:	Firmware node matching with the function
  *
  * This structure holds information about pin control function
  * and function group names supporting that function.
-- 
2.43.0



