Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CD2196D90;
	Thu,  5 Sep 2024 09:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529477; cv=none; b=C1R5CHyMaFk9TIEolUZ548j1/4ICavZpRwb4ioEbPfQYk7LwcNbgCSCgcwbUOn+ft7+SM141Cu2aMVTS0+t1jA3gxQU9wDZuBJliXwMWeNpJ0NLL4mKLwqUl8nfufUNLyX/cFH5d9cG4jsyt+DS8soJiKiruJdOaF5GU8tzSs3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529477; c=relaxed/simple;
	bh=FrZcjjvmCfb4KiVycLY/SHcJ1FGDEQUuXSxszoiCzGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jouY2ls2Fk0lAeWVipr9/Zvx1vwdMV/NDD9xb/ERKKOIDa9/0rz0QsSqK38C8AXm3TCYhrY0yhOuXIE/9ZxhNl581C1IySO4nQXq+Wgriy/QbV88zBv88k6UPKdkCj5m1rLBTkOyhCD9gNmd14tQFxTY1n9apmXFCykD699GYlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCLTLYQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCLTLYQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CB3C4CEC3;
	Thu,  5 Sep 2024 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529477;
	bh=FrZcjjvmCfb4KiVycLY/SHcJ1FGDEQUuXSxszoiCzGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCLTLYQ6MkuYhwVw2xQ+YFPrBsjRfhHVzTHNvgH/cGcsy3PPFPdpHRcWbk+x7vx1K
	 DrdF9+8iYhiP5oKoL0lco1UfJJzQm8Xl1JQShkH6RC5rGLUQVGGa+Z3H78J2w8u+ij
	 fHrF+J/A+RBNXhV8rYjJ8ybQEMuCX5B/uo38MjEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 045/184] drm/amdgpu: fix overflowed array index read warning
Date: Thu,  5 Sep 2024 11:39:18 +0200
Message-ID: <20240905093734.007934593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 88ffb15e25cc..d20405d84e12 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -475,8 +475,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
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



