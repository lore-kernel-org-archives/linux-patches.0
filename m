Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5847D317148;
	Mon, 13 Apr 2026 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099081; cv=none; b=JIerV0Ff3n2trtd007wYf2uehupCJtpaCphfs2YCPLqnWHwvISsdKEHAYKluCLEwR9EFwGyj3S3SQHTjZZcKeqHJOvdJcTYABw3XDYE0daSEcXBtSyKJZ0frRaEslv6l1lPU9jxK7dO+qGJMMBLJwH4MDYnlimkDqidsklXiODQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099081; c=relaxed/simple;
	bh=y8wpYegcc0xvc9zA2cgy017wxhsAA3Ch75TRMMlRnVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG+H65GlzElj1eoH0xCk7HMAZmr39ehgocLMo8ZL4aCBntw7YIjz3LctgBy1aH3guZe8u0UmKptWNoVUZ+aiknhColv/nb6kxXciFOwc6U0Ua+0fFJLKM+8oYpgv3mnjXtQJ+ZbNQcN83IB5siIfKDOWlYfSFZ02I7ZuBvQ7YnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibnzSGNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibnzSGNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921DAC2BCAF;
	Mon, 13 Apr 2026 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099080;
	bh=y8wpYegcc0xvc9zA2cgy017wxhsAA3Ch75TRMMlRnVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibnzSGNbTfBT+chznYvhkcEjBIGAm9VTiuKG2+RWEh+HUwcdz/eyQnhngLgZfqasP
	 l2lMwDvi4LPmKjN6JMbw5x2lwVhwJPvyn63hfXVRRZ2XnvMCNvaB5lNSLnsq7e4M4s
	 KL4SqPaQlcNBrrrdj19h7KgK+R2XKJo93LTr5rfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/491] Bluetooth: SMP: make SM/PER/KDU/BI-04-C happy
Date: Mon, 13 Apr 2026 17:57:27 +0200
Message-ID: <20260413155826.634536811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 0e4d4dcc1a6e82cc6f9abf32193558efa7e1613d ]

The last test step ("Test with Invalid public key X and Y, all set to
0") expects to get an "DHKEY check failed" instead of "unspecified".

Fixes: 6d19628f539f ("Bluetooth: SMP: Fail if remote and local public keys are identical")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 79550d115364e..0871dca1ceac9 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2738,7 +2738,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (!test_bit(SMP_FLAG_DEBUG_KEY, &smp->flags) &&
 	    !crypto_memneq(key, smp->local_pk, 64)) {
 		bt_dev_err(hdev, "Remote and local public keys are identical");
-		return SMP_UNSPECIFIED;
+		return SMP_DHKEY_CHECK_FAILED;
 	}
 
 	memcpy(smp->remote_pk, key, 64);
-- 
2.51.0



