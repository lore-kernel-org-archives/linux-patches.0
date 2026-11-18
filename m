Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016014;
	b=c7RqoxAGzoX/rWjFCTrdWx4dx4KLKE7zUXFq600jK/uq6Z6H8Au1zaJc0WgAcIAh+27d
	 DW4FnM9qA0OPBhRjr2enY8lY45Xi0nqmg4VIe85BaDvuUcS6xKtEFH7xEYolWZJh4Z8JC
	 60AWFADLeCmjhuiofN/Im7Y9AgkqucSmrQRqcbQ0olZGXKOuZZkXBhqhxGRb+bGV+uDBS
	 T7g62rxJw+Vi+AekbKNJ72NxkHC6nQ7zRBsGSTV+GgVfTLR8+vqt5kWfUVTtC4gOiNVvg
	 fGlQ0onhWpBQVTBiWxYiS8i8dOObSLlToaPoluTp6gO7OQWmbBdl/kaP4DW82Zw6+Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9eeGA/+J5pAYZwjMQPMKku7RA3/RcvhUKWw7gbYxHgE=;
	b=xqcZ+C2mipSpVfMEV57xlPQh+b9bzOLAajmD54SWGVr6pvNPR4+VgCdXkj28G2mjslbU
	 SXpwB5yW4mBpYTr+ZCYLdICeRuvy2bs3l1wuKKm5z+LriBjHoqTCISOGXSf1zbpr0cVBD
	 jNwIfeTu9U39n32qab00ug0VFmjbZnWMYOr+ImfctomG/8b68kF5Fhdy/QekUjq/z+c/+
	 V93iNBRq4U5fTrkt6AueCzPWcGljQntBiwmlM3T9y7VAclBirMqYurm381lmFWY0vpTdt
	 6B0g4oAfJy2MfvTq59f/tRJMehiscWg/v0Hdr9eUXIcfzkxtErqbVYoxAl2y0cHMiYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7ZDVZ72;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23791606A32A;
	Wed, 18 Nov 2026 15:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7ZDVZ72
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC2B1F000C4;
	Wed, 18 Nov 2026 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016013;
	bh=9eeGA/+J5pAYZwjMQPMKku7RA3/RcvhUKWw7gbYxHgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7ZDVZ72dhPi2TN4p5vnU4n8FG9JRXRSXqszkqZvuach/mC2TZVqK7cY33AHvJEXq
	 +zZ+36hknhjiyqUJ+2dI5KCbKXA09QqJYA1i2tnrZwy1fXvNrIwOWm8FJfOfFH1aPL
	 Wvq7gSZHZ1GgOE/JNRfw0RR3dPqfK/skZnGhLcCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0376/2651] drm/amd/display: Exit IPS before connector detection on resume
Date: Wed, 18 Nov 2026 15:26:56 +0100
Message-ID: <20261118150301.372975853@linuxfoundation.org>
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

From: Fangzhi Zuo <jerry.zuo@amd.com>

[ Upstream commit 86420fe3093161971b4064e05be11ffff1df76aa ]

[Why & How]
On resume, dm_resume() walks the connector list and, for each connector,
calls dc_link_detect_connection_type() at the top of the loop iteration
before the per-connector dc_exit_ips_for_hw_access() that sits in the
detection branch. There is no dc_exit_ips_for_hw_access() before the loop,
so the very first HW access relies on an earlier connector having already
taken the display out of IPS.

Commit d1d51519bc3b ("drm/amd/display: Skip eDP detection when no sink")
skips the eDP connector when no panel is present. On a DCN3.5 APU whose
eDP link has no sink, the eDP iteration - which used to bring the HW out
of IPS first - is now skipped, so a downstream DP connector becomes the
first one processed. Its initial DDC/AUX access then runs while the HW is
still idle, the AUX transfers time out (-ETIMEDOUT), and the EDID read
fails:

  [drm:dm_helpers_read_local_edid [amdgpu]] *ERROR* EDID err: 2, on connector: DP-1
  amdgpu: [drm] *ERROR* No EDID read.

Take the display out of IPS once before the detection loop so the first
connector processed no longer touches the AUX/DDC engine while the HW is
still in idle power state. This keeps the eDP-skip boot/resume
optimization while fixing the DP EDID read failure.

Fixes: d1d51519bc3b ("drm/amd/display: Skip eDP detection when no sink")
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f3551bd0b0a4f..0c92f9c5d5825 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1979,6 +1979,10 @@ static int dm_resume(struct amdgpu_ip_block *ip_block)
 	/* On resume we need to rewrite the MSTM control bits to enable MST*/
 	s3_handle_mst(ddev, false);
 
+	/* Exit IPS before the detection loop's first AUX/DDC access. */
+	scoped_guard(mutex, &dm->dc_lock)
+		dc_exit_ips_for_hw_access(dm->dc);
+
 	/* Do detection*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
-- 
2.53.0



