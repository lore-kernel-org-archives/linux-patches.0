Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59070489FD7;
	Thu, 10 Sep 2026 13:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047637; cv=none; b=svpqBDj3vOZbRQEMSxM5L8pkwLG7FRcwsjmoQMnISot2kpenzhnNR02+Tk1dsAeffBYL1qm4jTcTD0KdI/SwcWQSoID7TtqYzvC/IYebD/JgRUsO6xzIKfbV6OhpQ34DEhJ8eviZAtm263SeuXIK/+T/vTWRKzxpOTi7nlXx2Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047637; c=relaxed/simple;
	bh=VaC61zVNlC7L3HgGjcxSOV+lHNm8kzD9DbXgl5AW7mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNe+B+LvvuIDL4jeJZGFtkOumjRLiNv1KL5L7MeylZRltjKuYz6dR/lIz+fKHXDmxHdvTUdopEM1ETHC17/f0RYX2eMjmK63ZTDxmXOgIIlQdvg6q+Xgnw/2GLW1rYvhG5V7M1qkAkVHnT35nuDuSezMkNkxy0tuHKcybN5YqHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ic/XY4wa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ic/XY4wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0111F00893;
	Thu, 10 Sep 2026 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047634;
	bh=MrWt6NgE2JqoEwM5fhh8S+uRmmP9Gk5qAIh68/AzNU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic/XY4waIB3/mlQT0u/wl0pf4JdDgs2IZwHu+4Qc0pFkVsQn7ELC9fVgTXefW7YXK
	 Vq7CA7AU6xWQc41hkQOExvtoUL3WAvgwvMXt43wD5toyDbARQ6pdFS6b/6hSCeRV0N
	 +u2jh5wFWl5FSfJTz1bNAvKZEL1OPZzuxifEZDoEL4MttvVNMHKNDH+f452pUwBMLs
	 pnh9fxXan+usAnc5K2KVIxTklbYGuosYRiNIRTEhEt1bL01EbBVNWaVFtEb/CgAyDM
	 vlQu9kBEnSmvCeeC4D2z2vOOoinzZ4KRC1m1gW/NVKfmN1Is6wvvM0HOFHIyivhBv3
	 oCqk7KdCfnNqw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
Date: Thu, 10 Sep 2026 09:40:29 -0400
Message-ID: <20260910133106.0bc0d3f3027e@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <e976263f-5382-4e32-a3a6-5639c4d56abf@nvidia.com>
References: <20260909134237.773280130@linuxfoundation.org> <e976263f-5382-4e32-a3a6-5639c4d56abf@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> These are causing some audio regressions for Tegra ...
>
> Test failures:	tegra186-p2771-0000: tegra-audio-loopback-testsuite.sh
>                 tegra186-p2771-0000: tegra-audio-mixer-testsuite.sh
> [...]

Dropped all six Tegra "sort register defaults" patches from every branch where
they were queued:

  - "ASoC: tegra: Sort ADMAIF register defaults" -- 6.18
  - "ASoC: tegra: Fix the MIXER enable default value" -- 6.18, 6.12, 6.6, 6.1
  - "ASoC: tegra210_i2s: sort the register default table" -- 6.18, 6.12,
    6.6, 6.1, 5.15, 5.10
  - "ASoC: tegra210_i2s: sort the Tegra264 register default table" -- 6.18
  - "ASoC: tegra: Sort MBDRC register defaults" -- 6.18, 6.12, 6.6, 6.1
  - "ASoC: tegra210_mixer: sort the register default table" -- 6.18, 6.12,
    6.6, 6.1

> My intention was to only backport these for v7.2 because
> audio is broken in that release for Tegra.

Makes sense - and while digging into the I2S case specifically, we found the
root cause: your companion fix 53dd1c1de851 ("ASoC: tegra: Fix the I2S enable
default value") is queued in no stable branch. Once the I2S sort patch makes
TEGRA210_I2S_ENABLE reachable via regcache's bsearch, the wrong recorded
default is left in place with nothing to correct it or re-enable I2S at
runtime_resume.

> I see this is pulling in a bunch of other related patches, but I am not
> sure if these should be pulled in either.

We also acted on that wider concern. We reviewed the whole "sort the register
default table" family (all the non-Tegra codecs in this series: adau1761,
cx2072x, fsl_easrc, max9860, ml26124, pcm512x, pm4125-sdw, the rt* SoundWire
codecs, sgtl5000, sti-sas, tas2552/2764/ 2780/2783-sdw) and are dropping it
from 6.18 and older across the board. These patches accompany regcache commit
4b05ccb17f92 ("regcache: Sort the local copy of an unsorted reg_defaults
array"), which none of those branches have, so sorting the driver-side table is
itself what changes bsearch reachability in regcache_lookup_reg(), the same
mechanism behind the I2S regression above, but with no reported bug to fix on
these branches. Risk with no benefit, so out they go.

Thanks for flagging this.

-- 
Thanks,
Sasha
