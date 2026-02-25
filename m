Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4206226056D;
	Wed, 25 Feb 2026 01:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983040; cv=none; b=ZCpt+E25h+FRktx6PpkcdmniifC9E8P70iHBDcHylipe1arfO1ZONswglhIFTCeFAmvKhyY6kCx5w/4m1oF0GX3spa4JBmKyYgbhDWplbHbQNqJJ/IfSG+83MdMWx7fPyk+9D+qu7DYJ0bZVikCboQPOq8VZJRQUnzu2HOGyIrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983040; c=relaxed/simple;
	bh=PAyDYJizRBoVh70JII/V8gq+G/ZwEkPHyIXLriuIHkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9d8ay0tvc3zIaG5B+xXnfDTBywXG3nMbdiLU4Z4BHscl8eM+h9sxLX7sQG1nSwg/JTST9CvTXC21rL9iM6/FuW7higwponEB6dbBNEGeDmMGUai9s8MjyaSpftA+iE9NFICl/E1wZMMoFqckVYcc9d3Z30ISqsYh83GmPes3k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5lPOg7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5lPOg7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19806C116D0;
	Wed, 25 Feb 2026 01:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983040;
	bh=PAyDYJizRBoVh70JII/V8gq+G/ZwEkPHyIXLriuIHkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5lPOg7y46uaN715oCGZ/cqzeReiuvnTn65GaRN5DZEa/UM5fOzgkelW0pdWoGQGH
	 kzILJpYnUIH0V/aBYnrUybsz4xJ2M9jAIPaXMNDkGV+0ExifStc6iPjDnijkL/aEt2
	 /HNmHvoRvcLdzBURVxNTn4BY5vuUD78ejqKQmlLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 203/781] drm/panthor: Fix panthor_gpu_coherency_set()
Date: Tue, 24 Feb 2026 17:15:12 -0800
Message-ID: <20260225012404.644788448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 9beb8dca9e749e9983e70b22e9823e6fcd519f91 ]

GPU_COHERENCY_PROTOCOL takes one of GPU_COHERENCY_xx
not BIT(GPU_COHERENCY_xx).

v3:
- New commit

v4:
- Add Steve's R-b

v5:
- No changes

v6:
- No changes

v7:
- No changes

v8:
- No changes

Cc: Akash Goel <akash.goel@arm.com>
Fixes: dd7db8d911a1 ("drm/panthor: Explicitly set the coherency mode")
Reported-by: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251208100841.730527-3-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 9cb5dee932120..ff5231269518e 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -51,7 +51,7 @@ struct panthor_gpu {
 static void panthor_gpu_coherency_set(struct panthor_device *ptdev)
 {
 	gpu_write(ptdev, GPU_COHERENCY_PROTOCOL,
-		ptdev->coherent ? GPU_COHERENCY_PROT_BIT(ACE_LITE) : GPU_COHERENCY_NONE);
+		  ptdev->coherent ? GPU_COHERENCY_ACE_LITE : GPU_COHERENCY_NONE);
 }
 
 static void panthor_gpu_l2_config_set(struct panthor_device *ptdev)
-- 
2.51.0



