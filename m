Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214261;
	b=ti7JdL9+mNcurFA6TWkZnSBDo6OLqeXb+xvgv8Vtbz7wKTCBbLV/2s2LzxunhgB7OvFl
	 5O9eWeVTXKbgqPrkJHk/d3BkDnTYoux+lkdxZ/jhn9UMy5v0D42y+/MZVtBROayK4f7+d
	 PLMEDJJAcMFtk4ntbwVIS+Xm6IFA/U7/9TjQl/2pNp0uf55U+du8UiXqabsaD1iA0wyRk
	 kMm1KgHwJxj7wPihxMti3G6/VKF2fWRdzM9z5VAqQOJ7kukiHbeSPsBxhIBadSKJnOCeI
	 D3uCN/HIQ/hoz7dZDmGut35p7lS3E/obQNgD/QwMNxZ6BQAu9Hslh44RK6DEVT3QPDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Buyyi7jJcWk/t41eRB2CmsIzvLgsWEyZj6QH5lLunu4=;
	b=B4lDwZmGLh8MTOXlaNx2+0wvd7jY/hKeEy37tZh3+54gCSl4TwqursXyNQF0vWWVXoXJ
	 ZhFkLoe+5MxDf1/Z55sOm07/4Q13K/sF4sfHZI33fS+ZpnZOf3cuHjNBGA1py99QXxPLP
	 0wrvBDaJJnGJj0srD7m7chJE12GQLVchgjjsn2TNRHpknQwQfc+2fbS1VegOFpZgngLF0
	 NPc4AYay6XpV9tOhkgHofExKWU74NOQbt3/WM0tYtnwTU7Yep8cwl7+DG3zH/UbpGP2Sb
	 mVZpx6+jznEcW9o66gF77Q62EY3rclm554xT1gaNQqnX+nrmshVrPx8I7/VRUboqFYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMbosS93;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB962606A32F;
	Wed, 28 Oct 2026 19:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMbosS93
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E90E1F01825;
	Wed, 28 Oct 2026 19:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214260;
	bh=Buyyi7jJcWk/t41eRB2CmsIzvLgsWEyZj6QH5lLunu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMbosS937c3cbaZG82JVEdNZWdxISpWg8UrEMtl/mTpimsLePPqEuJtLi7rzy+Ei9
	 iOTmbqbdc92GoCUFquFWnqZw3omHTUMMnBvIblX16x3QmC9+TMgOcAQuL3JTyiX/T0
	 OL8AYuH96c1zBqjckAGcyJs3u19Eu8P8fSpCXnx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0795/1887] coresight: holding cscfg_csdev_lock while removing cscfg from csdev
Date: Wed, 28 Oct 2026 17:48:11 +0100
Message-ID: <20261028170517.524180502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 53b9e2659719b04f5ba7593f2af0f2335f75e94a ]

There'll be possible race scenario for coresight config:

CPU0                                          CPU1
(perf enable)                                 load module
                                              cscfg_load_config_sets()
                                              activate config. // sysfs
                                              (sys_active_cnt == 1)
...
cscfg_csdev_enable_active_config()
  lock(csdev->cscfg_csdev_lock)
                                              deactivate config // sysfs
                                              (sys_activec_cnt == 0)
                                              cscfg_unload_config_sets()
  <iterating config_csdev_list>               cscfg_remove_owned_csdev_configs()
  // here load config activate by CPU1
  unlock(csdev->cscfg_csdev_lock)

iterating config_csdev_list could be raced with config_csdev_list's
entry delete.

To resolve this race , hold csdev->cscfg_csdev_lock() while
cscfg_remove_owned_csdev_configs()

Fixes: 02bd588e12df ("coresight: configuration: Update API to permit dynamic load/unload")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250514161951.3427590-3-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-syscfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-syscfg.c b/drivers/hwtracing/coresight/coresight-syscfg.c
index 30a561d874819..55f36ed1af13c 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -395,6 +395,8 @@ static void cscfg_remove_owned_csdev_configs(struct coresight_device *csdev, voi
 	if (list_empty(&csdev->config_csdev_list))
 		return;
 
+	guard(spinlock_irqsave)(&csdev->cscfg_csdev_lock);
+
 	list_for_each_entry_safe(config_csdev, tmp, &csdev->config_csdev_list, node) {
 		if (config_csdev->config_desc->load_owner == load_owner)
 			list_del(&config_csdev->node);
-- 
2.53.0



