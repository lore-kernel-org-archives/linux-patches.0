Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591400;
	b=1tnujOK6AYBXqIyrf1UYQ02D9PSs+zBEqcEXZjaCVZHaClnnCIZ5kADDAf0+qZ3OGnTN
	 j2B/lk22d7Veb9+3nCjwPO8S79kDFmyFV3gGjy7R1AJaczTU0Sg/xY/PKx7Kf3RnxvH/a
	 q4ReAMsER81aM4yRXVF/3GDteZ8wKnhJ1mJ98hedFD3cgW8V9BkgQV7W/4lDelvANQ8dy
	 jJIJM8tr0z4hRy3GWHNMRuL2Ak5aH4YtTpBOWsGgy4tiFdpRRGqt2nwO1yJ5z4wdPWzfA
	 X8pAsUKBpTuX69KiHtBiimwwqW3yiuWAsuiSZ3RYh+rkyDzFlal3dZPqv01Wl/A+ZHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fKT4iIPTvuMjgnO4uh4a+mY7pYITB0TUKnp3PZTjqZE=;
	b=guBEf/obxRTZIydwmgkmrmwV5RODtXD+jbsEYiGNrtscZLevYl3SNSow0514YXAaS5Im
	 9EXxg+GabuoNVZpq8POCwxrHQAhrEvZnQuuzUVJ4w+0HGymoMKAn/orbrZjD4itc/je5m
	 ajneJEQD9P7XFrQ+hwquN1zU6MPEGhHaXo5J334p9v0NEtk2HPh5fIrOezOXRA/RNx6Sh
	 pwP2Bva8PU0TBNJ5vXamh/QqQcMFTC9ycNwA/07WdF/VJUY0HMr0Y8FxLWxXNTQXarGjz
	 +oa5P8IGdxGz4lsWmRQX7+SnQbPON95SHDdk2w++fNWCaUXOq4RtT/GaS9oPdpcAtfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvJPcQ7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A396079D40;
	Fri, 13 Nov 2026 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvJPcQ7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC651F000C4;
	Fri, 13 Nov 2026 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591400;
	bh=fKT4iIPTvuMjgnO4uh4a+mY7pYITB0TUKnp3PZTjqZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvJPcQ7cPUrv1Ek3pfeNAdRuYCfPnO2Tk5o+aXnoosA+H2GYHByBNIuKqGcfE0TxJ
	 Szw20HNFU9w8914Y3ta7jiZ9LOAAD21wYw6kzlxKfD3aCVNQJsLkbTwgbhNHyo6Xax
	 RQZcc6it17AZU4IM1QzjJw+hmUjksPeDlRUIycYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 498/670] coresight/etm4: fix missing disable active config
Date: Fri, 13 Nov 2026 10:51:02 -0500
Message-ID: <20261113153828.844434811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

commit 895b12b7d7b8c651f73f57a1ea040d35aa7048cb upstream.

When etm4 device is disabled via sysfs, it should disable its active
count.

Fixes: 7ebd0ec6cf94 ("coresight: configfs: Allow configfs to activate configuration")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[ shuai: kept spin_lock()/spin_unlock() in etm4_disable_sysfs(); 6.6.y does not have the raw spinlock conversion ]
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 9127bc0255528..41307719f144b 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1082,6 +1082,9 @@ static void etm4_disable_sysfs(struct coresight_device *csdev)
 	smp_call_function_single(drvdata->cpu, etm4_disable_hw, drvdata, 1);
 
 	spin_unlock(&drvdata->spinlock);
+
+	cscfg_csdev_disable_active_config(csdev);
+
 	cpus_read_unlock();
 
 	/*
-- 
2.53.0



