Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DD119AD5C;
	Tue,  8 Apr 2025 11:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112399; cv=none; b=PZJv806xVS7CO+BFGrM4OKA31zD6mf4VTvZonAhVOefXUQQHv5T3+fc8guIwiF5bx/ARNyrBvYUDYx1lY6GmqMn1QXH/RpdNuA8Kf7kAHivB5tiB3yxE01LjtlAsHMq7t8+TqOKi8ppgSXF3T8l++tTqIXCEOGeDT6uzvOkXIw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112399; c=relaxed/simple;
	bh=5lDYK47YKqsND9J64AstcjjiQ22C9VqOSUs1HtnlkGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvuKDVnEwI8KAuT8cguHaa5/vlNS5vVkFGb3F4y1b+Wxi8YMmAKXpQaRyn6/DqF82aBBgGTZhLACN9G6eIHGylxg1EQWfBFbJCHy8LSKD60RuRqpoCeQjm108NQPfoIed2RG03v643WF7qbHMD2A9EQjL/mGZP2BR54GkU1ieYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMh6Q+6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMh6Q+6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDECC4CEE5;
	Tue,  8 Apr 2025 11:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112399;
	bh=5lDYK47YKqsND9J64AstcjjiQ22C9VqOSUs1HtnlkGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMh6Q+6N+xUffAWEynPVdlb27Iwje4dM8DOCV0cJDauTSPS4iiVXqT/iYZLzIqoQJ
	 gLUpBT4lK3HdbAgqr8+sKZnGvebq/YzIMFY0r+2sPt9mVVmz+KGOyLBd9wZ8SnFLGY
	 HxfYB4Gyv7Onz7tLvhORbKj5ZnDytqvYqtRDQOII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/279] thermal/cpufreq_cooling: Remove structure member documentation
Date: Tue,  8 Apr 2025 12:47:00 +0200
Message-ID: <20250408104827.383611419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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
index 12a60415af955..8171c806f5f6f 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -56,8 +56,6 @@ struct time_in_idle {
  * @max_level: maximum cooling level. One less than total number of valid
  *	cpufreq frequencies.
  * @em: Reference on the Energy Model of the device
- * @cdev: thermal_cooling_device pointer to keep track of the
- *	registered cooling device.
  * @policy: cpufreq policy.
  * @idle_time: idle time stats
  * @qos_req: PM QoS contraint to apply
-- 
2.39.5



