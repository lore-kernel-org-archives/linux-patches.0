Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620668;
	b=KcSrXuRRanJCujgfvWvOnJpyqtNV52fxakJzRHoDu3eUt3FTELDWyrEB2CYppnLzcaJg
	 g7nsoYmsOhQlz5muHAPz/hdgmlZQkAnxPeoUgdmgaV8dWiXL+TCr1gZJNJsS96eHPO08Q
	 29ctK54vBzAIf0NdBWW93XEvouG7MlwSKyAlHDXE6Y0Zoa7BdpKLIVKdoW6ghSrQiLCi+
	 BPrSrpc9cKpzSPKwksS6hsTEjRrCC0gw3vO6bicN9H1s8/s/CgOExubD0lRc14DUnQ3EA
	 +fyVfs57V7MCSZGLNeZpoI60Khv8AJGm9e9/ldsTzQ8o8qQ6aPWwdtyP6XsdiO+KYXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mltg2QSFjXgKtvLKBZmoxCGlXolHCsx7SnHaB4pKCU=;
	b=Uh34xVy7fpIvAsbs0kCYHQaL35Rsk+OoEMVpb4fYzfDY6sZJz/wBmFDOIKPoSf1d8ORJ
	 mKvtDbGV2tLHlpmuPVEofAo1b9B0wpGvscyahRC/SWMEnlZ95eq1KNshH8lWEBV8mnmQ8
	 gs0RtpMBokUDpbHjPWuaS5xBOjbRnsIcWj5SFpyl6bfPtwhNVTY7wzHBKfqXf/LhD4M49
	 oQ40889VYLbVIaxR4clz6qpCOx+Mrl2Tuhb6zsLP4G5uYUjXxkUfzntH7oRIsLzVwDLkF
	 TdQLBEJO1xFvCiMpWxR0+NgOLbyt4kkNPBRACsscwVr50gCgUMIyP38yD1HH7dcsMrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giddYZ2I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15B7606A323;
	Wed, 25 Nov 2026 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giddYZ2I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9B41F000C4;
	Wed, 25 Nov 2026 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620668;
	bh=9mltg2QSFjXgKtvLKBZmoxCGlXolHCsx7SnHaB4pKCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giddYZ2Ic87OUdNj22g9IiIaDby6tBsm7Rc1lXzUgEV7aj9rQnKxPfRUCfKuV584g
	 ctS++NvGUETDjiXgmsk8xP0DoCrQR2X+hHETBTvaIyFCwy5bxnfoUBkRJkDWxgi1h3
	 TSTtuJer7odQXJK4Yh/D7liaolFMuXjrC6sNTlZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0995/1005] iio: trigger: Return an error when the trigger has no free irq
Date: Wed, 25 Nov 2026 15:38:53 +0100
Message-ID: <20261125143844.960213184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit dff701806ab6252f6a0fccba880c47cd09602625 upstream.

iio_trigger_attach_poll_func() prints an error when all
CONFIG_IIO_CONSUMERS_PER_TRIGGER irqs of the trigger are in use, but
returns 0. The buffer of the extra consumer is enabled without a poll
function.

Disabling that buffer calls clear_bit() with a negative bit number and
drops a module reference for the second time. On arm and arm64 the
clear_bit() goes about 512 MB past the pool bitmap. That is an oops if
the address is not mapped, and a bit cleared in unrelated memory if it
is.

Return the error from iio_trigger_get_irq().

Fixes: 995438233579 ("iio: Fix error handling in iio_trigger_attach_poll_func")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -292,6 +292,7 @@ int iio_trigger_attach_poll_func(struct
 	if (pf->irq < 0) {
 		pr_err("Could not find an available irq for trigger %s, CONFIG_IIO_CONSUMERS_PER_TRIGGER=%d limit might be exceeded\n",
 			trig->name, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+		ret = pf->irq;
 		goto out_put_module;
 	}
 


