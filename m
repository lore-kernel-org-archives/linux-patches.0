Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036232;
	b=rfLIZRVrKYMHhZpxFEPItTASebE4jDSYzpuqISvpjWK+f+DxNjnkaEODcjjjSfgwqprC
	 ZaPR3YqOHz05BN5SddbSIfvnotJfxlLAfPyuNOr1E8Qu1IZLox/ucCHLiOJjYbmQacNVz
	 tJWUcmC0MhuK/+4tCpecjiFoL+b3qtLw8hcy22bl2uM577MPBfrGlUUcl82/JT3Cs0dZr
	 Cd6nIQH/poRyWiseuhHIrg2SOGcW0DtSYYuiARMuhqyJeYPMRRmJBK6pnNgfYjmsVHWtS
	 Tvl7R0FIogp0uKqtKv431UitvByMcIBUHy6iAqKAw0WarGRH6MUiX3sYES/iezvhkKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oHW7PWE43Nzrqa/ldoO3T1pc+TRryko71u2BhqKvkx8=;
	b=iXztNJAhCt/7lRziIaLfJ92tTP912F6Lwj4o+klJ7rb3rM3c4mI2CFofGhiQgrz09Y0d
	 pN40xEBwg8NA+uNCPIF30GoAin4YkgZsYBc1MRuqYclXcynWWVwDEybi1NUX0I1NXXmOL
	 M8NytZuFhcJ6Jt7EpV3PZR/hMRBJJJVkQkXSmq+ceThJ60czOOhG64c9PQv8CCD2dvat9
	 g5EVgljvzLR0iUH7e6vDY0yk/6+SFa+/lvJRMfo2ZCDXzsM0ncplo1fLLT2SgsoogOC8L
	 wtb9DYbMyG7joQ+bS7ZyNNjRtQABe8nd3ep92ElgtHDgCtmIhXXwghktIeeXuda+99w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I5ZM9/xO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A9606A320;
	Wed, 18 Nov 2026 21:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I5ZM9/xO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4871F000C4;
	Wed, 18 Nov 2026 21:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036232;
	bh=oHW7PWE43Nzrqa/ldoO3T1pc+TRryko71u2BhqKvkx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5ZM9/xOz3FIpQjErFyYdO7DbTp5mSK+PlSLZCgSg6fnGA7C9ADrQSu+lUsYAM6QF
	 cDNcbnQzqib4k8Il9IkgxKME6QnUGtkzp2+Nst2py0ETuO7KF5SEd0CacJ7aGlMiAa
	 hlDg0XqPJ/BMN37pxRiLZQEuGopoWmH+DGixgu/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0969/3318] drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure
Date: Wed, 18 Nov 2026 15:26:31 +0100
Message-ID: <20261118150348.754300631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit d27f831aaf20aaf06e41ceb1b260e10672269155 ]

If msm_hdmi_phy_resource_enable() fails, e.g. when enabling regulators,
it should reverse the state of things already changed.
msm_hdmi_phy_resource_enable() is used also in probe path, thus such
failure, which could be simple deferred probe, would leave these
resources permanently enabled for the rest of the runtime.

Cc: <stable@vger.kernel.org>
Fixes: 15b4a4523859 ("drm/msm/hdmi: Create a separate HDMI PHY driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752654/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-1-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
index 33b0819a52c88..836bdba8aaa14 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -63,16 +63,28 @@ int msm_hdmi_phy_resource_enable(struct hdmi_phy *phy)
 	ret = regulator_bulk_enable(cfg->num_regs, phy->regs);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "failed to enable regulators: (%d)\n", ret);
-		return ret;
+		goto err_pm_put;
 	}
 
 	for (i = 0; i < cfg->num_clks; i++) {
 		ret = clk_prepare_enable(phy->clks[i]);
-		if (ret)
+		if (ret) {
 			DRM_DEV_ERROR(dev, "failed to enable clock: %s (%d)\n",
 				cfg->clk_names[i], ret);
+			goto err_clk_unprepare;
+		}
 	}
 
+	return 0;
+
+err_clk_unprepare:
+	for (; i > 0; i--)
+		clk_disable_unprepare(phy->clks[i - 1]);
+	regulator_bulk_disable(cfg->num_regs, phy->regs);
+
+err_pm_put:
+	pm_runtime_put_sync(dev);
+
 	return ret;
 }
 
-- 
2.53.0



