Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037640;
	b=n5lydb/MYLxVspjzgeAkjyrNKOrO9FxpfxdFHHDv13xZ8hsI/VTs0SOTpb63qb16E2Y5
	 1Ud1Uj2T6ldYenmm6FAg2s2FGA/szyuTpOGA4rXNPUuUJOhFSbjQMZA17EjHHIO5mxhOA
	 fAuVV4YvVNBee3cyWzmjcikXyPOJ3yXGbQzCIsAycWuMTyarLCNUz4i5YMWb1koEa0Spp
	 z0bRq6w0Vf110DG4b0RKFx3sX2riGSqdft/dZOwsYga4K9LGz9auKBeVX7AktrD+aj86T
	 GnmiCSmgheuCc92AUS2gdBzBcx1ZDxTkZp9sx08SIbXgvtf16HAGNVj/W2j5RYX65bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yaBq6SWRHIh56V/E4mgLwcMg7xxXACPlDz5iG9msd7I=;
	b=FFYtxkS4raWrzi1GZqleP7Z+yo8FAkMU4G2IQShJ5BfeEb6wRbgTCb1C+rEtoZmkmGif
	 E4N2pppfw+1ox0ix11KxM4ylULD1qWOV9iCysSPxZ3tTwrRzfm16JTBkcgE+NXeo0aG/i
	 3ADtKSL2cfqUiYryLyfNrwCvlagZ3jzprD7RzMqrYVzA7ho8WiMHwCEvK1kmq/buxcsW+
	 MvjmWldMcEBe08ejEuLPoyaVLwXk5nv1vUbfvBrlsKXOkXpUTttnpML0N/Qk1swboIkTd
	 YJHfcf34un2AXvFol6RaFt4z/GX27sjrSOY6O77KL5LzcuD3yyKBN0tmCpk5urU/4Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVKZ4tt5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70DB606A320;
	Wed, 18 Nov 2026 21:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVKZ4tt5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03A41F000C4;
	Wed, 18 Nov 2026 21:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037640;
	bh=yaBq6SWRHIh56V/E4mgLwcMg7xxXACPlDz5iG9msd7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVKZ4tt5z3v+MIMrzJsW9nNQ6ltezzGRPjXC9M/r76wfQH+sos7MclEVwnCnzbsGi
	 vr54vyNUx2j74b7VIFZdbIcdjs8sPQjmGUQC9iY1WDlkLdHBq1j+KskVAUJVp4XyQl
	 JJJw3s9UXh5TY99Mkz/HMXa08eDD3LDUlEJTvvFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1466/3318] hwmon: (coretemp) Check for NULL platform device in hotplug callbacks
Date: Wed, 18 Nov 2026 15:34:48 +0100
Message-ID: <20261118150404.872163230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f562057efcce2..6c10349ea68a3 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -664,6 +664,9 @@ static int coretemp_cpu_online(unsigned int cpu)
 	if (!housekeeping_cpu(cpu, HK_TYPE_MISC))
 		return 0;
 
+	if (!pdev)
+		return 0;
+
 	pdata = platform_get_drvdata(pdev);
 	if (!pdata->hwmon_dev) {
 		struct device *hwmon;
@@ -715,6 +718,9 @@ static int coretemp_cpu_offline(unsigned int cpu)
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



