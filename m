Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D296517C220;
	Tue, 10 Sep 2024 10:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964735; cv=none; b=Ku/5BR5ULnmy4b0/TvwYehoijRXxl8iOCP/WTMq/uga1POX/XRmbbzTeCySkxlCAUuxzyGUtAl8RD5kxxBn1m/i9tBe/k9FeEZpBRJJHfiG1fvQngv9q1RSIkX9W4xYEv7SCuYm/SmY2ZgzMrW4mM7D3/2pu+zcCT3+rub9tp4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964735; c=relaxed/simple;
	bh=+W/7LiUc4oixau43JKVlzi46EAIgt5jvP0TQ+EOH8t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RONJHYxuUndDfnWEOPOKiWDN0gJT/0tPyTqYHjtQSX8JpvjFwJDYJ7QqGYNv9uAyJjqiDwmKYuNuP6+waDNg2R0dRazlUziezOTJFfkLpEhYQQgh8TYBrelf3p7gNcOVMNwtvT1B0VodVRwnVV1QpN8Hn/JIjG9XoJnDJ02p4lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jw2Exs8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jw2Exs8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6DCC4CEC3;
	Tue, 10 Sep 2024 10:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964735;
	bh=+W/7LiUc4oixau43JKVlzi46EAIgt5jvP0TQ+EOH8t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jw2Exs8zOaF8B2gZnccJHGZAXyHMZLx/BO7FcCq/R7J7rlrGMImLiYMKpC7gX919h
	 B5Ve+OczNzT/N7bWz0mv+Awazaf+kIQnaXf7gbe4QHbZYkj5w2uUtESnDcuo0iEMiz
	 v3Kg1Chakrf7/4yKeu2aaA76vMOd5ssafNb0GYX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/186] drm/amdgpu: avoid reading vf2pf info size from FB
Date: Tue, 10 Sep 2024 11:31:49 +0200
Message-ID: <20240910092555.240350403@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhigang Luo <Zhigang.Luo@amd.com>

[ Upstream commit 3bcc0ee14768d886cedff65da72d83d375a31a56 ]

VF can't access FB when host is doing mode1 reset. Using sizeof to get
vf2pf info size, instead of reading it from vf2pf header stored in FB.

Signed-off-by: Zhigang Luo <Zhigang.Luo@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index bd53844a8ba4..ca4c915e3a6c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -552,7 +552,7 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 
 	vf2pf_info->checksum =
 		amd_sriov_msg_checksum(
-		vf2pf_info, vf2pf_info->header.size, 0, 0);
+		vf2pf_info, sizeof(*vf2pf_info), 0, 0);
 
 	return 0;
 }
-- 
2.43.0



