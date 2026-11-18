Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033462;
	b=GPxkHfaHtFpqg7Zv3i6LD8/C9QV63lQyeY8sjcLmNdXhgXDNtcW4hvjV059ejW5wSjWd
	 ztdMW4+vp7qhEBQ/6+Wa7pO5WWaZs1HmosnbgEn2Hp4p/hum2i95+cBHo5GQzGEW+BsXa
	 Q5RjfWlhtFvhkZIQXylv5rRA/3q7UD0UFILUuLByO4Hpn/DzljweYujiXWlQsJmeCQ3Wi
	 22ygy80aKgUlsny51u3VdNhSxS4RTISdu7R4N2rS0GMwGB7rZI8Tie6ZMqqR9iZftf46I
	 xx2gNnBDZtmoz7rybgJcb/I3EIgjwyZv8jgcbcbeDjOKl9RtkL4Dxt4aGAqHp3Yze9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DGAxT7Xxx1sHdzdt5cKbnn5kK9fq6A6y2Qg7ElATdIM=;
	b=hIG4g5E0n7Oqt9PP1IIXDwl8VCMy4dbI+xcXTHFOutQ9kBcpoRKc/zwO5ulVOYV1xhyE
	 Wu0tvHLBx4LDli01K6c/vLphiGNk/SgIVcrbgY2kQFBY0CJbSy4G1ZmESe5QEUmEllW3b
	 QDFUpAI3dGSkx1bJIfYPkFsDBRfTGFWqC3aBy/KkX/ZGzrMHOf/uTvnTxyX15DlCTmkrQ
	 80DlGjSS99k0zoxbVHTwCLGWmidzsDYWCrxtqNoVz12Su8Aoh+Blrdu57LoDh0O55qfxG
	 uDFp+fGICcww3guqtgsK56RLqhCVjs3/KhxO8nXLS2gq44HILKzeMeIIerwDCV1qq5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wDL/dcE1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1972B606A32A;
	Wed, 18 Nov 2026 20:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDL/dcE1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7981F000C4;
	Wed, 18 Nov 2026 20:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033462;
	bh=DGAxT7Xxx1sHdzdt5cKbnn5kK9fq6A6y2Qg7ElATdIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDL/dcE1bKCW3fRJCIgSfCXi5R3JB4ZqJh4TL/WHdK7z2Uqv/bfWognK9Gvb0+9ZD
	 yaXPMi8jTxwGn6+yDqJTXjbto5W+gZvYoJmrvVRaQbE2HbWEebP8ICFUnRShO8EXvR
	 0Q7/557MBfy88gCPZbsCe7PYi/BYHMBjZhVxtwIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0023/3318] drm/amdgpu: add buf length check
Date: Wed, 18 Nov 2026 15:10:45 +0100
Message-ID: <20261118150314.432921536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit 473f99e4a262776141366f7fb10f101d0f22b019 ]

add buf length check before using it to access data

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index 9aff579c6abf5..082dc720659ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -166,7 +166,8 @@ static ssize_t ta_if_load_debugfs_write(struct file *fp, const char *buf, size_t
 	if (ret)
 		return -EFAULT;
 
-	if (ta_bin_len > PSP_1_MEG)
+	if (ta_bin_len < sizeof(struct common_firmware_header) ||
+	    ta_bin_len > PSP_1_MEG)
 		return -EINVAL;
 
 	copy_pos += sizeof(uint32_t);
@@ -325,6 +326,8 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 	ret = copy_from_user((void *)&shared_buf_len, &buf[copy_pos], sizeof(uint32_t));
 	if (ret)
 		return -EFAULT;
+	if (!shared_buf_len || shared_buf_len > PSP_1_MEG)
+		return -EINVAL;
 	copy_pos += sizeof(uint32_t);
 
 	shared_buf = kzalloc(shared_buf_len, GFP_KERNEL);
-- 
2.53.0



