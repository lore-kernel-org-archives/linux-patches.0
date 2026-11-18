Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050921;
	b=AwPiM2SYvChoRy6Ea6lGyLf6YjnHQb+S7tDKqZOagN8FnF27v3554CxN7yUcu9t75Att
	 /Eo5MoFHh8RyO3De4ysmTF6cX1knmoArY5PjEeE7/f4gv9Mf2oIEhsBTffFHaHRd9G3Qv
	 n3w5TlVegzgCwW7UvVZhdpx6qLPZlJ/0M7YQJbJf+PYQ02Hihg4YrNBXiS9HC4FaaxomN
	 dqxjJe1Xayb+N1JrzjB1KZQqNvsF/cAu/z6eyvbeu8jgDZMqFEX/GTlCgTn0YiEi7dXBr
	 UyvwcwG83kWu1JAwk8cJ72y4jd3IYFG1YR9P7M2/UjnnohwFK8sbhmMIHr8BXTDvgdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OT+RNcP2ppGj3382rnNKKYQIbGQbrXAG9eFiSXlscWo=;
	b=HP6YZSTv8t/GPYEOga5ymYPOEqF4MG49PLRjp+bJP/SHEFruJ0i6MFVhlINJ12OLPaDc
	 8b7zpCsHUYCy7KZGpBzrK3ptQo2n1LNMXm7O7PCNxUvWS5sOE9trK5mqqWJQN0quvzS1i
	 5qOWRohATKqmdp9I5OAAwvoPU3UWoswlFwR3lZM6wQyBaStZ0hIItpYj5C6Hoo4BvrsFd
	 CZk3s3LEjSIyjwsJZ8gR7Co0hxOagW+mijPTK/EgafidDh5mbwIrgEqNTlDwSnH63stNG
	 5gKZOsTtNBL4HlvYiKNip7difARqNVagw4XaaP4BUEiIsDrCBqs879I0LMeuooZyw1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zP7VCDg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BAF606A31C;
	Thu, 19 Nov 2026 01:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zP7VCDg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEF61F000C4;
	Thu, 19 Nov 2026 01:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050921;
	bh=OT+RNcP2ppGj3382rnNKKYQIbGQbrXAG9eFiSXlscWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zP7VCDg5JAK70j+D/Q+FW27wqyWSKuIaWR7ZUZY8kaEMe/Qh8FyPoEqZ8IhtbjtZ
	 hL8+XFJLQaC+mRP2xk/gXesWnzAVptO2cwQz7E1ZgtcflhMyArnI/Xyoiyv3WhqhGJ
	 p0Roh87Va8C15wNkytAGWXCg4J2OnT6o1waaZoac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0025/2214] drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend
Date: Wed, 18 Nov 2026 15:28:21 +0100
Message-ID: <20261118150011.121281418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit af3a9eadc11896f6677bcb7102bfb7c84be48d2d ]

rockchip_drm_sys_resume()/drm_mode_config_helper_resume() is called
before the resume pm ops of dw-hdmi. This result in an atomic_enable()
before dw_hdmi_rockchip_resume()/dw_hdmi_resume() is called.

Resume (without changes):
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()
- dw_hdmi_rockchip_resume()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()

Change to use resume_early pm ops for system suspend to ensure pm ops
for dw-hdmi is run before rockchip-drm pm ops. Also fix a possible NULL
pointer dereference timing issue while at it.

Resume (with changes):
- dw_hdmi_rockchip_resume_early()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Tested-by: Heiko Stuebner <heiko@sntech.de> #rk3328
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260518193748.2482823-12-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index 9e1c34af53909..a95ac68114f9d 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -592,17 +592,18 @@ static int dw_hdmi_rockchip_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __maybe_unused dw_hdmi_rockchip_resume(struct device *dev)
+static int __maybe_unused dw_hdmi_rockchip_resume_early(struct device *dev)
 {
 	struct rockchip_hdmi *hdmi = dev_get_drvdata(dev);
 
-	dw_hdmi_resume(hdmi->hdmi);
+	if (hdmi)
+		dw_hdmi_resume(hdmi->hdmi);
 
 	return 0;
 }
 
 static const struct dev_pm_ops dw_hdmi_rockchip_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume_early)
 };
 
 struct platform_driver dw_hdmi_rockchip_pltfm_driver = {
-- 
2.53.0



