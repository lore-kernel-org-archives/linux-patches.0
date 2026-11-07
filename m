Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064163;
	b=udGKmRGk3VoebS4wyoHnUfB6kNeGUJJR8ZtcgrCzftQrUvR+O938UWWARQRXayzlHbBN
	 Mdbyt48wfbj2RVDrjkTQ9kuQVEjCMbXL63Ir0SyFqV8xvlJoV3fkXGhl9kIZFK3rvbkbK
	 oerpfjNy6OohrvhtvqRHD2DlkhhwOs8yFXC01vZN4WG8W2MQDOz6MSeAOHUEo26oRc2+B
	 glsVNws0+Ypu7GL3mx66Y5XsJBtX30HFjMxRM5XffflPRK3nFIQG6Z7+TDwXZw6dFnnr8
	 D3rpwIyL8eRqg2zLcZg9iZVvCPh5KYu2X05EqQrUJ+tYCfcUn5Bhgk1rNXFT2MjAAlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ovw44pldXfShgBlioBErxV9VU75mhfmb6S2lY2ACOFs=;
	b=ztUUGatMWc9/OuFVMzsZYfxHYRzIqQpTOIvmr9TThdwOGHUqTtWMz/X9WlnLHs9t5XOA
	 4/Ocit11FTiI4COSGjeilmXUzXig6NHAH+0vWrpc5/d0Lpk21Rkb2MObS1qMrchQPeJe9
	 XiP0bAO8jHg/XmxqTlyM9KmzCAMCSEJQtJ0a3c5WvH8at74YjEYSUBo0vHgYEuUxtpZbp
	 1YHBCgPWsHkDkghHBsE5WuvLEc6M9Veiw8KtBkOo4cbr9ccYmxbDKlA1MQVUNYCwwUg2S
	 FAdubj1lUbv6CfgraXr9NfNqqaObGakD8wsTC8X7vvMPaTWOydxBQvbmAfhHseaMnyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+PzIrv8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882D0606A32E;
	Sat,  7 Nov 2026 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+PzIrv8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362A91F008A3;
	Sat,  7 Nov 2026 15:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064163;
	bh=ovw44pldXfShgBlioBErxV9VU75mhfmb6S2lY2ACOFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+PzIrv8SOGlrDbmalYjNVgyAbCPOgQiSYyrwTmZVAMs3b9jX6tIcFjuU2cHwZacv
	 TQc/Go2Rq4D1RF9s1ugbYXPHxFbywnNyMNr0ub8KdXjZUhnKtbMztpUZFNXHNh/ZiE
	 N1ga5R6SB3+cwvGb4jDMmtXwi9Ijy6DtsvGGew0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0311/1257] hwmon: (coretemp) Refresh the temperature on the first read
Date: Sat,  7 Nov 2026 08:43:27 -0500
Message-ID: <20261107134948.025466093@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5095eb0576805..ace51e08e72dc 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -511,6 +511,11 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
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



