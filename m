Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621745;
	b=0/+nJAARRTDUEsamcXy1RA2SULEAgda4/SwveNHPpZDvrxLNUtIX0MFfZW3sl/Pr2YOz
	 uj56hZOmfvzu9tZKqaT8QkOB5vyohm5H+TYR+juF3FUHNGYAv0d2egf8i/qWeJwQh4UtX
	 h5+CuagH6ANtum1Nl23t+1AjqXp5wfxxQJrAaoEAwHHxy21hBjWVeFwg2QW9ZnCUtLSK6
	 85kfDe7Wgn2+TxTTkgKUpwBFfwUV13OlZnIDErzbErEtqmXd4ht+vwoM8nqzBq4kDfUnq
	 1jQ3TZrsjvWYGMObJq8o6HwWajdspcXpdX8eyA+FQLguZ8/FKN0RVEHAzssd7mfCzDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B7mPjl9oWhsi63qK4IFr0yxxS4CuOUAKxUpDcPoQFso=;
	b=xeocax4VjiZ0NgGc41NI7irbOwi6mqPfcuC+a4Oy+3oWoB9paXZ5islNUdbND73hf/1L
	 jCfBsfElJq8YSsqlwfwZbI7HbNTp6DdY+6PCZj6ebPOeFuFKZ08bQJA/E3e24Kny75of5
	 lr30Q9UfjGSYMgXJxIB0gmRZd+b0nnZ6hKzdRWIGIKXN08P9TtQfdjMruHTiiUTRS4IIe
	 5jz6pTPlzWPnr1G9b2QS9fudb2GvtHMHk8pwdXYBqSrtMvWRa7SmUujTRcf7iLQMfylgB
	 0ankL26k7JojgJhST1sArXoF+KRdqQH3exLCAs0KAn4EEgSvWS6H0rbHVtU+enH81Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfjovmmU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6DD606A321;
	Wed, 25 Nov 2026 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfjovmmU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE211F000C6;
	Wed, 25 Nov 2026 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621744;
	bh=B7mPjl9oWhsi63qK4IFr0yxxS4CuOUAKxUpDcPoQFso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfjovmmUhsfVwsY8em8A8uZVv4FMxCS20fkErLKhIiLcI+pPTqdjPYhAgY2c78eeZ
	 GDseJYMXzOojORtlxgjAsJBkRCgfERHXCpKXW6Vii/VVfCYEE/SkmNE0jJczmsIqcG
	 bwiZT90AOzBPMsZcqUYVIS6nvxyHS3ew2YulsKrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 323/990] cpufreq: Return -EOPNOTSUPP if no policy supports boost
Date: Wed, 25 Nov 2026 15:28:10 +0100
Message-ID: <20261125143829.654971312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 002afd47d2d59..46cf3d49b0636 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2809,7 +2809,7 @@ static int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
-	int ret = 0;
+	int ret = -EOPNOTSUPP;
 
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
@@ -2831,6 +2831,10 @@ static int cpufreq_boost_trigger_state(int state)
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



