Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3085B5381A;
	Tue, 10 Sep 2024 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963356; cv=none; b=e/Cl4B6mXUDMcWzJeOTTZEKhsOEBUwv6rOxJJva60uaRZbrTl/2w5vYTk8FUT+kIs8D+ORwlV+Y7Ul0qwxtl+IqBwT7nlus/SxSvqYt3+foLBDgjVCsx7BXUEM5VKze0KqWAIHowYZNFR3s4KApDOGZ6Ywyt03wT2WO8GD8aonk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963356; c=relaxed/simple;
	bh=7zZgX8Dp91th+1Ru4MXZv3IuL3yl4OmKX/6sWB0AXhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B4EUZUJKVJ1KYUU0IQfofBv+6nrNHVKBcytYxnsTR1tS1FmAdPtsN6/zCWLmWREZzmXaEUXRwjoKKSCVKjTJe80TGeLDOQxKw1lY9CAC3E9VBOzOPIAPktzjowbbN+Ecj8naQinXSuJDSwN+5I0Np1LJV/Dzq+Y3Zoiprncv790=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5rWYzcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5rWYzcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B9FC4CEC3;
	Tue, 10 Sep 2024 10:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963356;
	bh=7zZgX8Dp91th+1Ru4MXZv3IuL3yl4OmKX/6sWB0AXhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5rWYzcYEQj82RPHZvXWs0WvV7viqorZKu3W8aTVikB4qg2tdKC/g/f/TGdaPFUmw
	 /gghUxQtiMqvUf0oVzl4KmLtinZKalMs8D7M/Qf1om4OiN9yQn/IWfN5UF0EXyqm6j
	 YatdETQSnUUHZE9ioatHzHNmxlnLEJAIhcSP5OWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/214] drm/amdgpu: fix overflowed array index read warning
Date: Tue, 10 Sep 2024 11:30:31 +0200
Message-ID: <20240910092559.088531704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0554576d3695..294ad2929485 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -367,8 +367,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
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



