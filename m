Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061125;
	b=QxRWfjGaiqPOZQNaeozTwU0gsfw/j0ngAoPVoIwo5k83SV/T1G96xMR8lLiwocAurCLO
	 rbFm9qxKeeD/IRXtOg0B/mDhrz4RRuLyzi6uzBmq+GETuDi+rYgbLqRAVmLywcQYYB3LK
	 uIo+BpQFIgF1bX915Ol5Jvi8ZirA0sTBi94A2DaKc5IhcInCHTU/FwEFUKvSytAV08KWt
	 ie7nAVgbSTrYtwNtJ5c6Ssu8puuJwu+5GoqrqF/Z+zmD3cwW8SpaCNFKPPLpWK4MBEeUh
	 4NfdKO7vU0sDYHkpwNhQvh88uVmP9vewLBvO8DommVEULpM6roJApxtCNnsTgeBAIxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=id58xVcNUZ9plKgchnmZaj2NgArlloW21uEsQ0HlUtk=;
	b=a7AcoNnP9+Fwh4ANzb5XLtRxs25lFO38i4VYobLLlNFjzLchAEgKgEhWimoxZvRH1SXg
	 awD9eeronnu3GzJOsSKIkGbP22eLUf88gmepF0/KH7HCv/UrXaSFXhx09lbEe5c8Xl20D
	 LhntWbFURaqnlJbLd+G53NEiB8Rk3ogNhD2tFTSgOEftI0Tzonky96att2C40QuyRxOwS
	 M5sJFIZr4ywndjcXN2mPc+XmQf/Pp4LeBlNYE3Nmrqw5aQnbhP0w5jBh8wn4kVb2iJAdN
	 HPDiefoAsKSPZPgN2/i0blu/VhOAAkawT63SYh+1iA7ITRQdS4Y9KlcjhC5HJ8hoCsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPAupsQo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABD2606A326;
	Thu, 19 Nov 2026 04:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPAupsQo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FCB1F000C4;
	Thu, 19 Nov 2026 04:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061125;
	bh=id58xVcNUZ9plKgchnmZaj2NgArlloW21uEsQ0HlUtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPAupsQo1raSdm+Q1Ct9ebATiwtNRaR7++HLLpnM5HOe45p0ZcAryUqNjccFaHXz4
	 SRUue+vpX15jOkQ1O3ixiTzAIxPpe6o6BC7RNL/tZVkTIN+TUdxSmI+ceeijMPhR+R
	 9kt+/e4iSi8uX4TnscTy6TJz96m8qvWsyO8qxjtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1441/1848] soc/tegra: flowctrl: Release OF node reference on error
Date: Wed, 18 Nov 2026 15:57:59 +0100
Message-ID: <20261118150019.795213786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5db919d96aba5..727b92e938311 100644
--- a/drivers/soc/tegra/flowctrl.c
+++ b/drivers/soc/tegra/flowctrl.c
@@ -197,11 +197,14 @@ static int __init tegra_flowctrl_init(void)
 
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



