Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213736;
	b=35qRYVd14VKGpqolUJ7NfVcUiL8wJblKQMETee7msPypXJusuQykC4B/6C4HukCEmiYw
	 sOHmuq2wRDBt9MPKHVj76Fm9P/w0aLeNGlVfk5TFBvE5DP57WBg5tGI2gqQMowgSmfDaX
	 zkwX65zdQ9+CiKMwlRIXtSTczcupfu3jRHba6bIFFkiZe0szWdoWr8nHBSomBErl9sLm4
	 YPjQIIOtDhEewwgg04xiYcRNmvucm5G9Hxao5qYbIQUch1oq/8qgIHkSRhxFgCE725L49
	 07Si3eJsD82MhP+TZYUT0Pt9LY7KAymHp8S7GP8Z7E1qrPBbLpln51TEgoigQliYuKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mOAW5Asp6NPXqhXtGzQTt1q5iRzV3wOFrrAcjbAJV18=;
	b=GYj2kp8DsRIED/QU6pb2Ez/24Yp0IDcvhtklih/6cxMPholxJZXyaEs0h4/xP3ju4vD5
	 yG2x2uY1bDFuLG2HQgFYEO0oIi6FOReaWjE7ZV4uIGF+ts1senex/IlzzC7dmcBtNBPe0
	 unJoWm75S1YHX/hVWCWBKGNmNOAub6fhfdJEbsC5EYl7219pLAGM6baoAxOlu5Vc6RAmv
	 f4WdDSKMHSS2jskkJAlDQX5WcnlVSNuOBWShu2dQtrfHZPngzbyNS35ZAN9BNtw+8W7ed
	 4Ifj9bKT65zvH5y4OoqviLTjT/dL3AoRzD05wyotB+M+VAnwvKyqgHzAxBYWhOJCbcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJwI+Y+N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F45B606A31D;
	Wed, 28 Oct 2026 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJwI+Y+N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04EB1F01825;
	Wed, 28 Oct 2026 18:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213736;
	bh=mOAW5Asp6NPXqhXtGzQTt1q5iRzV3wOFrrAcjbAJV18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJwI+Y+NlxNT0coHD6Uc5F6Z+C8pEoppLbYPfSJIEgR1yP+Y1SLwByt545g8CRQ++
	 S38g9zgyJXz39EERFC1D5oSfoDSoEKEWM76u23iORndXesRRk3bGD51M/h1BM6k55Y
	 BTubmwn1mXQVK3b+EwDzL8SBkQo6IsHKmOR7XimY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Sandor Yu <Sandor.yu@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0610/1887] pmdomain: imx8mp-blk-ctrl: imx8mp_blk: Add fdcc clock to hdmimix domain
Date: Wed, 28 Oct 2026 17:45:06 +0100
Message-ID: <20261028170513.294107209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 697624ee8ad557ab5417f985d2c804241a7ad30d ]

According to i.MX8MP RM and HDMI ADD, the fdcc clock is part of
hdmi rx verification IP that should not enable for HDMI TX.
But actually if the clock is disabled before HDMI/LCDIF probe,
LCDIF will not get pixel clock from HDMI PHY and print the error
logs:

[CRTC:39:crtc-2] vblank wait timed out
WARNING: CPU: 2 PID: 9 at drivers/gpu/drm/drm_atomic_helper.c:1634 drm_atomic_helper_wait_for_vblanks.part.0+0x23c/0x260

Add fdcc clock to LCDIF and HDMI TX power domains to fix the issue.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Sandor Yu <Sandor.yu@nxp.com>
Link: https://lore.kernel.org/r/20240203165307.7806-5-aford173@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8mp-blk-ctrl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/imx/imx8mp-blk-ctrl.c b/drivers/soc/imx/imx8mp-blk-ctrl.c
index 575ed8e3a5209..65848f6b8f352 100644
--- a/drivers/soc/imx/imx8mp-blk-ctrl.c
+++ b/drivers/soc/imx/imx8mp-blk-ctrl.c
@@ -45,7 +45,7 @@ struct imx8mp_blk_ctrl_domain_data {
 	const unsigned int flags;
 };
 
-#define DOMAIN_MAX_CLKS 2
+#define DOMAIN_MAX_CLKS 3
 #define DOMAIN_MAX_PATHS 3
 
 struct imx8mp_blk_ctrl_domain {
@@ -359,8 +359,8 @@ static const struct imx8mp_blk_ctrl_domain_data imx8mp_hdmi_domain_data[] = {
 	},
 	[IMX8MP_HDMIBLK_PD_LCDIF] = {
 		.name = "hdmiblk-lcdif",
-		.clk_names = (const char *[]){ "axi", "apb" },
-		.num_clks = 2,
+		.clk_names = (const char *[]){ "axi", "apb", "fdcc" },
+		.num_clks = 3,
 		.gpc_name = "lcdif",
 		.path_names = (const char *[]){"lcdif-hdmi"},
 		.num_paths = 1,
@@ -385,8 +385,8 @@ static const struct imx8mp_blk_ctrl_domain_data imx8mp_hdmi_domain_data[] = {
 	},
 	[IMX8MP_HDMIBLK_PD_HDMI_TX] = {
 		.name = "hdmiblk-hdmi-tx",
-		.clk_names = (const char *[]){ "apb", "ref_266m" },
-		.num_clks = 2,
+		.clk_names = (const char *[]){ "apb", "ref_266m", "fdcc" },
+		.num_clks = 3,
 		.gpc_name = "hdmi-tx",
 	},
 	[IMX8MP_HDMIBLK_PD_HDMI_TX_PHY] = {
-- 
2.53.0



