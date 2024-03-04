Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCE48F58;
	Mon,  4 Mar 2024 21:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588382; cv=none; b=obMrcdIYkcknjYHmhmIJ0fckLTNjxHfrW0UB5ahZ5bdB0/PSrsbJ1Sd55YaeiNLFpEMNu5RUOF50QNgcmb4ybjcbsXiKzK9He/JefMLvG5QsaztzDfI+OPUFQEFo2k7xRt6iQYFxqUNkb4Kt/rUmM3BaQYDoRtomlAcSXH78Tk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588382; c=relaxed/simple;
	bh=YMa60vpicIAOkPHP05bHn900LWbyB8JnRJ6P1+pOFtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiIi+rHS9umBgeT15qcu7Nb1eaMhdyIdYiKu8IR6/6LILCNZXC4xy0YtuJdiM+Seqc9u4J9uBmc2ZmtJoX+V6coRL6AAkXRrFfZ+uvcWqZKgJeoVZPa/UAVken2/0mfXYzqlpJii5ORb+xavkEuqJgDQ0EBNuIJCI+pA3spT3D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VULdYOdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VULdYOdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699D0C433C7;
	Mon,  4 Mar 2024 21:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588381;
	bh=YMa60vpicIAOkPHP05bHn900LWbyB8JnRJ6P1+pOFtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VULdYOdQt7bdk1alWR7EQeH5zMUCW2ECic7Y1+IgF4LDaEDEmle5QYjCNfBsml1pT
	 dhj33jyLUKKg7vf4CabHEFkM4Koda4t/vreH412h2dAFOCw2AOB7SuBLLSGU3g6WYc
	 i5CDFIT4/B8wZD2h5DgItzT8cLsHPd3mjjWGIRVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tsung-hua Lin <tsung-hua.lin@amd.com>,
	Chris Chi <moukong.chi@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.6 086/143] drm/amd/display: Add monitor patch for specific eDP
Date: Mon,  4 Mar 2024 21:23:26 +0000
Message-ID: <20240304211552.673748554@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Ryan Lin <tsung-hua.lin@amd.com>

commit b7cdccc6a849568775f738b1e233f751a8fed013 upstream.

[WHY]
Some eDP panels' ext caps don't write initial values. The value of
dpcd_addr (0x317) can be random and the backlight control interface
will be incorrect.

[HOW]
Add new panel patches to remove sink ext caps.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.5.x
Cc: Tsung-hua Lin <tsung-hua.lin@amd.com>
Cc: Chris Chi <moukong.chi@amd.com>
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ryan Lin <tsung-hua.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -66,6 +66,8 @@ static void apply_edid_quirks(struct edi
 	/* Workaround for some monitors that do not clear DPCD 0x317 if FreeSync is unsupported */
 	case drm_edid_encode_panel_id('A', 'U', 'O', 0xA7AB):
 	case drm_edid_encode_panel_id('A', 'U', 'O', 0xE69B):
+	case drm_edid_encode_panel_id('B', 'O', 'E', 0x092A):
+	case drm_edid_encode_panel_id('L', 'G', 'D', 0x06D1):
 		DRM_DEBUG_DRIVER("Clearing DPCD 0x317 on monitor with panel id %X\n", panel_id);
 		edid_caps->panel_patch.remove_sink_ext_caps = true;
 		break;
@@ -119,6 +121,8 @@ enum dc_edid_status dm_helpers_parse_edi
 
 	edid_caps->edid_hdmi = connector->display_info.is_hdmi;
 
+	apply_edid_quirks(edid_buf, edid_caps);
+
 	sad_count = drm_edid_to_sad((struct edid *) edid->raw_edid, &sads);
 	if (sad_count <= 0)
 		return result;
@@ -145,8 +149,6 @@ enum dc_edid_status dm_helpers_parse_edi
 	else
 		edid_caps->speaker_flags = DEFAULT_SPEAKER_LOCATION;
 
-	apply_edid_quirks(edid_buf, edid_caps);
-
 	kfree(sads);
 	kfree(sadb);
 


