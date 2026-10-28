Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213583;
	b=TznUUokNxky3JCOk5LLimFaLPgkZiyDfGqfXVKv4GylutUxmdWmaRt7reNsQS1Ub68su
	 SF12ZnhUnFhkSzfTKb7CBheaXibkWQY2noIcaQOH/7akF6NbWHfeH0CkKK66pu98W5IEU
	 U55iU8yILnPdXw2/xXu6yJJwZYdFcyH3MJxO8ZUk+E7gAxxslCLJ6qNWKHwIYLgpYHKBf
	 bXNdR4Rrsg4j9Sf/i7hZVg8xrsdAIB5UEdqtC1xbuaZjbTOdST5Vkr6aw3ArNsT3Yk3Zl
	 FxlFDUpc15ZK3mMRqSkWBgIEvxhHY8s42h0sjbUHvmuKCOMUnn7Ov12xAzl6hI67xuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YAh5Q+j3wHYpo8zH0xw6ajaJ6zAnjgfU5z/Bz0EqsMs=;
	b=MJYMnJufKjtHi/SC9npj1XF0zeXwzqBoN0qvf4m8BEmpaDYQsD0VY/PWzRYKu7PuVJ0q
	 xnFfaPqvm9c8mVb+MlcRyZ5pSbjnviL6Zg1jMziGi2oIWZMnrz5zzl4wkgcQ1FGmy4B0F
	 yHEzDBDJZ82Z/A06Rino4GGSHcoE3wxWCTxprZoccWeXrsFvH0UWZAae1OP4pPbfsj/9a
	 iYFOcBtLPsQhJrDllp253MzURpV0EE67G7gs0fzVshcb7dbdLGXNT8thmwuSpWgIbbD8B
	 20H3V0AtGXNxh4zY4zZY6JKNZuY87venWH+6haoMUrByFv6jBfuUZY0vzUK1TX+F1RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIK05R9u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD6B606A31F;
	Wed, 28 Oct 2026 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIK05R9u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68211F01825;
	Wed, 28 Oct 2026 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213583;
	bh=YAh5Q+j3wHYpo8zH0xw6ajaJ6zAnjgfU5z/Bz0EqsMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIK05R9uNicMiRtrpPrHpIG+4+pT25/Q49AbwDP9PeA1G8oxg7U8EYkUmZC1OE11F
	 OS5Kxc2FrsanzcnE6agZhYgGSqGB8jh4YEEJvETY8JUYI1QgMtkLkTlxa+OeYS5D5q
	 vzvgEvlU1MyhXM5L2bIgp6+4NgKDVmvQWY4IPRUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0557/1887] drm/amd/display: Fix hang/underflow when transitioning to ODM4:1
Date: Wed, 28 Oct 2026 17:44:13 +0100
Message-ID: <20261028170512.055930907@linuxfoundation.org>
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

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit e7b2b108cdeab76a7e7324459e50b0c1214c0386 ]

[Why]
Under some circumstances, disabling an OPTC and attempting to reclaim
its OPP(s) for a different OPTC could cause a hang/underflow due to OPPs
not being properly disconnected from the disabled OPTC.

[How]
Ensure that all OPPs are unassigned from an OPTC when it gets disabled.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c | 7 +++++++
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c   | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
index 7dd36e402bac7..56487ba4d00e6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
@@ -139,6 +139,13 @@ static bool optc314_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(OTG_CONTROL,
 			OTG_MASTER_EN, 0);
 
+	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
+			OPTC_SEG0_SRC_SEL, 0xf,
+			OPTC_SEG1_SRC_SEL, 0xf,
+			OPTC_SEG2_SRC_SEL, 0xf,
+			OPTC_SEG3_SRC_SEL, 0xf,
+			OPTC_NUM_OF_INPUT_SEGMENT, 0);
+
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index 37c645a882dd8..4a2fa9bb5393c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -145,6 +145,13 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(OTG_CONTROL,
 			OTG_MASTER_EN, 0);
 
+	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
+			OPTC_SEG0_SRC_SEL, 0xf,
+			OPTC_SEG1_SRC_SEL, 0xf,
+			OPTC_SEG2_SRC_SEL, 0xf,
+			OPTC_SEG3_SRC_SEL, 0xf,
+			OPTC_NUM_OF_INPUT_SEGMENT, 0);
+
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
-- 
2.53.0



