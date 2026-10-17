Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DC2394470;
	Sat, 17 Oct 2026 16:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255624; cv=none; b=W86HJsFaGK1rBnwiigtrTwidhnSGHse0tPllSIdUZRAo5WKU/jT8BgJwBMFAFAobTnPIapo5nyrkDE0QfoSrELsB48HCZ18U7PAV7GLv8xd10UU8o7COQnUcTurbgcNvJ7Wq+oCOsKJwutZkPRbPWCwoUiRnTeurFKKR7QJ+Y/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255624; c=relaxed/simple;
	bh=330H0MkyyLacMC75BlCxKsqwnZnwc7LLZW1wHKjny6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPj9V9v60CsX9znoMwv1vNCSRbVwzwJby/txd72lxzcyeZ7CbE3GyWRHSxfUhu607P3i4kv2MWJxYu8MuT+Q16OLLh30JyOvmlYHhN/nynfM40z92iKhZMS19hRXglMuojk1D1qbbdSL5iAW98AEmqIfYS1cj1nb3WYrBY6yQQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVUmWqMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVUmWqMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CF71F000C4;
	Sat, 17 Oct 2026 16:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255623;
	bh=27Wp78mieI3WRxBTIkTbDDtOo9fDedznzR+V8lD8DJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVUmWqMhtOHoZJ7yVWo1pFwCF+3fH2j6WnhdG3aP0OMDzl/UvQZT2Csbybc7PNdpV
	 SQQY6vBwO7J/TTxLehOZxgYNHi5Bo9k34GHUNdBtzQqfev7iybFaVVnzHHNK5GS+ZV
	 oOY8H68nw4+7YiBRG7YAeezqAs35K7AyCmJVgErY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 835/869] soc/tegra: pmc: Document tegra_pmc.syscore field
Date: Sat, 17 Oct 2026 18:01:16 +0200
Message-ID: <20261017160058.284321882@linuxfoundation.org>
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

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit aaca2e9933a362bcd89ec563b3e89de18460335f ]

This eliminates a warning from the documentation build targets.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: e6ad1988e568 ("soc/tegra: pmc: Add kerneldoc for wake-up variables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index 0cca72e18437d..40d6ee8c3988c 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -424,6 +424,7 @@ struct tegra_pmc_soc {
  * @wake_sw_status_map: Bitmap to hold raw status of wakes without mask
  * @wake_cntrl_level_map: Bitmap to hold wake levels to be programmed in
  *     cntrl register associated with each wake during system suspend.
+ * @syscore: syscore suspend/resume callbacks
  */
 struct tegra_pmc {
 	struct device *dev;
-- 
2.53.0



