Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA1E27713;
	Tue,  9 Jul 2024 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524521; cv=none; b=tNNrF00rRt1/RU077sP4CQk1PZ+g6W6OWAEiYOVzJv70/WT2o/8ywDzK+fxwr4qF1QTWkDKtyPMtyoEOoUj1Lp99eMVDrb2aMY+VrGN/Egqa9DFhA9XmeYNt50ccLvF1Gfxep077vUD6en+xSK1sZ9zALMzJfSuY0/HMfdbXh+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524521; c=relaxed/simple;
	bh=bfL5Tjnm1VYfIgKrOOlbTvgtGGY2or1/3aR5bSZy+OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQ3h2TgDkqcfF2oeaBaj4MuaxWk9FSug58vYw6tGs8HdLA9GxMvYun6YUNnsD2gP57EDfT+C2BJQmNt0IeTPskN859mqsCKeNIf5HIU01Ai4erh4LxYJW5CHj4Gwnzj0OAIjbCesGXXcRA3SAjWuBAZTcC53VtA6CcEC/59Dhms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g//F3v4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g//F3v4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB815C3277B;
	Tue,  9 Jul 2024 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524521;
	bh=bfL5Tjnm1VYfIgKrOOlbTvgtGGY2or1/3aR5bSZy+OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g//F3v4jqJL0GYIzo2OZ0qOQhmCmuy1RLUojEN8ybusC0lH39/RIZepsEQRw5iKJA
	 oBCyHjxE8kyqd4XMtoY6RvDMdKVkmGC5ao6bzYxd4HUqf1y80awH+X1F0sEcN/2NYT
	 QvA3n/VZ0K/ewVx1W0NbrcFTvKtv+IyYaUowTNpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/102] drm/amdgpu: Fix uninitialized variable warnings
Date: Tue,  9 Jul 2024 13:09:34 +0200
Message-ID: <20240709110651.803765276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 60c448439f3b5db9431e13f7f361b4074d0e8594 ]

return 0 to avoid returning an uninitialized variable r

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aldebaran.c      | 2 +-
 drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aldebaran.c b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
index fa6193535d485..7fea4f0f495a3 100644
--- a/drivers/gpu/drm/amd/amdgpu/aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
@@ -100,7 +100,7 @@ static int aldebaran_mode2_suspend_ip(struct amdgpu_device *adev)
 		adev->ip_blocks[i].status.hw = false;
 	}
 
-	return r;
+	return 0;
 }
 
 static int
diff --git a/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c b/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c
index 81a6d5b94987f..1311e72486fdc 100644
--- a/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c
+++ b/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c
@@ -93,7 +93,7 @@ static int sienna_cichlid_mode2_suspend_ip(struct amdgpu_device *adev)
 		adev->ip_blocks[i].status.hw = false;
 	}
 
-	return r;
+	return 0;
 }
 
 static int
-- 
2.43.0



