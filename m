Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC5243E486;
	Tue, 16 Jun 2026 15:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623100; cv=none; b=t4kLm/Zno/2UnyuYoTNt7I/8liN1Tw9HnakOVjJ8GoscV0n3FmyZxtIP5UJxO2GNQBpvwMcQllAMe0clVW2vyKU9tu/cjuemS1Fi/iWMkHriStf2enqovjNLvcGqW2VsUmiKDVuzO5iBmopLmxpr4/zfNLy+GmqpQ0Ma0WIriIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623100; c=relaxed/simple;
	bh=ff/brXbi+0ERDd/3vv7hb42fLupraIEUV8SyUR48BYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzvInFueAVaUjgZq4Er7Hj4t8uMREQR30AHS6dUDMI3OIm6SLs2zyZKgbzTykri4LdNGr7DPWTaXgki481zaorKFpgh0bUWCx+siLjBn6SJ80QSQCOY17Hit0zKSIsNjqrL+u2DMAW4oxSShiUYzH/TTjJN70iipviNDH4GGq1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A70uoKiI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A70uoKiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A371F000E9;
	Tue, 16 Jun 2026 15:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623098;
	bh=Qb2tz8doJusTCmVM9/7SVYQLnSlPSu5K6WHG02IrPxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A70uoKiI41cbbFt0SHt2RT6XuBzSDXJrNOCIGug+BEAbH/A7Q8Or8B4K3bhj6Oaqh
	 StiH5mewnDHvGP91+f+T/Vqi0v/I8wbulGNu00VM3Iaz1pMewGPw/6BqZ2dKTpXZzL
	 bOjXLxg8nRAyvX5WHYyNmhmtfJwp+sW1ft2mzjxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 088/378] cpufreq/amd-pstate: drop stale @epp_cached kdoc
Date: Tue, 16 Jun 2026 20:25:19 +0530
Message-ID: <20260616145114.886479692@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 3cd07ee35a66038fd1a643632bfc057645e07c9a ]

Commit 4e16c1175238 ("cpufreq/amd-pstate: Stop caching EPP") removed
the epp_cached field from struct amd_cpudata in favour of always
reading from cppc_req_cached, but the kdoc above the struct still
documents @epp_cached.

Drop the now-stale @epp_cached entry.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Fixes: 4e16c1175238 ("cpufreq/amd-pstate: Stop caching EPP")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Link: https://lore.kernel.org/r/20260526022131.1302373-1-zhanxusheng@xiaomi.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.h b/drivers/cpufreq/amd-pstate.h
index cb45fdca27a6c7..75136d2250c1a5 100644
--- a/drivers/cpufreq/amd-pstate.h
+++ b/drivers/cpufreq/amd-pstate.h
@@ -76,7 +76,6 @@ struct amd_aperf_mperf {
  * @hw_prefcore: check whether HW supports preferred core featue.
  * 		  Only when hw_prefcore and early prefcore param are true,
  * 		  AMD P-State driver supports preferred core featue.
- * @epp_cached: Cached CPPC energy-performance preference value
  * @policy: Cpufreq policy value
  *
  * The amd_cpudata is key private data for each CPU thread in AMD P-State, and
-- 
2.53.0



