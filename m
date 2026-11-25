Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618445;
	b=hXTcwE2lv2Ijx+/73T9+CGqYlZVN6BQ0Wv0Pp5c/3TbcdUH73NtbH3YM84ZiwAUgEUSQ
	 3B6Scc1/dP/s0KpzjYcypUO8MQHXOyayC/EWSJ8BE8zab62LSqjuiTtqWugYHuwvohPtf
	 Aj9HrsQehJolVc+mnCxUBRXg5r8Z9Grqukft1CwpswOyjzN4ZWuh57CAqUx0zzyExWO90
	 hqQkd+f/BgUdYQ8MDLdp98Ylg+2hNVpMTasFAK8v6zHU6UTzlIJy+4o1xw4bESU9gC4Xn
	 nAIat5rlxaWV+fnv8Ypo44GkpCJKBhQb4HKZ3qTzk5aSEki1zYms8qUNN2ksKBPCbcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WziM/meuh5RJL4Rdwo7TxV9tOaxZlACr9SHO2kF3r2g=;
	b=S16I48vK2xP/8mWEtYw9qb+6/CbnRUtX5tIR2mDnuwxAz+AqmJuEznRCbCYHl62t63Yb
	 VXU3XO0e2vOmlINxLbL376gF8KtCzs3HDMjzs2FBZ31lAXikHRhjACnIthAcHCENAhZFj
	 1vdzdTrTf0qLik+Ux9PwArWWVoOakQ1q+tA1VKWQfdLbTI7NS23Nvqowem9rpAdYNBStD
	 WpC/9K60NSwa5DBXaVtqHGBRq0fkRl7QuVFLgablhLQ+Q/CChbGGpIZ6h9VkQemGDVy01
	 Psbu3/nrD01UxCk+m/ebmjhJE54VEuBW13BUa/XETm2mxDqSNmoPmIygtDzc+Ktzsfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cz35/Lcz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC17606A327;
	Wed, 25 Nov 2026 14:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz35/Lcz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608A61F000C4;
	Wed, 25 Nov 2026 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618444;
	bh=WziM/meuh5RJL4Rdwo7TxV9tOaxZlACr9SHO2kF3r2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cz35/LczgsUM/XC0N9gSiPFLSObPZqLt+5EEjJRmoH3kvzmE1jPUAUdkXfuqMZ2eV
	 V1GGaWeHzywQUXtvvj39XNh+XgcwUSFUe8qcfBVPXzhnySFGLIU/0Hbc36Mwa+x4FT
	 V4Js8HBOPxdtqIDsW1kSPO8f5IeAlcc3xXMhHldI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Blomquist <nblomquist@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0282/1005] drm/amd/pm: track BACO state in the SMU v11 ArmD3 sequence
Date: Wed, 25 Nov 2026 15:27:00 +0100
Message-ID: <20261125143828.349576393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a26ec190925733dd205507493e936e59dbcd2b19 ]

On Navi1x/Sienna Cichlid with runtime PM, when the audio function is
enabled, BACO entry and exit are delegated to PMFW by sending
SMU_MSG_ArmD3 instead of going through smu_v11_0_baco_set_state().
Unlike the v13/v14/v15 helpers, smu_v11_0_baco_set_armd3_sequence()
does not update smu_baco->state, so the driver keeps reporting
SMU_BACO_STATE_EXIT while the ASIC is armed for / sitting in BACO.

At runtime resume amdgpu_device_baco_exit() checks
amdgpu_device_supports_baco(), which ends up in
smu_v11_0_get_bamaco_support().  Since the state never reads ENTER, the
"already in BACO" shortcut is skipped and the live BACO feature bit is
consulted instead.  PMFW clears that bit once ArmD3(BACO) is armed, so
the check reports "supported but not enabled", the exit fails with
-ENOTSUPP and the ULPS ArmD3 message is never sent.  The runtime resume
caller ignores the error, and a later secondary bus reset leaves the
device unreachable.  This shows up on a Navi 23 being handed from amdgpu
to vfio-pci:

  baco_enter: in_runpm=1 audio_enabled=1 armd3=1 baco_state=1 ret=0
  bamaco: state=1 ... feat supported=1 enabled=0 in_runpm=1
  baco_exit: supports=0 ...
  runtime resume: baco_exit ret=-524

Update smu_baco->state in the helper, mirroring the v13 implementation,
so the capability check short-circuits while in BACO.

Reported-by: Nathan Blomquist <nblomquist@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/6076
Tested-by: Nathan Blomquist <nblomquist@gmail.com>
Fixes: 13d75eadfa1a ("drm/amd/pm: correct the runpm handling for BACO supported ASIC")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20261103141457.2558235-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d515b2694eab5b35533c7fb7af5bddff53ff60d3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c    | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index f0b2e7da67b1b..d2dfa2bb50a52 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1421,7 +1421,25 @@ int smu_v11_0_get_max_sustainable_clocks_by_dc(struct smu_context *smu,
 int smu_v11_0_baco_set_armd3_sequence(struct smu_context *smu,
 				      enum smu_baco_seq baco_seq)
 {
-	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_ArmD3, baco_seq, NULL);
+	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	int ret;
+
+	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_ArmD3, baco_seq, NULL);
+	if (ret)
+		return ret;
+
+	/*
+	 * PMFW owns the BACO transition once armed, so keep the driver's view
+	 * in sync.  Otherwise smu_v11_0_get_bamaco_support() falls back to the
+	 * live BACO feature bit, which PMFW clears when armed, and the runtime
+	 * resume wrongly concludes BACO is unsupported and skips the exit.
+	 */
+	if (baco_seq == BACO_SEQ_BAMACO || baco_seq == BACO_SEQ_BACO)
+		smu_baco->state = SMU_BACO_STATE_ENTER;
+	else
+		smu_baco->state = SMU_BACO_STATE_EXIT;
+
+	return 0;
 }
 
 int smu_v11_0_get_bamaco_support(struct smu_context *smu)
-- 
2.53.0



