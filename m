Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072101386B4;
	Wed,  5 Mar 2025 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197699; cv=none; b=uXt7fJXYo6OJzF38lhDMo90Wzobqh/NmysAEbsMOPDiyHXeYc1KfTBNopDSPOSlgZg08VFnPeeawDuswacQdvQXX0AtFwa7HPDf7zYJc3I+BtunMgWnk5DPJoGE/37mPoBHk2/YvLHjjFwvhW0RogS2BxERaF7/3Atw22lS7HjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197699; c=relaxed/simple;
	bh=SWdDIKYmJmALrMntqQK2pHTGyj8Mx6j4SF5lEFDjZtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9rSoRtEtTI/vaQ5U/d58ll4gFdIvNbvkEwLLKXtXVStk4FZ7l2oXYMpZgEnkT+KiOc8iZ5BNK8qYoONGg9zgCT6iq411YKuhXHr15B5SU3dH5UW2Ss8LGTlmZCrNAJzWdxHjeUoRytMmAfyPq8GRJ8Et5xYzn0AY/qjTgCOs7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDCZf885; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDCZf885"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA3BC4CED1;
	Wed,  5 Mar 2025 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197698;
	bh=SWdDIKYmJmALrMntqQK2pHTGyj8Mx6j4SF5lEFDjZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDCZf885E33hqnrq4hOqgURnChDiXuTseKh4J/KM+hwDeoDd60hFusuhtG2HmmA+q
	 AAFaI2UnBTguNB5YcmsrvfSqQno5P6lor3ACO+Ww8GLrGbdRxMhIJ/duaZf3xVshZu
	 qSez6yAuP9UXQ4w4hua3sZjZju0+XTsI+mlhx+8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 068/142] drm/amd/display: Disable PSR-SU on eDP panels
Date: Wed,  5 Mar 2025 18:48:07 +0100
Message-ID: <20250305174503.068281882@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit e8863f8b0316d8ee1e7e5291e8f2f72c91ac967d upstream.

[Why]
PSR-SU may cause some glitching randomly on several panels.

[How]
Temporarily disable the PSR-SU and fallback to PSR1 for
all eDP panels.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3388
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6deeefb820d0efb0b36753622fb982d03b37b3ad)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -51,7 +51,8 @@ static bool link_supports_psrsu(struct d
 	    !link->dpcd_caps.psr_info.psr2_su_y_granularity_cap)
 		return false;
 
-	return dc_dmub_check_min_version(dc->ctx->dmub_srv->dmub);
+	/* Temporarily disable PSR-SU to avoid glitches */
+	return false;
 }
 
 /*


