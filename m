Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208423;
	b=G5RnLbmpRsmomUMfZ+roro28dSx9fEz1MvWMxOjDNwOg7ZPRZCvbba27qDAIp7dL6nFi
	 lqK9GYuCYaLkeZA+lkolt90ReybBt/FmLhrBSyrXS+oOI5VGnHClZxY9eP70TUrASeKIP
	 9CFnRhLZSdPZg+GQJjrk2flx5W035cRKwGfP3ZnfBVz6yrgkOrKReD12E1wTKaFOs4PCB
	 VEv0tSFwLftHU4HV08zd/cltuDdchBo/gmcwmGQCWBWmEBrdn9nVpH2+8xAxBAgRe/kH1
	 ctxh+k8zXDNFldBrWe3osJ2eF/CkvWYkgb3Hv81AW/0DnGkz37ENtHE4KogC/HJFUDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r6w83tdj9IZHTxo6RdWN4CXBW1Zu2j1dse7scrvAxcw=;
	b=k9eCOK2Cx/PBrrp9etWQpl+P2D7Ed5ZHHk9WSe5hdliEgw+J5VID3fJrfkYG60cChdTh
	 tqvlmuIXKd9BOgYezR0RASHD684lzdTdX360RZ74Rqx0MYU24QVQiRC43i156zDpOpEMs
	 9NRgmTvP1MKrWf5Z0z9Ayxr8iGpwPT7Ano0Ipx8YQbg9eSzKGGGwOlItp6CgZTZh/ZJug
	 ZHEssdKXoznWdhb+54EMDc+FayVr6JfEW+NUeaOXh2I1ZbFFKMcajeKISL06NMvUfs5Uw
	 OJtBzAcCbW6txKa4XKvglreQWPdfO0BinIFNSduj5ZD8TlUeKT45xKdnjtnd/Xz6Skw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioYcbGBV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE5C606A31A;
	Wed, 28 Oct 2026 17:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioYcbGBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6B91F01825;
	Wed, 28 Oct 2026 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208423;
	bh=r6w83tdj9IZHTxo6RdWN4CXBW1Zu2j1dse7scrvAxcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioYcbGBV/ecG9DrZ+VfwdovrEM5VD+1aWPK+j4yQUQoXwnKrSWXuoi/ZaG5x5WOi1
	 kYcogKIHV8maYzj6H3NDMKCcPyMwM5tm6/FWE6pMlDOPOeDxafRk3KlTpyIQdNhBeM
	 1NgLw+vatwNbQ3TIBEJA/xuvaSr03Y28BGZ9nbr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mack <daniel@zonque.org>,
	Kavan Smith <kavansmith82@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/516] drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value
Date: Wed, 28 Oct 2026 17:54:09 +0100
Message-ID: <20261028170005.820384742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kavan Smith <kavansmith82@gmail.com>

[ Upstream commit 6cd33b6f4155efc20485929fd0b56bb704641db9 ]

MSM8916 runtime DSI commands still go through
msm_dsi_host_xfer_prepare(), which re-applies the link clock rate before
enabling the link clocks. That is fine in principle, but on DSI 6G the
requested byte clock rate often does not exactly match the DSI PHY PLL's
realizable rate. For example, the driver can request 56250000 Hz while the
PLL actually runs at 56246337 Hz.

Because the requested and actual rates differ slightly, every later
link_clk_set_rate() call is treated as a real clock change and re-locks
the PLL. On a video-mode panel without an internal timing generator, such
as samsung,s6d7aa0 / lsl080al03 on MSM8916, that live-clock glitch makes
the panel lose pixel lock and visibly corrupts scanout on each runtime DCS
command, including backlight writes.

Fix this by rounding the computed 6G byte clock rate up front, before it is
stored in msm_host->byte_clk_rate and reused by later transfers. Once the
host carries the PLL-achievable rate instead of the idealized one,
repeated link_clk_set_rate() calls become no-ops in the common clock
framework and no longer re-lock the PLL.

This keeps the normal transfer callback sequencing intact, preserves the
OPP vote path in link_clk_set_rate(), and matches the fix direction
suggested in the original 2018 discussion.

Reported-by: Daniel Mack <daniel@zonque.org>
Closes: https://lore.kernel.org/all/1a682c5b-7fc9-3aaa-120b-64b239a355a3@zonque.org/
Fixes: 6b16f05aa39f ("drm/msm/dsi: Split clk rate setting and enable")
Cc: stable@vger.kernel.org
Signed-off-by: Kavan Smith <kavansmith82@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/738234/
Link: https://lore.kernel.org/r/20260707013240.681012-1-kavansmith82@gmail.com
[DB: dropped extra chunk from the patch]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index d7e254613e8d5..fd5084244c81a 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -721,12 +721,24 @@ static void dsi_calc_pclk(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 
 int dsi_calc_clk_rate_6g(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 {
+	long rounded_byte_clk_rate;
+
 	if (!msm_host->mode) {
 		pr_err("%s: mode not set\n", __func__);
 		return -EINVAL;
 	}
 
 	dsi_calc_pclk(msm_host, is_bonded_dsi);
+
+	rounded_byte_clk_rate = clk_round_rate(msm_host->byte_clk,
+					       msm_host->byte_clk_rate);
+	if (rounded_byte_clk_rate < 0) {
+		pr_err("%s: failed to round byte clock rate, %ld\n",
+		       __func__, rounded_byte_clk_rate);
+		return rounded_byte_clk_rate;
+	}
+
+	msm_host->byte_clk_rate = rounded_byte_clk_rate;
 	msm_host->esc_clk_rate = clk_get_rate(msm_host->esc_clk);
 	return 0;
 }
-- 
2.53.0



