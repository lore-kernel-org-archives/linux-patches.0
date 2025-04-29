Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A357E110;
	Tue, 29 Apr 2025 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946091; cv=none; b=HPUiIx1FOAZzsgpjX4+wNUJK7EOPSfyzW7fbggnImqbxi2eS+MNdEfRLFBfMCI0rWjuJWDoGPBXerKr3RdHQU53SdrLjkVWil5QHShJYFXLVH5a07YthhJckICqyaUHcubflji163miA6DxWZaRI9a1TVu4cx/stJtsPAaRqVoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946091; c=relaxed/simple;
	bh=rXgOaGz9cM4MdVTOQJsZ5m/IiNyP5AFi6o1fXB/2DCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1EaOVxRvt4ykoLXJkh7YxE1dVCH2EkOUUHoVfW+aWO0RDJQmPuRyGfwyPZKDFbDgbQy3S8UmAZcECno+EGoR8ANiEUqo9S9OHZBsHty658mUPjNzd6vHdx4PlVhvJnowS15ItuTGxzYEUigHMx7oRnrHFUDL4VP7iGMR3HSV0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b96W5xev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b96W5xev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2990C4CEE3;
	Tue, 29 Apr 2025 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946091;
	bh=rXgOaGz9cM4MdVTOQJsZ5m/IiNyP5AFi6o1fXB/2DCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b96W5xevvCniRk9XNtxNBmvaaMt1k7150yK+MOB0+XrBqRZakJhWMcBzDzgBl0ZMi
	 wKPwryFCjN4zH63WcVGlSagjJleo0AHCKM+btmQ6yyHXpJECskFwWkmtAVaQLUQpHG
	 cTdNbQP7i0kP+LHpnhrwhYXDo+HMK1zdHmL3X3mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 121/311] drm/amd/display: Force full update in gpu reset
Date: Tue, 29 Apr 2025 18:39:18 +0200
Message-ID: <20250429161125.996025472@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

commit 67fe574651c73fe5cc176e35f28f2ec1ba498d14 upstream.

[Why]
While system undergoing gpu reset always do full update
to sync the dc state before and after reset.

[How]
Return true in should_reset_plane() if gpu reset detected

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2ba8619b9a378ad218ad6c2e2ccaee8f531e08de)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10901,6 +10901,9 @@ static bool should_reset_plane(struct dr
 	    state->allow_modeset)
 		return true;
 
+	if (amdgpu_in_reset(adev) && state->allow_modeset)
+		return true;
+
 	/* Exit early if we know that we're adding or removing the plane. */
 	if (old_plane_state->crtc != new_plane_state->crtc)
 		return true;


