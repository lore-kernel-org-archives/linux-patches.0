Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829323;
	b=pNw/GNHN5E+03wY8PzisujFXRH+SGuo/1IdeDSKzbNerlOrP28Qn0L/jh+76TsS6N8jZ
	 wwyNDlj74MRiwetdkYG4XSbOaHQpWykDgY6ALiategJbTOd6QeBd4Ax6Z8N1sAO/aAnGL
	 Ix9sr5X/9uRac5GXwF75zxSVgLSDtXaVZkyH2EOa83WT1cBS4sPnbItQIk6k9OBFQZZnG
	 00E0yYRfi6ixU/KGsXBFBI8joZLBSF/A0vz00w7J6v1VCYccZhDgAElozCHLjKSlhvfJM
	 N935hcSNSvaorBnQkYaAxRDWIpy5EF9yyCwwLiLaAF2q9BBIBJCIX1vu+xaY7y1zdCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYUVctQutmV6sy5+4WuSV/d+dgiwt+9tnWliLC6MWAA=;
	b=vIoKOXn2FvhuQf4Mmd8mioQ7rJs/oIiPKMKaK2GS0TYRR4hghJW4gXMY22Yq5TQ2sT5m
	 99N/e0XYz59BfZcFfcmnXeiMa33KBAuSOB/WFnqZNDoG1ZX7xuJ9RfxG+egjazDBbHt6t
	 eTfVa5C/hxOTnIOEmEx03BfUW6URJ2h3JsehbCqOXEWjDaz2tQN1bJHKC4SHGBgGQaTXc
	 QOmZtomik/WH33Y7vtbeaqTqFbR5gjNG2Cld4fF2Xcrm7dFj5b8rQ+Td4gyNGeMqNw9QK
	 1bDZq/XB8UkdIcDe6y/SYVgfe97eX2pJqiZrC6pW3Jegk+Tz1PNfY8D6jdZyVVe1vOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=szPCwXw5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675636070AAB;
	Wed,  4 Nov 2026 21:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=szPCwXw5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F361F0093A;
	Wed,  4 Nov 2026 21:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829323;
	bh=cYUVctQutmV6sy5+4WuSV/d+dgiwt+9tnWliLC6MWAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szPCwXw5jdZ1jIcA9Z+DmP5LNijMCPlV0LtUDHJeXW9YvvPxF0NiZFvJR31kr/tvP
	 1JJr+LAnLJ8x9fy/uh/BkwFb8O+KinAvzuOYQlP2LcepFFJkV9WKZwDBtNCludGlsB
	 g52NyHltkUNN8QRbwQkz55wmzN3hjfPhqV/AmHHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0023/1005] drm/amdgpu: add buf length check
Date: Wed,  4 Nov 2026 15:55:56 -0500
Message-ID: <20261104211044.205423268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0d3c18f04ac36..8ae72c862d112 100644
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
@@ -321,6 +322,8 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 	ret = copy_from_user((void *)&shared_buf_len, &buf[copy_pos], sizeof(uint32_t));
 	if (ret)
 		return -EFAULT;
+	if (!shared_buf_len || shared_buf_len > PSP_1_MEG)
+		return -EINVAL;
 	copy_pos += sizeof(uint32_t);
 
 	shared_buf = memdup_user(&buf[copy_pos], shared_buf_len);
-- 
2.53.0



