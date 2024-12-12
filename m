Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E88953365;
	Thu, 12 Dec 2024 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023554; cv=none; b=aKN7aM0l3idR7inXVDArIz5t0DHzC/zXtljHPXvRg2b0X/7w4/ufvpx2pdl5/9PJ182RQXSGUoPRa5fo23rZibvSwekap1uMXOD7fzeUgSBn6HlicmqMtlXRQPvpezVCn/EClCFnRVpKQQ49cBzCNz8xLMW3w5Hp+5FfLUu4sRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023554; c=relaxed/simple;
	bh=3JgCAw96Vp09b2vjdM6POUedlqsV8IQ04rW4dIf7Odc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q24e3V2E3s2slOl3YNCwMp588lakLQpWqYDpHL8Q4BTUsAGGZvfaZO8WoaitapSx2RgylbyrHxVOGOm0nXWvX1Pecaa24txYjl5xRBhwUssCZHlIfyqReYCW1L47CXgtvbo3JEClPVvhWva+Y59+Zz5sLXp8q9DUWNbv1gDrfS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6erdl4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6erdl4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49D2C4CED4;
	Thu, 12 Dec 2024 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023554;
	bh=3JgCAw96Vp09b2vjdM6POUedlqsV8IQ04rW4dIf7Odc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6erdl4xeMYxMpcyCz92b1OzQQDiiVXVkdV5KRz39VKLQ22OP9PY1yNx++Dwb3aI6
	 G1bNjWeZhpLPBQEFZ99GMCGc2aBskhT3hPIsUZa/NflVp6QpJT4vnGIJz4aChkViaB
	 hKhifnZt75/yLYI6Q3xWahpSU3xZOJ1BMUd5UV/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>
Subject: [PATCH 5.15 553/565] Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"
Date: Thu, 12 Dec 2024 16:02:28 +0100
Message-ID: <20241212144333.718494081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

This reverts commit aaf6160a4b7f9ee3cd91aa5b3251f5dbe2170f42.

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
@@ -401,7 +401,7 @@ static ssize_t amdgpu_debugfs_regs_didt_
 	ssize_t result = 0;
 	int r;
 
-	if (size > 4096 || size & 0x3 || *pos & 0x3)
+	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	if (!adev->didt_wreg)


