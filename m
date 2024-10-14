Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F355896;
	Mon, 14 Oct 2024 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918267; cv=none; b=VtLZvDDFzQPAcS+7+9QU9ezFJu/fnoRS2n+zEPGw/Dm+E8G36HDz6Tl8trIx2/GzVczyAEeEYTC6mNmfdf/FAZ2QNTdiB83T7Sz2DagodzQCaCaoT7b3w4xcS+e8gKf7483vJiCQsZFTdDdEjb8znaRdLrQpUhe07IgftOyIXmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918267; c=relaxed/simple;
	bh=zyHcned9l0v4vcYH1thwK4FqFW9t83jrkk9Z8TBK+bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHGva52nbWoCY4/ZSjko2TP66wNt7QiFqu15a8eFSmSaqnFmLhiOccLAyoX24+SSc9T0T7paAjIGlDxfGMKs78TpbVSVYz/35hKX40bXWHiqPstdZm4Dz6bRqXQ9+2sY4O+T5I005MmDNPtr746ekuR0cxJbN8O+WbcLAj2eDf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlMy/CqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlMy/CqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71E2C4CEC7;
	Mon, 14 Oct 2024 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918267;
	bh=zyHcned9l0v4vcYH1thwK4FqFW9t83jrkk9Z8TBK+bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlMy/CqA9umrZqM7Rq+C53SRieQ2HmfUWjEEHusTS1aOLtq78v4uQfQEQoXNLZY2K
	 4OzyTIFfcCFkBEV60BzECIJWmI51SBfRVc/8m2bi4OE8LfdJLRSGm3SE24YJIXrMhr
	 Z4a+KJysfThw3vqHWiafblIJsCJTulIPIUfuLZ88=
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
Subject: [PATCH 6.1 273/798] drm/amd/display: Fix Synaptics Cascaded Panamera DSC Determination
Date: Mon, 14 Oct 2024 16:13:47 +0200
Message-ID: <20241014141228.659206376@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
 
 	/* synaptics cascaded MST hub case */
-	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+	if (is_synaptics_cascaded_panamera(aconnector->dc_link, port))
 		aconnector->dsc_aux = port->mgr->aux;
 
 	if (!aconnector->dsc_aux)


