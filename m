Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060133;
	b=qE1xNLrdIm3VX43GO2S+9VQGrCLfx3Qo665Hdiw69tK5XkXjmKvWcWiC4u+yU4WAk3ps
	 lsNLWy9WAjSqZ9E1DSkpl+5JmAQIuA/iTVCBkFurj3lnrphKtyCl2XqYnuqJw9ibwHKJ5
	 fnsoY4tJZI9QFRTPUhZBNLrAeceo6bYiKrWArBwu4i5XOf49Cz7V3U5iBPAAea9TZBJzD
	 Y84P1tmmQw/QUXBaAxXAie7opMOwFBaxtuyLq1fjrxHnImkOUrpXRDGOAQxzyOZXuaVH8
	 yGkRYQ+zQFsH7rG5L1+2sXxrdJhUPCyteM6QlbqLQfRkZQD0zGmj+H/itdhyInUnZcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwDAPKSzTaLjqcrgs3jbmrKRa5XEUbZUxxx7m6rgapA=;
	b=2uFFMJD9BeW6iOrJiGlK8flVRbY6HmHwIBPhny7TS97F6LXVPKjsJuo0B52PUF2LGgOG
	 rkTxgJhZGG+cZwINL8q/SvQi4E1AOW+0/19RYIieEvjM3V/f0ygTl0VsLFOXmVDh0PK34
	 G6jIDICWsMd1ebO7R2YssytoCoq+CiOqXa8e8N1BiNpb3BcRp2KEOPFN/idcQ7fgOskuV
	 hfIQuVEol+iLd+GMmyrqWWMNuWb0V7OREL5BgH7Gd/NZjdLmIuowbyavsjuI7NszqffVI
	 oMzT1U/hGfN0r7iUIdi82qgDhTKe4BAjEC6C1hN72H3DPpkvqyVItcKJcLAYBWWjSZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8cMHIFx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA2606A326;
	Thu, 19 Nov 2026 03:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8cMHIFx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C1B1F000C4;
	Thu, 19 Nov 2026 03:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060133;
	bh=kwDAPKSzTaLjqcrgs3jbmrKRa5XEUbZUxxx7m6rgapA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8cMHIFxAMkgzgf9lhJ9GmMN8qMIgG/6OxprMiKL7OU0R1oSsTdoI47KQ0m8LxEua
	 iVRgx+7FopZ+iNHY2dLN/8Gh/pcVqkSWSi2j4c/NK0U+DH/cxzju3Ev+d13MRw68Xh
	 OY68/0Vx1Mcvnkwb4kvI1F9cnAqzGhv/ZoUpyGoc=
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
Subject: [PATCH 5.10 1090/1848] drm/amd/display: Avoid closing unowned DDC pins
Date: Wed, 18 Nov 2026 15:52:08 +0100
Message-ID: <20261118150004.400914739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 62778ccea055b..b05e515236224 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -373,12 +373,8 @@ bool dc_link_is_dp_sink_present(struct dc_link *link)
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



