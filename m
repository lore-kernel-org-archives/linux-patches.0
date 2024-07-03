Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184A17DA00;
	Wed,  3 Jul 2024 11:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006097; cv=none; b=UVwO+v0uxEUH0GtH9NoBUIEF32RYMaI2g0MlF+pUJJmcfdhJikyKJ55O03OWGuV2bGkDI480TzLQaYBBPHIsviDNpX0Gp//Cemw6DPASq/JfT2tjElfEhPILSUL3UjMcKw0Oz1o4v0ZDsjYCIspmWd7E6PsOAkavMX+XahNqeRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006097; c=relaxed/simple;
	bh=7Y3FwAn9RZ6+/mdQVX2VXYYZ38Q9d5xjoPB0QwXAWL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMKVhq+/gV8zkr1vRcaOUTSXNTl4pQWrmErp0lP0OsrWKtu/gnDivdM5elL4YmFxrTBKlWBV4pa/iubQOFxx5uZrJv5jIDjGFO0aSar9sfGn+xP28NBKtzylOmrFDKxTO/2pZ0jj/b0005Rb9YJO2s9eGEijyISAQtc0PXujWc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j70kmsM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j70kmsM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C30C32781;
	Wed,  3 Jul 2024 11:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006096;
	bh=7Y3FwAn9RZ6+/mdQVX2VXYYZ38Q9d5xjoPB0QwXAWL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j70kmsM9tDAJfIkD3zIN3dpJY2lCisxojjKhCofW8VdBQX2gvh2+JcdWsL+V1cFri
	 CsGjTctvziu3pQbQ9oe8PJubw7KkNtvG9byXJweyErzdoTtmAxWSWS0v5d8Ybs39rl
	 pVrrT/BPF4+9Te3etZtnhOh1aI3ytiv1yLemFw5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/356] drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA
Date: Wed,  3 Jul 2024 12:40:35 +0200
Message-ID: <20240703102924.426764066@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 37ce99b77762256ec9fda58d58fd613230151456 ]

KOE TX26D202VM0BWA panel spec indicates the DE signal is active high in
timing chart, so add DISPLAY_FLAGS_DE_HIGH flag in display timing flags.
This aligns display_timing with panel_desc.

Fixes: 8a07052440c2 ("drm/panel: simple: Add support for KOE TX26D202VM0BWA panel")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 0dc4d891fedc2..26c99ffe787cd 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2873,6 +2873,7 @@ static const struct display_timing koe_tx26d202vm0bwa_timing = {
 	.vfront_porch = { 3, 5, 10 },
 	.vback_porch = { 2, 5, 10 },
 	.vsync_len = { 5, 5, 5 },
+	.flags = DISPLAY_FLAGS_DE_HIGH,
 };
 
 static const struct panel_desc koe_tx26d202vm0bwa = {
-- 
2.43.0



