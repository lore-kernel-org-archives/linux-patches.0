Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044053;
	b=fJNOPvHqEbH/gSIrJq1/mANGd5CJzBc3LU5JZ700JjkWcdv3Lo3lVyBjC0LenEDGMdYG
	 VcsP+BkbBLbJwWmh9O5H70P7tHZ/+DT0A8ss1QAPCfCq6hE6uXuJerpA1hgf04bAFDfao
	 WtMc1s+34JwO57jvDTZkMlqRBuAgWTD7FdYhlle6OdnJxUcj02x0162EdSuOiIfD0yajW
	 hMPmthmX9oiTkK2QIDVhn3uF26ZmQ5ycIsRS/Lj/YHDL/RtymlD2SIlktVi4pYjXixe9j
	 fOoi3qJbMc5i2iln2MRJlEE8bcEtL84abwU0GQzAY+RQe/53wRBy8AQ6bCTtfD51meg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p0eRqWWO4WdNpVDYz4lHMeW/0j4hywo3Smv6p6+K8z4=;
	b=IDvp32MzH2Psnnm0O25KBt6TCq9EUmoIo9jxVYZnHxlGA8rvpPZCWxIp941c/X01lubI
	 3eWr0fFT/cs7k0WSe6FF9Vvx5PTL2p+AEpMmBG3tRa/wso5h4Y7gODUKg6DnhfH9LI/Zj
	 iBbTiXGkpgiMtj/etEa09SAqKFoSKIaYclW7MHfgKE1qVoF+t1zXYpCMyAKOpMOTprT03
	 hWqpeQ1i/SZDcuBVHSCkFyP9lbiKgtC8XC7laurDRk5eK6+WfjuzIHib1m3BgcLF8LWcy
	 py8RlTcWK/lASB0wusw90DEk1dvhu4CTPZD7scdxUr7VA3COEqbRYW206mfOqs5kSVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqse2xQd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E544E606A32A;
	Wed, 18 Nov 2026 23:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqse2xQd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA481F000C4;
	Wed, 18 Nov 2026 23:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044052;
	bh=p0eRqWWO4WdNpVDYz4lHMeW/0j4hywo3Smv6p6+K8z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqse2xQdddaeT6RAr5IAL6Z48CbIURZEfOFHnvH0Mmu8hKKavoJfd9Akayb5XPMO1
	 3dQ7MVx0X6QpzR7k7jEmf15VcfXcYxF2rtbGoZHTruJQ9lCvttw64nzXrNqvj/LBQ/
	 4F9iBKv23LQMF10LNEBIIU3OI2z+OfDyLiNdJki8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Costa <leonardo.costa@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Swamil Jain <s-jain1@ti.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0413/2857] drm/bridge: tc358768: Enforce input bus flags via atomic_check
Date: Wed, 18 Nov 2026 15:24:07 +0100
Message-ID: <20261118150216.255270830@linuxfoundation.org>
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

From: Leonardo Costa <leonardo.costa@toradex.com>

[ Upstream commit ed761e0693950fcb4f6b0f60387a3961b972adf3 ]

The tc358768 declares static bridge timings requiring pixel data to be
sampled on the positive clock edge.

However, the DRM core default propagation simply copies the output-side
bus flags, coming from the next bridge, connector or panel, to the
input side. If the propagated flags are incompatible with the bridge
ones, the data is wrongly sampled, typically resulting in visual
artifacts on the panel.

Implement the atomic_check hook, replacing the mutually exclusive
mode_fixup, and set the bridge state input bus flags to the ones
required by the tc358768. The sync polarity defaulting previously done
in mode_fixup is carried over into atomic_check unchanged.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Leonardo Costa <leonardo.costa@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Swamil Jain <s-jain1@ti.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260706132440.1594239-1-leoreis.costa@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
[ sashal: Added a new atomic_check hook that only sets the input bus flags, since mode_fixup and the sync-polarity defaulting it carried are absent, and kept the older pre_enable/enable hook names. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index acbbf1e79fb78..e9ca3054d4ccd 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -1146,9 +1146,20 @@ tc358768_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
 	return input_fmts;
 }
 
+static int tc358768_bridge_atomic_check(struct drm_bridge *bridge,
+					struct drm_bridge_state *bridge_state,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state)
+{
+	bridge_state->input_bus_cfg.flags = bridge->timings->input_bus_flags;
+
+	return 0;
+}
+
 static const struct drm_bridge_funcs tc358768_bridge_funcs = {
 	.attach = tc358768_bridge_attach,
 	.mode_valid = tc358768_bridge_mode_valid,
+	.atomic_check = tc358768_bridge_atomic_check,
 	.pre_enable = tc358768_bridge_pre_enable,
 	.enable = tc358768_bridge_enable,
 	.disable = tc358768_bridge_disable,
-- 
2.53.0



