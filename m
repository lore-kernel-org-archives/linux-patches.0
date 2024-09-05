Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E24618D65E;
	Thu,  5 Sep 2024 09:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530337; cv=none; b=rG8/h9wBjngfj0ucPR/p3KW38Qec7GCpU6WVuO+ns5F0faTOYnW5CkeLp28SctyTMbIUqvhRfnjS1u38n8WnhAt1Mm7DKsHKJhd33PsV1xA+MLF8PFRQfrOEhYdtVpLQ8iHR3o4Agymes8+3oQfL6vRpGSe3mtLt5eQyoi9gzrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530337; c=relaxed/simple;
	bh=0pP/wUTGw9lEFz+X/PUM2EBF69dy0kkEF73anu3TMe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj7IVFvLg69sbeWiPFB7WCwhImkHhz9x6532CnVYdORvDakeD+0PXvW2qDurcHaYuQo7wprfqHC28lAuvu+imgyGrkt03ieBC86xcpHb6K5CChZnYZAas1e9fjFdxKT/e3MSnjWcNg/d5uLJtGOhGJkJ4/Z4Nb4xJX6TfqkCMRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ncDikEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ncDikEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2AFC4CEC3;
	Thu,  5 Sep 2024 09:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530337;
	bh=0pP/wUTGw9lEFz+X/PUM2EBF69dy0kkEF73anu3TMe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ncDikEEwDe33ykD1B+iDm+mEPkBrVXQBuVEIweUkqpo2qUDjPB05kpvuASeaD22D
	 Z3wL+w/HbExvbKR9wqAA+aOd2UYA41z+B5uzlw2GC6Q8AEBpYHDYa2WZmr93eEc1rc
	 9VSytOni49Rd1SpcPV2h76+JJ/SZiuGGDcrjHUtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/132] drm/amd/display: Correct the defined value for AMDGPU_DMUB_NOTIFICATION_MAX
Date: Thu,  5 Sep 2024 11:41:52 +0200
Message-ID: <20240905093727.075433955@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <wayne.lin@amd.com>

[ Upstream commit ad28d7c3d989fc5689581664653879d664da76f0 ]

[Why & How]
It actually exposes '6' types in enum dmub_notification_type. Not 5. Using smaller
number to create array dmub_callback & dmub_thread_offload has potential to access
item out of array bound. Fix it.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 9e4cc5eeda76..88606b805330 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -49,7 +49,7 @@
 
 #define AMDGPU_DM_MAX_NUM_EDP 2
 
-#define AMDGPU_DMUB_NOTIFICATION_MAX 5
+#define AMDGPU_DMUB_NOTIFICATION_MAX 6
 
 #define HDMI_AMD_VENDOR_SPECIFIC_DATA_BLOCK_IEEE_REGISTRATION_ID 0x00001A
 #define AMD_VSDB_VERSION_3_FEATURECAP_REPLAYMODE 0x40
-- 
2.43.0



