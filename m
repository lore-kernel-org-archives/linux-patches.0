Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A048C2D8376;
	Tue, 21 Jul 2026 20:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666629; cv=none; b=GWWFrFiY/w1aLTkOeCQOn5dII/wQqoBs52TBqaBR6Eg21R50JQexusYE00hTunVmWiNrE7jA3woq8xCSzdYw7t1zSDWDT44cDBYuMAlu933xEcoWIynbUljKcS2Isomz8hYNnmoV2OcrEVJLEyoUKzVzzMQr671KkrJzl8cjTN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666629; c=relaxed/simple;
	bh=2HNQxIDbzIQhaSK6d8d6yXr5EI6sbm/RMtMI4jZNpmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekfCxX7FdX8nllJ7N5uT7jZ8fqhuRo4wVoVacPLJ2oPQ4SH6v5/EBP5+SUFpz6TxGNfgDn3UFd10wT3WiBb5gAOzQJeqabarHGZ9uHYSCQCaBn85bvlmT94TGvoQPUM5qpFasGj3mIcHa82A/fcWDsODMGUxEBDARZuI24ohu8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kp400HHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kp400HHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A8C1F000E9;
	Tue, 21 Jul 2026 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666628;
	bh=m72hCv1yseUlCVMwyHMsTuuVPjvIapFn0/dtKCGknc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kp400HHKt3enJtf4i/w0UIFYNEt8vRG8yVOU5YvCrZzngBsviKpZHTkoJIWpq7bw4
	 QUKA7ilMm1ckiTfus1IpJkmZcPRVT9GnhlPhy8rKvKlahh+LwqS3TCe89+eAzqJT1q
	 +OYW6fy3w819H9iE0aE6jCci54xhJ7mZn3YHQQQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0755/1266] octeontx2-pf: Clear stats of all resources when freeing resources
Date: Tue, 21 Jul 2026 17:19:52 +0200
Message-ID: <20260721152458.763892780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit fd4460721fb4062ef470ecdfdaedadfe7e415c09 ]

When all MCS resources mapped to a PF are being freed then clear
stats of all those resources too.

Fixes: 815debbbf7b5 ("octeontx2-pf: mcs: Clear stats before freeing resource")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1781636420-19816-2-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 3af58bc9f533cc..b288edd9e22db0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -213,6 +213,7 @@ static void cn10k_mcs_free_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
 	clear_req->id = hw_rsrc_id;
 	clear_req->type = type;
 	clear_req->dir = dir;
+	clear_req->all = all;
 
 	req = otx2_mbox_alloc_msg_mcs_free_resources(mbox);
 	if (!req)
-- 
2.53.0



