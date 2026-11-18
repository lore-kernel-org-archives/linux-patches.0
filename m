Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037225;
	b=5c8IjyBIcO00Gdsm41fslwaaHQyKEa8DQRxhhJ4W6bMofy6vWSy/1YKX97ZFFguA45ir
	 KbfJvUbLlVk3i5L10NwKH95fvwvclmIhvrgUHxTFZE5eTbfLDIRkhBeNj2nda0BXgBvKC
	 VHfw7orJnziBXP4534eliMZQZUUj9ZPKKRejFRHDT3lqU5QMFBv16uUDObfm5Qr6auGe0
	 36WeMi/1P05w1w5bmzM3VZ79I6f8kEw5nnlao2TLT4591qBg3B6XXmyHEx2CBwa7bn+AU
	 zcLGmheRVWQCZEQOZjy39dmFXnH2cJbipN31IbafY7/A17nEHOoJqXtor4Qc6NpEWMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BPxvMuQ8vvtl2lcLEWZiVJ/DyuSFpGP72P4Yo2vqg2I=;
	b=l/yjKKk9yRaEf7yZIiGzdFO5PjoI1pOLctMEMt2+MGwdBF6uhoyJD/sKZoP/3o9dDA50
	 ws/7IWDt1cxWbFeRLaZ9gTB7bbck16MHPX+pF1X5rHT7TGBQy0x54tL8kvOFMXnYVoeam
	 4vvIbB7j4tC1NCYbO/DvVW/F1PqALntFwuDQNVwN4Rp9TabHOPKB3SbeAlOShLdRzDHSh
	 mwOUPddHarXVXhbq9+ECpcQiHXnTXK/vqiJCNzl9HtESHLJhaHBM38kGz0eqH90n7N7Og
	 Pxb0cQk+OA43Hc9hMEr71tEgoTYrjV6mlL12HSgmVSNQW/v+MBfgqhYHt2t6yBLBTDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYhdf0oU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A88560A262B;
	Wed, 18 Nov 2026 21:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYhdf0oU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6111F000D2;
	Wed, 18 Nov 2026 21:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037224;
	bh=BPxvMuQ8vvtl2lcLEWZiVJ/DyuSFpGP72P4Yo2vqg2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYhdf0oU+oES4KsL/l1m9MHK4nD8ZbLvaumcDqnjdnkZ3oN5XR84Grycs0niGuwRS
	 daIMEERRuQzW2CRhOJ3TnVpFYcdxufzR5+CEylT5yb0Axt+DIzuBz2lbs2bQ7xNGvD
	 qiqyjrkKptkSmc14WYkYYYfGVKSScx/7FDwv/Shg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Ximing Zhang <xzhangjr@gmail.com>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1333/3318] hwmon: (coretemp) Fix handling of isolated SMT siblings
Date: Wed, 18 Nov 2026 15:32:35 +0100
Message-ID: <20261118150400.334852359@linuxfoundation.org>
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

From: Ximing Zhang <xzhangjr@gmail.com>

[ Upstream commit 37c1974a0ec4ec4624a270291a179c53f8f4fbca ]

Commit 0f8b916bc5b5 ("hwmon: (coretemp) avoid RDMSR interrupts to
isolated CPUs") prevents create_core_data() from creating temperature
data for an isolated CPU. coretemp_cpu_online(), however, still adds
that CPU to pdata->cpumask.

When an isolated SMT thread is processed before a housekeeping sibling,
the mask makes coretemp_cpu_online() believe that the core is already
represented. The housekeeping sibling then gets no temperature
attributes. Package attributes are similarly not retried when the first
CPU processed in a die is isolated.

The mask is also used to select a replacement CPU when a sensor target
goes offline. Including isolated CPUs permits the driver to retarget a
sensor to one, causing subsequent sysfs reads to send an RDMSR IPI to an
isolated CPU.

Keep isolated CPUs out of pdata->cpumask by moving the housekeeping check
to coretemp_cpu_online(). Sensor creation is then deferred to an eligible
CPU, and hotplug replacement targets remain on housekeeping CPUs.

Tested on an Intel Core i7-10510U running 6.18.50-3-cachyos-lts, with
nohz_full=1 on CPU 1 and its housekeeping SMT sibling on CPU 5. The stock
driver omitted Core 1 after module load and retained its readable sensor
after CPU 5 was offlined. The patched driver exposed Core 1, removed it
when CPU 5 went offline, and restored it when CPU 5 returned.

Fixes: 0f8b916bc5b5 ("hwmon: (coretemp) avoid RDMSR interrupts to isolated CPUs")
Cc: stable@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Ximing Zhang <xzhangjr@gmail.com>
Tested-by: Asaf Nuri Bertizlioğlu <ycistak@gmail.com>
Link: https://git.kernel.org/linus/37c1974a0ec4ec4624a270291a179c53f8f4fbca
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[xzhangjr: Resolve the create_core_data() conflict by retaining the 6.6
index allocation and init_temp_data(cpu, pkg_flag) call, removing only
the housekeeping check. The other upstream changes apply unchanged.
Tested on an Intel Core i7-10510U running 6.6.162 with nohz_full=1:
the unmodified driver reproduced both bugs, and the backport passed
sensor creation, 20 SMT hotplug cycles, and 20 module reloads. The driver
also builds with CPU isolation enabled or disabled.]
Signed-off-by: Ximing Zhang <xzhangjr@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 281b47d0e297f..f562057efcce2 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -509,9 +509,6 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	u32 eax, edx;
 	int err, index;
 
-	if (!housekeeping_cpu(cpu, HK_TYPE_MISC))
-		return 0;
-
 	/*
 	 * Get the index of tdata in pdata->core_data[]
 	 * tdata for package: pdata->core_data[1]
@@ -659,6 +656,14 @@ static int coretemp_cpu_online(unsigned int cpu)
 	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return -ENODEV;
 
+	/*
+	 * Keep isolated CPUs out of pdata->cpumask. Besides tracking the CPUs
+	 * available to this driver, the mask is used to select the CPU on which
+	 * to read the temperature MSRs.
+	 */
+	if (!housekeeping_cpu(cpu, HK_TYPE_MISC))
+		return 0;
+
 	pdata = platform_get_drvdata(pdev);
 	if (!pdata->hwmon_dev) {
 		struct device *hwmon;
@@ -688,8 +693,8 @@ static int coretemp_cpu_online(unsigned int cpu)
 	}
 
 	/*
-	 * Check whether a thread sibling is already online. If not add the
-	 * interface for this CPU core.
+	 * Check whether a housekeeping thread sibling is already online. If
+	 * not, add the interface for this CPU core.
 	 */
 	if (!cpumask_intersects(&pdata->cpumask, topology_sibling_cpumask(cpu)))
 		coretemp_add_core(pdev, cpu, 0);
@@ -730,9 +735,9 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	cpumask_clear_cpu(cpu, &pd->cpumask);
 
 	/*
-	 * If this is the last thread sibling, remove the CPU core
-	 * interface, If there is still a sibling online, transfer the
-	 * target cpu of that core interface to it.
+	 * If this is the last housekeeping thread sibling, remove the CPU core
+	 * interface. If there is still a housekeeping sibling online, transfer
+	 * the target CPU of that core interface to it.
 	 */
 	target = cpumask_any_and(&pd->cpumask, topology_sibling_cpumask(cpu));
 	if (target >= nr_cpu_ids) {
@@ -744,7 +749,8 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	}
 
 	/*
-	 * If all cores in this pkg are offline, remove the interface.
+	 * If all housekeeping cores in this pkg are offline, remove the
+	 * interface.
 	 */
 	tdata = pd->core_data[PKG_SYSFS_ATTR_NO];
 	if (cpumask_empty(&pd->cpumask)) {
@@ -757,7 +763,7 @@ static int coretemp_cpu_offline(unsigned int cpu)
 
 	/*
 	 * Check whether this core is the target for the package
-	 * interface. We need to assign it to some other cpu.
+	 * interface. We need to assign it to some other housekeeping CPU.
 	 */
 	if (tdata && tdata->cpu == cpu) {
 		target = cpumask_first(&pd->cpumask);
-- 
2.53.0



