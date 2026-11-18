Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025166;
	b=FRYWC3BQKpxHv2d+biSZGvCq37N0wRrPekIA4mk7NfcQlCuB1KdRgF3DaaHepToidpCu
	 xNLDgBDc3UaRpWVIPtlT6aeidQElToLu4Jd9HGa+6Xhfa5uVqwpdMLgo7Sxm3dUF7vLHk
	 wVaoGYk9rNG9t+UkwIsIoBoJqquAqsWR5nU6YGP3wF4F73mRNDczCXKxZj1cCLEIDXkQh
	 mn0qfvnqgXMXH80DYkZs3nvIUEdfK/7Z0v4/T2m/d4BGhqZaCOIjpdxciT9tJbMvJo16h
	 ZfXqc+6YLil6pUyidcY07+K6xnmFoW1sP+7wSZc69DC7I1i9OsZJAy5Pd/bAsb0Tybw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fiUg5Ds3d8yQxdokh3XZsgskWHhY6I8DR5xZpReisz4=;
	b=M60D9S2u3hK9hTezppStxTkwL/JnQDT14y0aqJBFtUfKPzTVPAMtXLwIHw9K3mqtxiYE
	 WVrIiySQXIM0fT3ZoB4jsUEZspM7sC1bnepdMBrbQlZkrAhaii2Uk+hHa/3ncTzyX0NAP
	 q5PLPqR4YMcxlaP5bLdgLgGlMw85VGmBVM8XJ1DO2uPMEyPLc4jc6uZNcLylCjPS6Bs8n
	 IhjCSAJt7YDe75LpKvT86NhjmceTh11rQ6v/O77UR1Cz/xdnvT+CwHZ1oSsUPHBiFysTm
	 ppfuWe6tu2ZcLuEcd2BIJ5IjTTXerTyefhfZhn0N0YlPVPYYLfHpR/9gjzdbbdlZ0tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kl+HJtfq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5545B606A331;
	Wed, 18 Nov 2026 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kl+HJtfq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E071F000C4;
	Wed, 18 Nov 2026 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025166;
	bh=fiUg5Ds3d8yQxdokh3XZsgskWHhY6I8DR5xZpReisz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kl+HJtfqY3Twf7tS6kabqXosERDVEojl4cZnciOlHQska+mVSQ0KACN6bmRPJflfZ
	 oUGSJJGxng2O4tYSKRWLozmTd3UcoY9Y+A583LHSUFUnS7fmus/57E//y3lPeThK6u
	 Kb+TNeNiaSUeyAntitBw6fgZocfp/qZeqIa+DdQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0984/2151] soc/tegra: flowctrl: Release OF node reference on error
Date: Wed, 18 Nov 2026 15:45:19 +0100
Message-ID: <20261118150158.324085431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



