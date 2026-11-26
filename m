Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704377;
	b=JN0+8/zSshuxabnS3Vb242B4X5wtXXcTPAqUyOkyJFoDj4AN5c9aM8fER+7NVkoRQV5e
	 XYcZlUiiA+esFVRchuQMMRfKrE9o6yv14gjo6Yq9Dhkq5T8GtodeP9T3DOunHsxxTkha9
	 b/abQvEADuPQ/nnCEUR1GurHx4so8crNMSkexYyRyH5pjowhPK7rIw00MKQ8rWkRVC3xj
	 sHt8uZ/qBmfSJT/lLzVxmz36LTRlVzaSHzXYovEu15Y9n+aY9y5A3WG7HOVOZodI3IVDm
	 4YaypJ2/M9cFz+zmvZuHKeiLNZDdCPaM7qbqNhF1CBAQZx+fDS7qengf+qPkVgLCBbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Z0if1KtTjZFEYwzVqOabS3d7xh+SNdP6T9bxRUPxMo=;
	b=Nb9y35l1Z8a9iqNcIAICXGdseDKN4Hx748YVSJ/S1ksIxtB+iQ2AADWpZ7b3Y+JODfNL
	 WpKjWlREZ8Bgk1+GSP4+2qfrv7QFr9EthDmMN0azoiUYL/3Tc+9PTl7jgGmPrexOznUeW
	 Z941KklF1eYQtLkg+I6MCkZ09og02HcCTrSf4c2U/CUICr8yoYmcBwvSrLCD8LONYMDLJ
	 jzUk1Cxjcj3GN3+PpQXgOp/slxumjkkWOEh5wfy2ZXXaJ0XF/yWOSSrNHz7EZxzkJyBf8
	 pFNx3VSAFgI6c7qFh1ZMAa4bNoWq19ZTQZ+NUStwgPb+k108UkTMj5xZBEmVU/wbX1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysg7OlZw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FFE606A321;
	Thu, 26 Nov 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysg7OlZw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0691F000C0;
	Thu, 26 Nov 2026 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704377;
	bh=3Z0if1KtTjZFEYwzVqOabS3d7xh+SNdP6T9bxRUPxMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysg7OlZw23r9SDavWA6qKWbE4/pt3ZgC02b6b4L5wywuKXacIi/TyjSdVElsn5xAn
	 rk9GsOpWePIok1JpBP7yFdH0N4Jq8ofacyP6cJviU5SpISgadljwAyf5IO8h3ZKmrZ
	 wZQRtgtULKUdufOfF4QVfKDosF3Eie2BtuiaiRts=
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
Subject: [PATCH 5.10 104/265] cpufreq: Preserve global boost state on failed updates
Date: Thu, 26 Nov 2026 15:37:14 +0100
Message-ID: <20261126143612.292170316@linuxfoundation.org>
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
index 232243d8b8ce9..b661ea5f4e193 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2640,6 +2640,7 @@ int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
+	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
 	/*
@@ -2648,6 +2649,7 @@ int cpufreq_boost_trigger_state(int state)
 	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	boost_enabled = cpufreq_driver->boost_enabled;
 	cpufreq_driver->boost_enabled = state;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -2669,7 +2671,7 @@ int cpufreq_boost_trigger_state(int state)
 	cpus_read_unlock();
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver->boost_enabled = !state;
+	cpufreq_driver->boost_enabled = boost_enabled;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	pr_err("%s: Cannot %s BOOST\n",
-- 
2.53.0



