Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D33928135D;
	Thu, 27 Nov 2025 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255938; cv=none; b=i61z9BYbo4TnqihtGfpgUkU3v2DUvCzzuumfQbwtY6chouO+U8ZS8x9AY2K8i7X9ivWI0DAg16dYPRs79nItLfEC6/CB6lGv0p3FtrOwNd2oTNwPBNr+IWRb7NBnPQLGL9/Me8Hnc8fWgNqISdpwvP4hH5DDJO7PWTNQlPXX1vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255938; c=relaxed/simple;
	bh=7btulC+4GEdBFsduRL955z3eqoTckNENdRnh0b+5u2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF/k7R1HsEI4jP10oIQB1TFQgTsm4fEMYGkWVs3Alj42kSiTnt16vW7TPK1iEX405dTOlsZHpXUXn/NlGptPYFHeDiHKQaJRXm8CN2ObwxIJcVRC6LB1xZhG2AuQwWWqYR6wNBfAT1XmAlB7tIXRBpEDcJ9yvxm09M1o1xO7EbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0ac3GT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0ac3GT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343BEC4CEF8;
	Thu, 27 Nov 2025 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255937;
	bh=7btulC+4GEdBFsduRL955z3eqoTckNENdRnh0b+5u2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0ac3GT3XrjKhhB85jxarau10QxP7YSN1MACSdewOzaYFuCJTExW2qdpFon8WC3HS
	 p2wW72DnYdSKFC6c1d3Wxp9Jav1d0B1kZgG2Ps0Ewe+BRoyBgjrR9LcdebuXvoRc7l
	 CVXiFX8vyjVqrjXvRy10D4QeJcWI/QGOrxSioMiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 165/175] drm/amdgpu/jpeg: Add parse_cs for JPEG5_0_1
Date: Thu, 27 Nov 2025 15:46:58 +0100
Message-ID: <20251127144048.978312240@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit bbe3c115030da431c9ec843c18d5583e59482dd2 ]

enable parse_cs callback for JPEG5_0_1.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 547985579932c1de13f57f8bcf62cd9361b9d3d3)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -878,6 +878,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v5_0_1_dec_ring_get_rptr,
 	.get_wptr = jpeg_v5_0_1_dec_ring_get_wptr,
 	.set_wptr = jpeg_v5_0_1_dec_ring_set_wptr,
+	.parse_cs = amdgpu_jpeg_dec_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +


