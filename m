Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026172;
	b=zCpecSosbaPo5apJag1l7NFPQqVt6brN0RdZ/o+QLfgkObniEIyuCH2x9QuisucBQElX
	 faJFRTr60uTmUlD9f9eCGOpbJV3FfGW34B9+ranFYmd1FlKloih7PLZP6R68mX57haTa0
	 LOsgtcO3l0BOVlCDCI01N2H6joC1xMwcPYE21hBqkt5tM+afwDCu37DzVF+CFP9JxagqW
	 4x2wd/SDwUiO2wGRWJcOkr1br/kQ91gwYgukA+b0jJtDAc0ZP21elM3a5gwdkvUD69E3P
	 eyfQwLNrosyIBUOtcXdo8qG2QvgR59UxQsJYIJIKnsw1XFe/04lFCC0sZuQEeOEYS1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yszZocxLMIMKyF8/NWo9O5IgQNv/DTaBt5HxGX3udMQ=;
	b=0B7n2zJw/WrtDqv7Mtp3de+Scel51eltR50YtLuWTrGd+QHD+nfh8wfvvXjV0dXeAtIj
	 I6+dquYppJYy1EBo8laRMhmUKd5Z+fAklIptnzsvZtCWTZbu+caTmyvMv3hfkVEKof0d+
	 6O88rpPwZ1kPLVkfHar3Zowcu2/jHOf4MRSQCvrqvscmdogsnJ2QXTVRagdC7RzGxNTDh
	 MpJMNlFoa/cP7cN1623Ilmu2I3aaqVar0DKRPuHSRZSEgrhqWkDuBVGEiy9MNJmBmdGqm
	 u6IuQo7b/LhQlWk3WF1rv7C6mOIiG8hqbHBjMfqzwieoGAVoFb2niHTGuEh5Q6c2gjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdsKZWx6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216A260A260B;
	Wed, 18 Nov 2026 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdsKZWx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743391F000C4;
	Wed, 18 Nov 2026 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026172;
	bh=yszZocxLMIMKyF8/NWo9O5IgQNv/DTaBt5HxGX3udMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdsKZWx6Y/nwPWW1jzJR3lDEdlupyEn2g3ODOx/5lxgd6iyOJUpT0Di6rQ4yeiK1z
	 owLoIf/zZ3Ryrwz9eTRzYexuBIt6Ple/zOi/O2vMOCLN02xW7yy1LK3McVJA6Isow5
	 FlP0/AI0lnFSsUf/S+c3YyL3Vb2avPxfBHOq0Kww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1341/2151] drm/rockchip: dw_hdmi_qp: remove now-redundant call to drm_connector_attach_encoder()
Date: Wed, 18 Nov 2026 15:51:16 +0100
Message-ID: <20261118150210.903724754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 14a25df41b19aba228e66c0d9578e6e6b3cc58f9 ]

drm_connector_attach_encoder() is now called by
drm_bridge_connector_init().

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260423-drm-bridge-connector-attach_encoder-v2-30-2ae6ca69b390@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Stable-dep-of: b6e19848c9db ("drm/rockchip: dw_hdmi_qp: Fix invalid drvdata access in PM ops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index 409f1a1e82a06..9c30a9bfb6b9d 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -563,7 +563,7 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 		return ret;
 	}
 
-	return drm_connector_attach_encoder(connector, encoder);
+	return 0;
 }
 
 static void dw_hdmi_qp_rockchip_unbind(struct device *dev,
-- 
2.53.0



