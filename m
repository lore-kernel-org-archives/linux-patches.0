Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212607;
	b=YTcaYTDg8F5O10hZcIu6kdorwbP4rRbviz29hwuhR2G6gosz9eZaMrLvoFiZFzeToZdC
	 kfws9nfmpJrS5WuWiC2pacnOGH1oWZMsauHj3ENr+C4gMyU/bulDa9vEr2plQDEeEKTrE
	 oPhHJgwY2I0t92TSlvD9L/Lz5TPLXkbzRcRzVz4hq3WQ4WkyGveqhakLWW7vHQn4aUujP
	 AMqTjWhne+Is8yvdkHS7aE9qTjJ+1koblcCF3B0Zh5PYT3ksw8mpiEtFkdZj4RMgCnKh0
	 5SuOlqxOHZkjWc/vWb1E/2GxP1xcauekOZq9usmjIA37ci9gx6TEAT/CJvqYG3xDjTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YaIQoT9yWr6muFWgESxP4GW/JZmk5KuaefvaXoQsZ88=;
	b=zQnzZnoBjll1+E47W5q20C9KHrP+KJE0FDYlchtyp82cIWdhww1C7JDkrOSxVAM/G3rl
	 N0i5gdgmqMK4mC7dVHNx5ilQlk38FOe7T9LADrOik9sTUqFbX4V/E5axtxZeUn3vCLR8W
	 liUdBazB2/4SCqE41WefjDXtOLOnkXaj+LgpN+SzEAuGUMm0jNbN9/LKw05sSHVMnzZnw
	 MZTsDt3q0VGGb3X1zPZMyQcrvnhSh1JF27AAA1QqTDnYyTiLHcoZQZW9bUapYuRk/XSu4
	 nMLuG0eZJGDSsxeSt27mn7oPjM0tPmxZGapUrwYabdXE3uWQpX3GLnlnpIXQNq/9hjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8ho018P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7144606A31A;
	Wed, 28 Oct 2026 18:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8ho018P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019591F01825;
	Wed, 28 Oct 2026 18:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212606;
	bh=YaIQoT9yWr6muFWgESxP4GW/JZmk5KuaefvaXoQsZ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8ho018PFZ6osaLQpVTp9b9sjh/Qd5w6oablD+XqgrvkbLI4r31PuFqRu3Ik2IDgj
	 HA+qVzMSRtt9dhPEx+lZXRS8brVyxB72v6JdZapqZGH92khnd6qGhPvTXNrPji3rAW
	 Mmk2QlupKZBeK0Cb8OMEDHxHMPu4Jz4Te8R066wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0214/1887] mtd: call external _get and _put in right order
Date: Wed, 28 Oct 2026 17:38:30 +0100
Message-ID: <20261028170504.103430343@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 79c4a56250216991f1d965ee26dcd273376e4e91 ]

MTD provider provides mtd_info object to mtd subsystem.
With kref patch the mtd_info object can be alive after
provider released mtd device.
Fix calling order in _get and _put functions to allow
mtd provider to safely alloc and release mtd object.

Execute:
1) call external _get
2) get_module
3) add internal kref
in the get function and opposite order in the put one.

The _put_device callback should be the last in put
as the master struct memory may be freed in this callback.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230620131905.648089-3-alexander.usyskin@intel.com
Stable-dep-of: 12b31d1acd20 ("mtd: core: call _get_device() with the master MTD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 565b948c99dda..ebe53a4f5d580 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1209,21 +1209,20 @@ int __get_mtd_device(struct mtd_info *mtd)
 	struct mtd_info *master = mtd_get_master(mtd);
 	int err;
 
-	if (!try_module_get(master->owner))
-		return -ENODEV;
-
-	kref_get(&mtd->refcnt);
-
 	if (master->_get_device) {
 		err = master->_get_device(mtd);
-
-		if (err) {
-			kref_put(&mtd->refcnt, mtd_device_release);
-			module_put(master->owner);
+		if (err)
 			return err;
-		}
 	}
 
+	if (!try_module_get(master->owner)) {
+		if (master->_put_device)
+			master->_put_device(master);
+		return -ENODEV;
+	}
+
+	kref_get(&mtd->refcnt);
+
 	while (mtd->parent) {
 		if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER) || mtd->parent != master)
 			kref_get(&mtd->parent->refcnt);
@@ -1320,13 +1319,14 @@ void __put_mtd_device(struct mtd_info *mtd)
 		mtd = parent;
 	}
 
-	if (master->_put_device)
-		master->_put_device(master);
+	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER))
+		kref_put(&master->refcnt, mtd_device_release);
 
 	module_put(master->owner);
 
-	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER))
-		kref_put(&master->refcnt, mtd_device_release);
+	/* must be the last as master can be freed in the _put_device */
+	if (master->_put_device)
+		master->_put_device(master);
 }
 EXPORT_SYMBOL_GPL(__put_mtd_device);
 
-- 
2.53.0



