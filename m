Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044192;
	b=AynIlaY09w/AmzIQQUy2/k9twuC+VuMpG0j+A6V2as7BUAgChGGfNHMj1Nb1sW+YTUFX
	 /O7k/khP41Ka9F/OO0ZPxrkfoB5+ZeXynW9Y22on2b2Rkfh5K+JIO2Pfx3BKpMGsR0L4i
	 iL5Enm4yfMoMn2M2G9m0smw4aBLryJawjqRQhOk146qEKL6MmVnp03LtfBKRjgiLyXH5f
	 SeL++N0v4m6b+mx0k/Dse4LfIEkWjLY5kVLBjARWZfL5QahCXueaN5/ASoTI/Oc9q0O6u
	 lyYAYrspUV2ZwPqVmcwfhIufXhVvpNZ2ZpopiVc/mOwn8C2VwVkcDmxfmvHnKMTTbaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i8a+QAzNQWFJiuACs5j3FibFq3OHApQSZZSxuRsd/60=;
	b=ELK6/5pKSdUqDl1eBvjsKfcxNGqLosIm+ZoNPufOlBXwRtgur0K+3ooqErx7X8xqEcs2
	 Mv9/DvvyekGWK+Ud/ikl6+ypzmNk92/h4VEWu5t6lGa61fhaJ5tlmNKhrVtprYKClCmRX
	 Fyjhz+8sOOPRY2juO3sc0qqmn8ZSqSR7841CLt8FIpLoOO2r5LbmIPo4exmvCNhnwSVzV
	 Miy4juEmPu0/nz4skz8uceAjY+/yTPZrfmjU0Kt8nZKLkoHN/GEzhqM88bdZLiaXeAY+X
	 H63QR539RnqJ6smqgg7xktbnXVgOsjAzdLBPIJ+jJ59gdjZN1RV5s6Jg5Yh0acbjV/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1tBogKa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2511E606A330;
	Wed, 18 Nov 2026 23:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1tBogKa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631181F000C5;
	Wed, 18 Nov 2026 23:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044191;
	bh=i8a+QAzNQWFJiuACs5j3FibFq3OHApQSZZSxuRsd/60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1tBogKatO17gj62LyVQE+JT+n6H+1Vr1ov04uym6T1bq8otKrv3aPVdrTNL+x/Ed
	 6aJLlDPRryfGkt3NnKWvp242rH/8eDjMd7XcNJl3lp6uMU7pWZeMOhgrefZjQL43yh
	 2PHaZav4Q2neSVxJeca5IZCbzTHG3HYVw/dYimXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0481/2857] drm/amd/display: guard dc_sink dereferences in MST mode validation
Date: Wed, 18 Nov 2026 15:25:15 +0100
Message-ID: <20261118150218.758512266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: Dropped the hunk for the missing get_conv_frl_bw(), and placed the dc_sink NULL check just before the first dc_sink use, after the #if declaration blocks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 94c83a707acc6..92ed349c43d91 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1671,6 +1671,9 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	}
 #endif
 
+	if (!aconnector->dc_sink)
+		return DC_FAIL_BANDWIDTH_VALIDATE;
+
 	/* check is mst dsc output bandwidth branch_overall_throughput_0_mps */
 	switch (stream->timing.pixel_encoding) {
 	case PIXEL_ENCODING_RGB:
-- 
2.53.0



