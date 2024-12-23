Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA1C19E98B;
	Mon, 23 Dec 2024 16:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969974; cv=none; b=VEGHMMCKCskSgduntHfEivytSWJkXAv8P3BijzagPSJ7Djx6gh//LwK+rtvE4XuFhc6hvDRrkaxOXcAtWsH80x5V3Rg9l60lyXh8NDRBS5F4juWpwAXT/DiUolKnxKMh362RLtu5QcYQY6E8lGVXnlVNDjqaI9ImqT5vdMqw6vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969974; c=relaxed/simple;
	bh=FmdPuaFyV9YJNTYTZGOrvvCzep5mInvyYH2gw3dM9Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cECuF0lFXoUc0ZwsUfKnlaW7/C0ctRv3rDJjCvvJ82jGuNa2xEV0tCml6tbFDEXTy7ljd+EvvKdOw7GdRT3tFsUoG2jmEHm6N8YVt6t352J/K1S+jumpPGX/15rULvd1fcoyAw1prXZdEHphcb2Hjce7QivG4d90oVTf7+Xydkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zh8IOYhf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zh8IOYhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10030C4CED3;
	Mon, 23 Dec 2024 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969974;
	bh=FmdPuaFyV9YJNTYTZGOrvvCzep5mInvyYH2gw3dM9Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zh8IOYhfnlQXw7XL56+fiXHyGEIcJTFm/Ktv/tGhrQPu2JwG3QmCk2JbxrYWDo3we
	 69v/7ssbQb1Ww6fRZQbrZ3awRR51SLG4UBVxG+1h2uK3j5lPiJMMU7HomNl0vzQ0vf
	 qLqPS7gnVDnojjGJK2T1v0fqqkd0LQX9Y/jU0QCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 106/160] drm/amdgpu/nbio7.11: fix IP version check
Date: Mon, 23 Dec 2024 16:58:37 +0100
Message-ID: <20241223155412.775292214@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8c1ecc7197a88c6ae62de56e1c0887f220712a32 upstream.

Use the helper function rather than reading it directly.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2c8eeaaa0fe5841ccf07a0eb51b1426f34ef39f7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
@@ -275,7 +275,7 @@ static void nbio_v7_11_init_registers(st
 	if (def != data)
 		WREG32_SOC15(NBIO, 0, regBIF_BIF256_CI256_RC3X4_USB4_PCIE_MST_CTRL_3, data);
 
-	switch (adev->ip_versions[NBIO_HWIP][0]) {
+	switch (amdgpu_ip_version(adev, NBIO_HWIP, 0)) {
 	case IP_VERSION(7, 11, 0):
 	case IP_VERSION(7, 11, 1):
 	case IP_VERSION(7, 11, 2):


