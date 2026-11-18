Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024207;
	b=s0THhkYFUA8LMBEl/oc0jWMVeWSb3vJzBda8eEqAoR8Apl8qbIUBA2aTkR4v6n5n4lCw
	 iEEcmCYoZLvftORpsCwl8b2wT9gfy+hBuDBFDm+XiP/7AMV7bd5FFpfH8rle5rt6J6p0a
	 FgsTbwDcc/DLKqN7iNNI6SABeZMS0X7vIvl2dLKfGGn7Qp8mhVk8R135hTMRUsu5VeIjc
	 9yGpeOUWvsJB+Z69WhQKXl32fIEYH/f93VtQ9crZK7i1sFSCSlYW32bni++7WwQ0W8aMR
	 TP/Jx8i03Y5ZDY4wa8oT/CeyVVdCjG3pdU83IPshcFMAvxdWAlUJdVBi+R2G3k/935A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MJwSuLUouzAmH0nqMhTGUf1/klBuy8PmA2KPzNCsyQE=;
	b=tcXQOqXk3PaWLrXcGEjC1qv0R7ZMlJ6XMJfJZpwHaagayZDk+CV+B/Y96ct2/BuUh3r3
	 1QYkdg9lJsJIfw2WRNnyC6o32H2CvrtrdfZrlYgpBI20kLVgLqvP7C+sZBdOXpM+Khmc+
	 Rcg+AgHtZwDe2jXV2Thc+9ZySwKdR3Mt2xDDIQebF1oiDce+pK/hze2n95KlxWhOFPZQy
	 Z63LzqES2PUh+N2yGIZHtWjNweRgAsWelRDw0RBF4I8fNvExf2cTobaoB8yDDKrPe51oN
	 seJDBJUlotUgAoFWCGHNhuJozFX0wIIBcvpfMd7FZXINL7FfBe8/GFmlZ8BiiEzxwAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdAntU0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD49B606A320;
	Wed, 18 Nov 2026 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdAntU0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A26E1F000C4;
	Wed, 18 Nov 2026 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024207;
	bh=MJwSuLUouzAmH0nqMhTGUf1/klBuy8PmA2KPzNCsyQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdAntU0gaJyZefylsnYXoSSbcS3D8r+MhmVM3KKl5CcmAszT4/Ki/VjrQqZiLi3Sh
	 pKAFLhCvvORBn+giXIBeVEpXTPD2CdvSNC787eEAS45mgI5ViXWAY1aHNNToVKV8ay
	 gFhoyxcTTsmSgwaawDXLsaSNKwB+IkEjvHfa71/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0606/2151] ata: pata_parport: fix parport attach idr_alloc for
Date: Wed, 18 Nov 2026 15:39:01 +0100
Message-ID: <20261118150144.014249215@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 193f5b84a95c02456f51fe5067750ecf73d213d5 ]

idr_alloc() expects an inclusive start and an exclusive end, so passing
port->number as both arguments produces an empty range. Because
idr_alloc() only falls back to INT_MAX when end <= 0, the allocation
succeeds solely for parport0 and returns -ENOSPC for every other port,
which pata_parport_attach() silently ignores. As a result only
parport0 gets probed and any higher-numbered parports are never
attached.

Use port->number + 1 as the end so the range [port->number,
port->number + 1) contains exactly the desired ID.

Fixes: 246a1c4c6b7f ("ata: pata_parport: add driver (PARIDE replacement)")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/cee1a15d98cd0d55f41fd65ca9d222b68a74e7d3.1790047457.git.xiaopei01@kylinos.cn
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_parport/pata_parport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_parport/pata_parport.c b/drivers/ata/pata_parport/pata_parport.c
index 5c6651621dfbe..2096a38cb6c87 100644
--- a/drivers/ata/pata_parport/pata_parport.c
+++ b/drivers/ata/pata_parport/pata_parport.c
@@ -731,7 +731,7 @@ static void pata_parport_attach(struct parport *port)
 	int pr_num, id;
 
 	mutex_lock(&pi_mutex);
-	id = idr_alloc(&parport_list, port, port->number, port->number,
+	id = idr_alloc(&parport_list, port, port->number, port->number + 1,
 		       GFP_KERNEL);
 	if (id < 0) {
 		mutex_unlock(&pi_mutex);
-- 
2.53.0



