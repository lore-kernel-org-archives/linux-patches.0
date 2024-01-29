Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F146775606;
	Mon, 29 Jan 2024 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548602; cv=none; b=FLUGYqqfa8Cvry9ugZhel9yxYzQmUEjFPnCeCidpme7F+E+2/hMWovWpsZCep5Onkrye76RabyKsYtSWhAVCgMMqphKJbsnrL5IF8sGUWijObguLnqfEgNu9JyqLdtxIkOx/8GFHL3E1jVn0gAnYks2UUu3oxMmHhXN84e7mA+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548602; c=relaxed/simple;
	bh=5w+wsKSeSDMZy92lQYCYK1vkP3dKO/jkmtWXSthJoQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI+DuJWCTofo6qB2QnX9WnYiCCQgZJW7mvgQzF02Ne8hEGiQA/WLDSQm1n4SNwvNKjuMrXEurGZ+72dgyl7osjkbXgsG/YEPbB3NSPbl99eLfv0ixpv45PxgKXhUnhG7N8gRvy9oZX85GKdE4vf5wi6eFOmI19mBmCOV6kuNjEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utGLWcrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utGLWcrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7005C43394;
	Mon, 29 Jan 2024 17:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548601;
	bh=5w+wsKSeSDMZy92lQYCYK1vkP3dKO/jkmtWXSthJoQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utGLWcrk++WLykRsD6fRyQVYLe7YbRZ8hY76yVBUFJug6P8oiEkMo8BR92yzpJrek
	 PUEHfwEXgZ0c/SSrWzZ7MJ6K7fCpMyVu/n3lMbv3NjLiDmAXDHGdncNdtuuuAuSXqi
	 aI59MAtguZ+434JJTGJDWrAUjVuswpEylJqd3MI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Ivan Lipski <ivlipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 264/331] Revert "drm/amd/display: fix bandwidth validation failure on DCN 2.1"
Date: Mon, 29 Jan 2024 09:05:28 -0800
Message-ID: <20240129170022.594153032@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10400,7 +10400,7 @@ static int amdgpu_dm_atomic_check(struct
 			DRM_DEBUG_DRIVER("drm_dp_mst_atomic_check() failed\n");
 			goto fail;
 		}
-		status = dc_validate_global_state(dc, dm_state->context, false);
+		status = dc_validate_global_state(dc, dm_state->context, true);
 		if (status != DC_OK) {
 			DRM_DEBUG_DRIVER("DC global validation failure: %s (%d)",
 				       dc_status_to_str(status), status);


