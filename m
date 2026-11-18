Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058318;
	b=PCeEWYJPkPOdJLuqRex+Rz1k+gRDJicacYpSPx69yYn3/V6U5xNApV4PfzRla/Jb7wat
	 8BixRrHJQ2FIUg9TewztzPAFhSC5lAFPrzEJGzelklBa/M7fCVeQ6oZ+U+B/4kO8xXERP
	 NAFkL+8HU+y5j9NjcQIO5QM72MDvPlsHhGFX2+BolKt3dhJmZY0+B4CJMXtQ72C6t4VHe
	 mjMTMCNHsS5Idz+OJ95FRoTfwe+cneDmgejCW1GL8zT9xt5vD0BdUBgLbYxCJzpPQ+5xq
	 ExDMDpqxgr9RvMRTu2OUa2/0m7Iqv4S6BtS3vgiChfyQ4lbQG5JB6U9CfEq08IPXd4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dPRUbqU5Hfy95nNZTAV/y0KTSan9ZIXSiE1fdelo+aM=;
	b=JGkDJ5MbXCrB+YGDgqY8HyYDrC7aPswrJBjiEsEhG9ZKVrEzzV2/fRBd+5XlYQPtTyw/
	 09Fqixm6p3bzBOJqd/gnjCUtQNCH+D8FHdJ9ro+o0G8UZjEIlDf7J8KnxoMQQPMU8Xbml
	 1uhV3lQOZLAOQN7yB5cmD/AJ+0H5HTU9PFTspGAhju3ye87ZUHJDGOhKNMO+VCFc9UaS0
	 eOnfiI3u9Krj+KFr3l6WdH7ItqNCinxUgsVregjut5I6gZKFZL/zzUpUy2djMaBj7fZbo
	 sK70HGhshMJWqDKKBqwMgDo72h3+oPItvAdjltHcv6SloTLmTmOg6a4UDW+0h+rXfIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/t5IJvg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A2A606A32A;
	Thu, 19 Nov 2026 03:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/t5IJvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888901F000C5;
	Thu, 19 Nov 2026 03:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058318;
	bh=dPRUbqU5Hfy95nNZTAV/y0KTSan9ZIXSiE1fdelo+aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/t5IJvgDDRTGrMS/kI6yC+I72WoojqFJbbqBKnPkp/OmZo+jC57iqM0YrYN95Fub
	 W6vlKdhttkEjj25WQXZrmKGVXgrwinm7rkFoojPVvdWd6A5knN6vaheQQpO9TvvrRC
	 L5OIToOvmLHB9tlwKgVoshshuRQkQxpbTMyktB60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0401/1848] iio: accel: kxcjk-1013: Disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:40:39 +0100
Message-ID: <20261118145930.622976230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 1de1206a42741adfb72ca8b37dc71a6bc80cb074 ]

kxcjk1013_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 124e1b1d0924 ("iio: accel: kxcjk-1013: support runtime pm")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kxcjk-1013.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 55ba93a87dcba..e34efe7b68f71 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1457,6 +1457,7 @@ static int kxcjk1013_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
-- 
2.53.0



