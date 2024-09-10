Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E106D18FDAF;
	Tue, 10 Sep 2024 10:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964801; cv=none; b=aQUCrOtErZYElwfNp/x93H0Jpb3YdwL0CiW/jG4bj2KToKSypLxd+aoRtv6vA4oc5W0EYdS4u8rCV4u6A+up7FrAr6OZHVgDZ5Ut437819CIisBUL/tOIWmWK49utoA1QDPWCkmqkrJDyB9nzHS/SUi1gtEJxBMg+HUo6L0v1go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964801; c=relaxed/simple;
	bh=KRPrr3E3XDAiPGTQauPYOsLCakcAp4QkDER/Dd/jd8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZDOFNZs5+9veT3zr9Yp47hbRO4JIOkVILAR6shxqVH7qwyd46MyxG1s9FLoyEWw6/9O0xl6/zX2l755RJXy9CKQccHrpG53TaU5lwk9pZgcI14zj+MBjKHflrXO6+FHzn8o2kMFmozRxmY8UNWspihtvn6ACqez2lh0qYTgHsmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdzc0PYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdzc0PYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD44C4CEC3;
	Tue, 10 Sep 2024 10:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964800;
	bh=KRPrr3E3XDAiPGTQauPYOsLCakcAp4QkDER/Dd/jd8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdzc0PYMZrmVstUAQNpz7kj9k6QDd5LeEP8hdLIJTVdqgPGPVRdX4JNQZoprc7Vti
	 zRacXyyZSDkQhJ55Bw9ZoMtOAiv8Ov30TC4YAuyzz0D51WO6xEv+2z4z2l8L9FDqTz
	 +F9nlCQ29qzlAhpS4ZMG0KxdfjTUdyA46ORvzB/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/186] drm/amdgpu: fix overflowed array index read warning
Date: Tue, 10 Sep 2024 11:31:43 +0200
Message-ID: <20240910092555.006055911@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit ebbc2ada5c636a6a63d8316a3408753768f5aa9f ]

Clear overflowed array index read warning by cast operation.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 15ee13c3bd9e..6976f61be734 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -368,8 +368,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
 	struct amdgpu_ring *ring = file_inode(f)->i_private;
-	int r, i;
 	uint32_t value, result, early[3];
+	loff_t i;
+	int r;
 
 	if (*pos & 3 || size & 3)
 		return -EINVAL;
-- 
2.43.0



