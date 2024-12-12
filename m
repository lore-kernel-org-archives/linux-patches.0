Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921D31487CD;
	Thu, 12 Dec 2024 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021579; cv=none; b=qUo3E3CbbIlXTJEVjEq6x7ApfOHveByDsvEYyqeCsbtAEkCwwa2sU1zFTSW9I/ezyxtXlvspPHuFaUgTi5c1g10wD1VsZi7eQjDOHpB2Q5Y7SCJSRHbK9yEQSPJOjkHfoLeeQ+6IsyHmXmb+FNk0Z1dJ14UhF/mS/ovn6e584uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021579; c=relaxed/simple;
	bh=CMny7rTr6gRG1+YkkclIzBLODXfcoji6L+ePnAguLww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3cLfLv6BMfU+3x6CyL+O+1wgXoZYQ3h3XxIf8yUaL5W1maL4NrgPHUjk3NF7qdHAXeCHtLzSVIyXKhpvz6bb2IPf5mEkWHDYaHN2dvsK0EJghYjb4V/sMAjmdi04b93ElZUYZkAmqU2/t6wD+nF86G2xgPuuZq01EN5Gn5bYnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocRSMODr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocRSMODr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00978C4CECE;
	Thu, 12 Dec 2024 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021579;
	bh=CMny7rTr6gRG1+YkkclIzBLODXfcoji6L+ePnAguLww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocRSMODrrguQTMi1a6bCjd7jzu6nCABqeSgmNUO5wFhPrMjBV9ehmGgNTBm3hlONQ
	 bFt+ObrDZ7cqpkdCIvHjaZzMrQzHD7jMzNknltIsYaOyLGTSt6ftwgTmUnGIZPJWdg
	 KNYh1f4Tx8FV5YfKGEhxXUIwR+I90hFuv2fdbPBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>
Subject: [PATCH 6.1 751/772] Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"
Date: Thu, 12 Dec 2024 16:01:36 +0100
Message-ID: <20241212144420.961464225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Zhang Zekun <zhangzekun11@huawei.com>

This reverts commit 25d7e84343e1235b667cf5226c3934fdf36f0df6.

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
@@ -419,7 +419,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 	ssize_t result = 0;
 	int r;
 
-	if (size > 4096 || size & 0x3 || *pos & 0x3)
+	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);


