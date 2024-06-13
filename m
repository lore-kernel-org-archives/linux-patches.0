Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C761145B1F;
	Thu, 13 Jun 2024 11:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279918; cv=none; b=t+tb2fAx1HkfSQtoHygBhQFQRwUKKH+CFIyatf7Ik9usxqfkJrNHCFAJ5Zt1T6BvHzCQGQe0G7gLawgbdzT+c7EBFya6/fUbnVFR8UGB5LBVfJqVUCo7yKC47A/loPyLHccLW6USW9SjJCuVtuCmD4UHgVYA1/PVO/M6sZZ/Pco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279918; c=relaxed/simple;
	bh=8P4zCihjU9WRCA3RtPOkl8T4jayZF9+WHwZGpq9RhDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOy1+zUKtDQ6YYvc2BSdkh6adRmotGFo4rAdngTeYI331K8r7xdcpQVU5cYEFZilmveBsWzB+xI9sKUiZLisSIY0e+xtMhXMM/C3TVYfEDkPzrL8RwG9213p++ZClRNiAESrrt00RQg4mDn/fqvMM/oKI1Vop73IPgkYNa1dHM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufaYkMto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufaYkMto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9687AC2BBFC;
	Thu, 13 Jun 2024 11:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279918;
	bh=8P4zCihjU9WRCA3RtPOkl8T4jayZF9+WHwZGpq9RhDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufaYkMto4FvwDnP3KHanHJpUVtlHtFD+PcCctLgzpq+kMDVEcfLczkc35Y1kkopWL
	 kKvQXdhOwCoPs9Uxdq1bMoPN+yTAb5LiV0IAQeUhBAE4A9JTmiuESboIFO2uMERX8L
	 3k1uc0RFVPk9bQzblqQSHV4V3bMltfpatkoJLyg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/202] drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector
Date: Thu, 13 Jun 2024 13:32:58 +0200
Message-ID: <20240613113230.862680278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 11ac72d033b9f577e8ba0c7a41d1c312bb232593 ]

The .bpc = 6 implies .bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG ,
add the missing bus_format. Add missing connector type and bus_flags
as well.

Documentation [1] 1.4 GENERAL SPECIFICATI0NS indicates this panel is
capable of both RGB 18bit/24bit panel, the current configuration uses
18bit mode, .bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG , .bpc = 6.

Support for the 24bit mode would require another entry in panel-simple
with .bus_format = MEDIA_BUS_FMT_RGB666_1X7X4_SPWG and .bpc = 8, which
is out of scope of this fix.

[1] https://www.distec.de/fileadmin/pdf/produkte/TFT-Displays/Innolux/G121X1-L03_Datasheet.pdf

Fixes: f8fa17ba812b ("drm/panel: simple: Add support for Innolux G121X1-L03")
Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240328102746.17868-2-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index fd8b16dcf13e7..83cba00f854d6 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1729,6 +1729,9 @@ static const struct panel_desc innolux_g121x1_l03 = {
 		.unprepare = 200,
 		.disable = 400,
 	},
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
 /*
-- 
2.43.0



