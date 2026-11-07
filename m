Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065084;
	b=R4ZMFyFv4P54ZAYzbsDiLpRHUbPzwAl417iba7g3rMdFv64/GMJGL2hcdeSHm/GXIhq+
	 XSBrW02+Q165iw6wgJFoYS5ovuwalqz0vgvhZQI9zWb2raf8RzSgsdvHnkUB8oLS1IPro
	 5UXwawS18SBhAMLUAjb2ApcvCXghJpYKBx1OYtVTllYcSiHlFg4FjETqXq8EBHT8vJD88
	 da+UHHC8LN83687RbdM1RwTrXamVdBXWdopnECs80syMjQb63Lp+kpGg4cKKa5GDE+Mz0
	 dZTi779XyJ//jche5Vdv5jmZ8/rDcamtjHsYPweWJ4XE5H9VPx2FeoCJFwBlWpSfJ4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gG9fQdpJtmYJQFqWX+RuCkogPI8mm+gW+Nl8BBtI+3o=;
	b=KYYjNJI9SwVI+UNQ7iMlx7EtfGSgopvMe8v7yqBsG77/1kxj8Ju/7c/Kdzs3pe2gNQRY
	 Sfscc1FD/ikFTLzZ3iBWUVcrqmjME0nbQBN/HJblSpT3SwZdIVOJZE2YWZlT+6Me7tKkc
	 eYoUkwv/r3CwHZo+ke9Mwo9D5TBWLs5f2qolVc+AR8SJ4uZinTauhUb3aqPwfxCBY/Rrs
	 GwS+eNfiPO1UH2s1z5sVTV5GHk+oI4LIN73mrCkjzYdnXsRFzdo8y0z2XQ/MvLeqD2U0Q
	 gtzyUVakxMJVuVzhxP5D8NZtArE+kq+XkLR8tj8OZygHX567sgR2zLxqzkyMOJgoHKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTpIVu2V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215F5606A326;
	Sat,  7 Nov 2026 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTpIVu2V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20831F0089F;
	Sat,  7 Nov 2026 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065084;
	bh=gG9fQdpJtmYJQFqWX+RuCkogPI8mm+gW+Nl8BBtI+3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTpIVu2VPsqQoNMbgUd+p0a+ETzneAKjim8XdQ6kxxUJzEBssLZDdVlzXrJYilaMs
	 MAP06yBHYFA30V0F/ThjF4vgoWr+fLmegQ2u8uaAh1cce8HTbszP9Uv8Opcn6OqhjT
	 eCxpFgX5Joe4ByLw2sa41aGLF/SKeGILvlqCgWvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Ximing Zhang <xzhangjr@gmail.com>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0880/1257] hwmon: (coretemp) Fix handling of isolated SMT siblings
Date: Sat,  7 Nov 2026 08:52:56 -0500
Message-ID: <20261107135003.630328573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Link: https://patch.msgid.link/20261016-codex-coretemp-housekeeping-v1-1-96618c5676b2@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index bee2c9896d4c5..9ed21c8c093a5 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -568,9 +568,6 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	u64 val;
 	int err;
 
-	if (!housekeeping_cpu(cpu, HK_TYPE_MISC))
-		return 0;
-
 	tdata = init_temp_data(pdata, cpu, pkg_flag);
 	if (!tdata)
 		return -ENOMEM;
@@ -690,6 +687,14 @@ static int coretemp_cpu_online(unsigned int cpu)
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
@@ -719,8 +724,8 @@ static int coretemp_cpu_online(unsigned int cpu)
 	}
 
 	/*
-	 * Check whether a thread sibling is already online. If not add the
-	 * interface for this CPU core.
+	 * Check whether a housekeeping thread sibling is already online. If
+	 * not, add the interface for this CPU core.
 	 */
 	if (!cpumask_intersects(&pdata->cpumask, topology_sibling_cpumask(cpu)))
 		coretemp_add_core(pdev, cpu, 0);
@@ -750,9 +755,9 @@ static int coretemp_cpu_offline(unsigned int cpu)
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
@@ -764,7 +769,8 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	}
 
 	/*
-	 * If all cores in this pkg are offline, remove the interface.
+	 * If all housekeeping cores in this pkg are offline, remove the
+	 * interface.
 	 */
 	tdata = get_temp_data(pd, -1);
 	if (cpumask_empty(&pd->cpumask)) {
@@ -777,7 +783,7 @@ static int coretemp_cpu_offline(unsigned int cpu)
 
 	/*
 	 * Check whether this core is the target for the package
-	 * interface. We need to assign it to some other cpu.
+	 * interface. We need to assign it to some other housekeeping CPU.
 	 */
 	if (tdata && tdata->cpu == cpu) {
 		target = cpumask_first(&pd->cpumask);
-- 
2.53.0



