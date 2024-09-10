Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3B918B49E;
	Tue, 10 Sep 2024 10:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963683; cv=none; b=ro8pbKbfvsQ3XKgc82eSaE6EQgMKtITh3VSJ3DoyZ+7WEu1E453NWYcBTZMqpoF8FuBHNrdXxvU5spCpns3XJR0JtXAUZ7bMs3am2HnsKA5KJcLnP/DRj2G2P//VnTSnTtLa34NhDRZtVYLWs87rg4s6iWx7xcap0YUeapruGhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963683; c=relaxed/simple;
	bh=VH43cKNXBiCALqv+thLTN0zRwpNypn4g8wyZDK85kyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErArQ+8ElpPJ2pVZD/fBdjWuM0qSTz8L+mYtrnNMQe1DoFJ4Q4w/RPYeQ5WNzLevPJhy3vm1aKB7McHlXnTNIYivqHDjh3hgW5R/p6uCddrdxceXepVNtxUw/I8jKjEGNkP2ljPD54i7EQBAsIdReD2Ua6YPnuiKrRDgXVoV42I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grqTFZJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grqTFZJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BF2C4CEC3;
	Tue, 10 Sep 2024 10:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963682;
	bh=VH43cKNXBiCALqv+thLTN0zRwpNypn4g8wyZDK85kyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grqTFZJcRyC4s3iJuIrcmcenm8bG3pXE9savvOZlUSmbrAOMTuAtA9pFot6qSkFDi
	 dsYM7HslsJlm+7C37grUvTk3LLG4irdH+9iURdcG7xcOxrD3F0+fSdzthz6V9ras28
	 D6EA3QXRHGiDom/Htu7ZndqlElyCwykiJ73GtBWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/214] devres: Initialize an uninitialized struct member
Date: Tue, 10 Sep 2024 11:32:42 +0200
Message-ID: <20240910092604.480162082@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 56a20ad349b5c51909cf8810f7c79b288864ad33 ]

Initialize an uninitialized struct member for driver API
devres_open_group().

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-4-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 27a43b4960f5..d3f59028dec7 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -562,6 +562,7 @@ void * devres_open_group(struct device *dev, void *id, gfp_t gfp)
 	grp->id = grp;
 	if (id)
 		grp->id = id;
+	grp->color = 0;
 
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	add_dr(dev, &grp->node[0]);
-- 
2.43.0



