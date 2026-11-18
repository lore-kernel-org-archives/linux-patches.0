Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047696;
	b=CmPlHHQkP5Y+jgOjdCGhL7rDGSn3t3oKu1opyBAKGBTJYAqdtsVv4K0lWImeJmMLeSLK
	 LKnMVfxFk4gFlFZhGv1IKlg2TpTe7xgTdVLsX/wlzYrh7hNutcAK9rc/Gu4SB4ST9yruK
	 4UsZiXKRjCemNyhYjkAkJh3yerOMJC2y9U6dSSuM1QQSvwiBsVZP3NK5Iq7FcYFWHnulT
	 V3zj60t5CLlKTrGGYwjIVh0xfHEg7joN8ntuch/Pqj+9vW4SHW5HQ2vpZvFuwbKO57nEs
	 Xp1DA6f+fiwf6JXedwSI+g3yfdh9DyUORg7U+1yUqiQ5mXR/AHY58hGOn0c9B92dvkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=osMvnBGgIUh52Ud7GOtoX4x0rU4zosLDHyFeS+Rk3Uc=;
	b=IerI0x77QV+R5ZqM5Nxd5lb4DpHfyUflcLLBr/+diOTklKGAagxgv9Gb22ccAXYr1Diz
	 tGqX1oqPtDqMLR9dlMjXrAavuf6UoghfiC1U7w09xHvGtiApN1MhcvXTEcQ3AHkFSscay
	 70iBP9a1ooWDfwjXH06tB0N8B0579FyM8Fm3t4reJ9cHpXV2xTF4m7RxKxZymzFTUL1eJ
	 Mq6qiJBdvrrkj6HVTXYTWA1YlaG2QcaxVUNu6ayhrMN2wnfuzDSGQ+rLTjlBKfEVrsSzU
	 /rxz9/l07ZIwA0pfCu5MWhTTzhCdwr+WtVL8b7prQJSCdH8fDu9/bPKYmYesxwhuz1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3dlSbJQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94C6606A325;
	Thu, 19 Nov 2026 00:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3dlSbJQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393041F000CC;
	Thu, 19 Nov 2026 00:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047696;
	bh=osMvnBGgIUh52Ud7GOtoX4x0rU4zosLDHyFeS+Rk3Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3dlSbJQQqVfM+NYeDKQk4TXKWgNX3vbIEepDhQOMx1Af3WpUGMX4Znw2HkY3i1LL
	 H73n0CsDpMYJu3J07tiqfz8/rz1+V90UArHIAzpGWTQ9734TygkpLETboWOgdG88D2
	 z6Z7MaKFpmSQjsO3RQP6dE9PPbte6Puq+jVuo1BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1690/2857] hwmon: (coretemp) Check for NULL platform device in hotplug callbacks
Date: Wed, 18 Nov 2026 15:45:24 +0100
Message-ID: <20261118150302.188752596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0f9c7ed3b5009a037e5533eac03a0d4d45ecf1f0 ]

coretemp_get_pdev() returns NULL when topology_logical_die_id(cpu) is
negative (such as -ENODEV or -ERANGE from topology_get_logical_id() on a
firmware/hardware APIC ID mismatch) or exceeds max_zones (for example,
under asymmetric or anomalous ACPI die topologies where
topology_max_packages() * topology_max_dies_per_package() is smaller
than the logical die count).

Commit 6d03bbff456b ("hwmon: (coretemp) Simplify platform device
handling") pre-allocated zone_devices[0 .. max_zones - 1] during module
init and dropped the NULL checks on pdev in coretemp_cpu_online() and
coretemp_cpu_offline(), passing pdev unconditionally to
platform_get_drvdata(). When coretemp_get_pdev() returns NULL,
platform_get_drvdata(pdev) dereferences &pdev->dev and triggers a kernel
NULL pointer dereference.

Check for a NULL pdev and return 0 in both coretemp_cpu_online() and
coretemp_cpu_offline() before calling platform_get_drvdata(). Returning
0 in coretemp_cpu_online() ignores the unmapped CPU without blocking CPU
bringup or tearing down valid thermal zones on other dies.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 6d03bbff456b ("hwmon: (coretemp) Simplify platform device handling")
Cc: stable@vger.kernel.org
Tested-by: Asaf Nuri Bertizlioğlu <ycistak@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: Placed the NULL check after the thermal-feature check because coretemp_cpu_online() lacks the upstream housekeeping check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 8ad0ac882afb9..371eb3fb8e933 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -619,6 +619,9 @@ static int coretemp_cpu_online(unsigned int cpu)
 	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return -ENODEV;
 
+	if (!pdev)
+		return 0;
+
 	pdata = platform_get_drvdata(pdev);
 	if (!pdata->hwmon_dev) {
 		struct device *hwmon;
@@ -670,6 +673,9 @@ static int coretemp_cpu_offline(unsigned int cpu)
 		return 0;
 
 	/* If the physical CPU device does not exist, just return */
+	if (!pdev)
+		return 0;
+
 	pd = platform_get_drvdata(pdev);
 	if (!pd->hwmon_dev)
 		return 0;
-- 
2.53.0



