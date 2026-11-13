Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591112;
	b=QMTPCp3xwJZOv/PQ7G7Vy/tLaWPGbwAulFdMFDdWisNyMTH5esPESq+nt+ZzxW0d0864
	 US1Gs6+73YXGwzJBsgRUagQa39O852kdfbvfUIq6SAxXYR/ZFROoVmS6hiutQNHYjCrzP
	 GY0hdYHyJobKCHRDTcGRQPAKlPkInKTORAjQS4de0v9W+AQj+sWwD+TOwJJcOFU+mbA+W
	 WWyUSlYU/OzvUIcQzhxxZyVPQf8+FwgH9Eb3XfIznKAbq2IecqlskKpqM7F5/vV1HS31x
	 dc4p/vqX19SOF8O1yPMZQTHLtqEzLDI5Pt5umrg2Ykmc4MY0xrocHN52GTNNI8We7Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wXvhMLzV7lRbF42DJwj+Dws9Qbrxz4ZNzxJQSeODDEo=;
	b=hAooLFKF4xPxsMF2cEsaG9ewZYSgDX93XDxYctDEXqYvtYMjXpTROhvbCAst9ljj1cAX
	 jABg1vyaYv3n0YityvA1QxTgGaSHWUyEIh+tQUukBZexK/Icp/Uo8KmBnL9fgeK5NPieT
	 yvKu+Ht9TByUZaUstzc0fQ71XuYvB7Ylon3Y3SrCDFJWwKfDaQbQHCDz9pjalKn0/+KJ0
	 A5gJx8MpQqvcf0D194e+z/XIEAvahL7i0wKRnQu89s9rgHAZr93FWqOtwofaKxOCUXvAO
	 OzngIId9eJjMFIrxls41cjoiS67kBDRoCRTQRvuEEJFoWwjKnXJL9tGKZIlCmtNbEHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q4/i0zBC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539256074B31;
	Fri, 13 Nov 2026 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4/i0zBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DB11F000C5;
	Fri, 13 Nov 2026 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591112;
	bh=wXvhMLzV7lRbF42DJwj+Dws9Qbrxz4ZNzxJQSeODDEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4/i0zBChZoydqGFyKRfXQfuKvql7NDrbDJkiG2Su3kmur5a/dXSJ2oZcvzb01X1p
	 XnR1KXw3fmoOKpECxw/32gkKAOpJZ51Sutl1e4HeDYx8WOkNAMNfOCtyAe79M3JjqT
	 KUpFkzIWVthjUdMZTWfHbzQ4aVarvA9/QSpBWUHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/670] hwmon: (coretemp) Check for NULL platform device in hotplug callbacks
Date: Fri, 13 Nov 2026 10:47:08 -0500
Message-ID: <20261113153820.775785052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 04b20cf272ac8..8de1c781ac7a8 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -692,6 +692,9 @@ static int coretemp_cpu_online(unsigned int cpu)
 	if (!housekeeping_cpu(cpu, HK_TYPE_MISC))
 		return 0;
 
+	if (!pdev)
+		return 0;
+
 	pdata = platform_get_drvdata(pdev);
 	if (!pdata->hwmon_dev) {
 		struct device *hwmon;
@@ -743,6 +746,9 @@ static int coretemp_cpu_offline(unsigned int cpu)
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



