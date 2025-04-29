Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3942528ED;
	Tue, 29 Apr 2025 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947849; cv=none; b=GP8WjNgrU2qPPjWRVFKEjZOeESq6pM5Q+1yaI/2B1hlluqWlABPpzAFnifLsrMa3mstfKbrZ47T36SpflzgrUSxjrJQnf2/i+g//XRNZ7h6vAaMBu5lJ1s2vL0pO78hcJ1nLfKz9TPOUV+RALpdP+5w98aOVQk0FxkjuK6B5sus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947849; c=relaxed/simple;
	bh=Lc5h4XT+C0UHaTmm57X1juCr/5k7NhNU60bQ5fFvZNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+BXhFrz5wEUs+7M10eOcYXXzuxRA0ZBX1fa2DklgvKyK0OIXwisg5fJS6MsaWlZk5dR3Icgy38ILA8qC8mCr03LKwISUomny79WR+P/1+Gt9/EO7qaZga99LY3eEc1Jd00tQm+4y0u7m01To7FWOZTXfBdPwYmgfBE5u9X5nUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ke3QM/AL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ke3QM/AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2218C4CEE9;
	Tue, 29 Apr 2025 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947849;
	bh=Lc5h4XT+C0UHaTmm57X1juCr/5k7NhNU60bQ5fFvZNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ke3QM/ALR5Z5yrPQOZJENbbLXBx1Xcyr0oPWDEK1rwO9xzefME0TjcarCt/p+O/MH
	 HKKs9OptSg4TXax5T8qFa2zsS4oAu/illJlFEYqsqEiWHsZvOTiNZP0E/MJCtTzwli
	 icZPghYhs9Rf9wpsBvMszDUPKlCFOjWGav/wYBw0=
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
Subject: [PATCH 6.12 104/280] drm/amd/display: Force full update in gpu reset
Date: Tue, 29 Apr 2025 18:40:45 +0200
Message-ID: <20250429161119.365582512@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
@@ -10775,6 +10775,9 @@ static bool should_reset_plane(struct dr
 	    state->allow_modeset)
 		return true;
 
+	if (amdgpu_in_reset(adev) && state->allow_modeset)
+		return true;
+
 	/* Exit early if we know that we're adding or removing the plane. */
 	if (old_plane_state->crtc != new_plane_state->crtc)
 		return true;


