Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B2F20EA2D;
	Tue, 12 Nov 2024 10:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407767; cv=none; b=uxiLDaj+z1CQeTukwrarOnPr0wW9HugYKjjvbeAtWsX1M24XUtfrHX5Q4NvZS1YHJETJqNYVz/C/ra8ixPW7oQVUzo2THoiDYBHYwNdBVdqxSkGAZL0CsOXYPm07bpNWrKCzwdEYF9PBFIWG8TFnJdvVlScdV2n4IXtbQiCTEVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407767; c=relaxed/simple;
	bh=PSKs06Fxv569QvPQM6shvFiTD40CvAbNCLSePiOkWRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZJddoUPhKkwPEHYb+CbvUjBb6Nhpb2Z3r4J7qofHApyqiW8edMwkSFwVL+eL0U+/qoBr5AHkjDs9zHzBvMabiKhBJJDS/BA20ToYNMyKMkAEz1jgAfNe3Jrn3Dni1lXebBqNfn42Xil9ZRWq58SnFiWkNs4ppoqthBNvEJHPfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/EsHB0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/EsHB0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B051C4CECD;
	Tue, 12 Nov 2024 10:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407766;
	bh=PSKs06Fxv569QvPQM6shvFiTD40CvAbNCLSePiOkWRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/EsHB0Oxj8/gmUt1f7010PyVV/lcWTaUiJn5ybJYL/DoERVtXgokem0g1ILovEXn
	 xCggh6iFoW+4Wyw9GGIMIvgyWWTyKnk+tkQ/i71fAIfAE9qZOnQwuCyxmJpKiTiNsd
	 AJATALHRXz3TR0tIRNd2Onfj+UV4YJUZYjEByZM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 077/119] drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()
Date: Tue, 12 Nov 2024 11:21:25 +0100
Message-ID: <20241112101851.663825391@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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
@@ -402,7 +402,7 @@ static ssize_t amdgpu_debugfs_gprwave_re
 	int r;
 	uint32_t *data, x;
 
-	if (size & 0x3 || *pos & 0x3)
+	if (size > 4096 || size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);


