Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054602;
	b=slxvCTZ+HXFgen8uD9zHY9jFtP/B4a1YmmcWeyTH1l6YayNhrHQb9pin3YSKt9O1P2Ju
	 UHIXwGw9rwz6PFuCeV6UKsbUF13MIeAjo7DM6PFl3CL2QTj1NHaHxB7N57qUfnqpWneZf
	 +84okxPz6jHYdEPTsxjn3zTZ+7IyCC5mdKaYe8qYAl8ilPGevkxSv6jsWixwV1wn4JbS9
	 K22T2i1RSZPrCza80OzcgEvYU67fV0G5lDpNUiOWbC3k5mc8C9X6GS2o3/M8572kEdKJe
	 fH9jH2urJ+wzsd1gexnqcFWy1A2W/XAg+Uh4oG8JMOTkmN0ItG/AetphUOxTkjs4x6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hfTfmE2aIkbVHycj2HkyIGw9c18uR6QWxPp18YPuLmI=;
	b=fBOYzwqpUX7EHRSgzgp13tq4BIydTYs84dR0/V3HDDe8DcQcKTVlZbeOnWq3xTrkHxRp
	 +RvL0HMMrrHMVveml6gO0Wn4iodWYmTl8TGa9+/n/RQn9/N7YN0KfuFEIpteZY5u8zRI2
	 ksmXd4I3doRYCi+sTgFJOz2rTiGrjXkSsAG+ceHiTC2+W/PTTy+90FBD5dctBl+lI/FWN
	 G3tetz051HGnAKMUqeWRzV4Y0kJlK7alPCmXcpfOgchn3SzH1uDrafzsKk/Ygz4ODqqLH
	 bboYl/AHsVm0F7278Ck8Rqk6CZ4kU5Sl+8AQfeMERQ6gxZk0hzEsiMEipm735jJ3yZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OullDoGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA8D606A320;
	Thu, 19 Nov 2026 02:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OullDoGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45EB1F000C4;
	Thu, 19 Nov 2026 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054602;
	bh=hfTfmE2aIkbVHycj2HkyIGw9c18uR6QWxPp18YPuLmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OullDoGxMUa/ZaHuFKwBcilrm5K/qKH7yqO8rhLEj9RGAX2llexFBNNQz7RlymLws
	 i5CE9Q9N1eTM3V2UJ3GbkR72bocuHGApIfRkIcjLiN1l977Wdchah7pY+ML0NrFqF1
	 xXdcJyHFPNIzqwTvYyaKyCe8E+SlSLk/ZREU94JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1293/2214] drm/amd/display: Avoid closing unowned DDC pins
Date: Wed, 18 Nov 2026 15:49:29 +0100
Message-ID: <20261118150103.272078385@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit e7ba638b8116cb5f1a5690f543052371215f1626 ]

[WHY]
dal_ddc_open() cleans up pins it acquires on later failures. If the
data-pin open fails, this attempt acquired nothing. If opening the
clock pin or configuring fails, dal_ddc_open() closes the pins it
opened. An extra dal_ddc_close() is unnecessary and unsafe:
GPIO_RESULT_ALREADY_OPENED can mean AUX owns the existing handles,
and closing them here would disrupt AUX.

[HOW]
Remove the extra dal_ddc_close() from the failed-open path.

Cc: Jerry Zuo <jerry.zuo@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 175ae7772b68757b4932f34ff862923cab7abe21)
Cc: stable@vger.kernel.org
[ sashal: adjusted context for dc_link_is_dp_sink_present() instead of dp_is_sink_present() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 6696372b82f4b..00d5190db5ed6 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -392,12 +392,8 @@ bool dc_link_is_dp_sink_present(struct dc_link *link)
 	 * which indicates we need additional delay
 	 */
 
-	if (dal_ddc_open(ddc, GPIO_MODE_INPUT,
-			 GPIO_DDC_CONFIG_TYPE_MODE_I2C) != GPIO_RESULT_OK) {
-		dal_ddc_close(ddc);
-
+	if (dal_ddc_open(ddc, GPIO_MODE_INPUT, GPIO_DDC_CONFIG_TYPE_MODE_I2C) != GPIO_RESULT_OK)
 		return present;
-	}
 
 	/*
 	 * Read GPIO: DP sink is present if both clock and data pins are zero
-- 
2.53.0



