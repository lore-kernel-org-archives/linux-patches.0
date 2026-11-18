Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038235;
	b=h/Kk4iDJeiawyf0fLsqKWrm+jkMQRcPg3uQgW5LXblCQXxvvlNQtxmlvwXO+lDh/LLwi
	 jxp/o8+eoCFzL2jMbqGukJW6ewY5t4uxdfwi8u71w2Vv9rqQc1KP4C9BzH9HwPGlnKTtz
	 QMFbmE0iYpfXN5Kc2Aq1ykVoZ5OpfMnkv5YXemFsM4rqA+p1smRmdxePF3XXDknm0eSnc
	 2qinowk1idQt4hUeE+ZW97+GozL9Sq6H1flLlSXo7QIn7FFqzi0Gy5Rk8AcIGA36Uq1iA
	 jOZEWrQmmaOvHrqxKc68t0Z2ICD89fF7NUPnnX0q9R4jc2+zFG7n5uVSt1C+Dg9BVvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DeDqwDcwi7auKvNHCFN5vCHeh6ISkKPtkSwQpBnNqfs=;
	b=By36wRKxJFGn+NdKmz8BtOnHmMVr25VB5Kn7JRVHuPLFNA3kwmK3Wnnu94znijIFq4VJ
	 YNZ3WT/O5ZHxXHh+YZka73RKFWLnPW1i6HO5n0xnSaafurNpm+dUqtYQrQzNv5SnXHeVV
	 JYI4dsgzp2K8qbx9oXkM/LQfjIvPHTz5+k/7jhEcwbeTVJrxR5fJAk3I4kb45xTj3qbI7
	 AB5zGlz178qf1N0iDaXvXchcKQM1qJ8nG0sIULYCk3dkPzc7Fu1mjx8C410EBUybFFMkt
	 4duaNYZraBuguMvo9dR15+dTuJMsC0M5tz/mMdgjVSmn8n5PYJdlEwHB+UT8MgYi62w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n8vduw/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF85606A31C;
	Wed, 18 Nov 2026 21:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8vduw/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6361F000C4;
	Wed, 18 Nov 2026 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038235;
	bh=DeDqwDcwi7auKvNHCFN5vCHeh6ISkKPtkSwQpBnNqfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8vduw/AzayGNTpNQwwROWNcwqNhQMggYYlc/oslC6qJMC23CWdRmJOQf3Mb9PvJX
	 lca7W1JSB/4MbxGty8V5chmhOUUn6v6PqqM2I0/+vksN+pNo/NAdiukrvudyUk7eSp
	 oJRf9Rey/ejeZyp7P7JQo78OC6MSsI5WepXiTa3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1673/3318] coresight/etm4: fix missing disable active config
Date: Wed, 18 Nov 2026 15:38:15 +0100
Message-ID: <20261118150411.988249258@linuxfoundation.org>
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
index 593dcfe4c9457..55b20d23b505d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1078,6 +1078,9 @@ static void etm4_disable_sysfs(struct coresight_device *csdev)
 	smp_call_function_single(drvdata->cpu, etm4_disable_hw, drvdata, 1);
 
 	spin_unlock(&drvdata->spinlock);
+
+	cscfg_csdev_disable_active_config(csdev);
+
 	cpus_read_unlock();
 
 	/*
-- 
2.53.0



