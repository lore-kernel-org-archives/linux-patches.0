Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061466;
	b=qq5LZn1ZISU+tfHF/0+GnnavK2vkiJOnYie63NQjpSF+t/d4ad4AbWXXABLxfvSoPnu3
	 9lHhXGXHJZnUGk1XYS9qHH+r9q5inNoTcu/TEmwisP7TT37ipCxK+j8oC7OEhEslqicUv
	 wUWBZK4s3dJz74fgXcrSnxjC6BZ9gtUu3zXoSeQbtDG4T6tvtpA6BQcQ2Ab+QHTzt4uZ2
	 ZNRdLBiTQQuUord6Ef/0nVd9GlswxFrxW03AZCT/nIL+x/wjJzEN39pX8IJWj/Y4+uYTp
	 dPK9S57nft/rDT+UMt+8lWIXiLeCwAj32Nr2LoJMNW1ad0udJsEeZtk2LZlkD39IdRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PaJT8wZ+6fOhTsFmQDFafSNmtwHge5H4pWoA3MLekZ4=;
	b=ayij/hWoqDE94Ge8Rew+iJxOw0fsVQnGheYNvWpVcWLLGGWd9O3n5s655XbZ/91vYaM9
	 JvQEEtoOP9UF+xw0URxzhWGs0Fn8zGOEmAPH08Qd8J2wnX21rjbRypPPEYN9FyJ6e3FhR
	 SEMdFj8tbyeWLRfxMRtLP+wNmEJE8drO/+RXSslNb1nX6oRAj0l1yvsfbNe2SdPoAGnxG
	 tfkyuMUo3WQ0yA+EjFC8FuyexXIgZepRD21leyjeCcIYb+XK3RAGTwkR+MZy1KvoWNA8o
	 kbUT0D+oWMcL3FNfNCvLrVdoHwaQwCzjilgSW6Gn9ikzmjybgqIRIGwJLKveXx1ttig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IDEIqiEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7E6606A336;
	Sat,  7 Nov 2026 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IDEIqiEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041471F0089F;
	Sat,  7 Nov 2026 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061466;
	bh=PaJT8wZ+6fOhTsFmQDFafSNmtwHge5H4pWoA3MLekZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDEIqiEzp6EQazC/SExJJrIZ9+UqTUm4NocrspgJtD+FmVwyy7cdyjqTsWuScnMOG
	 1Q5volavftbbgi0esY6HB8CPtw4gakiCAcI16fwrjcMRr8TcDQGRq8S82nWDzZjvUn
	 ZvApr8jQiUErHv68drjaqge9BiO2DdaTQBiIIHhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0567/1536] drm/amd/display: guard dc_sink dereferences in MST mode validation
Date: Sat,  7 Nov 2026 08:43:03 -0500
Message-ID: <20261107135013.502131668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 217f64f348c90cba62164e7ff38e0ccf78a5ca09 ]

dm_dp_mst_is_port_support_mode() reads
aconnector->dc_sink->dsc_caps... for the DSC branch-throughput check,
and get_conv_frl_bw()'s HDMI-PCON FRL-bandwidth path reads
aconnector->dc_sink->edid_caps.max_frl_rate, both without a NULL
check. dc_sink is cleared asynchronously on MST unplug, and both
functions run from paths that the driver's own comments document as
racing that teardown: the connector probe worker's ->mode_valid
callback and a compositor's atomic check, neither of which holds the
MST manager lock that the teardown path uses. The former does have an
existing dsc_aux NULL check, but dsc_aux isn't reliably cleared in
every path that clears dc_sink, so it doesn't cover this.

Fail the port-support check and skip the FRL conversion path when the
sink is already gone.

Fixes: f04d275d94e1 ("drm/amd/display: add mst port output bw check")
Fixes: 5c9b8b27a883 ("drm/amd/display: Tie FRL support into amdgpu_dm")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7c3db8da4e039698ae198c870712428644e965c7)
Cc: stable@vger.kernel.org
[ sashal: Dropped the conflicting get_conv_frl_bw() hunk because this tree has no HDMI-PCON FRL code, keeping only the dc_sink NULL guard in dm_dp_mst_is_port_support_mode(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9a3deb26149d8..8db1ce500fbcf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1819,6 +1819,9 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	struct dc_dsc_config_options dsc_options = {0};
 	uint32_t stream_kbps;
 
+	if (!aconnector->dc_sink)
+		return DC_FAIL_BANDWIDTH_VALIDATE;
+
 	/* DSC unnecessary case
 	 * Check if timing could be supported within end-to-end BW
 	 */
-- 
2.53.0



