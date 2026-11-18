Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060111;
	b=5KHDeKNVkepycSeelPO30NMpTV44E/OnBNs2r7dUszFpd441BcWlFSt+qCGk3nihRdg0
	 mnKmM2T4n/M8WeE1dxilHu3ZyERpDLe5ka9GrW8byunr4lQx9M7KQrqJE8Lg7VTslQ4q9
	 luQYkZmc0KFyXfUg0qn3ua5SJTMpnYZwp65kKYbhibgiEWFj7H/9mEW1+AR5dxlCQrAbP
	 Lb9zlNoD0uBxlWfGSz+j0A+G3nF4zA7866D9/v2aKsz9bkqTVYcMmqx/xdQj5StBuzFSa
	 qTo7cDFyfdJCCYaN7tc6XWPj0oFwKiMA7kBhnq7eGJPO3S+1j/uxSnG5R1VxIwebY+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iK5DHhKgtuIC7+sKp10J5kU+Kv/5cFCqMUGShF/U3mk=;
	b=S3Bw35j4O05dSxD6MdTUSOBwRdJMRP+hh72/UT4Dcujkh5aGbP88udESczfMLn9srAfm
	 LQ8u1JFK+PCAedrpev4y1h2E07p2Gcaaa0UxnnWeTS87wAWKDUkccSfjX+gJoaAnoUPLY
	 mBAKedvedY4oIGaiMrfu2viWcykF+IxUzi6uVEARM9qUj2OvoCJqCBKFmHsI2YDqHPxmf
	 Im78Ogdg9Du5rGEdCMB90IJR9GsHqukABdt00xg9d+Ku/llhR7cmIAGJLpv1G+c82p0NG
	 EBj9EcBy1INmqR+syf4NKtLdbaHghhAR+0upT9siuvGJ1832j40FdQOBX/tjlOJmOJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXVmi936;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578C0606A320;
	Thu, 19 Nov 2026 03:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXVmi936
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DD11F000C4;
	Thu, 19 Nov 2026 03:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060111;
	bh=iK5DHhKgtuIC7+sKp10J5kU+Kv/5cFCqMUGShF/U3mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXVmi936JOeNO0hz4Jb5ay2ywSwmdtavCVwPi0b4F5+5b7EkMPjDmyhD6pQDxTiKx
	 xBptRd9uObo8RzwCTstbPPTenZvcb/6fAPddiywMOfEDF8m5v9LMXZHZHyaLEEsqeP
	 4tvc8DL8x71/qyu9RVO2ZPAC0OelvJ8/w/Le2xBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1082/1848] hwmon: (coretemp) Check for NULL platform device in hotplug callbacks
Date: Wed, 18 Nov 2026 15:52:00 +0100
Message-ID: <20261118150003.716543721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context to use the DTHERM feature check instead of the housekeeping check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index d8ab0175f16b1..abc6ab90e9298 100644
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



