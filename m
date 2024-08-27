Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C341CDA39;
	Tue, 27 Aug 2024 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771823; cv=none; b=ld0T2LiR2NXXFe559J+paBBhNYQfrZms5hEZkqXmiWwkmQJlIojlaBlvN0xzfUrFw7lsR+Jx0b119W5e3QvWtFZo94QYDzWEC/St4i9A7sbUkoeGJPjV98uYPEHjs1g1o4ZR+zqLvZI8GRR4hkigJz01i++gmkvobTo+ysT1QKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771823; c=relaxed/simple;
	bh=E2Usd9Yuisdsb6tB0KAPXkEGyZdAr11AKcmiRQGZzoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZzdDKdyRGix7AtdTOP9xtVC6nE025PxmSCF46mBg8vVjk8WFxjXCUpNf8pHaVXXc8mOrnWC0qOsbXNH0IpMhUaqrXN+3H5y3KbzTM22MjzhihbgFGPHMJQciiiCKy9JANYH+KC8/befEkmr5cjMuElzbayyfqQiVhiRflvBSxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmJK6FZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmJK6FZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C32C4DE1C;
	Tue, 27 Aug 2024 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771823;
	bh=E2Usd9Yuisdsb6tB0KAPXkEGyZdAr11AKcmiRQGZzoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmJK6FZ72GxDDICgfo6q/6fvUrE2N2/4ZrbCXWNb3bGYUZU8aKxTyp1I7RX4/4xcy
	 Be/PCpBs/qalymW8YC8SlqpH5heNL9mBldjaU584DUncAmhZVKpsc+ssbtHnC8Tf5P
	 ByfOwntJfS1FQBtimlY8pTs0Jwyxd/8w8/3TaRU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 030/321] drm/amdgpu/jpeg2: properly set atomics vmid field
Date: Tue, 27 Aug 2024 16:35:38 +0200
Message-ID: <20240827143839.363775416@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e414a304f2c5368a84f03ad34d29b89f965a33c9 upstream.

This needs to be set as well if the IB uses atomics.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 35c628774e50b3784c59e8ca7973f03bcb067132)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -541,11 +541,11 @@ void jpeg_v2_0_dec_ring_emit_ib(struct a
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring,	PACKETJ(mmUVD_LMI_JRBC_IB_64BIT_BAR_LOW_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));


