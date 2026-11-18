Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036117;
	b=Qy7vo7WTUi9286UtNOwYJRuyWtJ4L15iF9x+r3d8kunlO8J7h4STpmqg0WLXe/h+kjaP
	 Q9NE2YATfMpcUSBML7s7Bcav9cxHRZegQ3y4OmAhtH0at140/7z0SqJrseLn7mRbSCmNM
	 VPqe3nph6wqdcm0tKO0vtVGwR3XYVOsNS3vStcCT/wOMQ5MbIC9WDFJXaa6Tvu6I79aQk
	 UxxqkdLpoYCRymGIIYRoXPWlplh5UdNj9tYyuixRghkXGPChplmlpfj8LdCBJeDDpz5s1
	 D3EwKUxoZLn2FWt7/+WAZK+DuOX3M7t5hj4Pc8Kew33z0EjpLIfgI6H7Ltog9NhKIzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zUXPUVTF1qL884g1gyABOdRdndLFJ2a5C/YqjrenP3A=;
	b=svbBPIPkXq7N8qtONZUxsXwc3Pb/mbg4XenKjWGrPlY5V99tZ2gGtlpvIrmHoFNxBCxd
	 OIy4uARAy+R1FbgaMkjbNVMrkGYuD0sWwed+70fG3juybHci9KfpCVlUIPKBX/sAP8PxC
	 BYmnHf+OMdPb8GiOgFONLBFD6R+M25jqIZd5xunPLyBUUs5KzEyU4yjuRbntO4+I8c9Hw
	 LXWecXxBlVfEYUJ6ie4YeQxghvyqM/dTC4kb+xdfc3gWY9yH5UDDua2fNotKv6clFX7Yt
	 ymll0N1CqwlRS3+qFE86TzZZa7OCg3eEgdebRTT3BXpPP4GybtEPPpiSGcPS/dMySIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w5OaUwmq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8DC606A338;
	Wed, 18 Nov 2026 21:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w5OaUwmq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C051F000C8;
	Wed, 18 Nov 2026 21:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036117;
	bh=zUXPUVTF1qL884g1gyABOdRdndLFJ2a5C/YqjrenP3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5OaUwmquALpIxFBSDZ8x3LphPb9sI2oXPhOoHMjYA3/m8p/EfD/aIBMV7H6gmraW
	 Bv2CU1WEhwyFd3LR9d/DfqtyhEli7AMKgnWLk0TNktWSM4gyfWVDRi9ZLrJR6PYvoi
	 MrLZcZTImosUYQWw1Mh0glk7BdV2t6OxrGcp2DDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0945/3318] hwmon: (coretemp) Refresh the temperature on the first read
Date: Wed, 18 Nov 2026 15:26:07 +0100
Message-ID: <20261118150347.941580796@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit e463cd582ca125e359ad1a66cb076434c14638b2 ]

show_temp() reads the status MSR only when the cached temperature is
older than one second. Commit 5c0e64dde80f ("hwmon: (coretemp) Remove
obsolete temp_data->valid") dropped the tdata->valid check that used to
force the very first read, leaving that comparison as the only trigger.

A never-updated temp_data carries a zero timestamp, which does not look
stale on 32-bit kernels: jiffies starts 300 seconds short of wrapping,
so the comparison stays false until jiffies wraps and passes HZ. For the
first 301 seconds of uptime temp%d_input reports the zero left by the
allocator rather than the CPU temperature. 64-bit kernels are
unaffected: jiffies starts at a positive value there and does not wrap.

Backdate the timestamp when the temperature data is allocated. One jiffy
older than the caching interval is stale under either word size, and the
first refresh overwrites it.

Fixes: 5c0e64dde80f ("hwmon: (coretemp) Remove obsolete temp_data->valid")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20260924-coretemp-temp-fault-v1-1-1884f0ff97d5@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index b8fc8d1ef20df..281b47d0e297f 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -491,6 +491,11 @@ static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
 	tdata->cpu = cpu;
 	tdata->cpu_core_id = topology_core_id(cpu);
 	tdata->attr_size = MAX_CORE_ATTRS;
+	/*
+	 * A zero timestamp does not look stale on 32-bit, where jiffies
+	 * starts just short of wrapping. Backdate it instead.
+	 */
+	tdata->last_updated = jiffies - HZ - 1;
 	mutex_init(&tdata->update_lock);
 	return tdata;
 }
-- 
2.53.0



