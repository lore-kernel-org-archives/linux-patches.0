Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD47156F29;
	Tue, 23 Jul 2024 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759338; cv=none; b=KyG5pIqJaJtiLq7sPU3YZ6kFYMNbHI2Mt4A/J1baXFnyY6pPtLfh4GVsAmBIsrcMfSN0G13SzV5/aiLui7MP8+HJwd1nAgP0nENueY0OV0+I6kGzIghxIDjgCZzhunuuj6JFkOS5z7EAktdt7QDKODKz2vQV14EOu/WxJmsi7+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759338; c=relaxed/simple;
	bh=WJZeQD1biii3DzzOHHJG5z21DqWDmTHFEYDKVK4fEVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBgpErnennidY7TefHOCF4HSltcIctk8Rio1IopKiaUk91HTSO+fbckbWaF628a9PGwWG63nD7Ph8r6P68vIqpIUAY5FZT+uuxlHqjahOP2W8pZWLl3VnmXk2HpmfPXYR5P8BfueMFbq6EJ+DLAHBy/tPO7KpWW61QfYPwOa/LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBpVeWu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBpVeWu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037DCC4AF0A;
	Tue, 23 Jul 2024 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759338;
	bh=WJZeQD1biii3DzzOHHJG5z21DqWDmTHFEYDKVK4fEVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBpVeWu/sywuNO3krHUxsNZi89yQTAFt0h2ALae+XyjPbZTFi4svtFXQAHnPCOwuz
	 MgbKQ6GzjOJo57rVpzF/duzrfk11tCBC1eJ/jmVqdW6jO8XC+NyURcbPwxCC+xdQvS
	 ScwnkUsjgoX/9QamWbxGH7h/jd+Xo87I+qBzZ41Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ming-jen.chang" <ming-jen.chang@mediatek.com>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/105] tee: optee: ffa: Fix missing-field-initializers warning
Date: Tue, 23 Jul 2024 20:23:59 +0200
Message-ID: <20240723180406.404855836@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



