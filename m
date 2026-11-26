Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704374;
	b=vw+P6RrmUCaVJM3LZx0UgsJNer3CJKWEItJzbc+N7/VH/e2i3pTQPBIvU944GHUQzkZb
	 IUFX4IRH31ODZV+f2MF7+7k22vxK2LJdyRBwV1jlHExEvm3hTXrwQOvMDbVJfXpjxVGXh
	 Jh6AhobUANNZUfgYxNxJKzozL8w/1NtGdOC5PAP9Vc8hKJEpOvlm4ZErZ6EDQISac4c2h
	 MAspP8LHdcuve/YVXJCftF0Bj3a5oJUmceCT+eM1XDNgcZKsRMrFPlr4nY18pR5jSNjxJ
	 Yf17YWmlb1wk27+K16Y5FbZuL3mqx5fP2bQDVmxc7DgqvY2WlNVoeTyuTEO2pqZULbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvQGkHK17z0DqMOuC8I8tFH1pM07KUuHIhyxYjb99Gw=;
	b=xwdN59nWrd4gqj4VRo/qBkleOUCHpiTPght9un9M/DYAhdp1LxHlbWU3CilfxuCcGu5X
	 zN9kLBCmN29rFUiuJEVNVyO36eKTXGQFRs51C0qOU3u5ynOIpwsCTtBqWSIr8xuQk5PRZ
	 rC1jR7HZoEU5rEQW+nJ2YqfUYGO2NtpPOzCV0M0FI2I4lL5FEsN0JIDw40YN921wrEB59
	 ZVzJlDtnjVadfcNxgEa9o+w8yWrHc1RltTNRuqFFbHosTm40BUgWkF33zZTKwJ4VH+eY+
	 53LMFcGeR2O0erQpBQQ5eexFiRSU8o9LoA3UaANB+blz6xaR1OsBmyFt7m0nfZXu1wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LU3CXbLN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2195606A31C;
	Thu, 26 Nov 2026 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LU3CXbLN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3471F000EB;
	Thu, 26 Nov 2026 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704374;
	bh=PvQGkHK17z0DqMOuC8I8tFH1pM07KUuHIhyxYjb99Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LU3CXbLNnDgbv6rcEe+V/RAkhFDODBzDcx/wfeLtww9yzG5Z6mb5iwQsrqFeVpkmd
	 RFA2FvSbtA5MSRvM/uSaYsSSJ0wThckVOQkcmPDYpjeGgPYHoAyalHZdWAuG3ohAZG
	 hvVvPMCOpaFcO+EBEJnvinMAOlPtr2nu32bv4yWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/265] cpufreq: Return -EOPNOTSUPP if no policy supports boost
Date: Thu, 26 Nov 2026 15:37:13 +0100
Message-ID: <20261126143612.215368475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 77cf053b041fe13d1fdd2e572e16ee7776ff687d ]

In cpufreq_boost_trigger_state(), if none of the the policies support
boost, policy_set_boost() will not be called and this function will
return 0.

But it is better to return an error to indicate that the platform
doesn't support boost.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251202072727.1368285-2-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: a0cde2b601bc ("cpufreq: Preserve global boost state on failed updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 585ad335f1c31..232243d8b8ce9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2640,7 +2640,7 @@ int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
-	int ret = 0;
+	int ret = -EOPNOTSUPP;
 
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
@@ -2657,6 +2657,10 @@ int cpufreq_boost_trigger_state(int state)
 		if (ret)
 			goto err_reset_state;
 	}
+
+	if (ret)
+		goto err_reset_state;
+
 	cpus_read_unlock();
 
 	return 0;
-- 
2.53.0



