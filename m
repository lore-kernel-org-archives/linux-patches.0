Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D4B13D896;
	Tue, 23 Jul 2024 18:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760178; cv=none; b=XFuSAQkjoEU1Z0Gew33LNGE7BCOcP1qWtQS3lKUqi4vXca8fuCwhjO/42gPS8eeb1H957tblD8KXIf6oBqZEf/5p4aLJZBCvzz8cKGiYh14p1aeDlB8FDzXgpyYx8VWkNbk/x80JIKsFPta+a3rZkRP/YgZr+uGrQ6I8GQgUuXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760178; c=relaxed/simple;
	bh=js9362GxM1g7OGNHkT6w/U2nutVMwTjNI8lr2u9mXow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NulgoLsBiA1bH73KwOa9F+2NPKqN0t2U3X4rfRsrjW5N/a4LjMyEofXvTElLaTq1B1SGygN82f+psj/osEHtWhpd5fx8RRWmjgranzehL9fSIVkZJCMT+PuEFjDNR+ScyOlHdoW8tbPp6H+UdTx7gRr3Z0r0BJcrxBWln3xS2gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgMB/4ly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgMB/4ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3A4C4AF0A;
	Tue, 23 Jul 2024 18:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760178;
	bh=js9362GxM1g7OGNHkT6w/U2nutVMwTjNI8lr2u9mXow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgMB/4lyOmxElrDezXmqaFdn9AnA1scDBQQVW92Dzc6oiiXIc2OCLT6dvk+SVScva
	 eY0eDJXb9w8PbpcE+uR7+tFGOB0ct9/04QU5aznKZc7zF8xHQZpn3wyckPza9S75bl
	 HSqeElZ4v/yqKa+C2PeTxrXqF7ogFSxYmOVHFdy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ming-jen.chang" <ming-jen.chang@mediatek.com>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 128/163] tee: optee: ffa: Fix missing-field-initializers warning
Date: Tue, 23 Jul 2024 20:24:17 +0200
Message-ID: <20240723180148.418333178@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>

[ Upstream commit e0556255a53d6d3d406a28362dffd972018a997c ]

The 'missing-field-initializers' warning was reported
when building with W=2.
This patch use designated initializers for
'struct ffa_send_direct_data' to suppress the warning
and clarify the initialization intent.

Signed-off-by: ming-jen.chang <ming-jen.chang@mediatek.com>
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index ecb5eb079408e..c5a3e25c55dab 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -660,7 +660,9 @@ static bool optee_ffa_api_is_compatbile(struct ffa_device *ffa_dev,
 					const struct ffa_ops *ops)
 {
 	const struct ffa_msg_ops *msg_ops = ops->msg_ops;
-	struct ffa_send_direct_data data = { OPTEE_FFA_GET_API_VERSION };
+	struct ffa_send_direct_data data = {
+		.data0 = OPTEE_FFA_GET_API_VERSION,
+	};
 	int rc;
 
 	msg_ops->mode_32bit_set(ffa_dev);
@@ -677,7 +679,9 @@ static bool optee_ffa_api_is_compatbile(struct ffa_device *ffa_dev,
 		return false;
 	}
 
-	data = (struct ffa_send_direct_data){ OPTEE_FFA_GET_OS_VERSION };
+	data = (struct ffa_send_direct_data){
+		.data0 = OPTEE_FFA_GET_OS_VERSION,
+	};
 	rc = msg_ops->sync_send_receive(ffa_dev, &data);
 	if (rc) {
 		pr_err("Unexpected error %d\n", rc);
@@ -698,7 +702,9 @@ static bool optee_ffa_exchange_caps(struct ffa_device *ffa_dev,
 				    unsigned int *rpc_param_count,
 				    unsigned int *max_notif_value)
 {
-	struct ffa_send_direct_data data = { OPTEE_FFA_EXCHANGE_CAPABILITIES };
+	struct ffa_send_direct_data data = {
+		.data0 = OPTEE_FFA_EXCHANGE_CAPABILITIES,
+	};
 	int rc;
 
 	rc = ops->msg_ops->sync_send_receive(ffa_dev, &data);
-- 
2.43.0



