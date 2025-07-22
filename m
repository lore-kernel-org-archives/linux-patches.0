Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770AC2E1724;
	Tue, 22 Jul 2025 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193628; cv=none; b=vDG/Qfo6BtrbBkbeUkiVtWqNAdfu5HHrgdcONIFpdnNIOH3EVBuAD/7MxV6YNm3kwEwwSRdr/8AIQg9Cap/cGoCnlCdfCo8QmoBmKeqSf1/FpTnQmTVvm9khlJx+GtLOUB1TXR1AqBNP5L+V1S6JA/s9pRGKI1/tQ9kgbj7P+EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193628; c=relaxed/simple;
	bh=Nw/Kdk5bAeWAzCSeC8g2QMYAkznsawCxEs3d5oDgjYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aiwp5Z+WVKl7oqrCYDncA/AZjMcb3P7sPDWyyAOMn1ZPhGANbzRJoaxOSCe+wO7UhjsTjiMYJtchCDZ9Z5luiycTvic+YNcmR3t6K2QGCTpyMpycA3r4xtcxMmWsh+Mnm/99QsCTAUWQOuAray4nnAX18KnwLdqqUW/kY2FbDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1LMFiWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1LMFiWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7E0C4CEEB;
	Tue, 22 Jul 2025 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193628;
	bh=Nw/Kdk5bAeWAzCSeC8g2QMYAkznsawCxEs3d5oDgjYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1LMFiWFneztmhj7ZJ1ECrZgJXW+YysbZbO5mxpRM8LTYAKjK1j39XfVinPZv1mcI
	 aT3VFN/3Bqr5xEhXJCC+CYOhSvrsIw5iTQvqdx/xePSlqjXA0253OaGTEBGtm3kJu2
	 LHhz1Kkl+jeHp6QS919kzEGmAhKQ7F/EGMnsArrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cathy Avery <cavery@redhat.com>,
	Li Tian <litian@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 150/187] hv_netvsc: Set VF priv_flags to IFF_NO_ADDRCONF before open to prevent IPv6 addrconf
Date: Tue, 22 Jul 2025 15:45:20 +0200
Message-ID: <20250722134351.376889870@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 31242921c8285..8c73f71051020 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2317,8 +2317,11 @@ static int netvsc_prepare_bonding(struct net_device *vf_netdev)
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



