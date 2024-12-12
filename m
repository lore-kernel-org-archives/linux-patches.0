Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833C52AF0E;
	Thu, 12 Dec 2024 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016841; cv=none; b=gsjfo3bTWRXFy2jm+Q0K0fSXkR+7C3kjEvs2A3kFe8KSYOh+iJJ9V1ZoQAYCEXy1pPTIRTYKG01moIIGb5uKju44jXrTUenYNe1gZPSbHB2rOo5CbOcgjhkqQX977Hh8lmg4/rFytDM69ig1BiTWZ0GbqUjNiMRLnaWAGkDgj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016841; c=relaxed/simple;
	bh=D68DjHyA8i6nAKO8SQ1zozJSges5MlVpwfsJmuZM3UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFZ0s0mMjzIghg1mm45Gch/c2YDBL07QB8hSneB6AeNk2uOGrtFcVM8RsJJfrFLuITCUhkZU0hOX9Yl1iQMpetjzUXS6kfmrroEdCBtWMXsQnRdRS3Oh+pbl/cm3D7iEmPlLLrUHLYhvYbtSH8d17KBt2aul99ZSV1PikvIP8tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXA0DeqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXA0DeqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A85C4CECE;
	Thu, 12 Dec 2024 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016841;
	bh=D68DjHyA8i6nAKO8SQ1zozJSges5MlVpwfsJmuZM3UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXA0DeqXuonpMyxEKo/IeBukzNEdM/7yq9LeFdEVPxGhbXb8bW61QVH+3652Dntqq
	 8j+QJmy40rrPSn+N1eQ9j96YVqLqj3Hr811IQriiFTXDom8vL+2WyMYKjwLD7d7kSt
	 w89WVhOafm8rsahU5krfFIOnnLvw0tolmhDkNTZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/466] drm/amdgpu: Dereference the ATCS ACPI buffer
Date: Thu, 12 Dec 2024 15:58:00 +0100
Message-ID: <20241212144319.067948786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 32e7ee293ff476c67b51be006e986021967bc525 ]

Need to dereference the atcs acpi buffer after
the method is executed, otherwise it will result in
a memory leak.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 7dd55ed57c1d9..b8d4e07d2043e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -800,6 +800,7 @@ int amdgpu_acpi_power_shift_control(struct amdgpu_device *adev,
 		return -EIO;
 	}
 
+	kfree(info);
 	return 0;
 }
 
-- 
2.43.0



