Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD0F6280B;
	Tue, 23 Jan 2024 00:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971148; cv=none; b=TyVZUg4jS2NYQJX25/PY14zf/cXIVJC5BwoAoLJRDRBrytiej2djcshOt6PuOKHXYRA+shRUdsQjBe58HZ68cGMQpfcTOguLlUAgmiIBPIukFbl3cderhktifu//V25cB26EKls0Zk20gngXdAmRI92TqsAkcl1w+LlchiskOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971148; c=relaxed/simple;
	bh=GtAo4309ZWeBWBrshP6ezGI0uZR1vlrKmwa1jospWyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1RWwt8AVLpJ4KVxgfg25vsMww521hDM08N3EnQQ4OOAfmwStfgSOu04j1m4SHgwULc0duT000/2/3IPY+YmoZ9AkTGkZ4Qivt3xN8L9hW/8AiRCeAG3wSJSqiC6JbQykmLlwcdX4b6tcDAYTkPDO9at6UmWqo4EbYia7V1xltM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZkkfcnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZkkfcnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082CBC433F1;
	Tue, 23 Jan 2024 00:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971148;
	bh=GtAo4309ZWeBWBrshP6ezGI0uZR1vlrKmwa1jospWyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZkkfcnOfFhrSU4ShNWTo/JuMXKgpPA8VuSzYsqxGe4NUmlu085dhE0za5dc+rYZG
	 MLbfmPCeSJ036H5cKXLFa7nzEZvgY92p2IJJVjiZQ7qjgyqwQ0garz9TQRl1jaxN5G
	 IRB1BotGT+BleagHC965vBV9UDjpCBrt9rtEtT+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/286] virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
Date: Mon, 22 Jan 2024 15:56:23 -0800
Message-ID: <20240122235735.001277733@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit 13d640a3e9a3ac7ec694843d3d3b785e85fb8cb8 ]

Base on the lastest virtio crypto spec, define VIRTIO_CRYPTO_NOSPC.

Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Link: https://lore.kernel.org/r/20220302033917.1295334-2-pizhenwei@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/virtio_crypto.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_crypto.h b/include/uapi/linux/virtio_crypto.h
index a03932f10565..1166a49084b0 100644
--- a/include/uapi/linux/virtio_crypto.h
+++ b/include/uapi/linux/virtio_crypto.h
@@ -408,6 +408,7 @@ struct virtio_crypto_op_data_req {
 #define VIRTIO_CRYPTO_BADMSG    2
 #define VIRTIO_CRYPTO_NOTSUPP   3
 #define VIRTIO_CRYPTO_INVSESS   4 /* Invalid session id */
+#define VIRTIO_CRYPTO_NOSPC     5 /* no free session ID */
 
 /* The accelerator hardware is ready */
 #define VIRTIO_CRYPTO_S_HW_READY  (1 << 0)
-- 
2.43.0



