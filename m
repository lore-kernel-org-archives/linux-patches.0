Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E161D0E39;
	Wed,  2 Oct 2024 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878563; cv=none; b=lfPaNUTFmodE1/SzBiAlGiZbgScC3YT3x0zzoE3LxJOTW0wq5R0m4EMPlushMUqHrkIfTAe7HZltbKAuNhGCDzvmC0SK7h8wX+VoV01ce9P2BWAHH4gOjsr1dMnfc72kqL/B39MY9ac+XFLFsmGtPwYqT8IQjxzi5F0y+wxSrAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878563; c=relaxed/simple;
	bh=aTk4ghF6p5y4Rv6YJjwbwTuLimYkK5WZ1GtYOLQ4y/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBvBXr+WFPRGttuMQzx76JApG2hR/rF3mMXSsRLn4NRny4alZm2N1mqC7PzQuc74gJESyMESypJfFoOwJvYQmw8GYQDvpAVh0RfD+SBwwolvsqq+1MNfOa37Z4pCBE2fynjUklYD5Z/3SYZLsi/aWb1I0DcV2L1rji9p4UpXfDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxVVvHOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxVVvHOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD697C4CEC2;
	Wed,  2 Oct 2024 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878563;
	bh=aTk4ghF6p5y4Rv6YJjwbwTuLimYkK5WZ1GtYOLQ4y/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxVVvHOORJy14LZHKt+C1rDLH7uURo3tbb88uDkjKsTpSCMhlwWDkkaRztDWQ8VJt
	 1l/Tsk+Zv2Hg9KTvrjOA+9P1F5d3ZrdXqnUIRijfMYiJAZIBg/wjKRfqqlpgEbkOO/
	 zz7+Vki8oJWgW4r086QKNQ0a49eWOHzLZSzW3aAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <superm1@kernel.org>
Subject: [PATCH 6.10 456/634] drm/amd/display: Fix Synaptics Cascaded Panamera DSC Determination
Date: Wed,  2 Oct 2024 14:59:16 +0200
Message-ID: <20241002125829.101773044@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit 4437936c6b696b98f3fe1d8679a2788c41b4df77 upstream.

Synaptics Cascaded Panamera topology needs to unconditionally
acquire root aux for dsc decoding.

Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -251,7 +251,7 @@ static bool validate_dsc_caps_on_connect
 		aconnector->dsc_aux = &aconnector->mst_root->dm_dp_aux.aux;
 
 	/* synaptics cascaded MST hub case */
-	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+	if (is_synaptics_cascaded_panamera(aconnector->dc_link, port))
 		aconnector->dsc_aux = port->mgr->aux;
 
 	if (!aconnector->dsc_aux)


