Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048C41586CB;
	Tue, 23 Jul 2024 18:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759790; cv=none; b=tdzeZb4goZ/3/9mUar26GMWdslZdynLrKeWuX7LwGlaLVlTbXOSVbLEr9OHAQq7Sf6oG60PbDmy3KPU/cIEtk8aWOwY85tNi4UxQG2WrzhVnqxTXSLMHhWw1wUlH9gxzk4yxwQJb/x2gdiPBnUIcUNw2eOFcS+ZM8DC4wUbSWRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759790; c=relaxed/simple;
	bh=xMcfVUjrZRL1M8hP+DTBnrxNiV1UaUe1yoa0JJk8dDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGdLY/RJhADTPbjkOvfOgNzqny6URaToXJYhr3aDNMuC9d6+yO/gHnekH9LI0aQxoUdc2vTFt8EjNJJWR8Fc2I4BNKH2DMeLWH2vbUGoJfSrXTZZEmX/OT9QvNoEOQ2qUZYxuygXPOVN02Xcgxtukwa95/PBQU2SQtABpCv4Sfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCjq1CsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCjq1CsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F53C4AF0A;
	Tue, 23 Jul 2024 18:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759789;
	bh=xMcfVUjrZRL1M8hP+DTBnrxNiV1UaUe1yoa0JJk8dDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCjq1CsDHESLG7jVYebEP0h5I9oeaMya9KHwByABnfx9p5rjL8NYpTqaI5/5Blxkb
	 0jX1ubO3/Qm5o2ZFFcVEYxiHBe5CiULED6pFeHhhUGTVgS+GO79eEmv9MqJoSWC7sI
	 4sVzRP+Sua11rHQTHD+GGck7umDskd8WG4r8iLAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ming-jen.chang" <ming-jen.chang@mediatek.com>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/129] tee: optee: ffa: Fix missing-field-initializers warning
Date: Tue, 23 Jul 2024 20:24:05 +0200
Message-ID: <20240723180408.536566322@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index 0828240f27e62..b8ba360e863ed 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -657,7 +657,9 @@ static bool optee_ffa_api_is_compatbile(struct ffa_device *ffa_dev,
 					const struct ffa_ops *ops)
 {
 	const struct ffa_msg_ops *msg_ops = ops->msg_ops;
-	struct ffa_send_direct_data data = { OPTEE_FFA_GET_API_VERSION };
+	struct ffa_send_direct_data data = {
+		.data0 = OPTEE_FFA_GET_API_VERSION,
+	};
 	int rc;
 
 	msg_ops->mode_32bit_set(ffa_dev);
@@ -674,7 +676,9 @@ static bool optee_ffa_api_is_compatbile(struct ffa_device *ffa_dev,
 		return false;
 	}
 
-	data = (struct ffa_send_direct_data){ OPTEE_FFA_GET_OS_VERSION };
+	data = (struct ffa_send_direct_data){
+		.data0 = OPTEE_FFA_GET_OS_VERSION,
+	};
 	rc = msg_ops->sync_send_receive(ffa_dev, &data);
 	if (rc) {
 		pr_err("Unexpected error %d\n", rc);
@@ -694,7 +698,9 @@ static bool optee_ffa_exchange_caps(struct ffa_device *ffa_dev,
 				    u32 *sec_caps,
 				    unsigned int *rpc_param_count)
 {
-	struct ffa_send_direct_data data = { OPTEE_FFA_EXCHANGE_CAPABILITIES };
+	struct ffa_send_direct_data data = {
+		.data0 = OPTEE_FFA_EXCHANGE_CAPABILITIES,
+	};
 	int rc;
 
 	rc = ops->msg_ops->sync_send_receive(ffa_dev, &data);
-- 
2.43.0



