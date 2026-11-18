Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040621;
	b=MePpuJLIm69jAzly4IbXFHX6QXeTRwZstNAieNIZgC4GeuJO29ioQxT0OGVqGNQo4M9T
	 bhbZd79fGZaefsqSvhMr90rx8f9KVv9rWUENe00X5Wg6hqdUQci0kVtr/svK/VVNCjKr6
	 p9IrpM7v2/3zLTqjoO+J7aHRo3KrNIjfITFJ795ta0G0vV5H0su4yJG92mGyymvlKNa4Y
	 Fj1JYoSnga/H+sOK5AGJggJt+9VSIbyddC2yjxEsp21fUdbYEMh/cQ9i958wfqMUaPNIf
	 MT+cfcQjLGR0q2TcE0gJCzYtUmKLlZ1DOLiVFpoViXel5Vn7Bd9CJ1bHrsgGGzrJJ5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zlUlFC2tjYuWJKI73Stw0sKNrU8hFUfKLT/2/wLbS6k=;
	b=wN1WapsnOyXHHplr+vRV1tSKPEXoF+H+P56VAalKBKwCA2pCsmlF1WcxUwrUoBAEGa9P
	 LxiFaFzK7g6290+ssUUn3dtrnIMKOIrQ2s0QfA5HzV0aoMu/4nH2SRsxLZR79Ch2nCJzW
	 iaubiu1pUxwPgYHlLJ+4A9LOyLjkFSdn458jHzET2COvxITmchQkZgzQDVsLeUE1xZXGx
	 3hmSXqnaHg4/zOCWy81oKnCh896ln5TAD59QulU0IBY5nnd3IrNS2zELd+1RKDzeaIQUu
	 oYHzMNdMnAr527y5riosnwcAtQvK1nM/KUVQ/vnygDYGjriG3ajNCmeDoftzFAdBY4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZsCEncy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4CB606A325;
	Wed, 18 Nov 2026 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZsCEncy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479FD1F000C4;
	Wed, 18 Nov 2026 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040620;
	bh=zlUlFC2tjYuWJKI73Stw0sKNrU8hFUfKLT/2/wLbS6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZsCEncyAR+lrCHSPW59Jp2zJxcMNMtqzL8XsQ/UgGDPlsrjh/RPpAGrMhnLPUu26
	 NOzmi/v1jxBhyL0DPR8VEynWO+lfqVxeb6KRGlVkT+c2PENBWRe0GDdBWO85rDi2QG
	 w3GTMyjCDbE9kP1lZXe2pFD2HVWdIoVJRSN8YYN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2522/3318] soc/tegra: flowctrl: Release OF node reference on error
Date: Wed, 18 Nov 2026 15:52:24 +0100
Message-ID: <20261118150437.020904215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



