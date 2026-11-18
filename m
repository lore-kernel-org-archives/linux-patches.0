Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018274;
	b=VBSeMPqgZ6GR9kNRVC9unX8y1C5TulSey8NzruIAvfLYvbjHfx8zglD5g7OSZyc/rXRf
	 lToTN1EHia9N0xnsNa/PxS2va6uDlORqSTAcKe9fMMP0MDYbyxFLBKDUsTgXwNNTw0f/V
	 tI2a8WW4MmalyTs3pRjPwE0zbE16oWo7ogUeajGZexDOjW0zUZcC5A1KCY0x/0rzW69C7
	 UvrwnbkJltwZmf11HAC55J9EUOf5LpctoADZ1AnWou8TamhruaQ+eTWTVjklzuw5lr38B
	 UmEodhxGSfbjR9GpwNLZjJtdG4Of/Q9eflI5gePisvES0hiV1nIzURBEASFKfKOgVlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xABEnJRbfjRwC9GEe5tXCirBubNXMFQg81DMIATrwfc=;
	b=H6pIaM8V28ryPT5/DM3FA0WB4xos4bsG15zZgbVmXYuEu1c1/gHjtI51KzNW3oBgNWw7
	 IluhdgA9+wTJZlvDS2V4A/iyeo8r+BO3iDkI5dZ2euRDKvTT6CUJU++aylpVbPqKuEsLy
	 go8awaJ7WWITtImAc8i2/POmPnAa12VeNc1d9CTiuuLpyFVJuntH/sL/8n5MbWaOiYcls
	 MCpCypUSYsrWuy89+s6t/2yrAiC3GnzJGDkawMxiNxUBrBu2gHuYvBFE0CddxFwjX8ZaO
	 GSFC21btZrO7FLHKoX/d92WJiH7p7K2zz3rbIsMNgwUGvDfDtawIQ37SkUUFUgmHMVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWKcQhPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D27606A31C;
	Wed, 18 Nov 2026 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWKcQhPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BDD1F000C4;
	Wed, 18 Nov 2026 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018274;
	bh=xABEnJRbfjRwC9GEe5tXCirBubNXMFQg81DMIATrwfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWKcQhPzLhnjTsvz5KGzcJIIHEV0YMYmN5PpxAWZfTz0i+GUbhit3YJrNwg696FGt
	 FUuS0iJzcLFZzfThi+Zvia+lWthyEfG0bs5wMQsBZmvRWi0YTLfZNNBVVZGCbZgBiL
	 0dkvNorSnmk7zCUcs7rEOcV/a02fSdhqHPzwZ4Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1183/2651] arm_mpam: Initialize all of struct mon_read in mpam_restore_mbwu_state()
Date: Wed, 18 Nov 2026 15:40:23 +0100
Message-ID: <20261118150330.594475778@linuxfoundation.org>
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

[ Upstream commit 4643335d5846123a25f535aad697c23f0135faca ]

m->err and *m->val may be read before initialization in __ris_msmon_read()
when called from mpam_restore_mbwu_state().

Initialize the whole struct mon_read in mpam_restore_mbwu_state() and fix
the spelling of mbwu in the name.

Fixes: 41e8a14950e1 ("arm_mpam: Track bandwidth counter state for power management")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index e883e19979b01..a4fa3129ec0c8 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1655,7 +1655,7 @@ static int mpam_restore_mbwu_state(void *_ris)
 {
 	int i;
 	u64 val;
-	struct mon_read mwbu_arg;
+	struct mon_read mbwu_arg;
 	struct mpam_msc_ris *ris = _ris;
 	struct msmon_mbwu_state *mbwu_state;
 	struct mpam_msc *msc = ris->vmsc->msc;
@@ -1672,14 +1672,17 @@ static int mpam_restore_mbwu_state(void *_ris)
 			continue;
 		}
 
-		mwbu_arg.ris = ris;
-		mwbu_arg.ctx = &mbwu_state->cfg;
-		mwbu_arg.type = mpam_msmon_choose_counter(class);
-		mwbu_arg.val = &val;
+		val = 0;
+		mbwu_arg = (struct mon_read) {
+			.ris = ris,
+			.ctx = &mbwu_state->cfg,
+			.type = mpam_msmon_choose_counter(class),
+			.val = &val,
+		};
 
 		mbwu_state->reset_on_next_read = true;
 
-		__ris_msmon_read_locked(&mwbu_arg);
+		__ris_msmon_read_locked(&mbwu_arg);
 
 		mpam_mon_sel_unlock(msc);
 	}
-- 
2.53.0



