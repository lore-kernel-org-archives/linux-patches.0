Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0153A13B79B;
	Tue, 27 Feb 2024 13:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041226; cv=none; b=aaES/VYeCJC//Mhl00q/GptpY7fepCreOR7kq1ID0lJHimc4SEMY7ZE+eYIUm6UsO2JmsebMqWvFS1etzAC9UWyt1/Nm5dotZHFFhxO3GUbcqW++HitoGoNAr9FvKMkMjYZln38y70ou6qLV2DkIRdrpjKIoJeqjX2E0+rTpUZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041226; c=relaxed/simple;
	bh=fR7fi8YhyyVWUZbPL5r24a9Nzn14Gef5sda+lqoKV5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVI1f5z4sA0cZPnfSs4kZ6FcXqJcavvAJ1BzW5aLLDdxPY/bfJ/9AeWrWXtalyQARTqSC7BZ1XcWT99BY8AXpk0A5ju1GMO+cABjRBq4WgCEl838wQXfbJzj+ZoWZK/qvEwcJN0reVGH4tAb2AMMdqhB95lW9luRC9TIMYtX9U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Rg48AFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Rg48AFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8369CC433C7;
	Tue, 27 Feb 2024 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041225;
	bh=fR7fi8YhyyVWUZbPL5r24a9Nzn14Gef5sda+lqoKV5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Rg48AFW5jIINa//c7HIJOA8RFemnGz8LjxKFmpXNYAv5zmg1CVgKheX00nBiU2bK
	 dDszFSkuHhTYSYoQEGu7RYxfKKgBvr9Q3I7QsNg4jLheaWf10+zs7/9FT6tpYo6E+p
	 w0VUWvUGrJHLlFqRlMfdC3ibQ2wSvLHovRD53VyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 265/334] drm/nouveau/mmu/r535: uninitialized variable in r535_bar_new_()
Date: Tue, 27 Feb 2024 14:22:03 +0100
Message-ID: <20240227131639.516431105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 65323796debe49a1922ba507020f7530a4b3f9af ]

If gf100_bar_new_() fails then "bar" is not initialized.

Fixes: 5bf0257136a2 ("drm/nouveau/mmu/r535: initial support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/dab21df7-4d90-4479-97d8-97e5d228c714@moroto.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/r535.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/r535.c
index 4135690326f44..3a30bea30e366 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/r535.c
@@ -168,12 +168,11 @@ r535_bar_new_(const struct nvkm_bar_func *hw, struct nvkm_device *device,
 	rm->flush = r535_bar_flush;
 
 	ret = gf100_bar_new_(rm, device, type, inst, &bar);
-	*pbar = bar;
 	if (ret) {
-		if (!bar)
-			kfree(rm);
+		kfree(rm);
 		return ret;
 	}
+	*pbar = bar;
 
 	bar->flushBAR2PhysMode = ioremap(device->func->resource_addr(device, 3), PAGE_SIZE);
 	if (!bar->flushBAR2PhysMode)
-- 
2.43.0



