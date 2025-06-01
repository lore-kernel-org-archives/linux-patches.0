Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2412571C5;
	Sun,  1 Jun 2025 23:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820293; cv=none; b=VKp4LC1PhYJNWjxR6LMjOfVWD6HUx4yO0biE1g75Qdh2teqUgDd82Zjr/LuxPmosIwD6QQ9N0BCaPGjc6kQqkPXVjmnSvoFFxvsN0jqkJ8cFyPByUoIqQqT8bhlv7mhM6go5/lZxS9gitqIQmz39en8Auq3Gee9saOlLh1tdw6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820293; c=relaxed/simple;
	bh=ogFhDNg55RVnGKs4hHMHSRvq3akhinNUm2zvM0MZFEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EDY/tM7GQMVrfajQU4F1BApqAhO2Xr2zMmRUQv634VjiX4qnAuVT2wVcY5IzZMItUyapgaIcTBOsJxdHho6PbqRoF5/rUEK74btHbqUvTLIvaYtKq9RdiC1PmWsw3hhOVYqCk70a8UKsQTEt0OHnVgb39yHuFaVp7stWKJLRGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGm4VOUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGm4VOUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4F1C4CEE7;
	Sun,  1 Jun 2025 23:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820293;
	bh=ogFhDNg55RVnGKs4hHMHSRvq3akhinNUm2zvM0MZFEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGm4VOUEHVJmcgjSc6iww+lWbadt3YLvyT1bKU4kV/bnaPdq+eQzUG+h38ao31ZnG
	 FSL4F/N4M2sENBqZW1OllkjkoDdQPfNGBBTTtFDllw1tA5qjz5Sy10ecVMma8FbWfs
	 MiiGdxHRbiN7kLWhfnZ7hyddxXM8HBZXotRJ47b2T6Ng+VWMgnr8cuM4TkaQaThcLS
	 is4XdZP2KxXhBfV0nMfSCiBkjMlTuYC2Y1STG8iBh7PChnOT0H8h1S+FhrahlOomLp
	 NWw+WWuJZxE8DGNDFRwMPAHeeCh+DjudRRrEadkpQv6KxmD4/GXX1o2yv1LQkZ8eLK
	 z9/6qJabHhEXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	lumag@kernel.org,
	jani.nikula@intel.com,
	imre.deak@intel.com,
	lyude@redhat.com,
	suraj.kandpal@intel.com,
	arun.r.murthy@intel.com,
	andy.yan@rock-chips.com,
	abel.vesa@linaro.org,
	mitulkumar.ajitkumar.golani@intel.com,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 006/110] drm/dp: add option to disable zero sized address only transactions.
Date: Sun,  1 Jun 2025 19:22:48 -0400
Message-Id: <20250601232435.3507697-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit f0ddbb1eed1898286d2bd99fd6ab64ca9700d267 ]

Some older NVIDIA and some newer NVIDIA hardware/firmware seems to
have issues with address only transactions (firmware rejects them).

Add an option to the core drm dp to avoid address only transactions,
This just puts the MOT flag removal on the last message of the transfer
and avoids the start of transfer transaction.

This with the flag set in nouveau, allows eDP probing on GB203 device.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Reviewed-by: Timur Tabi <ttabi@nvidia.com>
Tested-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees for the
following reasons: 1. **Fixes Critical Hardware Functionality**: The
commit addresses a significant bug where eDP displays cannot be probed
on certain NVIDIA hardware (GB203 and others). The commit message
explicitly states: "This with the flag set in nouveau, allows eDP
probing on GB203 device." Without this fix, users with affected hardware
cannot use their displays - a core functionality issue. 2. **Low
Regression Risk - Opt-in Design**: The code changes show this is
implemented as an opt-in feature through the `no_zero_sized` boolean
flag: ```c /bin /bin.usr-is-merged /boot /dev /etc /home /init /lib
/lib.usr-is-merged /lib64 /lost+found /media /mnt /opt /proc /root /run
/sbin /sbin.usr-is-merged /snap /srv /sys /tmp /usr /var 0001-Fix-
Clippy-warnings.patch 0002-Enhance-inference-prompt-to-utilize-
CVEKERNELDIR-whe.patch 0003-Update-to-latest-version-of-clap.patch
Cargo.lock Cargo.toml LICENSE README.md analyze_merge_commit.sh
dpp_rcg_backport_analysis.md io_uring_analysis.txt ksmbd_analysis.txt
merge_commit_analysis.txt model prompt src target test_gpio_cleanup.txt
test_patch.txt @no_zero_sized: If the hw can't use zero sized transfers
(NVIDIA) model/ prompt/ src/ target/ bool no_zero_sized; ``` The
modified behavior only activates when this flag is explicitly set,
meaning existing functionality remains unchanged for all other hardware.
3. **Minimal and Contained Changes**: The code modifications are limited
to: - Adding a single boolean field to the `drm_dp_aux` structure -
Wrapping existing zero-sized transaction code in conditional checks: `if
(!aux->no_zero_sized)` - Adding a special case to remove the MOT flag on
the last message when the flag is set 4. **Historical Precedent**:
Similar commits addressing DP AUX transaction issues have been
backported: - Commit #2 (drm/nouveau/i2c/gf119-: add support for
address-only transactions) was backported to fix display regressions -
Commit #5 (drm/bridge: analogix_dp: properly handle zero sized AUX
transactions) was explicitly marked with "CC: stable@vger.kernel.org" 5.
**Affects Multiple Hardware Generations**: The commit message indicates
this affects "Some older NVIDIA and some newer NVIDIA
hardware/firmware", suggesting a widespread issue across different
hardware generations that stable kernel users would encounter. 6.
**Well-Tested Solution**: The commit has been: - Reviewed by Ben Skeggs
(nouveau maintainer) - Reviewed and tested by Timur Tabi (NVIDIA
engineer) - Signed off by Dave Airlie (DRM maintainer) The commit
clearly meets stable kernel criteria: it fixes an important bug (display
functionality), has minimal risk due to its opt-in nature, doesn't
introduce new features or architectural changes, and addresses a real
hardware compatibility issue that affects users.

 drivers/gpu/drm/display/drm_dp_helper.c | 39 +++++++++++++++----------
 include/drm/display/drm_dp_helper.h     |  5 ++++
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index dbce1c3f49691..753d7c3942a14 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2081,14 +2081,17 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 
 	for (i = 0; i < num; i++) {
 		msg.address = msgs[i].addr;
-		drm_dp_i2c_msg_set_request(&msg, &msgs[i]);
-		/* Send a bare address packet to start the transaction.
-		 * Zero sized messages specify an address only (bare
-		 * address) transaction.
-		 */
-		msg.buffer = NULL;
-		msg.size = 0;
-		err = drm_dp_i2c_do_msg(aux, &msg);
+
+		if (!aux->no_zero_sized) {
+			drm_dp_i2c_msg_set_request(&msg, &msgs[i]);
+			/* Send a bare address packet to start the transaction.
+			 * Zero sized messages specify an address only (bare
+			 * address) transaction.
+			 */
+			msg.buffer = NULL;
+			msg.size = 0;
+			err = drm_dp_i2c_do_msg(aux, &msg);
+		}
 
 		/*
 		 * Reset msg.request in case in case it got
@@ -2107,6 +2110,8 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 			msg.buffer = msgs[i].buf + j;
 			msg.size = min(transfer_size, msgs[i].len - j);
 
+			if (j + msg.size == msgs[i].len && aux->no_zero_sized)
+				msg.request &= ~DP_AUX_I2C_MOT;
 			err = drm_dp_i2c_drain_msg(aux, &msg);
 
 			/*
@@ -2124,15 +2129,17 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 	}
 	if (err >= 0)
 		err = num;
-	/* Send a bare address packet to close out the transaction.
-	 * Zero sized messages specify an address only (bare
-	 * address) transaction.
-	 */
-	msg.request &= ~DP_AUX_I2C_MOT;
-	msg.buffer = NULL;
-	msg.size = 0;
-	(void)drm_dp_i2c_do_msg(aux, &msg);
 
+	if (!aux->no_zero_sized) {
+		/* Send a bare address packet to close out the transaction.
+		 * Zero sized messages specify an address only (bare
+		 * address) transaction.
+		 */
+		msg.request &= ~DP_AUX_I2C_MOT;
+		msg.buffer = NULL;
+		msg.size = 0;
+		(void)drm_dp_i2c_do_msg(aux, &msg);
+	}
 	return err;
 }
 
diff --git a/include/drm/display/drm_dp_helper.h b/include/drm/display/drm_dp_helper.h
index 5ae4241959f24..736dbfdd6321d 100644
--- a/include/drm/display/drm_dp_helper.h
+++ b/include/drm/display/drm_dp_helper.h
@@ -518,6 +518,11 @@ struct drm_dp_aux {
 	 * @powered_down: If true then the remote endpoint is powered down.
 	 */
 	bool powered_down;
+
+	/**
+	 * @no_zero_sized: If the hw can't use zero sized transfers (NVIDIA)
+	 */
+	bool no_zero_sized;
 };
 
 int drm_dp_dpcd_probe(struct drm_dp_aux *aux, unsigned int offset);
-- 
2.39.5

