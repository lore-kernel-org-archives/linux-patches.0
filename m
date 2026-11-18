Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018388;
	b=gjgfIbdGAoGM85ABDP2Gy6agIL0GhfXiOGx0J1KKQBgLB7cex5PVKC5BVui5tchwt/ZB
	 Ef3iZjgDvaL6TCaw9W+ckgdQGW58RRFFMXWUhKbJlDwR7McdA+dut4qhWBN402hAerpRJ
	 9HeAxrXxtfq2fWSOQ23EztnzYE9nlIcVRGlY8z2ljPLKUdvuUJPFt/9OjsZaBjlmNgDFg
	 YmBHRcaSUyec8Zg0eJ3EJgH7J03gy0mkqOE6VjIeXaOBGRqbMNA2Fn6XB84Ziv2aacGl3
	 NkazGA7HaMh7PZFCrXATezfshkS2Pn6D3vazY2lyKCPF+aRGi8+24h71C3HBqyR+Iew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLsFJaekYoEO/Skjzt9hhD2BHlKM94CD1AUlQjdV6Gg=;
	b=XrdQ3crqaoKNoryDrQzsODk7DxRR9URoR1qHMMiutT8mrzhstvoUR5uT0KAoNkBy7a4M
	 looFq+LEunWJ5K+NeMo3ipb5CsU2+PKqFraHMdwFvPgFvAHLMGPYtk4Ey0k+zztM/rggj
	 /kNwn5dIkDtnzDmIUiSEcmeOkMs8SeIto0lG3g3wcL2xB5eaX3hT9FefFFOyFSKH7OWjf
	 280sNCTYckZTY+NXm1xTzItIgp6P7SCephcFzHEHD/PFMoVN/OvnzTpOdO/tITSnj5u+L
	 +rCJT/CnRzR/NPJHbhHUvhfJ0zgC6hSg58JvsZao4kapi8c2w/6A427tUDBJHTViIVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9WFzby2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194D5606A33F;
	Wed, 18 Nov 2026 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9WFzby2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E8D1F000CB;
	Wed, 18 Nov 2026 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018387;
	bh=eLsFJaekYoEO/Skjzt9hhD2BHlKM94CD1AUlQjdV6Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9WFzby2JGufES0yXfCLHtW/aFGM1ne005y74dBYusZRPK37E+ogIgErtgP2gRmfP
	 /hhSlui1sGbwuZt9ScUFmwVQJogy/nVo/fkXhCie0jk5MfNzY/YdbxoCNXGBxQ9XSb
	 xPfC25UMZNspDylbd8GVo0P+skqRJe9hOXRZjVTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1182/2651] arm_mpam: Use __ris_msmon_read() for saving MBWU state
Date: Wed, 18 Nov 2026 15:40:22 +0100
Message-ID: <20261118150330.561776703@linuxfoundation.org>
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

[ Upstream commit d056d29aefbe8fabe26862b1372837484bdde4c6 ]

mbwu_save_mbwu_state() reads the MBWU counters and adds that to a saved
correction value. However, the type of counter to read is determined by the
RIS rather than the class and overflow is not taken into account. Fix this
and mitigate against further divergence by using a locked variant of the
same helper used for user monitor reads, __ris_msmon_read(). Using the
locked variant avoids having to drop and retake the mon_sel lock. If the
lock was dropped, an interleaved monitor read which detects overflow would
cause the overflow not to be accounted for in the saved value of
mbwu_state->correction. The correction is no longer updated for disabled
counters but this has no effect as the saved values are not expected to be
useful for disabled counters.

Fixes: 41e8a14950e1 ("arm_mpam: Track bandwidth counter state for power management")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
[morse: Added comment on correction being included in mpam_save_mbwu_state()]
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 68 +++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 8223e764e46e7..e883e19979b01 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1029,12 +1029,6 @@ struct mon_read {
 	bool				waited_timeout;
 };
 
-static bool mpam_ris_has_mbwu_long_counter(struct mpam_msc_ris *ris)
-{
-	return (mpam_has_feature(mpam_feat_msmon_mbwu_63counter, &ris->props) ||
-		mpam_has_feature(mpam_feat_msmon_mbwu_44counter, &ris->props));
-}
-
 static u64 mpam_msc_read_mbwu_l(struct mpam_msc *msc)
 {
 	int retry = 3;
@@ -1202,13 +1196,12 @@ static u64 mpam_msmon_overflow_val(enum mpam_device_features type,
 	return overflow_val;
 }
 
-static void __ris_msmon_read(void *arg)
+static void __ris_msmon_read_locked(struct mon_read *m)
 {
 	u64 now;
 	bool nrdy = false;
 	bool config_mismatch;
 	bool overflow = false;
-	struct mon_read *m = arg;
 	struct mon_cfg *ctx = m->ctx;
 	bool reset_on_next_read = false;
 	struct mpam_msc_ris *ris = m->ris;
@@ -1216,10 +1209,8 @@ static void __ris_msmon_read(void *arg)
 	struct mpam_msc *msc = m->ris->vmsc->msc;
 	u32 mon_sel, ctl_val, flt_val, cur_ctl, cur_flt;
 
-	if (!mpam_mon_sel_lock(msc)) {
-		m->err = -EIO;
-		return;
-	}
+	mpam_mon_sel_lock_held(msc);
+
 	mon_sel = FIELD_PREP(MSMON_CFG_MON_SEL_MON_SEL, ctx->mon) |
 		  FIELD_PREP(MSMON_CFG_MON_SEL_RIS, ris->ris_idx);
 	mpam_write_monsel_reg(msc, CFG_MON_SEL, mon_sel);
@@ -1312,7 +1303,6 @@ static void __ris_msmon_read(void *arg)
 	default:
 		m->err = -EINVAL;
 	}
-	mpam_mon_sel_unlock(msc);
 
 	if (nrdy)
 		m->err = -EBUSY;
@@ -1323,6 +1313,21 @@ static void __ris_msmon_read(void *arg)
 	*m->val += now;
 }
 
+static void __ris_msmon_read(void *arg)
+{
+	struct mon_read *m = arg;
+	struct mpam_msc *msc = m->ris->vmsc->msc;
+
+	if (!mpam_mon_sel_lock(msc)) {
+		m->err = -EIO;
+		return;
+	}
+
+	__ris_msmon_read_locked(m);
+
+	mpam_mon_sel_unlock(msc);
+}
+
 static int _msmon_read(struct mpam_component *comp, struct mon_read *arg)
 {
 	int err, any_err = 0;
@@ -1674,9 +1679,9 @@ static int mpam_restore_mbwu_state(void *_ris)
 
 		mbwu_state->reset_on_next_read = true;
 
-		mpam_mon_sel_unlock(msc);
+		__ris_msmon_read_locked(&mwbu_arg);
 
-		__ris_msmon_read(&mwbu_arg);
+		mpam_mon_sel_unlock(msc);
 	}
 
 	return 0;
@@ -1688,10 +1693,12 @@ static int mpam_save_mbwu_state(void *arg)
 	int i;
 	u64 val;
 	struct mon_cfg *cfg;
+	struct mon_read mbwu_arg;
 	u32 cur_flt, cur_ctl, mon_sel;
 	struct mpam_msc_ris *ris = arg;
 	struct msmon_mbwu_state *mbwu_state;
 	struct mpam_msc *msc = ris->vmsc->msc;
+	struct mpam_class *class = ris->vmsc->comp->class;
 
 	for (i = 0; i < ris->props.num_mbwu_mon; i++) {
 		if (WARN_ON_ONCE(!mpam_mon_sel_lock(msc)))
@@ -1708,17 +1715,36 @@ static int mpam_save_mbwu_state(void *arg)
 		cur_ctl = mpam_read_monsel_reg(msc, CFG_MBWU_CTL);
 		mpam_write_monsel_reg(msc, CFG_MBWU_CTL, 0);
 
-		if (mpam_ris_has_mbwu_long_counter(ris))
-			val = mpam_msc_read_mbwu_l(msc);
-		else
-			val = mpam_read_monsel_reg(msc, MBWU);
-
 		cfg->mon = i;
 		cfg->pmg = FIELD_GET(MSMON_CFG_x_FLT_PMG, cur_flt);
 		cfg->match_pmg = FIELD_GET(MSMON_CFG_x_CTL_MATCH_PMG, cur_ctl);
 		cfg->partid = FIELD_GET(MSMON_CFG_x_FLT_PARTID, cur_flt);
-		mbwu_state->correction += val;
 		mbwu_state->enabled = FIELD_GET(MSMON_CFG_x_CTL_EN, cur_ctl);
+
+		if (!mbwu_state->enabled) {
+			mpam_mon_sel_unlock(msc);
+			continue;
+		}
+
+		val = 0;
+		mbwu_arg = (struct mon_read) {
+			.ris = ris,
+			.ctx = cfg,
+			.type = mpam_msmon_choose_counter(class),
+			.val = &val,
+		};
+
+		__ris_msmon_read_locked(&mbwu_arg);
+
+		mbwu_state->reset_on_next_read = true;
+		if (!mbwu_arg.err) {
+			/*
+			 * __ris_msmon_read_locked() already included the
+			 * previous correction value.
+			 */
+			mbwu_state->correction = val;
+		}
+
 		mpam_mon_sel_unlock(msc);
 	}
 
-- 
2.53.0



