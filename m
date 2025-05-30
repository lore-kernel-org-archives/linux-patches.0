Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF5F268696;
	Fri, 30 May 2025 12:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608868; cv=none; b=iXYxSSVlJ48cYgW+yo1QvFDDbKEZAJuVoItTzbp3jRXmh0pxyL6Zy1+Q2yrcq2PgpQXQT4e009HHs20rdIxT8LvV7C7qNajbeF3NkJ+eeZpOK6vJ5Nih+tfukT9PqOL8tf5rKe6aeDrGEPqpT35hArTPbevx+t+z0T6UKnoITNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608868; c=relaxed/simple;
	bh=Yizfy1XHJ4W+SiEGnJstdQkQ/isGgjlfcQVKxgOkasE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzhdUVGQt5rUc18q9PqS3o24baaxTDGaWKusXiV2HwlBgZ6UXYqLtnz2GUe55VPdRGEJ1zIxoNG7BCONFSHvqG0hlFKxBpDKTa4A+YZ1T70top+Ax2errKnFaV0JH/JkV3aFiABA7fopaAVjNlhZoQEBd6BzvcI3+J5wvyXjcHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0XRL3c9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0XRL3c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41C3C4CEEB;
	Fri, 30 May 2025 12:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608868;
	bh=Yizfy1XHJ4W+SiEGnJstdQkQ/isGgjlfcQVKxgOkasE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0XRL3c9B4orkjyAWaUtCTYn1vEBJFgEmoBcizlUfCMZIeg6e9NCETIHJS46kfgXb
	 Fadz10yIHy88F5TPcRfCrGV2DCSkEVbm+zzntIi5GmpYsFOY+NX+cdN20+VYjgxRbU
	 mcLwxclHb3/0mgflkULHxz7zNvA8Vuhwqx6H3b7FqHkGW3krRQTva6LkvT1UbS4rl3
	 mfDTpqrjB8iJvoj17h1ObAdQCXCfY9dxF6PJiQntyVRKRj3T6ryf/J727cH0oL4eo4
	 +FM0JuScCQYUxR8JvCaubAu95ynQnrLePVUzWxJJ6PgxNYUE2oabfv3JkM1xAHu2rJ
	 OAQgc1zBv73Mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	alsa-devel@alsa-project.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 15/18] ASoC: tegra210_ahub: Add check to of_device_get_match_data()
Date: Fri, 30 May 2025 08:40:44 -0400
Message-Id: <20250530124047.2575954-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124047.2575954-1-sashal@kernel.org>
References: <20250530124047.2575954-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 04cb269c204398763a620d426cbee43064854000 ]

In tegra_ahub_probe(), check the result of function
of_device_get_match_data(), return an error code in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://patch.msgid.link/20250513123744.3041724-1-ruc_gongyuanjun@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Extensive Analysis:** **1. Nature of the Bug Fix:** This commit fixes
a critical null pointer dereference vulnerability in the tegra210_ahub
driver. The code calls `of_device_get_match_data(&pdev->dev)` but never
validates the return value before using `ahub->soc_data`. Looking at the
kernel tree, we can see that immediately after the assignment, the code
accesses `ahub->soc_data->regmap_config` and later
`ahub->soc_data->cmpnt_drv`, `ahub->soc_data->dai_drv`, and
`ahub->soc_data->num_dais` without any null checking. **2. Severity and
Impact:** - **High severity**: A null pointer dereference in the kernel
probe function can cause kernel panic - **User impact**: Systems using
Tegra210 audio hardware could crash during device initialization -
**Subsystem criticality**: Audio subsystem failure affects multimedia
functionality **3. Code Analysis:** The fix is minimal and surgical:
```c ahub->soc_data = of_device_get_match_data(&pdev->dev); +if
(!ahub->soc_data) + return -ENODEV; ``` This follows established kernel
patterns and returns an appropriate error code (-ENODEV) when device
match data cannot be found. **4. Consistency with Similar Fixes:**
Examining the kernel tree reveals that other Tegra drivers have already
been fixed with identical patterns: - `tegra30_ahub.c` already has this
null check (returns -EINVAL) - `tegra30_i2s.c` already has this null
check (returns -ENODEV) This indicates that tegra210_ahub was an
oversight that should be corrected for consistency and safety. **5.
Historical Reference Analysis:** While the provided historical commits
all have "Backport Status: NO", they were primarily code cleanup and API
migration commits (switching to `of_device_get_match_data`), not
security/stability fixes. This commit is fundamentally different - it's
a critical bug fix that prevents kernel crashes. **6. Stable Tree
Criteria Compliance:** - ✅ **Important bugfix**: Prevents kernel panic -
✅ **Minimal risk**: Two-line addition with well-established pattern - ✅
**Small and contained**: No architectural changes - ✅ **Clear purpose**:
Prevents null pointer dereference - ✅ **Subsystem confined**: Only
affects tegra210_ahub driver **7. Risk Assessment:** - **Regression
risk**: Extremely low - only adds a safety check - **Side effects**:
None - failure case now returns clean error instead of crashing -
**Testing impact**: Improves robustness without changing successful code
paths **Conclusion:** This is a textbook example of a commit that should
be backported to stable trees. It fixes a critical null pointer
dereference that can cause kernel panics, uses minimal code changes
following established patterns, and has virtually no risk of introducing
regressions. The fix brings tegra210_ahub in line with other Tegra
drivers that already have this protection.

 sound/soc/tegra/tegra210_ahub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index ab3c6b2544d20..140cb27f73287 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -1359,6 +1359,8 @@ static int tegra_ahub_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ahub->soc_data = of_device_get_match_data(&pdev->dev);
+	if (!ahub->soc_data)
+		return -ENODEV;
 
 	platform_set_drvdata(pdev, ahub);
 
-- 
2.39.5

