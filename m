Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E3C1EA80;
	Wed,  2 Oct 2024 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880223; cv=none; b=hu05kyIJCfBTtNd8ebLN0ea+/sSu4FGn5oE5zV3zF0ZqfXEo/oqIvz9n8THSI9hmGkexokvk4A+q/A0vIV/rVKVVmp5qdnZrbkvUtG7GECXAxG1oSC48qdT2d7E6LQ9/8oRdMdqGQI+yqJ/A5Yxyk3H+d2UADSOHQxv6JcS/1ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880223; c=relaxed/simple;
	bh=I6nD897YVk+TqwEHNp2nkvL2YmXuXlnEigfk+dflyWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFcL8ELSch0yC1zvysRqHTJoK+KFWRI/h4gX3aJLozi2f6zHz0GKd0tj374dVI/L/oPHfZgUGK9b0ATOGN9U+84O4ce7ycPJ1WOIzwRV6oXMuvzOrr57v+xg8K9GgJFLjW7vgGu0OoEaYZParO2QnXEPt+KkmyrGD3szCOjzl0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zy8JCGBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zy8JCGBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF186C4CEC2;
	Wed,  2 Oct 2024 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880223;
	bh=I6nD897YVk+TqwEHNp2nkvL2YmXuXlnEigfk+dflyWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zy8JCGBVMt8Or4IdiwyPtqqIy9rqADeG3vcHkaf000HcWIS4cu0wehRA62Iy4IJJK
	 wWVqwD3syXjnFG8uqXhzTx4H4zzAHLte+UgYvsteD4zNH2BgL8o6e/iTnoNnzCdNdq
	 vV38r6+91kqsAAT9x3QxojdwHKxd2o+4q9Fz+Cas=
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
Subject: [PATCH 6.6 385/538] drm/amd/display: Fix Synaptics Cascaded Panamera DSC Determination
Date: Wed,  2 Oct 2024 15:00:24 +0200
Message-ID: <20241002125807.628069782@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -246,7 +246,7 @@ static bool validate_dsc_caps_on_connect
 		aconnector->dsc_aux = &aconnector->mst_root->dm_dp_aux.aux;
 
 	/* synaptics cascaded MST hub case */
-	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+	if (is_synaptics_cascaded_panamera(aconnector->dc_link, port))
 		aconnector->dsc_aux = port->mgr->aux;
 
 	if (!aconnector->dsc_aux)


