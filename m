Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9333737222E;
	Sat, 28 Feb 2026 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301489; cv=none; b=mj/Xe5OMffXALdR5BWGB0LflC68ZzdtM8N5OrSawPqzcdCQq4grbJvM5MxZ8TIcZy7WFAaIkgFev1o4XunHJt+XMR+VldLzC+awa7lDDgvRHgpzc+0X64Gk4/aBV1HVuLLf5LLya46L1ytsH2jzdGWQyBt6hKJHaHo7scr1gUYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301489; c=relaxed/simple;
	bh=cJaY7sxMyezEaMfaclY1W52Lfoz5cuP/rvgYuPDkdnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD/EzE3cuZdE3C4j5H4dzlDkrusp9pNB5b4H9XeWpzXd4bNkU2Fg0j5GlWl6uVXdwa9GhED4RJ4Q6LiwT4WQ3c7Qw29pZMybSj/rcHF9idhcX9GKwrs8FVnegKwD21GCEFcRfq16aBUHCwundQ3JEj5YNvTWAQJodj+R8Fhlqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+6sLJBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+6sLJBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24ABC116D0;
	Sat, 28 Feb 2026 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301489;
	bh=cJaY7sxMyezEaMfaclY1W52Lfoz5cuP/rvgYuPDkdnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+6sLJBURhohUCeSOEbpAjSMoZNE3beo6y/6ylfQSWreLc/O/DGGjtEcZO7mnjGr8
	 +Xg9ofoOSdS4n6PMqaqmg85TCwAEKt5XqoD05d4OdZgYpNXDKg07ihS79/HFTFCY1z
	 txJGy+ZCEG0wW1ri95iXFRlyF2GWu7xzf+DM6IkYPOwrQhuOFV1st81DRjvGWEMr3r
	 F2aRdyfQM8Z7vlzTNRrebcqeLeO+3hl4nViR2v6KDUUAgSksMj+V6xllSKLwJ0ntk1
	 WJeidKv+5fDHuko8gu0srnBaOc7aCfVq0AdYUvQb9IjiVaNGQz7uiv14iob3T7e4u6
	 EG8FC36r/U9Qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 675/752] parisc: kernel: replace kfree() with put_device() in create_tree_node()
Date: Sat, 28 Feb 2026 12:46:26 -0500
Message-ID: <20260228174750.1542406-675-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit dcf69599c47f29ce0a99117eb3f9ddcd2c4e78b6 ]

If device_register() fails, put_device() is the correct way to
drop the device reference.

Found by code review.

Fixes: 1070c9655b90 ("[PA-RISC] Fix must_check warnings in drivers.c")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/drivers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 1f8936fc22928..427e1334f8352 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -435,7 +435,7 @@ static struct parisc_device * __init create_tree_node(char id,
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.coherent_dma_mask = dev->dma_mask;
 	if (device_register(&dev->dev)) {
-		kfree(dev);
+		put_device(&dev->dev);
 		return NULL;
 	}
 
-- 
2.51.0

