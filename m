Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060617;
	b=jF5dleSpY0JH0pqEi+j5EePSh1VnCc6c1Gsx7Nl2Nh5IZpsmpn57FT7kwvB4D/BZ8BCg
	 IQWd1czPGcr1zTMr4Q4TGdYL+U7CYw/pPtcV+e6NOW+Q0izRuy86VX3Xh+GhDw6Xv1Uq4
	 xOcEekllHnG9wrog6bAQEYTlbelIH9nfZt1b75V1Y5l5rs/twRex5UTXlki5O/xneeca1
	 dGKHB0J6bBIfyZBvLppByC3NngmsUWiPRSHHMmKjlvQdq2bIGBPKzf9sE87sYHSKTbZxM
	 mkVhuW2IClxmha42VpKTEMXCXfwIVZCkxsgHPNctgtGfGvr/C58eeQ3tt6q8RXdz6/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQHC2zcFpTJkmhpB/uYp3kSZ+TaUCwp2j6sP2GL+TC8=;
	b=QLv9B91xHcyNmh1jQ8KEoaCwE4N6pa9rXzr1Hk+uuIuTNNQuGPbRgUxaJqr+u3vcUi18
	 JT/HfcOd3IWnhLJRitZWEdKtBqP+hFJpwbhb/Erxc70Mz+WT+i9tv8epsVE099EbRtA8y
	 C1BF5GsZxB67sB19MzjKHOfK6+XJj3bq7e29DYDlZNRMavitlh4R5/OA1Y8H7n+WuXGPl
	 szmCqtmobwB9oVYO7QUzUQmgxgNXlzJO5QOBfJUTjsubAN9RQUVq2N0L8DLmX7BNTPsX6
	 Su/pzFI0VPBZTybTTcn7UuSCBCaqMQwBP019LSPShnivPrOcCX8ZeGxikTu61u4AczQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bdayf+ds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D2606A326;
	Sat,  7 Nov 2026 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bdayf+ds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211A11F008A2;
	Sat,  7 Nov 2026 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060617;
	bh=wQHC2zcFpTJkmhpB/uYp3kSZ+TaUCwp2j6sP2GL+TC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bdayf+dsI+QZ909IFWVWh257l3WU1OSY9eWsGC9c507EtLbzn9jaM3QrSDXU0w8KJ
	 Rij/XilXzI9BzF+jJxUE7MUdZXCt0vuwTadXQbrhf0j+SJ+hXbo4ad/GA5jA+I+9mB
	 57ZbJ0fyfC0UmItgf9RfvumfDycoFYHFilM7OM6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0066/1536] drm/amdkfd: add sanity check in svm_range_is_valid
Date: Sat,  7 Nov 2026 08:34:42 -0500
Message-ID: <20261107134959.521023126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit aa7e29cf9a37092cf5057a612ee09f28df20258f ]

to prevent svm range to be overflow or underflow.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 08fcc94c0a2c3..0b86da7d7c502 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3409,7 +3409,13 @@ svm_range_is_valid(struct kfd_process *p, uint64_t start, uint64_t size)
 	unsigned long start_unchg = start;
 
 	start <<= PAGE_SHIFT;
-	end = start + (size << PAGE_SHIFT);
+
+	if (size == 0)
+		return -EINVAL;
+
+	if (check_add_overflow(start, size << PAGE_SHIFT, &end))
+		return -EOVERFLOW;
+
 	do {
 		vma = vma_lookup(p->mm, start);
 		if (!vma || (vma->vm_flags & device_vma))
-- 
2.53.0



