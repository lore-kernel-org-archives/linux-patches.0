Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB0F208A7;
	Sun,  1 Sep 2024 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209713; cv=none; b=pfJKknhIe87JWECQ5ldRq//+ikb4ETh/5smAb8vSBy4zQ70bnjiVkC7CklHASB4ZYEAiYrOCdu5YbLHlNcBgCTwYWX/SHuoxcdtLltNuN9Ey/OyXX5E19OgKxZpr7J678Q+Xt/VzJOXEn8fKYYuG6VMGbqT7ij6ASOQPHjKdlx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209713; c=relaxed/simple;
	bh=Fq82Jx1hCY60T6yLZSjg05GoPVkTNCdviO5IFL1k9hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=USGKGTmGu1fjQq2yujRktj/YChhrmvmgOndfzEYsFpk2c6YGhrRRRmikfKrV7TYOP4fi27xC/LB5OOYdhVypRIOoa5o8+ukuG5tt0NaWW2t+VrvknDeccJ6u6q7N4SOhakG5RlER3N64GLSxhYrWNxU6O5FmMJAyzJmCXs+XhAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8ANOWf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8ANOWf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD80C4CEC3;
	Sun,  1 Sep 2024 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209712;
	bh=Fq82Jx1hCY60T6yLZSjg05GoPVkTNCdviO5IFL1k9hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8ANOWf5tFaq/IIIPYyjCyHTiLWi8JgH90MT9/nFFHkMpfQzyB1VYbZJEnnqoeaLh
	 VTlQom6g0ZKwOiX7Z4fe0Ek3cUbgjK3fZLvvQNAKQSVnGEfSNtVOzZzLQIfqEgILzK
	 Er+lR+FJ2pXECzhMFHuhlwpb10nY509WR5bYmDTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Subject: [PATCH 5.10 121/151] drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc
Date: Sun,  1 Sep 2024 18:18:01 +0200
Message-ID: <20240901160818.661311583@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

commit 88a9a467c548d0b3c7761b4fd54a68e70f9c0944 upstream.

Initialize the size before calling amdgpu_vce_cs_reloc, such as case 0x03000001.
V2: To really improve the handling we would actually
   need to have a separate value of 0xffffffff.(Christian)

Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -725,7 +725,8 @@ int amdgpu_vce_ring_parse_cs(struct amdg
 	uint32_t created = 0;
 	uint32_t allocated = 0;
 	uint32_t tmp, handle = 0;
-	uint32_t *size = &tmp;
+	uint32_t dummy = 0xffffffff;
+	uint32_t *size = &dummy;
 	unsigned idx;
 	int i, r = 0;
 


