Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062146;
	b=KcTOv4Lb41hIBEuk5mIYE5tXs5yoI0G7A1f4AF7luBL7FwOddqFzDI8kf74OTM6MV9dW
	 80NgrfSOtKG82zaPIqmugmYqzUvF60HYgM1V4HM+/t9i+AXEFRg3L+WqkYzW8Qtj7+e/I
	 NzaMcKNngg+fibyODKP9/Ihnjo55UXNtQN+oDREr9N1D70e6UyyJQUGyG9gKzJ+/H7gHY
	 EmdZcTSjGc0h41jEnRIFB6hR25+9nmIydNO6BjdD/xlFE4VL1LiJ/3zfi5qmCVmpuRCSL
	 IVDltEw8GYJ8tTEQhV8n1Nqsgn9ZYErONmEQYIGv1jUsgCz+QyqUempCRqeiPVx4Beg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OgF2pmPiTAG61ntMiS3fTls6//FRyFPcFvIhbvu/JlQ=;
	b=3pPfWxBl1efrNl4X8oW0inLxHJ/JEKk1mHQrRfirnuSbzs/uM2P4y3xgQI5LUnxuTi+Q
	 uJ+BQPB8L2cxOiReGnrEZKyJmrgjmNAMztDvIzNgTCSWthRc1bAd95pMCK8jdfV/Oag3a
	 X42Oln2p3IoU2z1AqDgkuGwufjeZYGtAyaCch6FJI367GTnQ4mF8Yua2ErXGMc2BP4ksx
	 mZ0XfAImtufw2nOvbCU5Qg4si0xsObeCCCZ5G7TFbea6k8a7MJGBvsRk+31fSLeQX3Ple
	 7AfM21O8vPgty3wqjbZPqOFvky2dM1ybvOfiKIMDfObZ/0td6WCVw4fPOjbw9fPjcKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuzJ6+jv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16E9606A333;
	Sat,  7 Nov 2026 14:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuzJ6+jv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E80C1F008A3;
	Sat,  7 Nov 2026 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062145;
	bh=OgF2pmPiTAG61ntMiS3fTls6//FRyFPcFvIhbvu/JlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuzJ6+jvhc4ju3XzicXHKOhyt0Crmf+x4AApOms6n6NSOJ91hSdKxE2bexzZvT5qe
	 F1liB41FBce3J2nhAtYibkoBtJ7qusOnMw8Ido0jN1pGS4JJ9fTPu8rTdZVAFLgQ3T
	 7gC976egJleejjLeJ/cxwUi06+vxiqJSF4P+bhYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1074/1536] hwmon: (coretemp) Refresh the temperature on the first read
Date: Sat,  7 Nov 2026 08:51:30 -0500
Message-ID: <20261107135027.859590798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index afa481b08c8eb..e84ccf65b327a 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -517,6 +517,11 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
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



