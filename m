Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069732D0C94;
	Sat, 12 Sep 2026 11:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212789; cv=none; b=WzzvcGyCQ3tiSJaaNkJmo1Zsb67yLCQsX3ulwHxdFVnesiXjQFtWywMYtFbo4ErH4YO7L7267cAdhDQ0ABGU6hss0iLGeqzV7xAsGoHWHJw0/Rq0Wy/jWcad1Qr/iTNr59Poxikvr32r3XHUfO1f1r1nysjW3rXD4L1EtpUv6XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212789; c=relaxed/simple;
	bh=/cXncbaGLWyKDjYWt4mp5WgOt2DPPhA5bBsAEDVD0rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaXkZJOUHtf09JRAfWWRXaBTlV5U6clk3ei+8kQgCVOYMEnmpe6nGTb/lYHXX9dHVPwHJhXHGsdOXzDvvHWrBFSs3h7UUUlVWWAtXebpDV7DhMjS4g5Hwm/C3S+h8J2jfjYirzAqPKFGTQODBV9EHBXfo12/ZMv+6u5DkGohNpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/zG8MXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/zG8MXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE08D1F00893;
	Sat, 12 Sep 2026 11:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212787;
	bh=51EjpJOD/Tu0e1n6ed0gtJGih/agESAZ8OTrgOWjk00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/zG8MXBSfkppfx0lXNvhbfcPwKY7LlyscB7m35a3o7KHKOLZ8viWE+S0+nuwbx8I
	 XCne4iDsNgCpkQrZj6O4UxFUEhGsfFPpdNGKBLpTFmkNSmQOkstJoJ6ixTB05TisJ4
	 D2x0g3eHW8NxxHfMl2SForaON0nIM+l6jJlLeK9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1471/1518] cpufreq/amd-pstate: Return -ENOMEM on failure to allocate profile_name
Date: Sat, 12 Sep 2026 09:00:40 +0200
Message-ID: <20260912065656.831229333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 87d2a8dec0f02b200eb3527da0ab11ba4d4e7deb ]

Failure to allocate profile name will return -EINVAL from
platform_profile_register() while in fact, it is a failure to allocate
memory for the profile_name string.

Return -ENOMEM when kasprintf() fails to allocate profile_name string.

Fixes: e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic energy performance preference")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260508051748.10484-3-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 1e14e974641c3..067f6aabf3222 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1226,6 +1226,8 @@ static int amd_pstate_set_dynamic_epp(struct cpufreq_policy *policy)
 		return ret;
 
 	cpudata->profile_name = kasprintf(GFP_KERNEL, "amd-pstate-epp-cpu%d", cpudata->cpu);
+	if (!cpudata->profile_name)
+		return -ENOMEM;
 
 	cpudata->ppdev = platform_profile_register(get_cpu_device(policy->cpu),
 						   cpudata->profile_name,
-- 
2.53.0



