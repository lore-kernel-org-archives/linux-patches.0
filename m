Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585561;
	b=BQrWk1sTqmX6ySl7kGCJk6eZp710kl3afNoDHcjgimx1+ij8dL3U+8DyW2WykvNuizRV
	 t04eB9nj0VPw3fMSREs4TvSLsgeqzagmuBDpFxfgWa665rOVUw4LcVlBEcX7Gq/PLRRZV
	 gPxnmzDCSoMdLkgWhud6+URzdKUP6PwBAGe0Xnp4tOD1gvtLTGPqoBscDGCV0ALglg+Uy
	 Zxt2BbogAhHsU4oXDBkSFAhLF/4wvgOH8BqpZmUl0rPjzUIBao7V2OTrFbBwpGFNgxnTH
	 KQgLcMm75TR14ajS7rh+7t+xL7YqiVbuwEQjwA3ROw/YtLL4Dd6FgpTYD+v89yW3UNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RYvTvsUi43c/wjYlf9vUgupOKpmFSVlw8mK28TWJlKE=;
	b=rsI2lbZkPCSau6CjZJeTAZ7C029hTTBUp9njjelO6yVtALo3sjEoOtq/wl6srHJXNZeT
	 E8fwEvXA4T5A2RFYiJkNIcEYnqrOtQlIsRnubaCpbkP2p0ZblwG10ODP7OSY/jaQ16bls
	 LpsodAlFgTzzr3s9N+TkTBchfgkhv2yuhitqjykfVurW97fsAAs62rsM/iIv9XBvGFiJd
	 WN+LpT8sRZeJas5oq5VRv1s3K2EKnmJU97eJsoBA3HDUQtt9TOwH2GIMMKSIXhQao5IEv
	 GvKlpnd6CIF+GUd0bedFuKJIdyWoMIfvZA76ZjAsL+ZbM1QIsf8l7IVLkyRqkTvq/lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h9lv//VQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CCE60A2628;
	Fri, 13 Nov 2026 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h9lv//VQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C32D1F000C4;
	Fri, 13 Nov 2026 15:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585561;
	bh=RYvTvsUi43c/wjYlf9vUgupOKpmFSVlw8mK28TWJlKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9lv//VQC5mJ/hGZgOJOFv8pnJIWYVWXKzj06BW8fX5kN4SukzJV/VwkjHrAZ+/EH
	 +caVL6mAPdmz+n2Vdy7+D59o83LKHbRgVETXZ0lPXwjSqnAeZpAe5wk6odmRjGhHAY
	 SOzItMt2sh8N17t56PwjiK9mZKT6/We7dOM0VdxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 198/507] hwmon: (coretemp) Check for NULL platform device in hotplug callbacks
Date: Fri, 13 Nov 2026 10:48:22 -0500
Message-ID: <20261113153801.195118175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 9ed21c8c093a5..17b9b63440f81 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -695,6 +695,9 @@ static int coretemp_cpu_online(unsigned int cpu)
 	if (!housekeeping_cpu(cpu, HK_TYPE_MISC))
 		return 0;
 
+	if (!pdev)
+		return 0;
+
 	pdata = platform_get_drvdata(pdev);
 	if (!pdata->hwmon_dev) {
 		struct device *hwmon;
@@ -746,6 +749,9 @@ static int coretemp_cpu_offline(unsigned int cpu)
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



