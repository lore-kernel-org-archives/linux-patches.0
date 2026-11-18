Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033036;
	b=oHIOWf0aEWE8l/qaTlD/t2XHLEzsMOIX74+ZYzaUMbYHcsMzOplE23jEX6vmg2P0B17v
	 vB4hGJJ4kcbZR023+mMGfl9/ctK7t5QJG7n3kkz/CnL/y2e11QXpei7UxLZW0dfAwgXWn
	 P2+kOdOuce5xS9XZ/gxHpahZQwBl3lLoA456B6jtJZ6eMUfmFQxsoy0gcd2gM/IWEttHd
	 T7qCHd6NxZGWoXSE2+EOYZJld4seVrWGaP6KPSSlROitgx0dlny+ahCoqls+a5Ssin1rQ
	 T0NQ2Og/UMYAeXxTVYobnS1QBl+sLMQJbNBT+pOaEe+z7R4W3tIubIXUqcIZ+JFrF7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+rp6Iu9V/qVvnPl8a6VjqJZ1dB+ADdiqiSmplTg5xw=;
	b=0of6LwcdPqnPXcLzjZnesGONBuuZTlEVl4WI7UNA3wUsfj7rBhBtEz9M+c2TDI4bGAIO
	 ISIdSC1Hs8R1ITn3UEIDmBibcIjNYRGUAhEHnNg8qWVcma6ZdjyDVIpHaKCYD/blON5V3
	 htWsCx8qY6Ag2s1CJ7YcKd6vM2JklxYLqqFit1LGKzkS91EO9xBaoBAy/pli/vZeKDIVU
	 aW7UJJMJlj0OJH/Zmudz/2Dg03vzLhCuBeamhvgKcI7VSB1BgWeviF3sUphEF+vmpTm0R
	 X7XuXIspn1txKmX57/3ZKGy4LuMtFmRfURbQ80M9hByHZ6ZEheGTIHk2loip6q0jEjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/zDnd8U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75ED606A31C;
	Wed, 18 Nov 2026 20:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/zDnd8U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECE31F000C7;
	Wed, 18 Nov 2026 20:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033036;
	bh=M+rp6Iu9V/qVvnPl8a6VjqJZ1dB+ADdiqiSmplTg5xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/zDnd8UW+iIpYDvibdwJBOtx8pujRQgA+yIGbvgkqUlcKL1gTDB4sLvk6qxwCG9V
	 A3AE6AOPQBKIwqjo409zQPknGtHwEe5yCcY9m48gbsID5+oCDUITul3q+5UB4hWFNr
	 ciT4z0HKMtLgCCVAH8pfNgkeVbfbAiHrQd90TYIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Qing Zhang <diasyzhang@tencent.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1625/1756] nvmet: protect nvmet_ports_list with nvmet_config_sem
Date: Wed, 18 Nov 2026 16:02:32 +0100
Message-ID: <20261118150114.505391129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 0e12f800beb3f..7b0c04a3faf62 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1921,7 +1921,9 @@ static void nvmet_port_release(struct config_item *item)
 
 	/* Let inflight controllers teardown complete */
 	flush_workqueue(nvmet_wq);
+	down_write(&nvmet_config_sem);
 	list_del(&port->global_entry);
+	up_write(&nvmet_config_sem);
 
 	key_put(port->keyring);
 	kfree(port->ana_state);
@@ -1989,8 +1991,6 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 			port->ana_state[i] = NVME_ANA_INACCESSIBLE;
 	}
 
-	list_add(&port->global_entry, &nvmet_ports_list);
-
 	INIT_LIST_HEAD(&port->entry);
 	INIT_LIST_HEAD(&port->subsystems);
 	INIT_LIST_HEAD(&port->referrals);
@@ -2022,6 +2022,10 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
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



