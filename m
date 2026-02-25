Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDA12BAF7;
	Wed, 25 Feb 2026 01:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983076; cv=none; b=ACoC1OJwKGTY/SvPpJdT4qMA2IenMP//vkFXkJzXoVolt1WqCp4AOKK8l7SbIGEL5vT08IG7+4wQMzHcWSd48iTMBncnifMbIPJmn9puv0tvS0Lyp5UOKQC5VP7ede1wuN5/q3IZeBL3lWkfBanc2EEE61erFp1QD6Alm/SIdG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983076; c=relaxed/simple;
	bh=1Xuk/8zRgMapNy5A/JGJ63G/DzIty+NaVihTrTaU8Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JW7bv2odVb9Gi6PXrq53HLcjWebd/9qi5lvNiP4X4yM1NewUlET213jSWpaB7AXjCBH+cRwZ68Mg+cWjwcRDynmElToJlk0EHtJ5oYrc2+2HAWX4mxrjGFjY8CYYZClKV764EyAN50t3Qe8bdvEamw4H9+dudhNZJsKZPVFkWC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00FVssew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00FVssew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1B0C116D0;
	Wed, 25 Feb 2026 01:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983075;
	bh=1Xuk/8zRgMapNy5A/JGJ63G/DzIty+NaVihTrTaU8Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00FVssewbtVxaEqAc/jCvnbTDtzpyTf16SuUlWp6vWVsl/ymr/TVQO9WZtQQZGfLn
	 8xY5uJFK7Hqbg+CkWTqX2QaynNtoQT+vhyumP2/6gLgi7jmF9wlwmrRqqbIE/udXe5
	 Jxs6+WJIZzfIq63xPu+mnq0BxVBXxNo5iMfQY8ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 237/781] drm/amd/display: Dont use kernel-doc comment in dc_register_software_state struct
Date: Tue, 24 Feb 2026 17:15:46 -0800
Message-ID: <20260225012405.521674360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit b1e2a6a57aa95f8192e8edb9edaecfd326745d32 ]

Sphinx reports kernel-doc warning:

WARNING: ./drivers/gpu/drm/amd/display/dc/dc.h:2796 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
 * Software state variables used to program register fields across the display pipeline

Don't use kernel-doc comment syntax to fix it.

Fixes: b0ff344fe70c ("drm/amd/display: Add interface to capture expected HW state from SW state")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 29edfa51ea2cc..0a9758a042586 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -2793,7 +2793,7 @@ void dc_get_underflow_debug_data_for_otg(struct dc *dc, int primary_otg_inst, st
 
 void dc_get_power_feature_status(struct dc *dc, int primary_otg_inst, struct power_features *out_data);
 
-/**
+/*
  * Software state variables used to program register fields across the display pipeline
  */
 struct dc_register_software_state {
-- 
2.51.0



