Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0D5CA40;
	Tue, 16 Jul 2024 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144283; cv=none; b=ejkJHDN2LFwnC73TpvL5QY43SjIDqdQu04DziGqtsUDTg13/Up1qdbirv1kNwXfl9B1swPCzvKsJ5GdJZ2ghy0C4fw8Y5XKlAkOn1xGfZhYrq9tax+XDGgU8IjaMBL9IgcVIaS2hGlKvNVE1OYUZiqmlVHfZRGrhR98/54vkGNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144283; c=relaxed/simple;
	bh=Hev4F+evGBRBAtaBCJZ/BvQU6cM1AnDEHSVdlDJ4Zuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+wpUyNR/UDZFo8Wsm+CSuU3495YcbOOmcSDOjQaAxaV2ayw0seonjmN/yyQ0hyBlEvsNRQzGLoDxVlx0ZyZ1V/+/R3u3ChzHdz6A+AhRwBmFSBhLCXfsYEhJtsjo38vyIuyXSvHuL/ou0zRsSEK/54QwgxIxTlU1e6egn2bfpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mO5Ek2C5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mO5Ek2C5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30B1C116B1;
	Tue, 16 Jul 2024 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144283;
	bh=Hev4F+evGBRBAtaBCJZ/BvQU6cM1AnDEHSVdlDJ4Zuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mO5Ek2C5zazZopOpbTxLyiDT8rbT1fkeSxD4pd4z+tmHF4QckkxmPKPmT5pmqXhD+
	 HxwQIHBID2DN0BFzBjWtSSeGkcl5VEc5o6Aho53g6fhnCQ/IhpI5qqsNQuaRKO9pWo
	 +F21ZCguYKce+Oo7Kc1rQUwrzJRcH85PItf1rKgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/78] drm/amdgpu: Initialize timestamp for some legacy SOCs
Date: Tue, 16 Jul 2024 17:30:38 +0200
Message-ID: <20240716152740.876324649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 2e55bcf3d742a4946d862b86e39e75a95cc6f1c0 ]

Initialize the interrupt timestamp for some legacy SOCs
to fix the coverity issue "Uninitialized scalar variable"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 76429932035e1..a803e6a4e3473 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -384,6 +384,14 @@ void amdgpu_irq_dispatch(struct amdgpu_device *adev,
 	int r;
 
 	entry.iv_entry = (const uint32_t *)&ih->ring[ring_index];
+
+	/*
+	 * timestamp is not supported on some legacy SOCs (cik, cz, iceland,
+	 * si and tonga), so initialize timestamp and timestamp_src to 0
+	 */
+	entry.timestamp = 0;
+	entry.timestamp_src = 0;
+
 	amdgpu_ih_decode_iv(adev, &entry);
 
 	trace_amdgpu_iv(ih - &adev->irq.ih, &entry);
-- 
2.43.0



