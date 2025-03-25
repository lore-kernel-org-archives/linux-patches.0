Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AA825A2A0;
	Tue, 25 Mar 2025 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905577; cv=none; b=N8fjwgY+1HdeppV9dUlcYGR19QP+WQTKNSVP6CWNSQx+IrnCmAbIV+5JjTBR2dR4eDM+upn0uy2mAFNqhksXJbJtunXVdbfAVFNBFDdyN+t3RdZcpMPXTMyPxleDOIz0K2MaZ0rEVenSQJKHrHVrZoBTm0F7BNWa3dWZ+j/lvd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905577; c=relaxed/simple;
	bh=gIq/4nTLjSAR+1onSUicWO9R18QyE2RUuHRPqgj82Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSzBThZpOOjVOWZ3s7PLNlR+IOZYNUZ4zjVyOsEC2raqjmhdRZezySbWff2eBUpncDJKkpuxlFl/iMUxVgkdojZalMDW6AAmWlDK7uK9QT3PCtjE7k4eDFxfDTcidk1VPrcAl7i82uNhrd7IN15LkT4dt1jNGaqxCJtQzCydcKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roxl4wpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roxl4wpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E19C4CEE4;
	Tue, 25 Mar 2025 12:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905576;
	bh=gIq/4nTLjSAR+1onSUicWO9R18QyE2RUuHRPqgj82Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roxl4wpJ/n273Feir4sb5/EzQHG0iWUE7TO9QpuPsCdQgwza4Hso10+RqJezt66GC
	 1WyXR9ea0wOiGSpQUNAr6EBIVWBpOoOKkVrOMTldbDbRKDrXOA9gWaURdQYd/oPbkX
	 GF3+bgsG1fRMqAwPN4ufVQ8d4mUnmeWTs44OtwpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/198] thermal/cpufreq_cooling: Remove structure member documentation
Date: Tue, 25 Mar 2025 08:20:12 -0400
Message-ID: <20250325122157.948251333@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9f8b438fcf8f8..bac0f52a361bd 100644
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



