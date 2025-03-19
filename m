Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270161C5F26;
	Wed, 19 Mar 2025 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395060; cv=none; b=r5DMbnwg928BJlG8o38sDWTsvFD0Gy4UYVbmBzpY/ATROO57N9xXOoVLcXO57Uv2diJNpYVEQn5Lt1+h+RgpGMpI0BPg+m02RYfRLnvMtWFUhm1hgI8tss79l11tb0Yg9lZFwRpmemonCHYjk4xXcEKR08YgKSfYROqt43jIXXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395060; c=relaxed/simple;
	bh=7NTwrxyaDnfhoVKE7HK6M/gHxDtSkeWRn3keqMz+pCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWe+TAKgOz81qKF8sue6wvpsZvnO+0HN5tKkepXTtrmLoMFIeMzSvabOVd51W16x6tpsfn7HtMKL/3+Lu/6h30oqTwo7qZPJiS14QMEJ4DFZ0lwOGDqbgTS3f3jHxySpKdzf+4lfhudUmk10pcLGrweY2B1HzREgycQrZ5Sndng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQzQURcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQzQURcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB26FC4CEE4;
	Wed, 19 Mar 2025 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395060;
	bh=7NTwrxyaDnfhoVKE7HK6M/gHxDtSkeWRn3keqMz+pCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQzQURcGcCPJFJI6+EGP/ufTNBT/DKm++4OACO+7flfyNymdMX2BcVlWqhSFJAm59
	 mebYecQHw0ORoOyWWSVSEH2M6V7mG/Kk0c9Bb/wAO9Xw7xRizMfGeFrxJDWOB2LXB7
	 mzUzc9OzB2xlhfIwUR78CGRj+MTWkObH6BCroFa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/231] thermal/cpufreq_cooling: Remove structure member documentation
Date: Wed, 19 Mar 2025 07:29:46 -0700
Message-ID: <20250319143029.141390824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit a6768c4f92e152265590371975d44c071a5279c7 ]

The structure member documentation refers to a member which does not
exist any more. Remove it.

Link: https://lore.kernel.org/all/202501220046.h3PMBCti-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501220046.h3PMBCti-lkp@intel.com/
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20250211084712.2746705-1-daniel.lezcano@linaro.org
[ rjw: Minor changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/cpufreq_cooling.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index 280071be30b15..6b7ab1814c12d 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -57,8 +57,6 @@ struct time_in_idle {
  * @max_level: maximum cooling level. One less than total number of valid
  *	cpufreq frequencies.
  * @em: Reference on the Energy Model of the device
- * @cdev: thermal_cooling_device pointer to keep track of the
- *	registered cooling device.
  * @policy: cpufreq policy.
  * @cooling_ops: cpufreq callbacks to thermal cooling device ops
  * @idle_time: idle time stats
-- 
2.39.5



