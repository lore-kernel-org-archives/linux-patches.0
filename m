Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032797;
	b=a4BnJxIoPHuLoDPX4anMd486UrH0Dur1zlXTA6zN+bvIu7m5lzqkp0XYzX7/PfKvatUW
	 Wn35d5Pn1n7b3T84IaNFB08Xc2bjJEHiU7D8FFYbMvV/c8BA0l/fCkQWkUm78dpaTGpHN
	 DnO/sBRbgVps5tZhqcOqcJaeyBN31P6mKRRBKLWc/F7dEdR0+TouS3M4Xv1k4BlZiIDQ2
	 v+VuwWfjCfKcPYSOFslSus2wilINXRibiZ8nOok0vz88zZWSm4BKrZvSdOxN0Gtfl6V3/
	 rvwM4UVaLxhrSEoq1Jh0kd2iOCnV8JwJR4Nb1uGoB56BM1lNH+OJCqqz0baebT4nbyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NyCDH25hJebf6zS6qFIZyaqb2nrmaxyS8LsqZB2AWOs=;
	b=soa2VOYRQL1WBOwhgfVXjPkE5RAIXE6LFk5xXpxzmPt1JtyMLczNhciA2BWbwVeUtImD
	 Nc8yGpwDFbui7PnoKrRr8DVMW9nQHbgb1KqZ6LqcpVdb74OqaF9QWtOSkzqV6F9Dya9aR
	 iwBux4B4kcG5qIOvZQjXWLoWh20VWFEfzactLq2V3FLt1Kulv5ZNfnnfRJ5uZuhe9cnRA
	 bcKFI+lCXH8qaFXSbIG5yW2fnTS4TAwU3q94CzcFSy7XcpLGzXbrizPaBADhLGm1pru8/
	 +EA2zI+KYHWXsoA0jROukvxLNYE4ujoo8yZJ+6JSYIVTJo9bk8OldXhhXJfJaf+KMBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnT7nB3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51039606A32A;
	Wed, 18 Nov 2026 20:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnT7nB3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78761F000C4;
	Wed, 18 Nov 2026 20:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032797;
	bh=NyCDH25hJebf6zS6qFIZyaqb2nrmaxyS8LsqZB2AWOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnT7nB3R0iXA0aJxeuW0mPA63Yy/fxGvVo0P7vc+IKctaiPyBLN2AMSdK77f/NLKl
	 ZKo+RYs5amlmo/gIfuZxX2FHWMceSYt8qkf07GUtg1WjO1JBZx+0NUeI4T4K7OgG6Q
	 CiN59ggDutPSrnkjv7adnfhcrrypOkWxUROXCISs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1512/1756] net: sparx5/lan969x: do not clobber the PSFP cycle timer update period
Date: Wed, 18 Nov 2026 16:00:39 +0100
Message-ID: <20261118150109.080695303@linuxfoundation.org>
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



