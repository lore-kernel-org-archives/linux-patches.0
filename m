Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618780;
	b=kVm3ysUk80AJw7SsY91eGAWISxy5Szrf8csPxdakzzlqxJp6WEEOY3rIv+CoiYffejfL
	 wabUKw1KQysa5Rmzhlc+Kg8mF17GKXTQUnZiLzorBHL4RcIMSGpZLrkvDELsSj9hVQ/ty
	 kiexI386MEs2naOjvROC5BCQcuK8Z8/bxoI2YR6ypERDMFE0iG8XbjSuijbjGfWfYeGDu
	 fWbukvl9snWTI60x8MfaagQcXYUd+DD5PmOdXT5noGLe1OA/vEMwL43aIry82VhPEwPTG
	 QzreoGBJXCtCDyQHggrlmi1OaMQl9mH5loRDDERvbC9Zusu+cAzWIrRlaEl+RpoO1sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IiVi7JVZ39nDRuap/IKtbF91epNZU36uGkkT2zipRuY=;
	b=dywhMbisZ5abuGl2H+Al/2fVPvQZXtQvHbbIPFfEQEK/zDxCxPXtCtUZm9wOThbPOT4a
	 aRILjFuEd1B1Fp8kB+1ddHDHrut8lQ2nr4cM0cufwEul5H0Lgj7TFikCABh6v+jRwqeaD
	 aU+PnBDKkpzz1xe+QY+EJptNqP0fOleLK5CDxLmSfYwAPQWiTHdyJ05MGF569c+QswyZH
	 GeZxbiEWYAnAyB8MOTNiyzHlkdQjX1g3dNwfoMG3EcAfWNDlvwXXo5cD56aVqo95ORkYW
	 37Ch4P5AIWvS3n3jNQyAxJOciDHjeIpmi/lb7n0Tfz14lAWrDYvB0UbSGolJci62pPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBMvirTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753C8606A31E;
	Wed, 25 Nov 2026 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBMvirTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC8E1F000C6;
	Wed, 25 Nov 2026 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618780;
	bh=IiVi7JVZ39nDRuap/IKtbF91epNZU36uGkkT2zipRuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBMvirTIUEWY+7o21unc9znfIbwHx2iudTGd2PfqjnkpE8N7m7f5DuTqGxfaHzX7N
	 rqx8LPh4Cm8IU2ehMWHjIboS8pEiaWvwBPf7ROKVX3IsttbE/wj5LvW0iW/2BtRL2Z
	 atJi26ZmHnWakyhE4Zg/ZLmXXaUtpkct7A00f5aA=
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
Subject: [PATCH 7.3 0360/1005] cpufreq: Serialize global boost updates
Date: Wed, 25 Nov 2026 15:28:18 +0100
Message-ID: <20261125143830.166858149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 3d5720dff09f3b90d9ab2a6707e4bb8d69542f4a ]

Concurrent global boost sysfs writes can interleave their global flag
and per-policy updates. An enabling write can set the global flag, then
a disabling write can clear it and finish before the enabling write
updates the policies. Both writes succeed, leaving boost enabled on
the policies while the global flag is disabled.

Serialize the complete global boost update, including rollback on
failure, with a mutex.

Fixes: 6f19efc0a1ca ("cpufreq: Add boost frequency support in core")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20261105215223.1263415-3-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 4bf7738a81b0f..cef055a4b7d91 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2814,6 +2814,8 @@ int cpufreq_boost_set_sw(struct cpufreq_policy *policy, int state)
 }
 EXPORT_SYMBOL_GPL(cpufreq_boost_set_sw);
 
+static DEFINE_MUTEX(cpufreq_boost_mutex);
+
 static int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
@@ -2821,6 +2823,8 @@ static int cpufreq_boost_trigger_state(int state)
 	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
+	guard(mutex)(&cpufreq_boost_mutex);
+
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
 	 * make sure all policies are in sync with global boost flag.
-- 
2.53.0



