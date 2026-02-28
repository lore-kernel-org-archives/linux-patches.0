Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996413451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301828; cv=none; b=Yjdt6UlOwCXMdrlzYfo7Bkq2cGywzOWXT6tJ1mUyZe6jAZQ9/JsoDz+rb2QGtpjnR3HOgqOmfhgBtEa78uY7BfoF3LBY/oQlmWKGwQB0BGvGy7khrOl6PbnVogCij4UfjcMShO/yua5ImWtqfp6KL7J4MIsF/LoOtwLR0cbPnHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301828; c=relaxed/simple;
	bh=NtmnK/RlLk3nOBtBabRZ8UFh4I0YhkxhcunYppyqF2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYFitkkgshymNhBywywr/yCnNnFnPRuk4PuIMlCwV8Ln+Em5wHY3+J5aiRhVmsAv3tXhWjVKMlbfofL+ntHHHG7rd/b5LNgWHgJuaLbaSbPF9E7R2ixvGuX2v4HkuSFviQidudDvo+5PBnCJN+WsxNoMXJYSMnz/5/2HPDL4qaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rnse7/d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rnse7/d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BCEC116D0;
	Sat, 28 Feb 2026 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301828;
	bh=NtmnK/RlLk3nOBtBabRZ8UFh4I0YhkxhcunYppyqF2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnse7/d7oinZ5tEW4rPn89Hy5i6diifFR8oVXC9nxXD7+9D5CfdTLfjZbavJ4ePDD
	 +KwEOQKfDgC7DgTPoLEVccr4egaZ7uyMEm/RQmFjfGl+4VHAxdCShumwfzJsl/f/DC
	 TrsmJXt8b1Rp/QuIY9DvlOg3MtAcCwXs9Pm8IOQdAf5bp4DNA+WSmXPErRdSJueTby
	 ugxrt7SqJx9A6HB/tCyTAM9IvQgD5+OOIaOTT/xPfs06wWvxHMubm08go8xSC+tfEe
	 eEDgy2hLOHr3BFEPW/vsrbLOS5CfnvB+lJTcIz/q26jzgCOnAN+y9k4sxO17VWDCdB
	 TCAP9yZO8cPOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/385] octeontx2-pf: Unregister devlink on probe failure
Date: Sat, 28 Feb 2026 12:57:46 -0500
Message-ID: <20260228180011.1568201-244-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 943f3b8bfbf297cf74392b50a7108ce1fe4cbd8c ]

When probe fails after devlink registration, the missing devlink unregister
call causing a memory leak.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260206182645.4032737-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 5492dea547a19..2de9c44ef57c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3101,6 +3101,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_pf_sriov_init:
+	otx2_unregister_dl(pf);
 	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
 	otx2_mcam_flow_del(pf);
-- 
2.51.0

