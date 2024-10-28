Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EB82AF07;
	Mon, 28 Oct 2024 06:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098079; cv=none; b=sUFkDlcVRwBAwg/4h5mJX/Q+OVUWi+U0TFN5fq8dctsmmrv3gFlBT5FvK2p9g+y5/1U7v4d6rlq6mKUrWcXn1DmAEgvQ/GbvFO11C3XX7SN2T0K1DTeHnxpIIkojPJeCMpx0NeA4LGnG54Ey04JAIkk/G73kLSLsYa9kRKKopRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098079; c=relaxed/simple;
	bh=6xkcYmchiQZMy2jilZ8+4UxyTrq4FrODIrmnzXE3Ia4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+nQCZqXagrzlSodUfwHvcyGdPeu4Ze1sHQNRoZZSYtGVYJPT5T5WzrjA96UwIGCvFEsGBPcTS9kNM/wZLlg6CyUeH3PAioca0/ihC0rYDYUz91o73fPeGSNoigMvGBdJuJxVyShhrv9jNsqEH3iQySSXGUBwCOOxmSaorDkjIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi3gporc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi3gporc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A3FC4CEC3;
	Mon, 28 Oct 2024 06:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098079;
	bh=6xkcYmchiQZMy2jilZ8+4UxyTrq4FrODIrmnzXE3Ia4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gi3gporcRr7s0hnAIF2cFLcfTAOIoVOd4JWXF+MH8L9z2emBDyBN/SR6s6fGsNdlw
	 FI3u0PmzeM8C9NOw8WLy3K4qIKxMD2CuZrVAUxMjT7wYcxHTcBuREUfCig9B2m+eFp
	 v1hVk/bGgC+f+VX27cndQ8yhVpH3oo82ODGI4LAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Li RongQing <lirongqing@baidu.com>,
	Simon Horman <horms@kernel.org>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 068/261] net/smc: Fix searching in list of known pnetids in smc_pnet_add_pnetid
Date: Mon, 28 Oct 2024 07:23:30 +0100
Message-ID: <20241028062313.737264311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 82ac39ebd6db0c9f7a97a934bda1e3e101a9d201 ]

pnetid of pi (not newly allocated pe) should be compared

Fixes: e888a2e8337c ("net/smc: introduce list of pnetids for Ethernet devices")
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://patch.msgid.link/20241014115321.33234-1-lirongqing@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_pnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 2adb92b8c4699..dbcc72b43d0c0 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -753,7 +753,7 @@ static int smc_pnet_add_pnetid(struct net *net, u8 *pnetid)
 
 	write_lock(&sn->pnetids_ndev.lock);
 	list_for_each_entry(pi, &sn->pnetids_ndev.list, list) {
-		if (smc_pnet_match(pnetid, pe->pnetid)) {
+		if (smc_pnet_match(pnetid, pi->pnetid)) {
 			refcount_inc(&pi->refcnt);
 			kfree(pe);
 			goto unlock;
-- 
2.43.0



