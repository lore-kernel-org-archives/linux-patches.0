Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017990;
	b=4M4Jd+IyxuBlLZ1jeCud/VA1o5Qz2vMWJCc0Iuioy9lU32tRHxTAVsWqljdHY9d+Dbnw
	 Rlp+87ASW1GTHQymElKgG9NKWrCKfbu6/FioAHDXM0t2p49U1GgJuLL0lInGimE400xH4
	 q9DwKF/A4lL1Xk6m0E6TEH52d+ovNPQ6RZp8DaW9MAGXjaK0MOTyRKYZZMkSg6uRnjunO
	 tLmiGGO8wl9nIw5wAPgQbM7WclLZoKzyCiilEREXCjelA5uZVpwIO+mW/yrHlE0rNR4Gm
	 ZAhYwIvx2cqYR2NYJUZuRQKrrUB20w3I4WCZERROky9nYqVIz0/4KP/TMY+po/72iDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GFg9ZPqLpReq4L3o0UCrBmVN8+xtYrNl4O07n2sKZn8=;
	b=1g35gYphn481iXyYZpThYaN5W1T7vZK7ROALB/f6YgQshQ/wKFnSOP91e1k65sTv+c9D
	 68uhn/bPowMQttha9egF3KFkDnzAPad0lPNMJdZKHVQ4yRs60S9Cv61wvYKyOJXzN8YJT
	 KhZNk5QDTFVFfS6PhpGO2hQqN7Cii9LTOpyQw7F+1fq/Fwv/g29GPTd4uKCSe4SOoIEba
	 jCRB8pZMexLJ2mhRJF7GDeboJVzFswvPMoFsIYRU4ljLa0kTO/SpUWMVL9PzY4VpbspU8
	 egJOyjtXFJ+nCKPQpZUHteeCF22fc+1hw7FbA3EHaWEvCEr86IcY4K5w2JkYKcgw7qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tccyr7dU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D04606A320;
	Wed, 18 Nov 2026 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tccyr7dU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893101F000C4;
	Wed, 18 Nov 2026 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017990;
	bh=GFg9ZPqLpReq4L3o0UCrBmVN8+xtYrNl4O07n2sKZn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tccyr7dUnEo3/LVDN+YlGjYXVNaSRlAGGAizY9IdUGcKG5GyLHon3CFLmQrYy7GWw
	 QYE1j0s57U8LZtRQTla147zjvVh+kEmEwzNKXoxfre0zHTC28Mt3jQ+ZTIVFtglCIZ
	 JR+u/O+XUxKoY2xOf3Z+OQCOiZm0KWH9Pox5asPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Lu Yao <yaolu@kylinos.cn>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1080/2651] drm/amd/display: Fix wrong plane index in dcn6 writeback latency loop
Date: Wed, 18 Nov 2026 15:38:40 +0100
Message-ID: <20261118150326.877371337@linuxfoundation.org>
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

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 2c3ed158087d2971cad00faab24e2143eef49944 ]

Use plane_descriptors[k] for the loop bound, matching the loop body.

Fixes: 7f7d7ea1fa51 ("drm/amd/display: Add new sources for DCN6")
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn6_calcs_dchub.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn6_calcs_dchub.c b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn6_calcs_dchub.c
index a4e2f8604650f..60e873edf13c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn6_calcs_dchub.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn6_calcs_dchub.c
@@ -1252,7 +1252,7 @@ void dcn6_calculate_watermarks_and_dram_speed_change_support(
 			DML_LOG_VERBOSE("DML::%s: k=%u, VActiveLatencyHidingUs = %f\n", __func__, k, p->VActiveLatencyHidingUs[k]);
 		}
 
-		for (unsigned int j = 0; j < p->display_cfg->stream_descriptors[p->display_cfg->plane_descriptors[j].stream_index].writeback.active_writebacks_per_stream; ++j) {
+		for (unsigned int j = 0; j < p->display_cfg->stream_descriptors[p->display_cfg->plane_descriptors[k].stream_index].writeback.active_writebacks_per_stream; ++j) {
 			double byte_per_pixel_luma_in_buffer = 1.0;
 			double buffer_for_luma = (double)p->WritebackInterfaceBufferSize * 1024.0 / 2.0;
 			if (p->display_cfg->stream_descriptors[p->display_cfg->plane_descriptors[k].stream_index].writeback.writeback_stream[j].pixel_format == dml2_444_64) {
-- 
2.53.0



