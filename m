Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042078;
	b=NtG+FTqcKO5VMtsz/hzKKNbSM5253+H6GVTIB6X76TTDm3bXPk8FVq97SFDnM1X5FQgu
	 HEFqP7tWWOPd5idH/BlcfjRV97VAvhfaRRWHe8U4YldBPwFSfLmsNnRnn4D1BO1FF8wl6
	 QdyydMgnwro3QxTxv33i2Ma1IzCGACUKjYAJFfeA8zrU3JsQ3Jl7k170Px5QEk32vhP/K
	 0zRszMs2JU3wbYH/2z/oKTj3aHfghAR6TQgw5BVOTebbtKgw9dE1PwrGzunggK70CQgIz
	 Xk58RHWpdJfL+y7j4fceZdq1OWZhCqEJWi6eLuqm9/8tYOul19emvlW/Bq2xo+bjSiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MpsjoJrrKQwdFVjRMsKjBp/VJADpWk95PMosaewx/FY=;
	b=d8pYVsR6OXuh+pe54+tlwXvpyVfbXJVOGmFmKU6oUAS+fLxAer2huy3GN93Z7FfcAFs+
	 ZN/dQS1NZ/0yLC2v+xyq7LiqxLcDOIlXdDO8LSrhQRgQOzXtg2IlIUVA2p4wyxl2gZGXI
	 /jWykOkVhKO5iDqGdQ4Y1Pjnheh/cYVsXSET6OoxaUVoxIb41KkCVKb0Q7fz+mlEDIWKm
	 ptxZRfQCQqbI2bpPFpYWow5QKc32sEWfIGItMEHQEncy5IjPZ8NjunYDc4oEsvw1I6BlM
	 c4qZltC7Ew2RUq1fa7sK8fw4C4Blhg8JJpuPcAD/tqWJU+rMbDyktujnRvZEBd/9KnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqCDDnQQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28027606A330;
	Wed, 18 Nov 2026 22:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqCDDnQQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A67A1F000C4;
	Wed, 18 Nov 2026 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042077;
	bh=MpsjoJrrKQwdFVjRMsKjBp/VJADpWk95PMosaewx/FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqCDDnQQiKWN11pp3siIoy/bpzdOBjkSVifiat0qAXVOWhNd2UqJmovgVzVzUZNPK
	 YSraJHD1u0APwZi+cZt7GJSZDYlK896EvL1EWU1+jM8ihme8nbQmdCkPKKZQdEMUwk
	 5hKMjiymL8IAdCF0KPwa+pJYPj6j5YySYgCS8Uso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3025/3318] RDMA/core: Free unpublished port statistics after initial-read failure
Date: Wed, 18 Nov 2026 16:00:47 +0100
Message-ID: <20261118150450.950920160@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d74bdcfa89fa45d3a506cddc37b3bf1b76cea0ce ]

An initial port counter read can fail after allocating its statistics
buffer and wrapper. Free these both allocations.

Fixes: 467f432a521a ("RDMA/core: Split port and device counter sysfs attributes")
Link: https://patch.msgid.link/20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sysfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 210092b9bf17d..254511d88ea99 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1051,8 +1051,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 					    data->stats->num_counters);
 	if (ret != data->stats->num_counters) {
 		if (WARN_ON(ret >= 0))
-			return -EINVAL;
-		return ret;
+			ret = -EINVAL;
+		goto err_free_data;
 	}
 
 	data->stats->timestamp = jiffies;
@@ -1086,6 +1086,11 @@ static int setup_hw_port_stats(struct ib_port *port,
 
 	port->hw_stats_data = data;
 	return 0;
+
+err_free_data:
+	rdma_free_hw_stats_struct(data->stats);
+	kfree(data);
+	return ret;
 }
 
 struct rdma_hw_stats *ib_get_hw_stats_port(struct ib_device *ibdev,
-- 
2.53.0



