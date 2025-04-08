Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6C3266B4B;
	Tue,  8 Apr 2025 10:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109736; cv=none; b=DAqpTXCL1vUOF0B49dzKIoPBwP5Zy39O8yGXQruG3P0eo62jUe7vh67E8u+jV+nzebMjeBfWjW+B0RPvLMOtStixRdZqV6NRaXN7TZamFYFMDO6Jfx2qR96JLaRPNakkzFVQ7zN1rDrDTJm+uW2FS9GQKlyWUuKCA/ZUDZKeltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109736; c=relaxed/simple;
	bh=zfTpTY6pTFIbf0yCeXLxef9/nhbKJERj97e276XUpw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3Emm/EIWdKXDNKScTSG/OIMSy3dfcm389SLUcZZh/gaqU+T1eVC1ATnpaDme6TCcwYKH9PiDev2Y5p8fEkKA0Bt7o4NW6ZahCo8hvHed8eUnJv9H4aqSP5VArbDC0wV9lzkRdMHEpFgImPf+WcidTHUPFKdR7rSfNTtzOhi9ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiBWTNrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiBWTNrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A07C4CEE5;
	Tue,  8 Apr 2025 10:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109736;
	bh=zfTpTY6pTFIbf0yCeXLxef9/nhbKJERj97e276XUpw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiBWTNrW0TUMBoNhcG0iAOqwvXY0ch9I3f2ye/k15Ei+cjwqOAQNpiNM7AFBHPKiw
	 9VdvB2tdHwehCKCVMQCKGzUFIpkS0ZGs8gcwswbCE2DAndrrIaeaXIynAtsQ5hhaSA
	 eetvRNbVu6lvbvxvbfI+j8bcLM3nRzqcRRa7shfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/227] thermal/cpufreq_cooling: Remove structure member documentation
Date: Tue,  8 Apr 2025 12:46:50 +0200
Message-ID: <20250408104821.369361993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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
index 6e1d6a31ee4fb..f1ae1530aa642 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -58,8 +58,6 @@ struct time_in_idle {
  * @max_level: maximum cooling level. One less than total number of valid
  *	cpufreq frequencies.
  * @em: Reference on the Energy Model of the device
- * @cdev: thermal_cooling_device pointer to keep track of the
- *	registered cooling device.
  * @policy: cpufreq policy.
  * @node: list_head to link all cpufreq_cooling_device together.
  * @idle_time: idle time stats
-- 
2.39.5



