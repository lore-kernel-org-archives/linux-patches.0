Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590450;
	b=j3hlXqnFz8kEEoSpHCikrsu6UP0aeHN8sF7Afl+eGAw+mq4DYXD84bhnbXVjTvF0gcrg
	 KxqeP1Vl0KQz2RPW1Y9jOMCvvddDAHYllTDS91oPR/mcqcq3ae1E7E6PGjEV+pzjuFQsx
	 gUfvmUA90kD+4U5zgWwM0O0aoDQOsUABogoQ9/mKU/gYqtIRtAuIlW9JXJBUOlhMbSgpk
	 OtvPTCH2ny3vo9wwMi954pNVOASMLCWKnscovj/iphFN7GD9cQFeOAauQ7ZZ4J7x6Nvs0
	 9yELibwpwe+r8pQoRW9hlGJ93cB4aSxl5vd3usD/qm9VmXK6aZuqkjaU3GEIXBbcyfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kIjHyws6lmlNVMfwRaNnT4gPLGy0BspTYPVYNWWIy7Q=;
	b=TdgPtmD2ZtvwbpbQw1gaxNq/o8HsdPCblLXnkL2OBJPQLUIwUvfGIluJlzgZbkLN+e+K
	 Y8iiPmgPDafvqwyEGEWNfl8jQplX8o0czaWQ/JeIyu82IRFHtWDxqBy7cmru7AHg5ledo
	 etGHYjKVVn+54nBa+KhrCYRGooq5xCfkRn65Pat8Aqm8Gc9h5CHIlCQLf/UC/V2CLZuwn
	 eHVQPrtt6neMXAv3Yo7JsNBCMnKYLyvfE+UI5EhYRT8/YTIFllPwojvVHVx+bM7YA/EB0
	 /+R6B38vFYKwTtLhJ1brPtg+t/mB9xXIh33EVxDcsWrinWPDmS5RyMKaQCevGGgRTMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TqSETXYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA386070F09;
	Fri, 13 Nov 2026 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TqSETXYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B611F000CA;
	Fri, 13 Nov 2026 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590450;
	bh=kIjHyws6lmlNVMfwRaNnT4gPLGy0BspTYPVYNWWIy7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqSETXYDS0Ugm2LT9A/vcZZh4NQTQrt2XnYbtd8eV4NjrnQj8QX95fE54KmyOtAJO
	 VWLTdZFNqiJ52TmH8Gk6YPMtoDronzZ1gPHnrEnrQEYL45uD9jYV5IKl69DeKeMIjD
	 2QSp3sV72h5Yakwkuwc8vXZG4PyilKxvPyg7jHR0=
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
Subject: [PATCH 6.18 406/686] drm/amd/display: Avoid closing unowned DDC pins
Date: Fri, 13 Nov 2026 10:48:59 -0500
Message-ID: <20261113153834.737723647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/protocols/link_dp_capability.c  | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index eb262ce42e2dc..9154fea65f583 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -2483,12 +2483,8 @@ bool dp_is_sink_present(struct dc_link *link)
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



