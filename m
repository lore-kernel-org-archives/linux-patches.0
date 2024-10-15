Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E36C1C07DB;
	Tue, 15 Oct 2024 13:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997629; cv=none; b=qX/FgwoIwxIwMJKwEb/e8296jpGdOoJmOg3mmlqPMra08maDCHaEXSeGlLOVobJ8JpH+3+W7PZQ1ZJw2E4U3wqD6r+be9DHBIrnPuGyKQyCZReuPwfaS/WfvtsTmMrrLiQ1xgv1RSdqCG34fw+D1rlHr2ftePh5jIUDrJU+T3yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997629; c=relaxed/simple;
	bh=DQqWtn/khCrl1K4nYL7QIFPxFA+itPh2HJUqPBdQDZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNUQ5CxNp1VyOjWNS5T3OI9bSfTxrbIutD64TTugrDwsOQB2+dyS5dUB2ne/Bh5uEC1T/FJa3G6KXn2K5Z3KQ/+ED71l3h4Y7NA0Q43Sz+Dz6/WnklYZrLpFtHyKxNWcOdAc90pZkcZ+KL+gfBpwqOacK4l2xJUhC92sWhNfhdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qD5N5xWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qD5N5xWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B0BC4CEC6;
	Tue, 15 Oct 2024 13:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997629;
	bh=DQqWtn/khCrl1K4nYL7QIFPxFA+itPh2HJUqPBdQDZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qD5N5xWuNEeK9bhx3IeXMV9XUMZML5w0tA8106qya1UAMOMUxoQR3Ckspwx5onNOZ
	 Vlbf1a6U3DcZOr3CYgYtisfPqjoSic0X6ECCahqWKXZ1m/O4jYItQpRR3ugRfoLeba
	 JTWwIMOhD65qT6WeRNQYcTr5H6y0rAMrkavWPduE=
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
Subject: [PATCH 5.10 208/518] drm/amd/display: Fix Synaptics Cascaded Panamera DSC Determination
Date: Tue, 15 Oct 2024 14:41:52 +0200
Message-ID: <20241015123925.012156973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -201,7 +201,7 @@ static bool validate_dsc_caps_on_connect
 		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
 
 	/* synaptics cascaded MST hub case */
-	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+	if (is_synaptics_cascaded_panamera(aconnector->dc_link, port))
 		aconnector->dsc_aux = port->mgr->aux;
 
 	if (!aconnector->dsc_aux)


