Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015063;
	b=M9Dgz94dUnA0xsIbCHLy68SdtmVSrI3xAgYgv7voSZB+/DwxVb1szp+izMbaHl9pW/HS
	 BWxsHfAounNyDYKL/cbHbcVaRmlf+0P+h4pb4YbZB6M3s4pS+tbRhQKVw+b4m+3JKdg17
	 lNgM5NhNxFvkkk5xcKOOLal/vcvEhrxrVMAQNFuCjttqTW1tY7wM+HEVr6tGLGzKlxdOz
	 WMr0fPQD+aysx8fKJPk/Da58OnPvf30CDoS2nFitLXNOsx/EW50TquJqgh6wASTfdyKa5
	 S2bRU78NN/9P9yJIfkGnfYtkKRtfF7AnOLUHOHE8jVRRPUH4L40t5VBy6o3S8lcZj2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KrHj44AXok87HpZjHS3d/SVh33S5gL2ySm3deAgvupI=;
	b=4aXShOnO2roQKx3vbWQhZAwbT0hzNStas8AFEs4eSqc+c6pIC2h8m2uGBr41li2WEqNQ
	 XFYEPJyaFXsYL6S+5Y2i5tOkNKwlYuG6E9olWkP0xdMbnq+T8K2Bj9KFQrMTDY22zBsF+
	 nuVRa1kvRtHT5IsEmn+rFB6feisB8JoeHjT0frdspQg7Ewjr/PKnR0Oh5MfHhYdnPtYPe
	 /zB5dsJ3pqilSR/SeMO63mD87zRGDcXLEdtifzMMkrHoHE1p/DO50iSMvBrxZh9Taezoq
	 y4cKIUErn8tLNDkZ6CKXFZMhEwH6MTvfMvJYCnyGnWZBCLJgSOGl+RKmvPA/grViung==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IdQl/ksa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6BC606A32F;
	Wed, 18 Nov 2026 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdQl/ksa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68D31F000C4;
	Wed, 18 Nov 2026 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015063;
	bh=KrHj44AXok87HpZjHS3d/SVh33S5gL2ySm3deAgvupI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdQl/ksa3n0DqCy3YdUehO9stZKervEfMm8AKo9rrFPMJGFL5IuE7JibjqJO4kQwr
	 HR7sqJJZ0ptcue0g1VMHehRxqNgQY9CZIlfN62eWvTO3j5Ayc8Y/8s2LPyX09rfHfm
	 NQeKIP65XFfvizutit5iO/oGyyOUDVZ4q3CJoM4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0040/2651] hwmon: (coretemp) Read TjMax only when refreshing the temperature
Date: Wed, 18 Nov 2026 15:21:20 +0100
Message-ID: <20261118150249.411798531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 5407d2b7d5279b7100621d92f2181184c8f00d62 ]

show_temp() reads TjMax before checking whether the cached temperature is
still fresh, but consumes it only when recomputing that temperature. On a
cache hit the value is discarded.

Discarding it is not free. On CPUs that report TjMax in
MSR_IA32_TEMPERATURE_TARGET, get_tjmax() returns the value it just read
without storing it in tdata->tjmax, so every call reads the MSR again.
That is a cross-CPU call whenever the CPU owning the sensor is not the
current one, and it is made while holding tdata->update_lock.

Read TjMax where it is used. The value cannot go stale in the meantime:
bits 23:16 of MSR_IA32_TEMPERATURE_TARGET are read-only, and the register
is package-scoped, so every CPU of the package reads the same value.

The temperature reported to userspace does not change.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20260924-coretemp-temp-fault-v1-2-1884f0ff97d5@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 9a6aa085c94c ("hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 2d7487b2f80a1..7fced0e2abeba 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -406,9 +406,9 @@ static ssize_t show_temp(struct device *dev,
 
 	mutex_lock(&tdata->update_lock);
 
-	tjmax = get_tjmax(tdata, dev);
 	/* Check whether the time interval has elapsed */
 	if (time_after(jiffies, tdata->last_updated + HZ)) {
+		tjmax = get_tjmax(tdata, dev);
 		rdmsrq_on_cpu(tdata->cpu, tdata->status_reg, &val.q);
 		/*
 		 * Bit 31 indicates whether the reading is valid. Some CPUs
-- 
2.53.0



