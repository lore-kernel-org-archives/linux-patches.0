Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054497;
	b=Qy/oXZpqgZQuzeqnc9tbK0QBgcfl9qOTWf3T/yov7z+9eygVUnMPvpL2sT+D/xtZJW2H
	 pbdDVEfblrYjFqk/D0T9N7yPHY/ESNtz6lNuD1a4aCZC1U3ZZHf4J8mjlkFvjO4+kcGjG
	 wfoRBpRHpq+AuBKTeVP/RJt8lZ7PV9CxVhZmaYwjRHAs0byfdzQebRstm/m1PwLD2GF1g
	 V9Ylvve1xkp+xWjGu6YaIbNaD5PdYyeKZoSkiP4LIQj6j4nuQGpn381l7QrNBHyGvudt6
	 rYGeLYDxfJ0hrqWJ/o7h+KwKs9fnOTIjvFZEq2upy/Iqt8GpuGKaiV6+7hsT8h4uwBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+XwjWkS2FoA+Z120GXEOA8rbm2hcIs1kqKBPWZmSDLA=;
	b=iHDJhFHuYjFPZbA3wE2Ca0n1jXwvpWBgwRjBVPkvFT74B2ghXPti/7PXvCf1gvAp3MWd
	 76Qam2J3ApQHLMr7h1fRqYOa2353bVFf+E6xwtHlhpeJdAeGwzrzixORsxnyvxzogYhfu
	 1KOFWjuNraz4ZMqK46fay/jUuCMa7HsmCTgEWtkwc5mqgQteLEPzq2+ET8kXOWJcyIgRW
	 IwKzGxLGinypGrQwUVZSw7G/TdBk6TBMFfbDMvwlXf/UFrA8VRwIxdNwfMQlRP8Ri/dR6
	 u5Yq5QDfUdvclqbWl0ScNNQCCVIuIlOBhj6jPxhfJZGqQ4fETUom/V7KOVV3rA6lOEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuYXvXHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F7606A31C;
	Thu, 19 Nov 2026 02:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuYXvXHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32C31F000C5;
	Thu, 19 Nov 2026 02:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054497;
	bh=+XwjWkS2FoA+Z120GXEOA8rbm2hcIs1kqKBPWZmSDLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuYXvXHygECTSr+HWgfC7p/ElKqC2yEyMibPk9uA9BVeR9FWx9Hoyu5LX3ueuo9gP
	 8+W7rTm1n202p8P3RuTAA0r1qsSB0zqKJDGZGlBsOnNpSQ+zX3hIKtOWQaVPN+q+ME
	 giq2h1VhGq2uWDhFHSFAtN/TA1RXjZaauk7DO5lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1288/2214] hwmon: (coretemp) Check for NULL platform device in hotplug callbacks
Date: Wed, 18 Nov 2026 15:49:24 +0100
Message-ID: <20261118150103.092060344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted insertion context from the housekeeping check to the existing DTHERM feature check ]
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



