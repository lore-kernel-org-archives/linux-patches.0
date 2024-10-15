Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFE61D4154;
	Tue, 15 Oct 2024 11:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993062; cv=none; b=KafNBGnQ/78+SN2rVp/IvB2FppC7eC41oa0GSnHdomeR921HVuAc9FTWYaY14Sw4OG6hSkprWeepwLrO9k1theOJanHS5/cZkENSUGFqUF4jx4gfZWXhS9jNSyuFZ9ORdA7kBiaZ1QYzS176heVrfvhSKxXoTT3Z/vgDnc4yCII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993062; c=relaxed/simple;
	bh=4r2IvBrl0uIHjK/Ky9r+rZMQr0dMTqp40mio8NuFnBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF4zOv9Bwc87u3PwMIzmZF1BnoZ7p1a87rDPs7GEzxUzHPhJVcnRqJZll6dYTuHM/wV2DCPuBNPXpcdXJBFAh8/Se4lmbOokKaaPtDF0ArEef9j5Ejg4qtvZxQ2haIL9Yp2Fy2pfI6udTkt2mmiZcNiOdkmI+bffdx3HIA3cIKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlbmdTcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlbmdTcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59324C4CEC6;
	Tue, 15 Oct 2024 11:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993062;
	bh=4r2IvBrl0uIHjK/Ky9r+rZMQr0dMTqp40mio8NuFnBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlbmdTcOCpfd/UW0MQL0Q72np7m0G2mWEVDU4i6s4F5w0leDERJjrSOj5InxnmDVq
	 Aia/xXezmscII0820GjVM5356y5f66OZ0zEENh7s0HSHXNDQdQioXJ8HK3blkdASY6
	 Q+Dpd7w2H4Erg5AgRRLbw+JtsSkerIQhr2XSXM2o=
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
Subject: [PATCH 5.15 299/691] drm/amd/display: Fix Synaptics Cascaded Panamera DSC Determination
Date: Tue, 15 Oct 2024 13:24:07 +0200
Message-ID: <20241015112452.211678426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -227,7 +227,7 @@ static bool validate_dsc_caps_on_connect
 		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
 
 	/* synaptics cascaded MST hub case */
-	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+	if (is_synaptics_cascaded_panamera(aconnector->dc_link, port))
 		aconnector->dsc_aux = port->mgr->aux;
 
 	if (!aconnector->dsc_aux)


