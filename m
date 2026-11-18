Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039898;
	b=ASwsq5WBQQvAhZJFgO+w/5mZwbr6UKSBnoynBJNL1/1gyWXj3JVwKhfdhfkcadia55SY
	 3MqoY79yxBMgvzblhl9nwmJi7812XNqokazKyFay7F9JxWnExA8Vb0twIay0KHTaUAu4W
	 N6wzYpCMaNoBCvGm0ri/wgjH628ZjbTErraPTt7SPY9DvHQ8uLBWGQ0nLcfjiK4WCgl7T
	 oiU0hdKLrZa27EmRCyCk2HAVu0uS/o/HMOrHvG3080faN9pu6izIdB6nCwmJKe5TvIJJ3
	 BAgmSk06ichK633ezSGjp8benBtakIzFyF5hxReQpXWHwtcin1F2PgmO3JJjFMNtwjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7G/Z2HQQod1cbe+M+va7rnHj87Xh5s4ZZqJhi+bIjA=;
	b=o6IZSbrXyvdmtb2iPm4UHBA3wF8vpF6kTxRgp+Jmcn+0XWMf/15uTl6VkhaJtyznPm2p
	 jCfj3x6rP9r3ZSqVfQb+jaHczYld4K1d6UrrjGuCiQywyVxXYwC7oO4Y5s831yqrgb88+
	 j/h3uwk2d7px0LjMu76HE3qrd4x5C6tBms/rH2DCqEGvEewmy5zXK6MyLJ8T8+XGSlscV
	 iANiuYP3nJfcm2jFZjfgM/uJBg9xmxnRPk2DcoB1XX0hfXgLaj9qc6bNnUVVU7zzEjehT
	 ti5//52Ie+dCqIW4AhupPLkD4xacD3AxFF6Axi+XaLQszxFBqeHdn4tz0qzRI5qry8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dO+WViD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6029606A31C;
	Wed, 18 Nov 2026 22:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dO+WViD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7C51F000C4;
	Wed, 18 Nov 2026 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039898;
	bh=h7G/Z2HQQod1cbe+M+va7rnHj87Xh5s4ZZqJhi+bIjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dO+WViD4fEu5/JAw/jaRbwCKLKXRKiKAcLtismW6IU4db6RuMMpAbb/RiJQM6vrmS
	 pGZQ7bHghQO+WhUVZAr//oLC1GcL/9u137IDGYfH3Dd6SmkzBTY/8IgrX428ZH6ZLd
	 PvpryVgrq2T0QTrnbAn5v3Aq/KbLMhEoiUMuqWzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2264/3318] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 18 Nov 2026 15:48:06 +0100
Message-ID: <20261118150429.729964288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fb0555647336f..e028a1ceeb156 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -231,6 +231,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 		return ret;
 	ret = ib_init_ucontext(attrs);
 	if (ret) {
+		rdma_restrack_put(&attrs->context->res);
 		kfree(attrs->context);
 		attrs->context = NULL;
 		return ret;
-- 
2.53.0



