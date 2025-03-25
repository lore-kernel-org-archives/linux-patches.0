Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514F226FA48;
	Tue, 25 Mar 2025 12:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906391; cv=none; b=Mf6Q5dwzKw8adozB4P/a0P/JprLcve0CMy5xUUclpi3K5hbk2z90JondJfcIjxf17KhqmmFqsutvg2Ke3RPw+3qTXNIiBBawXmTrXoITUdX1KKkTV+g3rbmX8l50bimk2WYGZscEYBZ+TYTB4jm845z/JBEa81fKZTRChSCYSR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906391; c=relaxed/simple;
	bh=9ikQk7QulwB2y9M8FsQbmc11/hFMNu9aoJrJh9XvZg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT0zErqm/hkjTK8kRnm5lvJxOCgIRnSGEAjJ56Rz5talltLHfz/0HDiPWz2BOqK94Lv971OtWxogISGlsbbRRb5ITWs8iHNZL/JvN63cL7X0IghuwVZcav14dMcjleC3TMJR/o58PJYSB4oRjT6MB+aDwhqYQpys/g092/Z3+e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzqmInjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzqmInjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034B6C4CEE9;
	Tue, 25 Mar 2025 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906391;
	bh=9ikQk7QulwB2y9M8FsQbmc11/hFMNu9aoJrJh9XvZg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzqmInjD8Ocm9x0DspzG1YjaFxL6rB/DnsmvxIL+wTrckxZhLnXykaqRWQxPMdfn+
	 UnsMEbUNTzBS1OZt0wBCYIuJn+b7g4o/0T8dfdY1AC//JV1+KPswV7q27kuqqQNyUf
	 gnMONOp+FOikIpRp++EtdvvzDyoZ67MLcdSL5kYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Yilin Chen <Yilin.Chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 092/116] drm/amd/display: Fix message for support_edp0_on_dp1
Date: Tue, 25 Mar 2025 08:22:59 -0400
Message-ID: <20250325122151.562659075@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yilin Chen <Yilin.Chen@amd.com>

commit 35f0f9f421390f66cb062f4d79f4924af5f55b04 upstream.

[WHY]
The info message was wrong when support_edp0_on_dp1 is enabled

[HOW]
Use correct info message for support_edp0_on_dp1

Fixes: f6d17270d18a ("drm/amd/display: add a quirk to enable eDP0 on DP1")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Yilin Chen <Yilin.Chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79538e6365c99d7b1c3e560d1ea8d11ef8313465)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1720,7 +1720,7 @@ static void retrieve_dmi_info(struct amd
 	}
 	if (quirk_entries.support_edp0_on_dp1) {
 		init_data->flags.support_edp0_on_dp1 = true;
-		drm_info(dev, "aux_hpd_discon_quirk attached\n");
+		drm_info(dev, "support_edp0_on_dp1 attached\n");
 	}
 }
 


