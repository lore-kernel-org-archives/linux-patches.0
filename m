Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F781C4EC9;
	Tue, 27 Aug 2024 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770909; cv=none; b=H8Ue51p7oBMmUmpOSRDeBKaX6dQBOpswOiNiEUOqwZIszN/Irzg4nGxUnqxY2Vf/wKOTewlqh/f8+6CbprMzpTEi7zAI35eJqv0pvopIMcUW/DSxTt0khsvifXGabS/EPnqWmp6+cnRnOpvIi8rsDVlPG9p3S1fHUlAKEz6ydhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770909; c=relaxed/simple;
	bh=n5SNh+c45OKlmDnzNIfnaIX5db3UUKVQqyiCU4mrPbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlWtELF7OchS8ctPeLIZcQKywN+msoEZ2w8HnscmKYk2Gx5NjEFLrYpNoO8RVhPlWuUxQKT64LEE7RL4ci/NQJ1CMH3kxC40SBTq2PG+xqNAPc9xhH64Us7QJ3rzLgGNtzGYd0rfYpZF5i1rrks1a6u+BR6FOoOqcnCAd4oUxhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0RkF44v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0RkF44v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AD8C4DDF3;
	Tue, 27 Aug 2024 15:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770909;
	bh=n5SNh+c45OKlmDnzNIfnaIX5db3UUKVQqyiCU4mrPbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0RkF44v2Z2CkZ5JmmSY2YdiSmIdi5aBfotjRYyOBmjdC9R4PcB08kDWMxSMaJMVg
	 gplLNbm4hahpq8CLBaLkaurzuLbxiAMqw2NsAN/3vOvTgAifDToF3IUU4cjqX1WmD+
	 eyU8t8kawC+oQ6KsiNK+A6FMVJVeDZB3NLcll9YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Joel Selvaraj <joelselvaraj.oss@gmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.10 005/273] Revert "misc: fastrpc: Restrict untrusted app to attach to privileged PD"
Date: Tue, 27 Aug 2024 16:35:29 +0200
Message-ID: <20240827143833.583684087@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 9bb5e74b2bf88fbb024bb15ded3b011e02c673be upstream.

This reverts commit bab2f5e8fd5d2f759db26b78d9db57412888f187.

Joel reported that this commit breaks userspace and stops sensors in
SDM845 from working. Also breaks other qcom SoC devices running postmarketOS.

Cc: stable <stable@kernel.org>
Cc: Ekansh Gupta <quic_ekangupt@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reported-by: Joel Selvaraj <joelselvaraj.oss@gmail.com>
Link: https://lore.kernel.org/r/9a9f5646-a554-4b65-8122-d212bb665c81@umsystem.edu
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: bab2f5e8fd5d ("misc: fastrpc: Restrict untrusted app to attach to privileged PD")
Link: https://lore.kernel.org/r/20240815094920.8242-1-griffin@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c      |   22 +++-------------------
 include/uapi/misc/fastrpc.h |    3 ---
 2 files changed, 3 insertions(+), 22 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2087,16 +2087,6 @@ err_invoke:
 	return err;
 }
 
-static int is_attach_rejected(struct fastrpc_user *fl)
-{
-	/* Check if the device node is non-secure */
-	if (!fl->is_secure_dev) {
-		dev_dbg(&fl->cctx->rpdev->dev, "untrusted app trying to attach to privileged DSP PD\n");
-		return -EACCES;
-	}
-	return 0;
-}
-
 static long fastrpc_device_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -2109,19 +2099,13 @@ static long fastrpc_device_ioctl(struct
 		err = fastrpc_invoke(fl, argp);
 		break;
 	case FASTRPC_IOCTL_INIT_ATTACH:
-		err = is_attach_rejected(fl);
-		if (!err)
-			err = fastrpc_init_attach(fl, ROOT_PD);
+		err = fastrpc_init_attach(fl, ROOT_PD);
 		break;
 	case FASTRPC_IOCTL_INIT_ATTACH_SNS:
-		err = is_attach_rejected(fl);
-		if (!err)
-			err = fastrpc_init_attach(fl, SENSORS_PD);
+		err = fastrpc_init_attach(fl, SENSORS_PD);
 		break;
 	case FASTRPC_IOCTL_INIT_CREATE_STATIC:
-		err = is_attach_rejected(fl);
-		if (!err)
-			err = fastrpc_init_create_static_process(fl, argp);
+		err = fastrpc_init_create_static_process(fl, argp);
 		break;
 	case FASTRPC_IOCTL_INIT_CREATE:
 		err = fastrpc_init_create_process(fl, argp);
--- a/include/uapi/misc/fastrpc.h
+++ b/include/uapi/misc/fastrpc.h
@@ -8,14 +8,11 @@
 #define FASTRPC_IOCTL_ALLOC_DMA_BUFF	_IOWR('R', 1, struct fastrpc_alloc_dma_buf)
 #define FASTRPC_IOCTL_FREE_DMA_BUFF	_IOWR('R', 2, __u32)
 #define FASTRPC_IOCTL_INVOKE		_IOWR('R', 3, struct fastrpc_invoke)
-/* This ioctl is only supported with secure device nodes */
 #define FASTRPC_IOCTL_INIT_ATTACH	_IO('R', 4)
 #define FASTRPC_IOCTL_INIT_CREATE	_IOWR('R', 5, struct fastrpc_init_create)
 #define FASTRPC_IOCTL_MMAP		_IOWR('R', 6, struct fastrpc_req_mmap)
 #define FASTRPC_IOCTL_MUNMAP		_IOWR('R', 7, struct fastrpc_req_munmap)
-/* This ioctl is only supported with secure device nodes */
 #define FASTRPC_IOCTL_INIT_ATTACH_SNS	_IO('R', 8)
-/* This ioctl is only supported with secure device nodes */
 #define FASTRPC_IOCTL_INIT_CREATE_STATIC _IOWR('R', 9, struct fastrpc_init_create_static)
 #define FASTRPC_IOCTL_MEM_MAP		_IOWR('R', 10, struct fastrpc_mem_map)
 #define FASTRPC_IOCTL_MEM_UNMAP		_IOWR('R', 11, struct fastrpc_mem_unmap)


