Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591216;
	b=oPAvlBsgBvqkSpkTYEF4jx1BXvXR1Yz2v974zVJFNXtk/muWdGFOWGDuITF0EZUZxU9X
	 l0gCMOShK4NmT7UlCVXELAvWDEdviH1eP8dY9W9ClNPa6/5W2DbGxAX5NP0wqlaGUuj32
	 SSvNfEXnfxX3jVp/KGTWFq07xzBf4xfCwTG1KCN/2wo3hCrJ6tsFQPhHb6FCRMdIC+rpm
	 rN6L/W5aGAzIUpwl3ItRpf1ZE61NPCi3Tb2P7jWQRRnyH9NoeRwUASCcDXyyzu9SSdJwJ
	 qzAd8+yHVIOjpFOzSzGBujTun34sy5ztUqqI90JTT2Rc0rb/fvKXOvrkTiSj5svIo8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=89zBy8M/ZYCrVOWBrDio0OfmxN2lktb2EPbvPoihLfw=;
	b=QZn8WwYyPhzuyDT1mxRQ07VBti5TkHHwBoFt7iCD8OY6H45FBBTU/0cNoSKSHbiHPsGj
	 TaWzv/7jVGOeVvVNZVHlw+xBtM8QIUiWAbWuc3tN4OAFT5ynkgRsBSTtwrlk38q6UUyWz
	 GwvEwSlGTXE10AzMblkp74cwDArOe5iOonfYH23EfGJV4laLXdPV6kBEHZ4nuC8Np4nsR
	 T9lS5KLVV4oafCFmykEnzK6gTRMhhmAdBhsFdR2/zNBpnYimB+iI/NsV7+xoJW8LRrJ8H
	 t9G2PBbLUPunBdWNN9CMHsP6yyk5ioNMUD5ct7kJ8NBT3qoT/Zx5YQkE7i8H1f1qSeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXZATlht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D4606C0B7;
	Fri, 13 Nov 2026 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXZATlht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5E91F000C4;
	Fri, 13 Nov 2026 17:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591215;
	bh=89zBy8M/ZYCrVOWBrDio0OfmxN2lktb2EPbvPoihLfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXZATlhtYGtRk95r+dz5puAffvrs0i/9m9R8QPWhu/bBe04uZIwy49ky4c0TjrlLZ
	 nsSmz2X0iTrLg7FjugUWuHy1YVDkh4+a0W6X2CU2+YRMrfvRnVtzs0M8UVu6gF+SCq
	 ADlttlfAMaEitGKe02Z1oueI/7/RyVjmCN1LcrJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kylie C <kyliepc@proton.me>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/670] drm/amd/display: Dont select zero V_TOTAL_MIN/MAX on seamless boot
Date: Fri, 13 Nov 2026 10:48:33 -0500
Message-ID: <20261113153823.658839075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Kylie C <kyliepc@proton.me>

[ Upstream commit d13f36e4e055cce03761de590bc8dc6346b1d5c8 ]

Initialize V_TOTAL_MIN/MAX to V_TOTAL before enabling the selectors if
they are still 0, as optc1_program_timing() does without seamless boot.

Tested on Renoir (DCN 2.1) eDP with amdgpu.seamless=1.

This removes the flash between the bios logo & plymouth on my laptop.

Signed-off-by: Kylie C <kyliepc@proton.me>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ad7473e82b9242c4ee7eea82ab16d3f82f01651)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
index b4694985a40a4..d70b14f54519a 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
@@ -452,6 +452,13 @@ void optc2_lock_doublebuffer_disable(struct timing_generator *optc)
 void optc2_setup_manual_trigger(struct timing_generator *optc)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
+	uint32_t v_total, v_total_max;
+
+	REG_GET(OTG_V_TOTAL_MAX, OTG_V_TOTAL_MAX, &v_total_max);
+	if (!v_total_max) {
+		REG_GET(OTG_V_TOTAL, OTG_V_TOTAL, &v_total);
+		optc->funcs->set_vtotal_min_max(optc, v_total, v_total);
+	}
 
 	/* Set the min/max selectors unconditionally so that
 	 * DMCUB fw may change OTG timings when necessary
-- 
2.53.0



