Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045555;
	b=jUe8yEfA9mSkYqzx3JxuYbaMZ/4MBKvAJOHcmwUKalQ/Fyv7ieiaIaY1tYETIZ0swphK
	 koCmlLeYCcJH62HXgBMDo1muYI3DFAc3lmIFf9GEWvssXLWXGAIMXyztYMEbuLQrm16QZ
	 6saVWcRQaVyBXe+stZqmGhGdEQTas9YAeHlkidVsA9VTCVllDhSQxZHbwce1Qcm0lMD0N
	 8FCgMmw+OtpaocTqV8mhfg3R7zDE7jMaopitfBnGWe6RvbQqljoD5OOwvWbr2amdIO1ZZ
	 Bh0IlOIjPw7FTwxPFCddLRg7eF/Iec83X5kuwP9HigQx0udm0OIxM2Qx4olFuloKa4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aHX/qwAP3Mi9+qLj/QJ6UTzThDa1/hM0O4E4NuQnUa8=;
	b=SSnHmHcgwPXnv8kEigHOYEr7RMMp/WoExYvtv4L1vOEdNV0waKuOqBBOo6X1ZDRbm1pr
	 8mAhPo3t0TW9ybw33Y/EcHs0DnfBLRZeUqfyA+kOULtdz5uPTLHv8pB4m91LfQ+z61OiZ
	 BmTkHObXNnwkL8YMoj+09pZ2WntrKh6LSSqHvZ+saYoFL/Y+CEGIGKEXfp9dpxZddIw/j
	 7hMFyzwQrsxWd9KbTqy5xmpGJx3I5EPJakLMCp4huz8qbLc/9yx/HwukDUn9pefHyclM3
	 gxcr5wnL+/wLFSHEWMGikF6BXhnMQOGOASPCU8N2osG6UpGRPJzQHHytmm5yjHDQysQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AxBEepq/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E1E60A260B;
	Wed, 18 Nov 2026 23:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxBEepq/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B591F000C8;
	Wed, 18 Nov 2026 23:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045555;
	bh=aHX/qwAP3Mi9+qLj/QJ6UTzThDa1/hM0O4E4NuQnUa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxBEepq/mvcbVhiX9MyF5Q7Lwqfb3j+8asV+JmuwnkDKW2EKhiC3+MUpU4SwFiXzf
	 qUb/aJm/vqHbWO5PfYHd+4Qws8++p2jpt1GxjRnOHIeupQeKDIoMB2qJudPtlLulwL
	 zrHY13g2F/DPz7H5mM7AWmG5R0nWfUjUuiTG7qvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0965/2857] mfd: tps65217: Fix NULL pointer dereference on IRQ init failure
Date: Wed, 18 Nov 2026 15:33:19 +0100
Message-ID: <20261118150236.352676489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 0473a5b0663663b75573bf284beb77459e07c461 ]

tps65217_probe() ignores the return value of tps65217_irq_init(), so
when the irq domain creation fails the probe still completes and the
driver ends up bound with a NULL tps->irq_domain. Unloading the
module then makes tps65217_remove() call irq_domain_remove() on the
NULL pointer and oops the kernel. On top of that, irq_find_mapping()
may fall back to the default irq domain and dispose of mappings that
belong to other interrupt controllers.

Check the return value and abort the probe on failure so the error
is reported and no inconsistent state is left for removal.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20261002113624.178588-2-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index eebd60601b01d..35fb732358dcb 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -334,7 +334,9 @@ static int tps65217_probe(struct i2c_client *client)
 	}
 
 	if (client->irq) {
-		tps65217_irq_init(tps, client->irq);
+		ret = tps65217_irq_init(tps, client->irq);
+		if (ret)
+			return ret;
 	} else {
 		int i;
 
-- 
2.53.0



