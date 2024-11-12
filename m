Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CF9213EFA;
	Tue, 12 Nov 2024 10:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407373; cv=none; b=AkZoMO3jnoIb2PJ8tI9SVSB8Rm8trOIRyeMT3deRiwK8J9ODvWYmMNrFIVlqlpvurQ2L9IWT/ZG7nQ/rOp1lhcCiKF9J2K+rHmuL0Dcxz+uDUbM+PnuSbytl7G/ugK7axbE25O/+spZm6hHgxZR3pxFbsp1fWDO85L1zhR1oXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407373; c=relaxed/simple;
	bh=uUBryTaza5Ip4ANHud1LigIVhGTPveDrqGLynToXgeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgVgf48oDgoB7l9iFwQAlCtOjqVlMEDiBq4LT4cULPdTlB/jVuN92bsf8Uz5KzhMe1c8MyW3SH7/mM3E6hjpWnjWQvv7bzo3/ww9z1rng2xUEcBqSevew5pRTozVDCeOSAcDEKEi3c7fG1iFuIA42M/eDxjeLQq8O0WGRtH785U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwahgCXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwahgCXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2F8C4CECD;
	Tue, 12 Nov 2024 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407373;
	bh=uUBryTaza5Ip4ANHud1LigIVhGTPveDrqGLynToXgeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwahgCXq6Hn6tnLMPbOAP8wFJOEmw0rjFn/3Gzs8h7leKcGoNDsTchpkjx2HHn8Pw
	 kG7gotgmv7QddRLisbr2I7U74DQeHqmCEe5oUsOUtVB14i0syX0BA1AGvNQsgFkYvC
	 IRCBR4ND5z/xIGHGG8vCVh+m0eLsfXT1hEnIZ0Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 57/98] drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()
Date: Tue, 12 Nov 2024 11:21:12 +0100
Message-ID: <20241112101846.438790940@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 4d75b9468021c73108b4439794d69e892b1d24e3 upstream.

Avoid a possible buffer overflow if size is larger than 4K.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f5d873f5825b40d886d03bd2aede91d4cf002434)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -419,7 +419,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 	ssize_t result = 0;
 	int r;
 
-	if (size & 0x3 || *pos & 0x3)
+	if (size > 4096 || size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);


