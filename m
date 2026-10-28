Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212672;
	b=21OK/rbBWyXrv93Y3UVElGNOkAEMDWK0Whq2xMhaaX4bFT5ALMesM70gHimfM4sxJJkn
	 0uevKPAiVpg8Gwqu5yoTvPmGPYZJZuroLcGCwvEKCBkz/Omi11b+6bvaTnLL6gXlLC0kF
	 5aeN98cG868Gem+5zEjYEjgujJsvUiOV8bHZHfjM0yxEGK+VqypxVXEmWNf08LcszgxyK
	 3EMKBW2UyfQWsYmGY7E6tJxfwyWIYZMcayGgWwAoKyigfDkjsXetPoZxnv3tsmIq5eZid
	 O7tpZQ6Lh7Z1hg2iMOnwnaEPgU3sqkq/zLUew9dP0Xioqc9cWif5URC6MirudyRU1AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/FHjOgp7VOcoQZqRiMLt08Nd2hA+68kV6c7xwDWDekw=;
	b=AwEVkAqS38OMYEK4pwiwSFpKwT17jjbQBVNmBo3q3IMffle+L+KSttArevpAetMzEzLT
	 savr/OPhw3O1qEdcYkeKIzbo7NnV/KvbrgBk08pgBaGN9RXBZEinF4W/bow4oQzZ8kFtx
	 SPUGKYmG9dOBnM/DvQCC/cKTcqJvRepmoNW1wDX7F+BBi0zVfM1f4N18AT85w3H8kMYDd
	 urxO7tui+TSl6/EkPUSbkCpRr7CToEKjITk6PaGSHn+oDTaQc/GSJ+/8TaEwRGPhg4LWL
	 Yzr70mhQL+pUuPqOZY5UwbV5r0xvDPF0EZyP5AI1BCRSQFEkfcL5wJr4IWj41whUOCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SOSp2Ei4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DB7606A320;
	Wed, 28 Oct 2026 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SOSp2Ei4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819B21F01828;
	Wed, 28 Oct 2026 18:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212672;
	bh=/FHjOgp7VOcoQZqRiMLt08Nd2hA+68kV6c7xwDWDekw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOSp2Ei4ZKcPpxCpravai+aG2ZgVMAnZzTfJX1GLKrrgFA1CQy43qDUSZwX3Gu6ob
	 jvH0Ytr6qV6Xb3VRqjpyAMayV5pL7LcxYr2qTBMsrPa2f8G9oFoJv8j0PeapSoKdwE
	 nClnUqU5RYMklwWN6DRYVHatXN8eDcc+BBhoEL0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baha Mesleh <baha.mesleh@nokia.com>,
	Subrat Pandey <subratp@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0235/1887] octeontx2-af: mcs: Fix SC resource cleanup loop
Date: Wed, 28 Oct 2026 17:38:51 +0100
Message-ID: <20261028170504.579922999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baha Mesleh <baha.mesleh@nokia.com>

[ Upstream commit cdef07f3002f708a345392ee28d0d9bfac8383a1 ]

The SC resource cleanup and statistics loops were incorrectly
iterating over secy.max instead of sc.max, so the highest SC id
could be left allocated across teardown or FLR. Use sc.max as
the loop bound.

Fixes: cfc14181d497 ("octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources")
Signed-off-by: Baha Mesleh <baha.mesleh@nokia.com>
Signed-off-by: Subrat Pandey <subratp@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260922102149.2078168-3-subratp@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 211c10aa5880f..30c672d526a0c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -314,7 +314,7 @@ int mcs_clear_all_stats(struct mcs *mcs, u16 pcifunc, int dir)
 	}
 
 	/* Clear SC stats */
-	for (id = 0; id < map->secy.max; id++) {
+	for (id = 0; id < map->sc.max; id++) {
 		if (map->sc2pf_map[id] != pcifunc)
 			continue;
 		mcs_clear_stats(mcs, MCS_SC_STATS, id, dir);
@@ -738,7 +738,7 @@ int mcs_free_all_rsrc(struct mcs *mcs, int dir, u16 pcifunc)
 	}
 
 	/* free sc entries */
-	for (id = 0; id < map->secy.max; id++) {
+	for (id = 0; id < map->sc.max; id++) {
 		if (map->sc2pf_map[id] != pcifunc)
 			continue;
 		mcs_free_rsrc(&map->sc, map->sc2pf_map, id, pcifunc);
-- 
2.53.0



