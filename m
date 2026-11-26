Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705235;
	b=SYxaMveE9ZJhIy8zCUK97KpphAoT44+keIN84wr4fCAHoQSf3jhcASNR/HyrnYBDFqqF
	 qJuUrJM1KlJym380sjK4/TIsJDrgmskV21c765mfSgRR2eaYUNVid6zxvXWiMASykCvKH
	 g9f7iPlgdN/4q7SX7iGx8vftsV6/du7NYLDbWHOsTgDQUcFNszLdLhspuSZiScPR9qBi2
	 uNEqJ0wq8fbTURWrfgd2D3nJJGSR/JhgRX+qdIV02kUOZ20U9XeriJheDsMnh6Vv68XfQ
	 fxSbF0tajecL1Sx9J6jbjE2iPhtjusGoTPCOD0uJQi3KyxSX2vNUec8T10Gf2JsGraw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4spMvPyO1+nZZoeBCKO0Yjf0OXcsKPfLj1bPi+57Xs=;
	b=JFwIhCMIFTWDpkaDJ72ldrCzcG6VDQ7kBBJprVWp2OEs1lSb0YRnJDxPKFQBT1M0yiAa
	 Hc97mWbNKI1FFCcFkaCv8eMawpIb2Xt6GU+F5T/GnauSWpCC3CxKKbqbnEhSY1hsAv7zW
	 Nq9vHlxyFSSDbQnJAyfshzV7LeN8u9xW4b4so/BMtruj4oSR0lhV9DRGyqyFchQRTpjIM
	 OuLPDw6cGcaewSC6hcNl74Lluwf1AgNQ4E+jqPc7y0pQa0+26KpBSwJZZASkO3CXlEwPK
	 9fPvjAU2AFAZYWqB8PzksEz5Om9M7FUODsEfOJIRs/f3fiuEUGOMt1aJI3/SomedtaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGHT60aq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10D4606A323;
	Thu, 26 Nov 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGHT60aq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D816D1F000C4;
	Thu, 26 Nov 2026 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705235;
	bh=L4spMvPyO1+nZZoeBCKO0Yjf0OXcsKPfLj1bPi+57Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGHT60aqwpFhQh4dpAFSTWu5nlL7jQho/K+4jWTi31JAJNf/K5vU/H0HWwqZEppzr
	 Mnqxxuc17Fq6hZXLGl7QmcBfqWdgoZKdSWT9ND6917rP/Umj87MYu0a5U7bDMV96Xy
	 vu05bVs7bmz6PwznXYN46UFKgWLoeePEkhJ9+Bfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/319] cpufreq: Preserve global boost state on failed updates
Date: Thu, 26 Nov 2026 15:38:11 +0100
Message-ID: <20261126144009.521374258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit a0cde2b601bc32b76d61e50141c619790e5e2e41 ]

cpufreq_boost_trigger_state() restores the opposite of the requested
state when updating policy boost state fails. For example, a failed
write of 0 when global boost is already disabled enables the global
flag without enabling any policies.

Save the original global boost state and restore it on failure.

Fixes: 121baab7b88e ("cpufreq: Force sync policy boost with global boost on sysfs update")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20261105215223.1263415-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 10bec33a1d36b..0a32d1e5ef687 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2701,6 +2701,7 @@ int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
+	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
 	/*
@@ -2709,6 +2710,7 @@ int cpufreq_boost_trigger_state(int state)
 	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	boost_enabled = cpufreq_driver->boost_enabled;
 	cpufreq_driver->boost_enabled = state;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -2730,7 +2732,7 @@ int cpufreq_boost_trigger_state(int state)
 	cpus_read_unlock();
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver->boost_enabled = !state;
+	cpufreq_driver->boost_enabled = boost_enabled;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	pr_err("%s: Cannot %s BOOST\n",
-- 
2.53.0



