Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018283;
	b=qtDegq/2ZU8HQU7BP9QaqRrft7tfPrjmrcxT/OPh5dRnR7zUHCfuDqPEcb/wi8vdbjzM
	 LY8tSUboXlRi4rq9IHu4h8NWowz9WxZWDBp9belng+t+cBtKWK2uus7AZkY2THkNH5bM9
	 ZvIHpuZOskHXhnA1UC5GWG7qdRE4e74TpGwdhq0OI1nRffOzaURu2LAKkp8Ba47FGGyW+
	 WpiYgLPCF/Mi2K21VFKEnMVp2elr8I1BPEixvLKDtb4B7gQYrNNxk+RI9kKLf+4rNseAL
	 GM2r3urxXhlAbmp8v7/5NAcgNvDwizyUMQ3SndHa222Eo7SsEHYBvUG04YaTPoLRnoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IgRZ9uCZ79o4ukZ9Tru32CC3+hqv1tH+KSNH51HKzaY=;
	b=l+WcMfiNjSrvZVytHDf7iG5qO7FdUJAUCm/qcpu71XylzxQr0duWbxSlVnl0tsgcX5Ce
	 RPaFkF98LLQ5y4FTbcgrnn5WsHGgJyZYB+2Qbxk+vvST0GF38VOHO5e4hY2r4/bVKLds/
	 0PoKUL721Ktd9+o9LJcCzOWPMjkCb0oZHnUBYAYeGADxi477bN8OMONOt5KNKTY1V0n6s
	 HAmWQixlMLCcbOd/AYrgxaRtCagASbvlgENW2dWGR5D4nYl74ejWagUeh6p44NDcTg2HH
	 5I9jlEb1xvTs4T4AmeQXMQYZif8xLVlvBXw6lFlO7X7ZIqaf0UR+wVERtolVx1OWz3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpk0tUUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449F3606A32C;
	Wed, 18 Nov 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpk0tUUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5191F000C5;
	Wed, 18 Nov 2026 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018282;
	bh=IgRZ9uCZ79o4ukZ9Tru32CC3+hqv1tH+KSNH51HKzaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpk0tUUZiWUjeklXpOk/0A+kphazHRJPUl950nPYzS4fqoomSbBEDX+PPyNvpfQWu
	 q+SOxg4c86USPa5AyBP1zZQ/FwcFZQj8gF3/FetXSIIwa0FlagEGQT0G/T3+Q/sQFT
	 wKlnjo9ue585Q5ojpumVV0cq7Qy9oHTgF2/wFYtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1186/2651] arm_mpam: Dont loop forever if there is the maximum possible amount of PARTIDs
Date: Wed, 18 Nov 2026 15:40:26 +0100
Message-ID: <20261118150330.698687129@linuxfoundation.org>
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

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 1e105782a1ce59ad066492a574ee57ff2f4374d1 ]

On a theoretical platform with the maximum possible number of usable
PARTIDs, 0XFFFF, the loops iterating over PARTID in mpam_reset_ris() and
mpam_reprogram_ris() will never reach their termination condition leading
to a system hang when register the cpu hotplug handlers when MPAM is
enabling.

Fix these loops.

Fixes: f188a36ca241 ("arm_mpam: Reset MSC controls from cpuhp callbacks")
Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index a4fa3129ec0c8..e859e877ca839 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1760,7 +1760,7 @@ static int mpam_save_mbwu_state(void *arg)
  */
 static int mpam_reset_ris(void *arg)
 {
-	u16 partid, partid_max;
+	u16 partid_max;
 	struct mpam_config reset_cfg = {};
 	struct mpam_msc_ris *ris = arg;
 
@@ -1770,7 +1770,7 @@ static int mpam_reset_ris(void *arg)
 	spin_lock(&partid_max_lock);
 	partid_max = mpam_partid_max;
 	spin_unlock(&partid_max_lock);
-	for (partid = 0; partid <= partid_max; partid++)
+	for (u32 partid = 0; partid <= partid_max; partid++)
 		mpam_reprogram_ris_partid(ris, partid, &reset_cfg);
 
 	return 0;
@@ -1817,7 +1817,6 @@ static int __write_config(void *arg)
 
 static void mpam_reprogram_msc(struct mpam_msc *msc)
 {
-	u16 partid;
 	bool reset;
 	struct mpam_config *cfg;
 	struct mpam_msc_ris *ris;
@@ -1841,7 +1840,7 @@ static void mpam_reprogram_msc(struct mpam_msc *msc)
 		arg.comp = ris->vmsc->comp;
 		arg.ris = ris;
 		reset = true;
-		for (partid = 0; partid <= mpam_partid_max; partid++) {
+		for (u32 partid = 0; partid <= mpam_partid_max; partid++) {
 			cfg = &ris->vmsc->comp->cfg[partid];
 			if (!bitmap_empty(cfg->features, MPAM_FEATURE_LAST))
 				reset = false;
-- 
2.53.0



