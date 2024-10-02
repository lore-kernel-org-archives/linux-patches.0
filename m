Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4191D042F;
	Wed,  2 Oct 2024 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876771; cv=none; b=VyJDWxFNbjCHSxxl6MxaEWn/J0td9MO+99FWeOVZ0x2yJErFtVRGnH48Yf6ssskGKINsDiCU4aAbCUeYxJaV7sqctgjc3a7rQyTBLRzbZX3JQf1fP7A3SN5TBrOV2UYeDzkESJnuSje9gxMQ9az8GUUWAw7Vcr8JTXsuqCxhVO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876771; c=relaxed/simple;
	bh=Mh4QncMOed/F5axfX8YNBDFwqiWu4douGThZR9qLlyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpdgygsUH83sNZkYurcbhygmib5CylWcnx5k3oXPKjQ2jJepZ7PN4WIVfzyy/SeJ2I1KIGgptwxsFcuwUzDcxcoCShMy9H5LoWhyBcRQtABkIEtpOuQ4szxoaaRipiEggkTzJ72i9bYAj94l5wPodLkeOSm+vPbNjqS9AEIxEUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsmSLPVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsmSLPVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971E8C4CEC2;
	Wed,  2 Oct 2024 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876771;
	bh=Mh4QncMOed/F5axfX8YNBDFwqiWu4douGThZR9qLlyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsmSLPVorLWiyZQsE1nkBVO4gA4ryTk2bm/HJcaoHhYbhlgIGsYJ51jAwgXmQHZUb
	 MyDRm4hUXx+NVH668vikvi1fjbUWPp3eFEMuOYTgbJ3ofh+MfRU5I0aqQJnWu2K7iC
	 3aJkCoQ0UFmGEXlLE6sCzt+nV3uawqeyVH8GYx6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Sung Joon Kim <Sungjoon.Kim@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 556/695] drm/amd/display: Disable SYMCLK32_LE root clock gating
Date: Wed,  2 Oct 2024 14:59:14 +0200
Message-ID: <20241002125844.696741351@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Joon Kim <Sungjoon.Kim@amd.com>

commit ae5100805f98641ea4112241e350485c97936bbe upstream.

[WHY & HOW]
On display on sequence, enabling SYMCLK32_LE root clock gating
causes issue in link training so disabling it is needed.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Sung Joon Kim <Sungjoon.Kim@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -736,7 +736,7 @@ static const struct dc_debug_options deb
 			.hdmichar = true,
 			.dpstream = true,
 			.symclk32_se = true,
-			.symclk32_le = true,
+			.symclk32_le = false,
 			.symclk_fe = true,
 			.physymclk = false,
 			.dpiasymclk = true,


