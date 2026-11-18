Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047614;
	b=N/cMgpzzRRq4cZC1wRZ30gjdcp/lUPJPl5bakBwuf1MSEVa8GmXW0GFJkc3JaBp9Bc1h
	 /+C31SgM/hfPVnIAGT/J/yw3l4hs1W1c5ZbaumuocrlvoBHpZBt20fSvAloPzeFsH3my4
	 k/Z0e0b0f4UYA517klmOqNhqbFokWDpAPn1Ay/5OJQ3dNeFgGe6ArKikOQOzSRHLB+R08
	 X3hA+sEAfs3tXsoIpupwlNxlByg6YHvdX8UI12qCOdTMYm/7Qf6m8AQAl6VWyIsaftNOG
	 cDd4JHv9wvtvpazXzmwTwT+XHUDKr2MerRyJUPNmx2MNT4TZS5YrWSzlwYrhL1457tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1aORABAHUttX24pPU+RaXAmaIDt0a8d/St46oeVU5JM=;
	b=yqhoqqvW+P1XS3B87EKtJiA4JGRL2PA3a18UTawcFYV1mGDU2esOJzQY9cBZYq2l0ub/
	 Mcw0ic7cl6mxp9tuKbke+TfrOYzYitGohKUUUfKXF7j/oCkm2bpisramzzOGDuUANOR/I
	 F15z2Qz+5XwqugHKd3DTvfp4NFnfkGk55S1FCnhXr+PsCOpeZxnmAW45cvPMNN8fIlVPe
	 plR1Z9rlXltVBxNeJ8jMbw+Z1mSokbtfRlw2aiXO1Vwc171PtQpPi63Dv0pOZJl/9Wm4e
	 Whk8BIlYPmpvgQw9zIjqLzZtgHeIpI92phi0ameH+/FbNoazLWM/wQpHBiWGxzA9YkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImxWJCXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66686606A31C;
	Thu, 19 Nov 2026 00:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImxWJCXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EFD1F000C4;
	Thu, 19 Nov 2026 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047614;
	bh=1aORABAHUttX24pPU+RaXAmaIDt0a8d/St46oeVU5JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImxWJCXN7bTlvDlOpXkwWsed06f9FI/W3HUQpFJQJaV3YbBH30/Cw3ufRgqBuROAn
	 jPoU15HAZNiq1fw0Uzi5vm9bKRlIN8BUHGOEeWgD+8SD3WK0mXTYpqRh+uxP1duMUa
	 03eWGmMfJjBzs9WF4/dY+RAsBDJIkLBoBd5gt1j8=
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
Subject: [PATCH 6.1 1701/2857] drm/amd/display: Avoid closing unowned DDC pins
Date: Wed, 18 Nov 2026 15:45:35 +0100
Message-ID: <20261118150302.579238360@linuxfoundation.org>
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
[ sashal: Applied the edit to dc_link_is_dp_sink_present() instead of dp_is_sink_present(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index f0db2d58fd6b8..9282b065a90a2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -399,12 +399,8 @@ bool dc_link_is_dp_sink_present(struct dc_link *link)
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



