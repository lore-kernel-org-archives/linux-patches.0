Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030615;
	b=279USUh9U6YtE8fBWxOKCjn+h8njTC3pcGjdfc5mjjQ2LJLk9Ps8jEUE5ge9zGNVWpdW
	 ytNylYpmkuiwrqJTphYDsIHxZwlknOP4B2+Em/zA/zZ4txnYsfXR0pCC0ggx25/phy3JC
	 RZ/rF/hM84B/nPSV8D9N9NaIAyvoKVahglxX+5sHl48VWyVXSdQwklvAGI9qNYVFYkNeQ
	 YsWdK+lKEDU+GIVtb5hh5AyPwT5Gba6cG8HFEyAJbcBVvv1g8UKjNNjVC90v7GSSNf+7U
	 w+J/EU0olOfCooHQaaSXaOVlH3rCe/7xYTDtL0V4DwLK6VkcD+0bojxDMOC+0upqx6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aQgoIch6aE5xv8MQ7VwTP/Bbm9sdogWCtvmmMLQm9os=;
	b=sKEJzXZZ/LFBqn9hDBUF2IGdDQJEWVCdBDNPKTXqWYJ/2/lbXJswRiQNx2oKqPsab3fM
	 /P7IdM1i5PYTKl3mys62oCZAEPlK8eHmXl0wzxy21vaqmT8aft7Mz46hpWkqikHIKRrg/
	 PINyfQBaF0F1DNcGBLCNoqFeTZcQS0Z54ZESA2PeCoG+FG9lzx9ad2DQ11JPZq+dqX0Dr
	 /Y3hKH/hdzNB0vEb8Os0THE9IyRglLgoLVYN0he+l7dO3lzO+pRWJ9pjyE8M8OZvqBhIT
	 Lz+sW/Rahvf70IfpHlTj1NerwJ9mbc+Cy4yOYHWwnXcPWSvUs02bdd7yT4zvuuOqvgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnfKtFA5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B575606E7FD;
	Wed, 18 Nov 2026 19:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnfKtFA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB9D1F000C4;
	Wed, 18 Nov 2026 19:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030615;
	bh=aQgoIch6aE5xv8MQ7VwTP/Bbm9sdogWCtvmmMLQm9os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnfKtFA5vQ2sGdT5kiexf2gVBx1bVexVfuwkY3VxKD+5VL3DF9Nimh5F6gi7kBxYd
	 ewfQ9EjRGhApzf+7CrjDAT4aCp2AKpevSu5oceTh6mmiA4liPWc5/AhOq5NdeVu1a1
	 fQh3TmCHoXAS2spDde+SYhz0QM7+mqbXwgDGxc0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0767/1756] soc/tegra: flowctrl: Release OF node reference on error
Date: Wed, 18 Nov 2026 15:48:14 +0100
Message-ID: <20261118150040.159747748@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 4eaed7ea6ab36e1160d660b05551702c36dfed6c ]

tegra_flowctrl_init() obtains a reference from
of_find_matching_node() and currently releases it only after
of_address_to_resource() succeeds.

Release the reference before checking the resource conversion result so
the error path is balanced as well.

Fixes: 1fd09e5d884a ("soc/tegra: Add initial flowctrl support for Tegra132/210")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/flowctrl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/flowctrl.c b/drivers/soc/tegra/flowctrl.c
index 221202db33130..d5c3af586d31f 100644
--- a/drivers/soc/tegra/flowctrl.c
+++ b/drivers/soc/tegra/flowctrl.c
@@ -195,11 +195,14 @@ static int __init tegra_flowctrl_init(void)
 
 	np = of_find_matching_node(NULL, tegra_flowctrl_match);
 	if (np) {
-		if (of_address_to_resource(np, 0, &res) < 0) {
+		int err = of_address_to_resource(np, 0, &res);
+
+		of_node_put(np);
+
+		if (err < 0) {
 			pr_err("failed to get flowctrl register\n");
 			return -ENXIO;
 		}
-		of_node_put(np);
 	} else if (IS_ENABLED(CONFIG_ARM)) {
 		/*
 		 * Hardcoded fallback for 32-bit Tegra
-- 
2.53.0



