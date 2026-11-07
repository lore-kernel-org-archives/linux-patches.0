Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060568;
	b=xmJtzyrPuoyw20cOTKbdLoOUSYM/+ofOgGact+vcKGnHuxhldDJCQvSpFPB9DxX8Hyhe
	 ulnKe3RW4LH7NTYflnSM+QQ4wK6FdJETajFf1jBljXihSZBOpyteEmFTafWT82dyicXVS
	 Js+c6raXdDpP0lJ6gC0xQnDe9DMmWxq2Al6/+OnBzFTSs44T1qqAk47TZf5FpCoVFRWrh
	 G7jWwI80i4lROlEoeN+G6P4Jf6HMDMKQZn90bPowaztG1RfyPb6PSxGXLR/KAqTkkXSpn
	 sdNQ8f9ccGOcunwFeI0/T2pTVNPSsBg7n15dsOOPJ6KVMFXvbWag3pZ562Jv8QqogTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGswOsxKpoDMj9PD7r1/NtNhbjTHjpNLEUoBBgrFYTc=;
	b=ic7wWojeQeslztpV7DkVUrp1+eJn5i+irrGoUMTJq5sRWT6RVuWfIvtsy+S1CYZOrF1U
	 /itwLCvdJe1VpYAR4irarXLj+kh0n3y7+4+YB8+xsblEx1J+aJo+OcwbWXTMHTkfS+Ln3
	 xwPe7v2l43eoAZNTNF52s2ECZGxqFiQaGzy0sIOkOuo5RG8HXOmlr9Lmrk5xqSQ1RVKX/
	 b6be7NFdi823rU2BHow0Mlx9D7hPYRSCkQ+tFSj+/T2bQ1bvtlIGMykDLir7VpVzEIbPu
	 gaUZwA9FV5NjMgW+C14+U9J4+EddzG3ex3wk31o2NVI/DF8ug8drtowL/ZNglJO97xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8chR7c5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301D606A326;
	Sat,  7 Nov 2026 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8chR7c5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA52E1F0089F;
	Sat,  7 Nov 2026 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060567;
	bh=nGswOsxKpoDMj9PD7r1/NtNhbjTHjpNLEUoBBgrFYTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8chR7c5HEGtbtv6YYQQ+jiW5Ya3qpl4+PhyrTUdKA98AhmmS2VjVRAIKw8jYBILl
	 1urPt5c+mYeSnFZnBsxirRZmW8q8SeLrnSzx4yEjWNA18NRui3KhshRJWvYQnnzKyX
	 +W5U06qLq/7VoZUpW9kaad/noON5Z/cESQlCfzfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0029/1536] drm/amdgpu: add buf length check
Date: Sat,  7 Nov 2026 08:34:05 -0500
Message-ID: <20261107134958.490662702@linuxfoundation.org>
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



