Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E297778276;
	Tue, 30 Jul 2024 16:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357947; cv=none; b=ZLgAP5SEVd/WFeNGOiqzMOhKaCDmbgd26QOaoTIzT+i1dkZw6P1thheR98+8/cZ4NjhvuZ5spwPD7/7VJ9i3r/tArGpdhVPCF3T89TZibwr6zIHH4TrA5s4doESPnI8N9na+Ds8JGJvjj1f3ucJKYtE1qKGMBpIbDH0l+PoulME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357947; c=relaxed/simple;
	bh=P8FgoCmZJrF4tzeRomy1cUWWmUIqmt4mX8+5GgJtYxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqQ/PLU/eEa08BEGJg+RnzR7Ce9FYQDtrLM2I+GEAaC0euZV9l/nCbOD2VOwLUcEsTpw5+arcoEHdBFseqj4maI8aL/+P2ucUXcS41Wz4lSvk5MYAnt5XWQkuSX5FtIBlcH6HPrMnYL9oN0CqkhtKgAmoHGvh4AUfFOIqsXlua4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8utiGXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8utiGXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B6FC32782;
	Tue, 30 Jul 2024 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357946;
	bh=P8FgoCmZJrF4tzeRomy1cUWWmUIqmt4mX8+5GgJtYxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8utiGXEndP7WFCUlZ5lcZeWGzx0MR4uqgkNx6ZRiZVhGuRSPI0yqUq5NeCaaPCOo
	 kSkz0eua+2DW5sEpvsdhYcc5j7L921aVYFIGtYtxDrzUP5nyllI7yxDOWkMjT8q8XE
	 OHCAByVxAqGqIPuy1vWk0JElw6JluQhOWMO9slSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/568] RDMA/core: Remove NULL check before dev_{put, hold}
Date: Tue, 30 Jul 2024 17:46:53 +0200
Message-ID: <20240730151651.835201557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jules Irenge <jbi.octave@gmail.com>

[ Upstream commit 7a1c2abf9a2be7d969b25e8d65567933335ca88e ]

The call netdev_{put, hold} of dev_{put, hold} will check NULL,
so there is no need to check before using dev_{put, hold},
remove it to silence the warning:

./drivers/infiniband/core/nldev.c:375:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7047
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231024003815.89742-1-yang.lee@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 2043a14fb3de ("RDMA: Fix netdev tracker in ib_device_set_netdev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c        | 10 +++-------
 drivers/infiniband/core/lag.c           |  3 +--
 drivers/infiniband/core/roce_gid_mgmt.c |  3 +--
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d1b5908c70cdc..e70804d8de828 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2174,8 +2174,7 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 	spin_unlock_irqrestore(&pdata->netdev_lock, flags);
 
 	add_ndev_hash(pdata);
-	if (old_ndev)
-		__dev_put(old_ndev);
+	__dev_put(old_ndev);
 
 	return 0;
 }
@@ -2235,8 +2234,7 @@ struct net_device *ib_device_get_netdev(struct ib_device *ib_dev,
 		spin_lock(&pdata->netdev_lock);
 		res = rcu_dereference_protected(
 			pdata->netdev, lockdep_is_held(&pdata->netdev_lock));
-		if (res)
-			dev_hold(res);
+		dev_hold(res);
 		spin_unlock(&pdata->netdev_lock);
 	}
 
@@ -2311,9 +2309,7 @@ void ib_enum_roce_netdev(struct ib_device *ib_dev,
 
 			if (filter(ib_dev, port, idev, filter_cookie))
 				cb(ib_dev, port, idev, cookie);
-
-			if (idev)
-				dev_put(idev);
+			dev_put(idev);
 		}
 }
 
diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index c77d7d2559a11..66c7e1e6600dc 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -93,8 +93,7 @@ static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
 	slave = netdev_get_xmit_slave(master, skb,
 				      !!(device->lag_flags &
 					 RDMA_LAG_FLAGS_HASH_ALL_SLAVES));
-	if (slave)
-		dev_hold(slave);
+	dev_hold(slave);
 	rcu_read_unlock();
 	kfree_skb(skb);
 	return slave;
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index e958c43dd28fd..d5131b3ba8ab0 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -601,8 +601,7 @@ static void del_netdev_default_ips_join(struct ib_device *ib_dev, u32 port,
 
 	rcu_read_lock();
 	master_ndev = netdev_master_upper_dev_get_rcu(rdma_ndev);
-	if (master_ndev)
-		dev_hold(master_ndev);
+	dev_hold(master_ndev);
 	rcu_read_unlock();
 
 	if (master_ndev) {
-- 
2.43.0



