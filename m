Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023662;
	b=dvTgm4XoD1lYalOGCYmeNPGeMuR+gUXq+Mc2sAvxhiygcBwuP2jJKWXgElFe1sljlbfI
	 oYGtBwIY/NfpMfn8Zsz96IzS0mPYs4CjGnr/7qLu+iWoHCE+1Pa+GYRIzO8vpjEu5Ctq1
	 ZYfufe/WqiWIcU0CXjbnfS8T4Woj8LurMZhy5pnu8iiz6p7cvO2MsIx0wjanqpbMeFI1H
	 EoE3Lo1QjN3QOIijj6w1DK0Xrtthy3ovgNfIoKipLPqkJ1CizjMC1wdKThW9U6WfgyHmt
	 539wlBGzPz1JLAt/0uGi2p0wT9Pcm2RTL3pSQFMi356Rbh1wCk18hhV/rX53+KHrU7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P0/9y6maKDphM/lCUHlp1BKpvwl+kAotCml4nRJTX0o=;
	b=fv51sxwyi3FoF+sWJRrCvQTrBJ9UL+mJwjicnCaxwQiLF7k/sQ+YaMkUyeM3bbi6FZ2B
	 peucDAekFEQM48KHX+QeLL68L8Ss/fvVLxUu7GWZDpovwuGFFG0QM+wQe/JKvieNi8xxQ
	 8PkwgVvFw027zTdq8a1RXIB40+utxWEv/Uwz/Hg68zSkHOGkO3PvsQ5OVo2VOolk3LAWA
	 wvx7JpHK+EtmExQSLmVw9cRd+RETxtQUugzFIJICb31SbHGJlOLAotSSq+7hyXbhBnSIA
	 yD3VOmR1LLXiSNI6ihccta5DjFEb5kVHCsIDzDZfEIXOtLdDhNttTN9ZdXe+sevZt9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myB3lIYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DA2606A31C;
	Wed, 18 Nov 2026 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myB3lIYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A34D1F000C4;
	Wed, 18 Nov 2026 17:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023662;
	bh=P0/9y6maKDphM/lCUHlp1BKpvwl+kAotCml4nRJTX0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myB3lIYWRNbQA/3wZeqttZ6DJiStWOzylEsLWjV+WOVwXofWXrjBn8lq2nJHRNw3G
	 kH1U5shyxHTWKXSyGMqtuk7sl89fiUxIHbFIPPSsrVgoaLp9AOy+pAHv9OC/j/TNxO
	 x5yTi0VRD7pSUMGGWYKsvhpc0C+Wmpulvjcm5s3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0449/2151] memory: emif: fix device_node reference leak on np_ddr
Date: Wed, 18 Nov 2026 15:36:24 +0100
Message-ID: <20261118150138.390020811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miles Krause <mileskrause5200@gmail.com>

[ Upstream commit 314ef67d673284d4c070455bd62d332f6d0f8634 ]

of_get_memory_device_details() takes a reference on the DDR device
node via of_parse_phandle() and stores it in emif->np_ddr for later
use, but drops that reference without calling of_node_put() on two
error paths: the devm_kzalloc() allocation-failure check and the
is_dev_data_valid() check. Both return NULL immediately, leaking the
node reference each time either failure triggers.

The same reference is also never released on the success path: it is
kept for the life of the bound device (compared against a later
instance's np_ddr in the duplicate-DDR-geometry check) but
emif_remove() never calls of_node_put() on it, leaking it every time
an EMIF device unbinds. of_node_put() on a NULL pointer is a no-op, so
this is also safe for the non-DT get_device_details() path, where
np_ddr is left NULL by devm_kzalloc().

Fixes: e6b42eb6a66c ("memory: emif: add device tree support to emif driver")
Signed-off-by: Miles Krause <mileskrause5200@gmail.com>
Link: https://patch.msgid.link/20260909-master-v1-1-8800f5647ab2@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 2fadad0666b1f..44ccc25618354 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -922,6 +922,7 @@ static struct emif_data *of_get_memory_device_details(
 	if (!emif || !pd || !dev_info) {
 		dev_err(dev, "%s: Out of memory!!\n",
 			__func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 
@@ -946,6 +947,7 @@ static struct emif_data *of_get_memory_device_details(
 			pd->device_info->io_width, pd->phy_type, pd->ip_rev,
 			emif->dev)) {
 		dev_err(dev, "%s: invalid device data!!\n", __func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 	/*
@@ -1140,6 +1142,7 @@ static void emif_remove(struct platform_device *pdev)
 	struct emif_data *emif = platform_get_drvdata(pdev);
 
 	emif_debugfs_exit(emif);
+	of_node_put(emif->np_ddr);
 }
 
 static void emif_shutdown(struct platform_device *pdev)
-- 
2.53.0



