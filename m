Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794930C340;
	Tue,  2 Sep 2025 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819797; cv=none; b=LJ53cBCftjeado/E61w1fJ5tvUMiJOllOekYhf1QS1GfkqF0zBcxPceLAvM9OkA9QJkkvasUj4phwRhBzMpCmH6F36iBJ1pQ+Dqsp+Nr/FTIRHDTxbnkgLjV4mhITrhXVjp/8O7adFzePk1Nq9Z3eD7HNW9oohH3ZvwEkN2L6OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819797; c=relaxed/simple;
	bh=qNEDoieNlvAMUaQSly7sJ4WOITzhyTWyzRgBCHmfqZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDP+PzCNh/i7QQ31bB/3zmqiI95jzS42qe7J3VvB8d4cISjLe6+c2oQ2J/+9FzjotB8GN2AuX1G57of85SmoQC3h/9SQ23nAoswCNi7VRg3/FDpTYGSr4h0FNYVQDhf2cwjU5qBso1DldUpxtG9ApK68VdJH+hOl1bcolwgeXms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YQTPryp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YQTPryp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB95C4CEED;
	Tue,  2 Sep 2025 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819797;
	bh=qNEDoieNlvAMUaQSly7sJ4WOITzhyTWyzRgBCHmfqZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YQTPrypNWGE3m5ra1PBh4zgI0EhGMN8fl1dkkt1/kRtkcRTvu13ArtrQj6n1+uU1
	 wTKOKtohOeOHE+beyhR23a5io0g8RI5X7tr4noAqOWH2+cPNEL9Vc/N45ORHXZOMn6
	 rScKQlWX2erleCGRxKoQCo1CrQwzBr/9mUONMBJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.16 131/142] drm/amdgpu: update firmware version checks for user queue support
Date: Tue,  2 Sep 2025 15:20:33 +0200
Message-ID: <20250902131953.302833627@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

commit ee38ea0ae4ed13fe33e033dc98d11e76bc7167cd upstream.

The minimum firmware versions required for user queue functionality
have been increased to address an issue where the queue privilege
state was lost during queue connect operations.

The problem occurred because the privilege state was being restored
to its initial value at the beginning of the function, overwriting
the state that was properly set during the queue connect case.

This commit updates the minimum version requirements:
- ME firmware from 2390 to 2420
- PFP firmware from 2530 to 2580
- MEC firmware from 2600 to 2650
- MES firmware remains at 120

These updated firmware versions contain the necessary fixes to
properly maintain queue privilege state throughout connect operations.

Fixes: 61ca97e9590c ("drm/amdgpu: Add fw minimum version check for usermode queue")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5f976c9939f0d5916d2b8ef3156a6d1799781df1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 456ba758fa94..c85de8c8f6f5 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1612,9 +1612,9 @@ static int gfx_v11_0_sw_init(struct amdgpu_ip_block *ip_block)
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
 		if (!adev->gfx.disable_uq &&
-		    adev->gfx.me_fw_version  >= 2390 &&
-		    adev->gfx.pfp_fw_version >= 2530 &&
-		    adev->gfx.mec_fw_version >= 2600 &&
+		    adev->gfx.me_fw_version  >= 2420 &&
+		    adev->gfx.pfp_fw_version >= 2580 &&
+		    adev->gfx.mec_fw_version >= 2650 &&
 		    adev->mes.fw_version[0] >= 120) {
 			adev->userq_funcs[AMDGPU_HW_IP_GFX] = &userq_mes_funcs;
 			adev->userq_funcs[AMDGPU_HW_IP_COMPUTE] = &userq_mes_funcs;
-- 
2.51.0



