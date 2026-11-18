Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028092;
	b=MjpBToApfV5Vki/flS182ifP9QU7m0nuXkRGS+RpTerpBymRplRSAeGGqdxXau4Wo0TC
	 qD/HE3e2rWx2/rigw4+bgyHBaPs9YpBSn+loO5hBkJBM07Satv6OIWYX742Tvdkd3Eerv
	 zsEV4VvyyeRyHOUa0UgOJsX1TG7pqARLP0v6QbU6kXpZqJ+w9ReD1mFDoq+ocSIclSq9U
	 Peq2AFwnGDcyjMrIFE2vVXgCWbop3D3XWY1BLSVNUWK3tbxgZ/B2JJPGV9EiOxfF69k8u
	 Lq3GhaAqtsSUqxp5uTDc1DvYrebSzImu0FEYxLIS1FaKCb4VyPZMXTi4yGYDWAHvSJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHrzwPQuPNQQMxFKCmf3L7TDZ9PksKXDJS7BDujF89Y=;
	b=cuZgwIMPBF3OPxLTIq0A74USgs6DgJGKC+uxywFfg050jJ6CkNuQt26rh7n2OS6VH7sQ
	 eM8CVQdO7yt/mQn/Ooee1o5N+yicM6PSmA9WR7HrvC3Lt2ON6upjfXYf2hqQuE8h8KAMk
	 8LK2XMFN6+x0wG8yrTKScWzSfUgL+oXhuzv/C4XWm4tV9lletV4KNsaStDH5gQs3Vdfc6
	 D0IFZ6WHi/Ps8wmYa7guJYVEW2Gxuyao3rGK9NUcpBRln6twK+7mWihuo6ypB2Z2YH3FG
	 pnQM/YaRSzklmxEO6+kKb7IeWPKV6W6SgfsBeh/tHUzZCY3cEFHlYHCwI7dS2KNXSPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLdZWETJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87D8606A31C;
	Wed, 18 Nov 2026 18:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLdZWETJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C86B1F000C4;
	Wed, 18 Nov 2026 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028092;
	bh=dHrzwPQuPNQQMxFKCmf3L7TDZ9PksKXDJS7BDujF89Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLdZWETJK2Tf6ZPJI7Sr5v6b5vPikKxY6mohWv6gO4aae/mtlSIHKwlKxUxWYAoeL
	 CkST3Jw8rQ4JeVeyXqlUfVhGy1eBBxkzvCYfilSHrQjUfJMhCseeHYh1jF3WYbU+O1
	 49Nsxq+We29hNn+NW1BPqtMUjyinhWkvgpJrl7p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Qing Zhang <diasyzhang@tencent.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2022/2151] nvmet: protect nvmet_ports_list with nvmet_config_sem
Date: Wed, 18 Nov 2026 16:02:37 +0100
Message-ID: <20261118150235.392360727@linuxfoundation.org>
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

From: Qing Zhang <diasyzhang@tencent.com>

[ Upstream commit cead6beb89256ae7145b65fbe8e8a5fedba4a47c ]

Readers of nvmet_ports_list (e.g. nvmet_subsys_disc_changed()) hold
nvmet_config_sem and assert it via lockdep.  The writers --
nvmet_ports_make() and nvmet_port_release() -- do not take the lock;
they rely on the parent directory's VFS inode lock for serialization,
which is an implementation detail of configfs and not a guaranteed
contract.  Align the writers with the lock the readers already require.

Also move list_add() in nvmet_ports_make() to after the port is fully
initialized: the old position published the port on the global list
before INIT_LIST_HEAD(&port->subsystems), so a concurrent reader
could traverse uninitialized list heads.

flush_workqueue() in nvmet_port_release() stays outside the semaphore
to avoid a lock dependency on nvmet_wq.

Fixes: b662a078576e ("nvmet: enable Discovery Controller AENs")
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 61b4e90f4e34d..5250a517da8bf 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1984,7 +1984,9 @@ static void nvmet_port_release(struct config_item *item)
 
 	/* Let inflight controllers teardown complete */
 	flush_workqueue(nvmet_wq);
+	down_write(&nvmet_config_sem);
 	list_del(&port->global_entry);
+	up_write(&nvmet_config_sem);
 
 	key_put(port->keyring);
 	kfree(port->ana_state);
@@ -2052,8 +2054,6 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 			port->ana_state[i] = NVME_ANA_INACCESSIBLE;
 	}
 
-	list_add(&port->global_entry, &nvmet_ports_list);
-
 	INIT_LIST_HEAD(&port->entry);
 	INIT_LIST_HEAD(&port->subsystems);
 	INIT_LIST_HEAD(&port->referrals);
@@ -2086,6 +2086,10 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 	configfs_add_default_group(&port->ana_default_group.group,
 			&port->ana_groups_group);
 
+	down_write(&nvmet_config_sem);
+	list_add(&port->global_entry, &nvmet_ports_list);
+	up_write(&nvmet_config_sem);
+
 	return &port->group;
 }
 
-- 
2.53.0



