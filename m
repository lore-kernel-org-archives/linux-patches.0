Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6891922F0B;
	Thu, 18 Jan 2024 10:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575204; cv=none; b=GzZZxaBqVuIGeZ3QlkHQ42YcmuoLCi3+AN3cd7rH7+ODzs/4eTjQVdxbDzt/Fz/nlgYE2FUSggaAQXehh+iqBW1yh2rZkE27gN30DGaeD10wrY+syy4NHdHMzQzzIwAOfmls845cldtulq0r330aTxaAOOhTSkT5DZMJ/lM538U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575204; c=relaxed/simple;
	bh=4C0GsuO7CnJ6cNDfsGqNmUYs4bLzsA/dwsjy1le5be0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=QEeU2VbopSDkrVxAVO3RTk2tKE2QePqB/INgoRARBs7kkHJyrUqZW4kcHMOc3eJF0CBNCf8YrpAnwyNs3f/g9ciODYqlTic4NRqWorameD0KLCfYyE3/fkB8FggqSJWBsU7YbcmNIyOYNOzlMt16oEToagzzXvHuFRxYaDIUoYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jmjp6hfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmjp6hfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6A4C43390;
	Thu, 18 Jan 2024 10:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575204;
	bh=4C0GsuO7CnJ6cNDfsGqNmUYs4bLzsA/dwsjy1le5be0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmjp6hfqg9snyud7rGrgd59KMDiZZ4BeLNsiJ7RJ3RUCoYHekif4p9aSiGDJ/6LUZ
	 EvpVp6HioNosf+uWesFko8MPkezo4V+XkmfLhftkXgjKYoTCxHqkhgPGKZY5cjOaZh
	 xqFAWmFeMforTIA4BY+py6BK08uRSVKs06HKod6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/150] pds_vdpa: fix up format-truncation complaint
Date: Thu, 18 Jan 2024 11:47:50 +0100
Message-ID: <20240118104322.244942359@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 4f317d6529d7fc3ab7769ef89645d43fc7eec61b ]

Our friendly kernel test robot has recently been pointing out
some format-truncation issues.  Here's a fix for one of them.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311040109.RfgJoE7L-lkp@intel.com/
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Message-Id: <20231110221802.46841-2-shannon.nelson@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/pds/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
index 9b04aad6ec35..c328e694f6e7 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -261,7 +261,7 @@ void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux)
 	debugfs_create_file("config", 0400, vdpa_aux->dentry, vdpa_aux->pdsv, &config_fops);
 
 	for (i = 0; i < vdpa_aux->pdsv->num_vqs; i++) {
-		char name[8];
+		char name[16];
 
 		snprintf(name, sizeof(name), "vq%02d", i);
 		debugfs_create_file(name, 0400, vdpa_aux->dentry,
-- 
2.43.0



