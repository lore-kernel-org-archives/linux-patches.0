Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CCB40C03;
	Tue, 29 Apr 2025 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949818; cv=none; b=nZTKw+oiOr1HtnMb7nOpgp36LwDfHqI1NjSpQ8TakfzmpLnIN3WGOF3xyECBC/37B8JhHpmRGN7uUTxFnNcku6i3WGVuwvL7gAes4csuNkyhELtPKHv6Fl9Te1L+5hTfl9Ilp8xfYhyq/6k3gsG56F2gW5EkeMKZAtr6lX/cCLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949818; c=relaxed/simple;
	bh=giQDdAkBVN9QLMbcbB3Jlg0jhIn2sLYl/d62HMZdeAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYDOIrurqHmkgxN0uzgA6W52qLvyQT7WM8EnZ+V/6U7+FcJnGRSaiXti2JzcCsoXZS8h1zvpOYeW8/lRxrA6rRQnaiCTWfi11nKyUkkezqey+vl9n32/QlB6B0LTG3sLgx9M/4yjDS4rO09njuhrWs7em1U04pUvhoiEOT12F3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YcOInf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YcOInf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122E9C4CEE3;
	Tue, 29 Apr 2025 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949818;
	bh=giQDdAkBVN9QLMbcbB3Jlg0jhIn2sLYl/d62HMZdeAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YcOInf+/pavI3mQONE+yr0HfajHyfly1rv1FrKVS3FMtcjly+tQvm8TJ7963ZoGf
	 /JKoJYTms6NmDOt2Uqdzr3wldY3AU22Ra611Hy8BJY8MO08Apo/FypvZdEvvdt20lq
	 7xf+3bLo4diF+OTUZddv6zifwBH+TFDthZ3g7/DU=
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
Subject: [PATCH 6.1 067/167] drm/amd/display: Force full update in gpu reset
Date: Tue, 29 Apr 2025 18:42:55 +0200
Message-ID: <20250429161054.484882294@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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
@@ -9358,6 +9358,9 @@ static bool should_reset_plane(struct dr
 	if (adev->ip_versions[DCE_HWIP][0] < IP_VERSION(3, 2, 0) && state->allow_modeset)
 		return true;
 
+	if (amdgpu_in_reset(adev) && state->allow_modeset)
+		return true;
+
 	/* Exit early if we know that we're adding or removing the plane. */
 	if (old_plane_state->crtc != new_plane_state->crtc)
 		return true;


