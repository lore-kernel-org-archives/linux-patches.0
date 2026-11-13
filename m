Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590305;
	b=l2jV+AraJmX4tsFcbuDnTDV7F+NtycSO+t9bJgeDxgmf4fJ3YbFdWKviBW5vEdFRlVmv
	 c3xrd0es3QAdvglMOltJOGzUB9Ddb799Cj9EW+qReS+FtSUBWEpc5oz5j4jVzKL6t+0I5
	 4D3xRDht8bcakHxoT6u8YPKSos7+YRMg88rzpdv4xpq64ErCbW7aK/8cdECCL5E2M3tof
	 gIn8YK05ladTBM1I74jBRkCgv5G6i0yp0KtLqZbKeFA6tTpbH2+o4Iogwfq6YIuM+V8sr
	 xDaxencoeni4xna2In+u7YBoNjykD83MkzZWqMuL7y6/oiUj70bkX4mPxwPxiVdpzCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1sHC5uxc0TEfFkJLPH8n0Mt7cxPzC6tTecvK0px7lJk=;
	b=l8KtB7kemDXQpgfbB1cA66G9uoL+JbOuzrvHRWBPnFu88Pt4KdOIRKO5hDuS6sIhygLy
	 PdrMOPsEaJ6PIufTArz/dw0W/N/cigz+QiFiPhG5bqrlXJpY8RwkirAeshN+L+k5oHI8q
	 C4L5IXX1LxeKKjuIHoorrJRfmoOMNsjjYarE2NnKinYESbF0P6MU/lepZWuhXMzADEm2d
	 D6bu5MwGMSIdKBdNkRrLm5nYCq3cUWiIfHThjome0pqCUUEqA8poufBmmf2VRhWTGsRlX
	 HsSL6fh05B6lLO0bzUxuoZu65PFUf8jf618LZ3/aZB7Ap9NdvKAj0ZH8gezdygxkBdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTQ9o04a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB969607C35E;
	Fri, 13 Nov 2026 17:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTQ9o04a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E8F1F000C4;
	Fri, 13 Nov 2026 17:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590304;
	bh=1sHC5uxc0TEfFkJLPH8n0Mt7cxPzC6tTecvK0px7lJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTQ9o04aFveAkbySKXzVnIWvBfKDykK+a0f3ZUgyj3BV6JuQHbgkgoTOZAz01x3/8
	 eaxUTgC7LOZmPuysWGypcwD96WoS1OxUSayPn4jS5pEoCAUZTkAP7t5tbnBHXeNaGW
	 3r66tWG7myCNyG6MhqljoGKS2liKqtoL+MV9piuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 291/686] hwmon: (coretemp) Check for NULL platform device in hotplug callbacks
Date: Fri, 13 Nov 2026 10:47:04 -0500
Message-ID: <20261113153830.833346471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c9b7e435eda81..ac56319ff90cf 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -686,6 +686,9 @@ static int coretemp_cpu_online(unsigned int cpu)
 	if (!housekeeping_cpu(cpu, HK_TYPE_MISC))
 		return 0;
 
+	if (!pdev)
+		return 0;
+
 	pdata = platform_get_drvdata(pdev);
 	if (!pdata->hwmon_dev) {
 		struct device *hwmon;
@@ -737,6 +740,9 @@ static int coretemp_cpu_offline(unsigned int cpu)
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



