Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6366B22333D;
	Thu, 12 Dec 2024 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024906; cv=none; b=fUIpdAJi59sa+pAbJzIA5YXzOExM5Eht3f2Z6k08Q5X1NJ6GYErcMkm2POWX/vZFN/yMCB/hYum2ckMXGJyGuGxItsKHtJSDi6ZQeNTluA3eZFH1BPqST2YKtfwwKOlWoXxFqa3ZCesjwaHcP4/jo21jMu6CvfTC9qjz5x1+4Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024906; c=relaxed/simple;
	bh=fz5IMC84DK+dcEP35jfxY8vBLno0juO6nwODlHXHLLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYwBiIX1nkq7t1Wbrc/0ap4tfNd5i2tyaPYA1Bp+iZmd6OvmYt9oXibL928cQrDxsoHp8F+E3f6rGUOgj6cjNTlDO1xQjy1rLegfqvjNx7vvqbzVoiq4zJ7E7lbfkAYaultuD75or5kXY1gIGwxbx5xCBS4rWBeRjOTjibIFI30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3DpfODW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3DpfODW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92AAC4CED0;
	Thu, 12 Dec 2024 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024906;
	bh=fz5IMC84DK+dcEP35jfxY8vBLno0juO6nwODlHXHLLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3DpfODWNjRx8G9SDm83czqfhmNCsY3RpUfD8DqAP6OzMIv65NAk/JiW2nwJeyxFY
	 MmbfZ/9aXjAjI0MQ2jjzuueSdjq5UpwvDRwIA55f3YMrdlQeeVQ4+0TrTzsF5vPXZ6
	 kemlXVEK1LxMKwFlnB+vlTQhubN4icUYzS+Mvw4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>
Subject: [PATCH 5.10 452/459] Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"
Date: Thu, 12 Dec 2024 16:03:10 +0100
Message-ID: <20241212144311.626966237@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

This reverts commit 17f5f18085acb5e9d8d13d84a4e12bb3aff2bd64.

The origin mainline patch fix a buffer overflow issue in
amdgpu_debugfs_gprwave_read(), but it has not been introduced in kernel
6.1 and older kernels. This patch add a check in a wrong function in the
same file.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -396,7 +396,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 	ssize_t result = 0;
 	int r;
 
-	if (size > 4096 || size & 0x3 || *pos & 0x3)
+	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);


