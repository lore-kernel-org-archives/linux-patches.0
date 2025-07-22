Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902A72EA475;
	Tue, 22 Jul 2025 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192502; cv=none; b=c6IbiG2JIt3JvxRH9FvLh4h1m8lpiRzYfRklgaXEUzAxr/okETK++nhOFgcU/JpEXe2ke366Ape/paLMq4bziA3EVxjIBIL/flHTbTlgm0XuKKhTHKS/PLWKU9iiU/V2ubGdkbPiqqip7EgWYC9HCWtEBNREBAVHUJ9eIfefRwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192502; c=relaxed/simple;
	bh=TRub+0L+zp90wtzTLoLKLobOCTNt27kh5VRUMGwkCbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJJIwudC0bNuYvPdsBfZgw6HYEwmzUZR5fYbvKCPekIHRpLlIavU5e+jtNk7UDyTWW+FPQs7BPBSCTp9Dq7EpUAi7Ug6RmICJQ31YiHL3WjpnPzt/dmb1IloLiWveRJyDsQjqNPady/GyOYKnmpQsQ/ApMv65riVMTFO+9OoVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjHF91RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjHF91RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4018C4CEEB;
	Tue, 22 Jul 2025 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192502;
	bh=TRub+0L+zp90wtzTLoLKLobOCTNt27kh5VRUMGwkCbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjHF91RT/BCiGq84TL+x97w/WklD5KOTa9TOzObYiBKg8HqmVw5+FyaunaXMjyxH0
	 +SaiKkb8WUgr2O8Pa/fEe9qxSoQPuQ3bL4YBD6B4tb8CqE0bSwoyYjXH4+UgyBWc+w
	 OcRkugmwYDLyiEjQ4UOd7NV5UoSNRiMYDLSZ8n9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cathy Avery <cavery@redhat.com>,
	Li Tian <litian@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/111] hv_netvsc: Set VF priv_flags to IFF_NO_ADDRCONF before open to prevent IPv6 addrconf
Date: Tue, 22 Jul 2025 15:45:00 +0200
Message-ID: <20250722134336.567705240@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ce6ac26131b34..f33f9167ba6b6 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2313,8 +2313,11 @@ static int netvsc_prepare_bonding(struct net_device *vf_netdev)
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



