Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C40226D02;
	Mon,  2 Jun 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877130; cv=none; b=bwtxxm7kdziTSmUiNz5Ik8PlNI2CDnse/0AA6L+9cmSCwFUQih/9qRpSm1/VbL2/TebuG6SRsZvOpR99Oa/TqrIuzACLX0uOmf0PzKQPCmHb2NorB8jt8N6uS4NGOh8B+jrn5n9Zw+ZYd4vBva7FCd7RiwwjJpdZnUW0dvk4Jd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877130; c=relaxed/simple;
	bh=mdxvWaKEyj0mWhZN4iF03Oc6ApABz5m4Pn8IBKF2m5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=If1b07yYpsMbljNLUsoga7Y0GbGEzRnEjkbeXoiQZKtNmUYfFroEWfo4QKLRvnyQO0fQUfF64oXqdLnhgvqp+JCW0Jo1YkXjXeeinYWwDwATEPi08KHpLj/N11v8PPQ+BVVRv53BZEi2FiPo3SHJPPTFgKd7Pr66u9lec3PA6J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOHNZC6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOHNZC6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B5AC4CEEB;
	Mon,  2 Jun 2025 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877129;
	bh=mdxvWaKEyj0mWhZN4iF03Oc6ApABz5m4Pn8IBKF2m5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOHNZC6EmdjTXT3V+n1iD//18z2LbTfBeb/upU3W389RYE769XRhiFrDPOG47hy6G
	 GKFLbgoiqslLAZ3ZchyUvmrzp/H8XLR/HTXvvfwhMfN5qgXoFNv17P8p6lv0jUO/Rx
	 SH9GXSPOuZ08PlOMDm73MPQrtHSOwdzJ41VLkMms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/325] drm/amd/display/dm: drop hw_support check in amdgpu_dm_i2c_xfer()
Date: Mon,  2 Jun 2025 15:47:38 +0200
Message-ID: <20250602134327.207663100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 33da70bd1e115d7d73f45fb1c09f5ecc448f3f13 ]

DC supports SW i2c as well.  Drop the check.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0d8c020cd1216..998dde73ecc67 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7281,7 +7281,7 @@ static int amdgpu_dm_i2c_xfer(struct i2c_adapter *i2c_adap,
 	int i;
 	int result = -EIO;
 
-	if (!ddc_service->ddc_pin || !ddc_service->ddc_pin->hw_info.hw_supported)
+	if (!ddc_service->ddc_pin)
 		return result;
 
 	cmd.payloads = kcalloc(num, sizeof(struct i2c_payload), GFP_KERNEL);
-- 
2.39.5



