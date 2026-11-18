Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055157;
	b=JyCqbOasjukGYtzi7C+3hrJyshE10l0Dzhw+57/CWm/lLH+y26l+ErS3ibaa9QDf2M6Y
	 BnJYP41ZdwKAtf/SMx0gOVQQrMsUFVvgDMxh021EIxxb13tC+hj3KqiVDCryOQxV+Jsje
	 sMPWnASxQhClAm32n0DLjpzFklXBadelDNQ4INN38SmsWybQzEiuXUtp36YNjWjztOOQp
	 3TodGJlL7wZ7/QMiumhsHAkQnaRIS3JGqKYBTDSbsBUTFF8Bvnd3QPSoRuB1r3ZPJMpMd
	 K+qUPw/OH2K2LCFIM0hBQ5imgzam97JZGf1cL44FgYTSPBgHCNkocWeKvhitQY3eaBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLxpiOZMyG8YrSBpmacYTbYXxlCVa9Vs5ftmGr8WWxU=;
	b=P57JjW/BaF7GlGgezzM9BlwkcRoGAF52Razrt8Dz36Lj327kT2GlXGyqIwYiaug2TR4c
	 oQx5vQakfEJSajfnI+sEaJhku7qTioAY3VI21/r2io2AGfHoEDXEdlYhuBv6P77Bmuv/b
	 Z6w70OqIBOhcpBF8VsvyDAxwAv1AOwJ1Eprb+h7toCUaKbl7WVOScBQQG8FL7SouuuTF+
	 pxtDYrvcaSm/APsVeiE/4NwOJUtIuSfdgLz0cjGWO3Uf/6rtiB+xXADr5SzYJ+01Bh3/4
	 22NFQH4uxTe7xFOJhxxQ+H+9uMnB4JswpL8+s4x8RwRlaJW3n9zjB4jTKfT/wRn8hNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDfBC3Rm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8416606A325;
	Thu, 19 Nov 2026 02:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDfBC3Rm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BCC1F000C5;
	Thu, 19 Nov 2026 02:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055157;
	bh=eLxpiOZMyG8YrSBpmacYTbYXxlCVa9Vs5ftmGr8WWxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDfBC3Rmn+arxjTcm61F2U0dRkdRjGEe3klMuqk80iYVB4DDjNrBWI531ssUW51P6
	 OW3sDTNyEzVIAIxuJZtDX4wEZ3/TETL3k9GGMEDdSFH0t0h+yf3OtFQHgVwBs5p0gC
	 +iXbvtrtN5Wy4bqTSgwtHcfzd+HTnsCTyjHH5ks8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1531/2214] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 18 Nov 2026 15:53:27 +0100
Message-ID: <20261118150113.427839604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9dcacdc41083cccff74292851bf9fde999e0731a ]

The UVERBS_METHOD_GET_CONTEXT handler allocates the ucontext via
ib_alloc_ucontext(), which calls rdma_restrack_new() (initialising the
kref to 1) and rdma_restrack_set_name(NULL), the latter attaching the
current task and taking a task_struct reference.  When ib_init_ucontext()
subsequently fails, the error path only does:

	kfree(attrs->context);
	attrs->context = NULL;

without first calling rdma_restrack_put() on &attrs->context->res.  The
kref therefore never reaches zero, restrack_release() is never invoked,
and put_task_struct() is never called, so the task_struct reference taken
during set_name is leaked permanently.

A local user with access to an RDMA device can repeat this path (e.g. by
hitting an RDMA cgroup limit or supplying invalid ucaps) and leak one
task_struct reference per attempt, eventually preventing those processes
from being reaped or exhausting memory.

The legacy ib_uverbs_get_context() path already handles this correctly
at its err_ucontext label, where rdma_restrack_put() precedes kfree().
Mirror that ordering here.

Fixes: a1123418ba10 ("RDMA/uverbs: Add ioctl command to get a device context")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916085529.1838-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index 049684880ae03..05cc541c82090 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -230,6 +230,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 		return ret;
 	ret = ib_init_ucontext(attrs);
 	if (ret) {
+		rdma_restrack_put(&attrs->context->res);
 		kfree(attrs->context);
 		attrs->context = NULL;
 		return ret;
-- 
2.53.0



