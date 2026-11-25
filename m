Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621748;
	b=oG0W5uUxe5EW+wJ76UiadUFGRJnsyRbqjy47JWX4dyaUa4WXiRToXl8MaQVs2yQvFHgA
	 IoID3tuAPAUkGearUiiKK5PKybACzYUZ1dJlmMglYVkwVtoHOY6s53EltwLUsxyUJ35Pc
	 a5thTGooP5phqZPjcacCt2qrr+kvumNZEivRScqliaIgir60cFx5fMKnZSiONKtGP4/6y
	 eVgB2JQTrBEdeJXMG4C1LlJqd9ZKHM73NhzbGDAUfnOWaOc1m/D5ndD7euwbl62car1/m
	 wk5W/Fac14zJuwbtDOWdTiKXKMxHIuexAXWPsaJhzV4e5+s3bb81HRyeQj2SEkr3AgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nX9gxgDtstcwu/edv4x2FNWcPDxBtah3KDBIPACXWK4=;
	b=RT40TDST5bhl9C71i8hvGQ4MGgKOtdZb0LXfL6g3jeCvEGCG8WAg4Tg9kVxcpvuFppaA
	 KjfJ8KvdTb/DARuI+2ilC00BJfCilEyvVXbC1Qm3qO4MHUbiXhvH3G0q0z43dTOgvHsCV
	 GgNpmRKTM02Tj5LpbiIvSlaS0reg/e5/2oe6rJrkrQdWYfPsdPERVGlxHOyonvyc4MjVj
	 gb0nj1hAyqatGRwW6DHL+AKcJSWneVot0zll7QnLNR3iHDhSGij4VHstfq5HfxvXGSWFU
	 0pvFfm4IvUHq5S8aAXK4H0HXV9F0CMdkT26GJ7K4I4AEysCPCPi0eqIX5dMzhijqneA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXPVHYJU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3F8606A329;
	Wed, 25 Nov 2026 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXPVHYJU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410401F000CF;
	Wed, 25 Nov 2026 15:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621747;
	bh=nX9gxgDtstcwu/edv4x2FNWcPDxBtah3KDBIPACXWK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXPVHYJUap4fJfk/MVrQ5MzR/c+j6WTJh5QE8kMMNsupj27m2nJ5OSYdzwYQIfR2v
	 bdPOrdqsO6dHPKZND2gf23NGPAMW1pG7F/lAgJhGg81GvfuikTvhSnEju41RIQg6ih
	 nfzlfzwsTD0Bd+tuqyfej/oErq+JXoMb53aR3IIs=
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
Subject: [PATCH 6.18 324/990] cpufreq: Preserve global boost state on failed updates
Date: Wed, 25 Nov 2026 15:28:11 +0100
Message-ID: <20261125143829.677082668@linuxfoundation.org>
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
index 46cf3d49b0636..a48dd423b8f98 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2809,6 +2809,7 @@ static int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
+	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
 	/*
@@ -2817,6 +2818,7 @@ static int cpufreq_boost_trigger_state(int state)
 	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	boost_enabled = cpufreq_driver->boost_enabled;
 	cpufreq_driver->boost_enabled = state;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -2843,7 +2845,7 @@ static int cpufreq_boost_trigger_state(int state)
 	cpus_read_unlock();
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver->boost_enabled = !state;
+	cpufreq_driver->boost_enabled = boost_enabled;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	pr_err("%s: Cannot %s BOOST\n",
-- 
2.53.0



