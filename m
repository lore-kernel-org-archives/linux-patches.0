Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E1D253B52;
	Mon, 23 Jun 2025 13:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685384; cv=none; b=VjJcql+InIVIvJTK8sfMRf1U3v9gNCc5ffMjijF9iS69+SvUTXx7mUfntrcVUNqnr8TiBV7EWfDfN9BpOOEAOxbI50XmF1M6YHeZCNOvpbzfJU77/vJwzUHE5ylhqc+ftW8m8LPtOFg/F+f6BwaspsCS+TU0T4tlc1BjLtQdHJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685384; c=relaxed/simple;
	bh=gU0TkA8EVvbzdWp4R3lan/BDO+F3ZRX/Yz8cb7hQJtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jyhpd6VEaJwl6VReqc8dBlwI0p2ajUtpaFzy0IfD9trR6jjLRGvoCW2dhF1kMF5atqtG6bu6S7J+6FWgjzN8riA9hRLjOXgxXjhYFbg9F90qdXBQR9ezPhewqqDWigFEtishw5eNWCGSsbl1a1ucmUvVOni/I6bPRGKVmDrS4ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIT21R0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIT21R0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B9FC4CEEA;
	Mon, 23 Jun 2025 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685384;
	bh=gU0TkA8EVvbzdWp4R3lan/BDO+F3ZRX/Yz8cb7hQJtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIT21R0UsciGJYfmEYhNZehl+jeVFf3I+GMxg3B7nt34qQeQ1CEwp2a8SbrY4jx/H
	 DDAjhYEEN5zGArI8PcirS+OPvX1Z/EFJXu7F+i5e/xtF1yW16oV7v3A6lIIqP3zQsG
	 Ohjd7DbxPZAzw7rEbG2q7ySJCeu69/HG8p7HfnWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 257/592] drm/amd/display: Avoid divide by zero by initializing dummy pitch to 1
Date: Mon, 23 Jun 2025 15:03:35 +0200
Message-ID: <20250623130706.411871165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 7e40f64896e8e3dca471e287672db5ace12ea0be ]

[Why]
If the dummy values in `populate_dummy_dml_surface_cfg()` aren't updated
then they can lead to a divide by zero in downstream callers like
CalculateVMAndRowBytes()

[How]
Initialize dummy value to a value to avoid divide by zero.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
index ab6baf2698012..5de775fd8fcee 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -896,7 +896,7 @@ static void populate_dummy_dml_surface_cfg(struct dml_surface_cfg_st *out, unsig
 	out->SurfaceWidthC[location] = in->timing.h_addressable;
 	out->SurfaceHeightC[location] = in->timing.v_addressable;
 	out->PitchY[location] = ((out->SurfaceWidthY[location] + 127) / 128) * 128;
-	out->PitchC[location] = 0;
+	out->PitchC[location] = 1;
 	out->DCCEnable[location] = false;
 	out->DCCMetaPitchY[location] = 0;
 	out->DCCMetaPitchC[location] = 0;
-- 
2.39.5



