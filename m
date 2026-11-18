Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029869;
	b=B9UIM24/a1efH4PqoCRT/vAj029P+NfTaxMDVXCryE8pcNkA9Fo+3qWSkolr92+SDnUs
	 BLF+FpHkAXUNm7xEWlcTUEF0HJxaZ46OGz9hIhabiqphZfHdYcCFkAGzmGhR/XwszLUqC
	 KFE5jW5KUrJM8DMAkuC/QXY/Qi/BGIpSfeY7BVuTwM45Qq9OBu52+2op4mhzGKEHzScVP
	 rYFzuJS8YMng/ydt+mo+aOopU/Yw0bWez/ajdN6WedTd6h0N2CoNSWYVnpbtN1K1D1FJP
	 DMYn6eizWjtUiPUlBcZalaK/sw9g6qIe2YesuyDem9kNoD6CODk/nVYawR/SCMUXV1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aD1kiu7vvXcTicolNygLtTx8H3ZVRzl0uZNE0aSJA7M=;
	b=5Rg9soHe8HL0Q38Fu54Cb0pwLtT5A3RkJ9P+zmYPQSugGZ3HAP0LPKJWXrlRsU7Qy7gw
	 iug9wDe2WEEZDkQdEDhv9+wwlWosoeyjv7Wdk7qlprpsglm8cfyT/BqoJZeK7t0BVWaYh
	 Mr2uWqcn/KeswEzNZ1wAQtmNEBdD16uNWX+TIu4SO1OHaesUwvbTOLez0ucngqDO7J1jG
	 qISmC2c9+z2bc3U5wx1ZTBqqw7YeovvvcY/xLEud1yluZpHI7dVu7Fm3WxSFcVFd8+Yuy
	 tLbpE3hRw8Nw+qjOJI4UbCVoLyWSbhLfb8E3EF1K5WaoMRArPjqB3+cIppE4bupjomg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=et2cnKQK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849F606A31C;
	Wed, 18 Nov 2026 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=et2cnKQK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096971F000C4;
	Wed, 18 Nov 2026 19:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029869;
	bh=aD1kiu7vvXcTicolNygLtTx8H3ZVRzl0uZNE0aSJA7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=et2cnKQKKuQev3vfERISoARKf5kNGbOMNyfxKx4LoDOZz9uD7zCMNcfeWmN34sF+r
	 w3RtxG79xowakDRype5f/To2jzOwAEvrU8XKdgoBYnPnnFd949A9vrvgN0W7Bj7aBH
	 61kCM1E+UH+n3FpNdUlAVcIlPp9PeJ2T04fx5KSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0502/1756] ata: pata_parport: fix parport attach idr_alloc for
Date: Wed, 18 Nov 2026 15:43:49 +0100
Message-ID: <20261118150029.053160400@linuxfoundation.org>
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



