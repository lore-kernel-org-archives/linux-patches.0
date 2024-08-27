Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C33A19F485;
	Tue, 27 Aug 2024 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771055; cv=none; b=aBLbAG3Rt60XyvhLltOwqBx6Q/WWeuLCobzRKYOZ9w7Mx1QbG6pWbfi7BtGuLPR+V4ecabmppZv2toneBPRZnt62wyw28jRQbXvyl4VdV9W2FqCe/3bMduhaOLMFmsNVjbgvk0jVLcCzHloKqjYxZuYqXUB5sWCa+Sbpr+I8YLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771055; c=relaxed/simple;
	bh=Qj1gh5ZUAGGlsDFA91j6YsUS2tg32wOWDHRMma2bWYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEhAw+u6EgDduVowigI+Uij7pHX5OJc8T2GMpxDy55B94bzlbr1fIvhm/f6Y9il8u+EkCeNLpx9VVp+vdc92J1TqXs8h71nXBzLmHQrgFuxfkJq81Mb+jshs1hLZsXxfy0iwkugqwadM5/M61gmJrH2iOe0pyY+dL2EQlqGewYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buSD2JG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buSD2JG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AAEC6104C;
	Tue, 27 Aug 2024 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771055;
	bh=Qj1gh5ZUAGGlsDFA91j6YsUS2tg32wOWDHRMma2bWYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buSD2JG76Uzuo5oRpr/N/S6y8RFv7V27nfpaLAWJYbjSGTB+awytsYjldOvMqd4hT
	 kshj6+4zS+ljgbpVKnerrzw+BcFof708Y10cO/PG1vApgMraGmd+JY9KtjXrAgmscn
	 hujzquSd9UI2PFJoG8T1HM/g08cB7Qb5D/zcTo88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 074/273] drm/amdgpu/jpeg4: properly set atomics vmid field
Date: Tue, 27 Aug 2024 16:36:38 +0200
Message-ID: <20240827143836.231420079@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e6c6bd6253e792cee6c5c065e106e87b9f0d9ae9 upstream.

This needs to be set as well if the IB uses atomics.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c6c2e8b6a427d4fecc7c36cffccb908185afcab2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -773,11 +773,11 @@ void jpeg_v4_0_3_dec_ring_emit_ib(struct
 
 	amdgpu_ring_write(ring, PACKETJ(regUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(regUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring,	PACKETJ(regUVD_LMI_JRBC_IB_64BIT_BAR_LOW_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));


