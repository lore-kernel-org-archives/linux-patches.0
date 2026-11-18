Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042311;
	b=AvCVo2M9sGuSyEf+GQFsgKhzDvtATi8eY4XjCwvsGo7TALh72mQSVNbWDSJ+OO3qMBjw
	 6xZy+r8PJ9PgSIRoMFEUxTW54EqRkvoyznC+JlBjJ6DLWdc5TjQtuoSlp/duhy+Tz7IeF
	 PybdTuCBK3JnoS5oL+JX4eSQeWEsXAUcUTqNpB5f9h0PXBBygcPJNX3pN22jYmxZpeR3M
	 JXgWNz/wGRln5fAWRFmC5T/ACYn+gWUJBIqGcSmUIJKlwY3xcCdyr47WM0arwwQroYwSY
	 5U2WpkreP1HTqQdGE3PxcRVGZlQp/FX30u0cJxLVxiOv9eFg50e2U36uF4zfkhAHYUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFCJEw2wn0tfhV9CAogcMZF+xlRLHno74H1v0cwTKhc=;
	b=pbKJp6xvc63ClWDiRJzYKNGiT69NSXqZ6xPOTJUxM/Heyc3inaP8+XPsEUIWULgNdvjR
	 sceiyYjqrd+nKPGwZ2qNWjfNrILvGgQL7K6XaSnn+JWxm83ihVjx9h6f2sZehxblEwoa2
	 zScrZX3TzwvYfuVMMUJPsFJND6zz2IQwwUPVvQiJUlyNA/Sso8woQfjkGv2aZ6sSTbsIg
	 J8Rj38LDF6KL1frJ0nmH3HLnzhrD1M2E6I7mBeCjiuMf4hT/LAI1+0qYJzxyoUARMP2py
	 0Yl0QU4CrcVbGwDh0iwcZAWhfi0cEZa+F+DhHzT0vh2tLo3mQbnjHfUf+ufNQiiQeOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4vBEX70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33373606A31C;
	Wed, 18 Nov 2026 22:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4vBEX70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D691F000C4;
	Wed, 18 Nov 2026 22:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042310;
	bh=VFCJEw2wn0tfhV9CAogcMZF+xlRLHno74H1v0cwTKhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4vBEX702aZlV15DPFBB86KqJN+64Szd5zgObb/GOTIFNmm56EZmWuL4bE7YRZjqI
	 GAHLqm/uGnXwTnlPv7VQ4Yb/6hr1sMYVBQ9yN5jG8sdxpGJgvimA9B0cjrOp6ixc4B
	 PpWkt6rojGG4y+WiXqhuvgDeK08JjwZskX6gNBcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3126/3318] net: sparx5/lan969x: do not clobber the PSFP cycle timer update period
Date: Wed, 18 Nov 2026 16:02:28 +0100
Message-ID: <20261118150453.699907301@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 5a3dcad8e101ddcd3a886907c8992df54472f749 ]

sparx5_psfp_init() enables the periodic stream gate cycle timer update,
which keeps the cycle start time of each stream gate within one cycle
time of the current time. SG_CT_CLKS sets the update period, in system
clock cycles.

Before this patch, the update is enabled with a full register write of
SG_CT_UPDATE_ENA only, which also sets SG_CT_CLKS to zero. That is below
the documented minimum, the number of stream gates (1024 on sparx5 and
256 on lan969x).

Write both fields, and set the period to the recommended 10 us,
computed from the core clock since it differs per target (6250 cycles
at 625 MHz, 3280 at 328 MHz).

Found by an AI code review agent, and confirmed on lan969x and sparx5
by reading the register back as 0x80000000.

Fixes: e116b19db202 ("net: microchip: sparx5: initialize PSFP")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261020-sparx5-psfp-cycle-timer-v1-1-00f2908f096a@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
index 2f06d7ab7d4b7..850b4af8564f3 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -317,6 +317,7 @@ int sparx5_psfp_fm_del(struct sparx5 *sparx5, u32 id)
 void sparx5_psfp_init(struct sparx5 *sparx5)
 {
 	const struct sparx5_sdlb_group *group;
+	u32 sg_ct_clks;
 	int i;
 
 	for (i = 0; i < SPX5_SDLB_GROUP_CNT; i++) {
@@ -325,7 +326,14 @@ void sparx5_psfp_init(struct sparx5 *sparx5)
 				       group->min_burst, group->frame_size, i);
 	}
 
-	spx5_wr(ANA_AC_SG_CYCLETIME_UPDATE_PERIOD_SG_CT_UPDATE_ENA_SET(1),
+	/* Poll the stream gate cycle start times every 10 us. The core clock
+	 * period is in picoseconds.
+	 */
+	sg_ct_clks = 10 * NSEC_PER_USEC * PSEC_PER_NSEC /
+		     sparx5_clk_period(sparx5->coreclock);
+
+	spx5_wr(ANA_AC_SG_CYCLETIME_UPDATE_PERIOD_SG_CT_CLKS_SET(sg_ct_clks) |
+		ANA_AC_SG_CYCLETIME_UPDATE_PERIOD_SG_CT_UPDATE_ENA_SET(1),
 		sparx5, ANA_AC_SG_CYCLETIME_UPDATE_PERIOD);
 
 	spx5_rmw(ANA_L2_FWD_CFG_ISDX_LOOKUP_ENA_SET(1),
-- 
2.53.0



