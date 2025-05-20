Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8AE22DF87;
	Tue, 20 May 2025 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749434; cv=none; b=WHbNvnWEPzoHqpWGSaF4CoUxW5gHBzk2AjMlbiE2vr4nwUBZtX0VQtwIHahRGraLA+cZNKjf2BNtX/CFelhsGmWMKJ9doyvn8K8JpXdzqroEl+nAQx/pBCnQDqrb6jJFYJggNIVHG7tI7t8Cyow26PByeXEgxf4f5Ym+1Z/fsCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749434; c=relaxed/simple;
	bh=p6Mmf+s5Cs4QyK/6jzSCidz+7X7l9v97VeCvZ0fJW9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAAtflug/4SMasVF1XJk8ykkQo/7CqLyQvauSw6DzZ8st8qk1VLyY2viMOOlFuhLbvBwTBPk161Lrzz9wuGHz2uGn10V6jMvKEobRkh+Zym0iZv+C6mQtm118PtGG8RtTkxAlGZ89+tVg8I0bJ7ipiz/TkdzHQHprHMQQE5OmxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1twopu9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1twopu9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3697C4CEE9;
	Tue, 20 May 2025 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749434;
	bh=p6Mmf+s5Cs4QyK/6jzSCidz+7X7l9v97VeCvZ0fJW9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1twopu9It9WN+4cpmqQqvlTgPiC3s7cNrNAa9CINMw5SlD/erziMNFHSriv7AqnoY
	 ub7vT4Lb4E8mraHszA3V4qkvLEmO2sA7TJ5mi5iqr7bJXrsdtp3xdXFFJemXpNIWz4
	 SrfzLTYfnsBhd/jvl0ZQgTDCzWfvsHfxYgDsTLy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 6.1 44/97] drm/amd/display: Avoid flooding unnecessary info messages
Date: Tue, 20 May 2025 15:50:09 +0200
Message-ID: <20250520125802.386427920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit d33724ffb743d3d2698bd969e29253ae0cff9739 upstream.

It's expected that we'll encounter temporary exceptions
during aux transactions. Adjust logging from drm_info to
drm_dbg_dp to prevent flooding with unnecessary log messages.

Fixes: 3637e457eb00 ("drm/amd/display: Fix wrong handling for AUX_DEFER case")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250513032026.838036-1-Wayne.Lin@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9a9c3e1fe5256da14a0a307dff0478f90c55fc8c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -111,7 +111,7 @@ static ssize_t dm_dp_aux_transfer(struct
 	if (payload.write && result >= 0) {
 		if (result) {
 			/*one byte indicating partially written bytes*/
-			drm_info(adev_to_drm(adev), "amdgpu: AUX partially written\n");
+			drm_dbg_dp(adev_to_drm(adev), "amdgpu: AUX partially written\n");
 			result = payload.data[0];
 		} else if (!payload.reply[0])
 			/*I2C_ACK|AUX_ACK*/
@@ -137,11 +137,11 @@ static ssize_t dm_dp_aux_transfer(struct
 			break;
 		}
 
-		drm_info(adev_to_drm(adev), "amdgpu: DP AUX transfer fail:%d\n", operation_result);
+		drm_dbg_dp(adev_to_drm(adev), "amdgpu: DP AUX transfer fail:%d\n", operation_result);
 	}
 
 	if (payload.reply[0])
-		drm_info(adev_to_drm(adev), "amdgpu: AUX reply command not ACK: 0x%02x.",
+		drm_dbg_dp(adev_to_drm(adev), "amdgpu: AUX reply command not ACK: 0x%02x.",
 			payload.reply[0]);
 
 	return result;


