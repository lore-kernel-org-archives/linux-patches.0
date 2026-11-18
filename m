Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021530;
	b=QOuLkRWx5rKB+Bi52h7EyJyw5dJzagk41PBehBaapH6sNCPNupHR3ifHSyU6URTZDIdM
	 R0MCrFyC9yWUSqQ2Q0sClPd1cjwOe390rnv1wub6jXvGitvnLMy0ewKCQy+PKageeFyyO
	 sa+SlYAYu6QKZ4CV9SI1uAwYHDSUVDPcUPlS5XYTE23E0QutMLX67dM22ONRPxVhgaA1O
	 ydIlILj5BRJfEilMZVAja3rbyko9fWWtA4y/8SDghvBTO0ktrikeTtsqvUfJ8pV2KxA8o
	 7BCjHQTSdRry54wyaQDOXLcWynpn7XOKRxSKsNpKpaeOFoS5n+U/8JYdIlXF/7Ffy9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dnp0dE3ij5DS6h9PxXmlEAfIOfKnyK+HLnhrldmkmXE=;
	b=EGcNfzkdh3253jrTkX66G4cb7sdhTOPy9fUPC+n3XR8IJ5qKBWDvB5R0ibRWmagS/D2Y
	 RZ1HQfhcjHJuPQ1R9T+WHxcFx/u4ixt2k6mhU6g0utGK+JLqW/OXcn5LqUdcvaHWUmri2
	 vGNEY0NLEWz9GBtCAYHv/g2JU63S3gC9whZ2NZTY9n/7jkTfQBTBto31GExK60gNnCd32
	 xlbAcQ9vtGyRe8ZENtrYROxorTvnNg6n1QiGfmqAf9YIFXBIWRecr0yICEg3LxeykvEk/
	 IIA3ZlWoDfhQLTPk7paQtjPWIMG5GLEGB0cca6OK0pNdhRy6nyDB0De+bSblj8EXwcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7hjWLq8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB012606A31C;
	Wed, 18 Nov 2026 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7hjWLq8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FC61F000C4;
	Wed, 18 Nov 2026 17:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021530;
	bh=Dnp0dE3ij5DS6h9PxXmlEAfIOfKnyK+HLnhrldmkmXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7hjWLq81Z0Dq6J0gV+8vF5rFQMZF3jDRT++K+SHzn7u4y3U0QX2+7bP1vxBW8Ct3
	 9R3rr0X6sBkUo8qgnm+J0kExvGciGoIR28v9KsxE1q/yxlZk4PrErs+OO17K+ZPRRV
	 gKuwYOatWAARi+v8nzObG62Q+kYxYqYVHk1o62CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2340/2651] net: sparx5/lan969x: do not clobber the PSFP cycle timer update period
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118150409.339960308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 83b37f95ee467..fa19a48f941d1 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -322,6 +322,7 @@ void sparx5_psfp_init(struct sparx5 *sparx5)
 {
 	const struct sparx5_ops *ops = sparx5->data->ops;
 	const struct sparx5_sdlb_group *group;
+	u32 sg_ct_clks;
 	int i;
 
 	for (i = 0; i < sparx5->data->consts->n_lb_groups; i++) {
@@ -330,7 +331,14 @@ void sparx5_psfp_init(struct sparx5 *sparx5)
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



