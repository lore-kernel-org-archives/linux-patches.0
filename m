Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDCC23AB9D;
	Tue, 22 Jul 2025 14:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193024; cv=none; b=dhW2jbR4r3BWlBwQX3gdMHoowYa69a2gpd65qSajsuCbPTi612JlZb93PJSZ524x3ZyMjPAJN6f2r40GhnXrVVCo45Y2f4M3++K4i2WwjmmYPoI2xY3bfWirz6Z+FBXvVEuXrFSmdE35fZVN9J0068k6SrUj1/DLM2OAnqR4ZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193024; c=relaxed/simple;
	bh=JRzxEBunyE81RCTEiVJDY0dyh2VZiIePzvvATkjS9C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvgzNlY5Wc6466N/2tM62Oy/GwERUN56qc1ovYlJ1Y5UZuYwMmI+LkU/e2Qo3SIO1hvo9/DUGMBwDwza+a2wanQ0GS4OitUhIQLXjum6EROvHjnuyoW58xftW8q5EsexEeMMyBmtL8xgEx5FMRsFrTG5ztL6c/3b9X+r6vrbRiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKRWakBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKRWakBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B44C4CEEB;
	Tue, 22 Jul 2025 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193024;
	bh=JRzxEBunyE81RCTEiVJDY0dyh2VZiIePzvvATkjS9C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKRWakByn9ELwaWSLEa70pqXGYQhM+TbWkBa6KVkrHznozVvVrKUMmJtcLzyijQfW
	 JZCJ8O7QkiRLh6kUL5CTL8ZZqG2OwdbwK1W0HAqmudraBodOT6glErsHMcS+Jqmcju
	 Om5uIoEa/zRdM/+70dCa2fED6HBB4oxv1+ecajVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cathy Avery <cavery@redhat.com>,
	Li Tian <litian@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/158] hv_netvsc: Set VF priv_flags to IFF_NO_ADDRCONF before open to prevent IPv6 addrconf
Date: Tue, 22 Jul 2025 15:45:11 +0200
Message-ID: <20250722134345.472289570@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Tian <litian@redhat.com>

[ Upstream commit d7501e076d859d2f381d57bd984ff6db13172727 ]

Set an additional flag IFF_NO_ADDRCONF to prevent ipv6 addrconf.

Commit under Fixes added a new flag change that was not made
to hv_netvsc resulting in the VF being assinged an IPv6.

Fixes: 8a321cf7becc ("net: add IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf")
Suggested-by: Cathy Avery <cavery@redhat.com>
Signed-off-by: Li Tian <litian@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20250716002607.4927-1-litian@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8ec497023224a..4376e116eb9f0 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2316,8 +2316,11 @@ static int netvsc_prepare_bonding(struct net_device *vf_netdev)
 	if (!ndev)
 		return NOTIFY_DONE;
 
-	/* set slave flag before open to prevent IPv6 addrconf */
+	/* Set slave flag and no addrconf flag before open
+	 * to prevent IPv6 addrconf.
+	 */
 	vf_netdev->flags |= IFF_SLAVE;
+	vf_netdev->priv_flags |= IFF_NO_ADDRCONF;
 	return NOTIFY_DONE;
 }
 
-- 
2.39.5



