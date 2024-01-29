Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BB8158D64;
	Mon, 29 Jan 2024 17:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548234; cv=none; b=r9fke4M1qLYQ6Z3zn3vDcvxZoJC8RM0AAvzWrnPFjURDvZtwf/9bL5UsHERmgkf6SLeHFYK+USIglg9xnUv0GeVT3oes6eZqHBzjZnTuXaCI81o+wvrRgZqgD+wH9aXLpR3HM16T0nso+y0K96PYaDSVdO8NOKI6OuT3e+vMBpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548234; c=relaxed/simple;
	bh=vVfqCSfh+X+7Ac2/yX/Qbeo/3wzJVlAsHpKt+PiM6pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNOvvrCoTpNLGmg82RsFC5f/hnBdd0r7tKhX0K6upfR7JoNl5AFHo/EjlQIb10oh+xOqDcdopcGyhMYXN36sHoz7deGbo4GHcnMEdAEeK66z5gL+LE66M0tQzqFirLAyyirucVmA+Pic1jl4PdrrW1xl+4Lwg4Ph3n/6yXIuSpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEzTuq5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEzTuq5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BE8C433F1;
	Mon, 29 Jan 2024 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548234;
	bh=vVfqCSfh+X+7Ac2/yX/Qbeo/3wzJVlAsHpKt+PiM6pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEzTuq5dajNI19z7uZCmKBAOWCW2Ek7NMleGJl4G85T/qdfX9B+aUJCsIFL5udzMd
	 /f/eP7w/Jf+m1H8s27E+2UOpKXWiOHVh8uhURE79UGDJ/EK4XezXYSeDOpuHR0Nan7
	 PEvsZmfF+V7+GeCMDZ8rZPDYw3wHIDK+dvorLGyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Ivan Lipski <ivlipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 258/346] Revert "drm/amd/display: fix bandwidth validation failure on DCN 2.1"
Date: Mon, 29 Jan 2024 09:04:49 -0800
Message-ID: <20240129170023.981943521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivlipski@amd.com>

commit c2ab9ce0ee7225fc05f58a6671c43b8a3684f530 upstream.

This commit causes dmesg-warn on several IGT tests on DCN 3.1.6: *ERROR*
link_enc_cfg_validate: Invalid link encoder assignments - 0x1c

Affected IGT tests include:
- amdgpu/[amd_assr|amd_plane|amd_hotplug]
- kms_atomic
- kms_color
- kms_flip
- kms_properties
- kms_universal_plane

and some other tests

This reverts commit 3a0fa3bc245ef92838a8296e0055569b8dff94c4.

Cc: Melissa Wen <mwen@igalia.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Ivan Lipski <ivlipski@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10479,7 +10479,7 @@ static int amdgpu_dm_atomic_check(struct
 			DRM_DEBUG_DRIVER("drm_dp_mst_atomic_check() failed\n");
 			goto fail;
 		}
-		status = dc_validate_global_state(dc, dm_state->context, false);
+		status = dc_validate_global_state(dc, dm_state->context, true);
 		if (status != DC_OK) {
 			DRM_DEBUG_DRIVER("DC global validation failure: %s (%d)",
 				       dc_status_to_str(status), status);


