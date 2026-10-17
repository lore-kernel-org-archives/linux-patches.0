Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0617E3B19BF;
	Sat, 17 Oct 2026 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255626; cv=none; b=mHEP9gxNvpQqISPD/K/ApxxBSXs0TNmVvX8HP75J2dwirI9BWU44oGkDBwBXeY2Pz48f5EaAWjhRwWkUpSTmZOpLpS2IRT0Zx42MwnmG+IMdWzmcTxIzuSuDYN+LhueBJ/LJwSsW25aVzihlgk9iwkyt2sK0F6C0lAfFMlmPLLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255626; c=relaxed/simple;
	bh=JR5AbzSUI8tYveRj0Rw/DuOQ8QC4zntKsfXOitxPB8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hq3wHgr2Ap72f5QdZyH1p7u21ga+QKNBL6eWIjOqSayhbjU8P2Lcci8uBqbXeUZIHQcyPpZA/VvMNyKvRYdvomDMRvfEu/dM2l5RwRSTxSNMei4KWnPRJy0rEWRTh8hjUeYVWt5I+fQl/4+y487tyCaNUOU38fnbOXOQL61tEAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ci7E/7AA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ci7E/7AA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABCB1F000C4;
	Sat, 17 Oct 2026 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255625;
	bh=Ot3ZoIc1YkJWXiK94SeFKhHam50qu/mTvfKpewmWD5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ci7E/7AACyJv+/VORSYPgNIiX8bxIqE0GavL3X+YgMkYZe5IJknDISPu1f8ypj57Z
	 45vdTnbGL4IPoi6fm9sD/0RoE/Tg+48/MkYjWBTd64EEMJ0z0nQSdYMadGAXocGZeG
	 yHFiHUbFGp1Nw22xSa+GlQwHlQBdS6hwCIHCZhSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 836/869] soc/tegra: pmc: Add kerneldoc for wake-up variables
Date: Sat, 17 Oct 2026 18:01:17 +0200
Message-ID: <20261017160058.309229869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit e6ad1988e56834d641ba4aa0d58970723c1c9c9b ]

Commit e6d96073af68 ("soc/tegra: pmc: Fix unsafe generic_handle_irq()
call") added the variables 'wake_work' and 'wake_status' to the
'tegra_pmc' structure but did not add the associated kerneldoc for these
new variables. Add the kerneldoc for these variables.

Fixes: e6d96073af68 ("soc/tegra: pmc: Fix unsafe generic_handle_irq() call")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index 40d6ee8c3988c..806167724b26d 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -425,6 +425,8 @@ struct tegra_pmc_soc {
  * @wake_cntrl_level_map: Bitmap to hold wake levels to be programmed in
  *     cntrl register associated with each wake during system suspend.
  * @syscore: syscore suspend/resume callbacks
+ * @wake_work: IRQ work handler for processing wake-up events.
+ * @wake_status: Status of wake-up events.
  */
 struct tegra_pmc {
 	struct device *dev;
-- 
2.53.0



