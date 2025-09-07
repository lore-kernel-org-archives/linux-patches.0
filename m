Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC58B17BB21;
	Sun,  7 Sep 2025 20:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276883; cv=none; b=YMxdIdnjJvnkX+M186n64RXQNblTmlvxjkjUoeLZPGnkKprjTfPdRPPcBs8g3J/dqrXk6Y1Z1A6rLZsEfnOnp2rs9lvW4nqkGtUVRrZnfghbi1Ee6jCHOZHED8TiY2lRbHv6P83gGGyU8ZTvrUPzx6o6Ttw3jvvXUtbR7yWqSuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276883; c=relaxed/simple;
	bh=IVg7cLOTezMDMD1eL4RjCPfEJg3lNlNXGKoLLM/CAY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtbmFCx0O2XqBZkibPkk8z8QFzZsz2+mLHmHpLtHs6+0iZvQ/siC5WZ7jqrFQ3t0JvS/hHGGkhBvwflrO0eS6VEmJH1veEDNeUljObmN15qO5bruoWHWR7nipg7AJvFZHONBytpjGapzhAfiuX2tU0oVmnMbDtfCaRXDdiPpRo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycsLVCZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycsLVCZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E5EC4CEF0;
	Sun,  7 Sep 2025 20:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276883;
	bh=IVg7cLOTezMDMD1eL4RjCPfEJg3lNlNXGKoLLM/CAY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycsLVCZ8XQFJRimmcoRGNFTbhh8z1Ed1FOa6Gw2MwvZdvSLZwgKVLAVTecnzgolVE
	 kZMC/jwq9f5bgiAFanQ4xEzIzhmqiFvthR7tf9e1fBy16Zg076VEpJHeTy2l8lZ1g1
	 tsESZbpIMEVgCNHki4DCxoXsf+qX1VRIECASPd+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungbae Yoo <sungbaey@nvidia.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/175] tee: optee: ffa: fix a typo of "optee_ffa_api_is_compatible"
Date: Sun,  7 Sep 2025 21:56:54 +0200
Message-ID: <20250907195615.340115299@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungbae Yoo <sungbaey@nvidia.com>

[ Upstream commit 75dbd4304afe574fcfc4118a5b78776a9f48fdc4 ]

Fixes optee_ffa_api_is_compatbile() to optee_ffa_api_is_compatible()
because compatbile is a typo of compatible.

Fixes: 4615e5a34b95 ("optee: add FF-A support")
Signed-off-by: Sungbae Yoo <sungbaey@nvidia.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index f9ef7d94cebd7..a963eed70c1d4 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -657,7 +657,7 @@ static int optee_ffa_do_call_with_arg(struct tee_context *ctx,
  * with a matching configuration.
  */
 
-static bool optee_ffa_api_is_compatbile(struct ffa_device *ffa_dev,
+static bool optee_ffa_api_is_compatible(struct ffa_device *ffa_dev,
 					const struct ffa_ops *ops)
 {
 	const struct ffa_msg_ops *msg_ops = ops->msg_ops;
@@ -908,7 +908,7 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 	ffa_ops = ffa_dev->ops;
 	notif_ops = ffa_ops->notifier_ops;
 
-	if (!optee_ffa_api_is_compatbile(ffa_dev, ffa_ops))
+	if (!optee_ffa_api_is_compatible(ffa_dev, ffa_ops))
 		return -EINVAL;
 
 	if (!optee_ffa_exchange_caps(ffa_dev, ffa_ops, &sec_caps,
-- 
2.50.1



