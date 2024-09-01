Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679F11E498;
	Sun,  1 Sep 2024 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209013; cv=none; b=sY1GNNPBuKoOlamQc7rGvTpS9LG8BEfa3m2dPONCpnWIgBz7oxa+1FITIbkPqT9Xx8+yD4eQnKTW46ScXHWOdxYBtIfU1smB3lJHVMyX4sp+kMIN/IQhXq+Ry2/2/UWDhbMQWiRxomPooLVwyWwT2abiorahpPm1pUP4zKvmkXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209013; c=relaxed/simple;
	bh=yaxmpzFrLNRLLzVcUSbfZRwmRplgT4QVoa8b9tLl+Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9ZaFMqPLIqeIN5AyVrMl5NVcXuWkYLEXEkzn05bFyw98q5Tew94SRsXNC4XPmKqZmv2yLeYZsZzbQEz6aXl5uZbvIqTf88Yo4daTcx6W/XZ2S34pTEvWzSb3mmQh2L8yIik+VKVV7+v11kGX93lzF490oZ6U/SRb+iH40I4Now=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAPt+nv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAPt+nv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAA2C4CEC3;
	Sun,  1 Sep 2024 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209013;
	bh=yaxmpzFrLNRLLzVcUSbfZRwmRplgT4QVoa8b9tLl+Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAPt+nv3bEZTpKhpOvr3ACtl1JBGKwi0Pr4+MEk5AQI8c0k1ql2rNooaY1piwdQwg
	 8csJzIzn0zwQ0VkvBY+JX6OjLpIdyI/p7HrZdUdyypvGsFpAHEq4rDzDVQo9UiHvY7
	 ZH/KDt4oiNSvuM5Z2r5fBAPsWJxernQmailtTAt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Subject: [PATCH 5.4 107/134] drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc
Date: Sun,  1 Sep 2024 18:17:33 +0200
Message-ID: <20240901160814.115591345@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -715,7 +715,8 @@ int amdgpu_vce_ring_parse_cs(struct amdg
 	uint32_t created = 0;
 	uint32_t allocated = 0;
 	uint32_t tmp, handle = 0;
-	uint32_t *size = &tmp;
+	uint32_t dummy = 0xffffffff;
+	uint32_t *size = &dummy;
 	unsigned idx;
 	int i, r = 0;
 


