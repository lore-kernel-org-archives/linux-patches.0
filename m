Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F3F2FB99A;
	Sat, 25 Oct 2025 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409673; cv=none; b=iJi6f2JCwoSEU7T8JJXq4SFZcFiz6Ij2tVBHZjWgzGawlI22v27GwY4EKUHNHVtLVn+TwJZ9Ma7SvClo6qGuV4ON5YiznG+zH2K/2YLrVAi9B4VTZWm63af475BnBqHc+2dIvgT9v2jUHXTQVBKGzp55Xgkf2no2M9kQcpj27IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409673; c=relaxed/simple;
	bh=ufZhKk2NELWrfrcZXrd+b4uhCZs6C+C7EE0sRNPiKFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JH9o3RmJkm5mur2nRdAAixcr/32SoVUsM9nnmHApThgkDiJKlA3LP54NMBWInfoijw7Bo3hA7Uu5ZuWprQ5zRhFhjNJifDKduC/4jPLPzknFVQXeZNmU/RJzbiOgly5jzxNChaHB77QeWGMarynIJQ0wxNi3trrWYULxAYp03dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Flv+mGxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Flv+mGxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0836C4CEF5;
	Sat, 25 Oct 2025 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409672;
	bh=ufZhKk2NELWrfrcZXrd+b4uhCZs6C+C7EE0sRNPiKFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Flv+mGxY3hAHWgmfRrkzdKHXQMqKyU/+mMyK1y4JnxPgTWq/GR5Ipn5HKO/JvMC/o
	 piQSn4zAe7aZSDxAoWBXWAM+8RPnMtEOBO6V4ThFpgF9O+WPdwRY0qioAn82EYmo7i
	 KTl44NQoxDCXGJxJMYX8K4Mxk1DVC0+BqmQVLJbpgtiKC6mgf5cePKQmcndPpa8Pqj
	 xNRpu2/XQdaHVReSzqKwguZzMK/AWQ9OR8Z61b8DqrH0xhu2UMPI5IjPDYomf5bwor
	 oikIs0ZFVHDQ+IgX81PyeQwA0sjj8BOKeBh6zhH9ehNygxdxN8d7IRcR1nDtR63xNA
	 AWrgnZN2S+JVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Perry Yuan <perry.yuan@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	christian.koenig@amd.com,
	kent.russell@amd.com,
	alexandre.f.demers@gmail.com,
	vitaly.prosyak@amd.com,
	arnd@arndb.de
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Fix build error when CONFIG_SUSPEND is disabled
Date: Sat, 25 Oct 2025 12:00:45 -0400
Message-ID: <20251025160905.3857885-414-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 8e3967a71e6fca9c871f98b9289b59c82b88b729 ]

The variable `pm_suspend_target_state` is conditionally defined only when
`CONFIG_SUSPEND` is enabled (see `include/linux/suspend.h`). Directly
referencing it without guarding by `#ifdef CONFIG_SUSPEND` causes build
failures when suspend functionality is disabled (e.g., `CONFIG_SUSPEND=n`).

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Fixes a real build failure: The code referenced
  pm_suspend_target_state unconditionally in amdgpu_pmops_suspend(), but
  pm_suspend_target_state is only provided when suspend support is
  enabled. In some kernel configurations (CONFIG_SUSPEND=n), this causes
  a build error. Guarding these references with
  IS_ENABLED(CONFIG_SUSPEND) fixes the build without altering runtime
  behavior when suspend is enabled. See include/linux/suspend.h for the
  conditional exposure of suspend interfaces.

- Targeted, minimal changes: The patch only touches
  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c and adds two preprocessor
  guards:
  - Around the validation block that checks mixed suspend states and
    error-logs the unsupported state:
    - if (adev->last_suspend_state != PM_SUSPEND_ON &&
      adev->last_suspend_state != pm_suspend_target_state) { …
      drm_err_once(…, pm_suspend_target_state) … }
  - Around caching the last suspend state:
    - adev->last_suspend_state = pm_suspend_target_state;

- No functional change when CONFIG_SUSPEND=y: With suspend enabled, the
  guards pass and the logic remains identical to pre-patch behavior. The
  driver still validates suspend state transitions and caches the last
  used state.

- Safe behavior when CONFIG_SUSPEND=n: With suspend disabled, the
  guarded code is compiled out. The suspend PM op already returns 0 when
  neither s0ix nor S3 are active, and system suspend is not invocable in
  this configuration, so skipping references to pm_suspend_target_state
  has no behavioral impact, only avoids the compile-time dependency.

- Consistent with existing AMDGPU patterns: Other AMDGPU code already
  guards pm_suspend_target_state behind CONFIG_SUSPEND. For example:
  - drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c uses #if
    IS_ENABLED(CONFIG_SUSPEND) around pm_suspend_target_state uses,
    ensuring buildability across configs.

- Scope and risk assessment:
  - Small, contained change; no architectural refactors.
  - Only affects amdgpu’s system suspend path and only the compile-time
    inclusion of two code blocks.
  - No side effects for runtime PM or other subsystems.
  - Typical stable criteria: it’s a build fix for a valid configuration,
    low risk of regression, and confined to a single driver.

- Backport note: This is applicable to stable branches that already
  contain the unguarded uses of pm_suspend_target_state in
  amdgpu_pmops_suspend() within drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c.
  Branches that lack those references won’t need this patch.

 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 65f4a76490eac..c1792e9ab126d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2597,6 +2597,7 @@ static int amdgpu_pmops_suspend(struct device *dev)
 	else if (amdgpu_acpi_is_s3_active(adev))
 		adev->in_s3 = true;
 	if (!adev->in_s0ix && !adev->in_s3) {
+#if IS_ENABLED(CONFIG_SUSPEND)
 		/* don't allow going deep first time followed by s2idle the next time */
 		if (adev->last_suspend_state != PM_SUSPEND_ON &&
 		    adev->last_suspend_state != pm_suspend_target_state) {
@@ -2604,11 +2605,14 @@ static int amdgpu_pmops_suspend(struct device *dev)
 				     pm_suspend_target_state);
 			return -EINVAL;
 		}
+#endif
 		return 0;
 	}
 
+#if IS_ENABLED(CONFIG_SUSPEND)
 	/* cache the state last used for suspend */
 	adev->last_suspend_state = pm_suspend_target_state;
+#endif
 
 	return amdgpu_device_suspend(drm_dev, true);
 }
-- 
2.51.0

