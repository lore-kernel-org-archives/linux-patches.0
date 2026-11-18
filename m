Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016353;
	b=4XJYED0NjXT/dHWSkXGWz/b6Z86xuh1ywFU92vJatDQLeZUHa+AJmUlNoziiBkDHYQ+e
	 EEvX1zGCwZYqsXAqDEvApIp+XETCwNYdFAnf32RiMRxua61i0eRh12Vv3/6xGy3T7oEpV
	 xB4CaeNOuvh88I6Fq+xQSEeuHOVgClmOhGmMh1mg1DJ7ABktOPADCOAUppSPDoAbJtDoc
	 AO8cw5COly45Q0RzqpCImFGt3ICyjbaO10JVSyQ/PcgKAX2dTNa8aTsFzr8BW9sa5/SPc
	 zg0aArgEEYJ+iWWZlP71zVjlotbTL8Cbg2bY6ECc/g/TqujxIt7nP7ZqAOTnPhziiPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wSf2ALq2pc6b2LyvOALsQVsIG/91c/TevBuSsERWvxk=;
	b=4PBTcJu3HzCxPQIvIWvoNZezkH/5U9Y9bZrFzBKt7Q5IPd5HIO0g6n9CNBKGlE/Zrdl7
	 u4jxvTuqgXr8K/0X9U2wyomS8nUGh0O9OmXvxSjbhLBnaeBfazMiRciu+OEkPva+RIqXp
	 bLNC14fD2WGinTOuFuIoU/ibMLIxS8UUiakY0+Fx8Iu/mUu5lJNvU4rYKvLUh3qjVq5qF
	 KDuDCof2w49FiqWfg05Hd2lzsZfAJnl4uvIvyx99SY3B6cFAa7CKEBTVJzQG/7WS0c4ZR
	 qWp3g7S4IVO0LLO6/EhwXeT5UlE7KdtQms9W5tCxgtsI+MT8Z6MaCcj1CtClpqI/Bmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JldU+v4d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B7B60A260F;
	Wed, 18 Nov 2026 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JldU+v4d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5201F000C4;
	Wed, 18 Nov 2026 15:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016353;
	bh=wSf2ALq2pc6b2LyvOALsQVsIG/91c/TevBuSsERWvxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JldU+v4dppeo9q/7fNbUlvsb25eVQFf1iZhMQm8mNJsCuQ07uF+zJXY+pn6zctMyl
	 Vg11toc4zr22XrtXcMfvguMNjeQgRu3GxttX3yzzgU9mfr6HVCrzyry0+L02hyW4cn
	 D/4S3tk6YcbPNNIEkWqmNeLKtgkyUpmGywSVbFYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0472/2651] memory: emif: fix device_node reference leak on np_ddr
Date: Wed, 18 Nov 2026 15:28:32 +0100
Message-ID: <20261118150304.781786646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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



