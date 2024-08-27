Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E060C1C57B5;
	Tue, 27 Aug 2024 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769718; cv=none; b=aKTNWxaYjnQQ/YZH0S5fNQD0GqM/yvHg6ayXDaoNuuJlydsWkt6cwzS7IMRAsti/v+yTZOdcuzyx7xxXcVAn1DRIe8aZGdt9T0APayRM05bl748bBwm0wypFVq4Ct4FT1KDNiyontqi5EjuR8SeoX1QE6wMqzZ/t/CADTLs8SIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769718; c=relaxed/simple;
	bh=H8eyLxXrjmlbLX+X04vNKgeGbsaNh23JQMr7z/2Z9jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siFEmiAyLRlDEee8iT42i1bDvmTSF9pNPepF6WezmH/kGZww6wKGD2YN5EBZ451nOKbsfcjwLqOYA0TPSDMOmMnv34NXcGHRdd5u95o9L+HEnJKPSDjlWm7/Md/QhGl6thNJPPtNcuEcDdnkTWyiY99p2S0Rs2kqhp5AJ7Uw2aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv3Eip+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv3Eip+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C5BC4AF15;
	Tue, 27 Aug 2024 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769717;
	bh=H8eyLxXrjmlbLX+X04vNKgeGbsaNh23JQMr7z/2Z9jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv3Eip+tc+0TORt1SsKP2UzxOPJoKEAQBlPuXUS4RCWqp7e9KknLVEMnGop4a/+8S
	 012/2/VClmOsWzIy7KUZu5pO+ItGkbLoST67URXacAEaM5jTcD8wc9sLe4u09QcPIo
	 eLU87tHCz+b+t9ijhc9GKHCubDFIvA89Ug/hPURA=
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
Subject: [PATCH 6.6 004/341] Revert "misc: fastrpc: Restrict untrusted app to attach to privileged PD"
Date: Tue, 27 Aug 2024 16:33:55 +0200
Message-ID: <20240827143843.571792961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


