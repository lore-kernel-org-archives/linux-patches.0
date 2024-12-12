Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846BA222D7B;
	Thu, 12 Dec 2024 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023517; cv=none; b=SLbNIXw5ZFUSZ5gw7Fz7sqTrGlP5OqNK1hMSIBFDRpGIxU9XdlvRKlTHMci9KEYiPd2ESq4mIZobo1AwgJ5Z1Lj1fOTKrDvxaBDv8hj1awAh+nwZ/OfXm++RL54KIWVXJy3DWucTcpc46Ca5N59d1Mrn8HMdCM+70f3lONMuw4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023517; c=relaxed/simple;
	bh=onoIzCjysw4lZh2JefjS5dynaJ3CzTWstbecRDdfBhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJbB+N5i7MqyXat708TtJc3vnZ7oZ4507195zdbFk5TcSvBI+S63QWQaMiw9icxig9pCVu+M2AoZWhxMSJGjVrpnSKfiaCPK1bVzEb2O82CWJ0XuPC6mDqE9V266G/+eGTCeq5ddpuP0JotQr0LQ3oME75aP8H0JVOSN/fRefNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B32bAj+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B32bAj+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CD6C4CED0;
	Thu, 12 Dec 2024 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023517;
	bh=onoIzCjysw4lZh2JefjS5dynaJ3CzTWstbecRDdfBhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B32bAj+K50ZivlEQk2WN5hb0bK5s5NS8rtSLGyjEVhuhQ9iyFSbOPUIS8rAXsjadv
	 I24Dc9k0e9BsWftnumHRi5P9UVEzAg4w9F8iwK4xPoTFxdHYXbADW9NbgQib4aOVaI
	 Q23qlLrVfaCzzSBorUKwXqsh1QzxltZz8LCBJIhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Guocai He <guocai.he.cn@windriver.com>
Subject: [PATCH 5.15 560/565] drm/amd/display: Correct the defined value for AMDGPU_DMUB_NOTIFICATION_MAX
Date: Thu, 12 Dec 2024 16:02:35 +0100
Message-ID: <20241212144334.000374086@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Wayne Lin <wayne.lin@amd.com>

commit ad28d7c3d989fc5689581664653879d664da76f0 upstream.

[Why & How]
It actually exposes '6' types in enum dmub_notification_type. Not 5. Using smaller
number to create array dmub_callback & dmub_thread_offload has potential to access
item out of array bound. Fix it.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Guocai He <guocai.he.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -48,7 +48,7 @@
 
 #define AMDGPU_DM_MAX_NUM_EDP 2
 
-#define AMDGPU_DMUB_NOTIFICATION_MAX 5
+#define AMDGPU_DMUB_NOTIFICATION_MAX 6
 /*
 #include "include/amdgpu_dal_power_if.h"
 #include "amdgpu_dm_irq.h"


