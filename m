Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025180;
	b=lvpvUFqc+wJ3+tM6X55EyahiY8JAGB1k2n4ExhPouJ6/Qau7Z7eBdwkP2J9hEkkPQ7u3
	 qH7QHCsmej15s/KrEWr6rHqXhjuhUJ7/AuQpIfxXS+VjkzYcFjstPo5InGCSn4Pe7TPta
	 bKrl3PDXNxp9PswHWZ0FTSOqi5EATZtA3iKdGHW04ftoKKhcGLs/kagaKqqxbPPMZIyCH
	 IViJ5NJAD/HVT/d1h7JLVhNhTZhO1+IRqEe39jXCTaxdyvmtJV3a+xvISfertIMaFi9KI
	 bfWJ9XjOjQIxqI+UWw26/hKuh26Qvo7g8qBYLQs3wL4h5jZVeIzPfFADAwBNATNzDmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pyhr3Q3kaO4BjYirR1Y8RnAX+QpQMj0sXujuluZO3iU=;
	b=efr1PaLlcpWK4oY63cx7SoOhWZ9+f0Xs1Dn7N3EN/QnDTJa6soR37ZFo45ot0yMHvPES
	 YRr+dleqfM6GgL5LllEi4r451i4RS9bSjHT4A9Lf6rgBxX+y7+L9b66GgTLoHk6hgPdCq
	 6nG9iikFlE1/0mrkf3MU2hMrrDc8dduGtbkbzx6W94MPI9ao1SwbbG+Y4i6p4uvwPlB+z
	 kogPgUKuQFg8WpLNImqkZZ+dJCfwvcRyIHd+IWlk2+SrK8PT7Coj6HSBP8MWaeqKhHZs3
	 2rZVlRzUwbsAMaIn7djvzj4iTH1SuesiD9ulaC0Lkst4zI5OL8JgCojcgh9mWrGbVyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p/jZ07aY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD8D60A2600;
	Wed, 18 Nov 2026 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p/jZ07aY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C481F000C5;
	Wed, 18 Nov 2026 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025180;
	bh=Pyhr3Q3kaO4BjYirR1Y8RnAX+QpQMj0sXujuluZO3iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/jZ07aYkjGqJOBPH+TjQilVoJ+B5+UqLWQCV54v582JXLt3hfj8pEp/4ByR7JpYi
	 G0Jh96sxJazNzI9sZLvawSQtsWRQhNjlbg6UK7tSp0pm8l/KNBWLYZ6+g5ltz8kVHU
	 I42HZYQlDDBeRyEWxCK6xvlREAd2EoJujNU5v7P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0989/2151] coresight: etm3x: Set active path on target CPU
Date: Wed, 18 Nov 2026 15:45:24 +0100
Message-ID: <20261118150158.492889611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit bc9907750718cdaad85870c93f2c72db5c85e345 ]

Set the path pointer on the target CPU during ETM enable and disable.

This ensures the device mode and path pointer are updated together and
observed atomically by the CPU PM notifier.

Tested-by: James Clark <james.clark@linaro.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: Jie Gan <jie.gan@oss.qualcomm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260515-arm_coresight_path_power_management_improvement-v14-21-f88c4a3ecfe9@arm.com
Stable-dep-of: 950cca5352b0 ("coresight: etm3x: fix inconsistencies with sysfs configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-etm3x-core.c  | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-core.c b/drivers/hwtracing/coresight/coresight-etm3x-core.c
index e71a6fb36fabf..258b6311f5c79 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -436,6 +436,7 @@ static int etm_enable_hw(struct etm_drvdata *drvdata)
 
 struct etm_enable_arg {
 	struct etm_drvdata *drvdata;
+	struct coresight_path *path;
 	int rc;
 };
 
@@ -457,8 +458,12 @@ static void etm_enable_sysfs_smp_call(void *info)
 	arg->rc = etm_enable_hw(arg->drvdata);
 
 	/* The tracer didn't start */
-	if (arg->rc)
+	if (arg->rc) {
 		coresight_set_mode(csdev, CS_MODE_DISABLED);
+		return;
+	}
+
+	csdev->path = arg->path;
 }
 
 static int etm_cpu_id(struct coresight_device *csdev)
@@ -494,10 +499,13 @@ static int etm_enable_perf(struct coresight_device *csdev,
 	ret = etm_enable_hw(drvdata);
 
 	/* Failed to start tracer; roll back to DISABLED mode */
-	if (ret)
+	if (ret) {
 		coresight_set_mode(csdev, CS_MODE_DISABLED);
+		return ret;
+	}
 
-	return ret;
+	csdev->path = path;
+	return 0;
 }
 
 static int etm_enable_sysfs(struct coresight_device *csdev, struct coresight_path *path)
@@ -516,6 +524,7 @@ static int etm_enable_sysfs(struct coresight_device *csdev, struct coresight_pat
 	 */
 	if (cpu_online(drvdata->cpu)) {
 		arg.drvdata = drvdata;
+		arg.path = path;
 		ret = smp_call_function_single(drvdata->cpu,
 					       etm_enable_sysfs_smp_call, &arg, 1);
 		if (!ret)
@@ -585,6 +594,7 @@ static void etm_disable_sysfs_smp_call(void *info)
 
 	etm_disable_hw(drvdata);
 
+	drvdata->csdev->path = NULL;
 	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
 }
 
@@ -609,6 +619,7 @@ static void etm_disable_perf(struct coresight_device *csdev)
 
 	CS_LOCK(drvdata->csa.base);
 
+	drvdata->csdev->path = NULL;
 	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
 
 	/*
-- 
2.53.0



