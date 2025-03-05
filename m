Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F911481DD;
	Wed,  5 Mar 2025 17:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197427; cv=none; b=R73igCoLmzQB3N7VBC1rTi8dNoCYXK4kj/Jto+7kBCYE3mZIPFd3jb2Xa/uE/80wJtwKwi3FvG+kzTmKSc1lhFmkEsy+LlHebsrTKZUVPTvFQjpwL0BDxtqfTCbbBht/tpGdT0h07GMErJlYmZVdEVnyerqJaj2d8HCA3XOXj4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197427; c=relaxed/simple;
	bh=0L1bvat81ZLmbFPYRzakrXpylx5C5HXKOvqTAgjozwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/3dKKfL0ZNIokJDfG6LypsvInIG9SsjpAX+YZupedP6JXUjcEvE4D+EgWosZ97rBbLEkHB9uZAhf/BP+jzhzkIoWdo+KF/KaueQm2MC3sDX/pgb/WIkYhQMm6DY5dEQ0sT5aPTlv8f+2HmpQC7zsQdyTE2rSXb/lrSFuI9J4oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luxVqqEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luxVqqEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B561C4CED1;
	Wed,  5 Mar 2025 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197427;
	bh=0L1bvat81ZLmbFPYRzakrXpylx5C5HXKOvqTAgjozwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luxVqqEB4hyG8uDwZbyqoTJO88mM971TApJtMufxbBddMfG1kyEI9YFaBqbLWjJuF
	 wnmbOQ9NQFz9u6cvcWKcLWnai/M3zr2r7WTF5GUgQn15TXutV7tLI/cGQbnOrQKPwJ
	 kI57WrBXg4qkayZeF8uLCodHVLsWRprG9q5yWk5o=
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
Subject: [PATCH 6.1 153/176] drm/amd/display: Disable PSR-SU on eDP panels
Date: Wed,  5 Mar 2025 18:48:42 +0100
Message-ID: <20250305174511.581727880@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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


