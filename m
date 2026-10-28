Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212624;
	b=rAKsU6dsd5WwMHl+VUKBfUVqFuIZbZqR8Lm7YY1FayoSjNhgCe68mx2npqRNdZM4sTV2
	 Zg5B04lx+AUzhL50lEhQ7Wma8c7+H5UZst2p2DMNb9h2mRk9xC3bMBMf+HAc13okUjECc
	 hGyexRpxpnuCYg4gnsrJB7ZFlg0Pkm33gaUPGv957My0sl1SIby58QsaWQS/EpsGXbPt4
	 jbznmkEMdSuJMKewVTeTKEld6QAm7xjhlQlTNwYzsI20CyWWpV0JXJEbsDbXVkc+diNnS
	 sGIczbDfeHZjKKNfC3dzeXnBQFHUyfxbX7Z0nYjAAKI5Z4jnCnS2LCwUJOpqyrwGBGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ztxcXFe4zIVtQHuE8AfO2z5LRJuc1TXj3GJ0tUV6mmI=;
	b=m8KY5eLVP27i0SZcV6OFfhFs62g9lv67j3qy3AQEr2/23kuO1U9islYk4tf0Ib5Yvdim
	 b41cGFXqsn3Z4geE/1XTIhKuEPcIkZGjmuF2DLVSoAZUfBv/XNRXUU0QY31ppIeEVEYqk
	 PfxE4xqG3se26mlSu4e3Jin6UGTOuD7DVBFwv+4vtQvtKYpj8treEc4Wz7r2g1CdDfOAv
	 0nJ+EWB4kmRwDSkZEQ8LLih0dhEnq2M8MkYlpEXe88mSCbv49QwaHB8BZtr/PGpskd3lT
	 upZM1wn2aFBZt18kNmzQcAxByiUmi92gfUj9Dl0jJ8iwdNX7jG9kFGfV8nfMwpaR0wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PCzkifae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152F3606A31A;
	Wed, 28 Oct 2026 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PCzkifae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208EE1F01825;
	Wed, 28 Oct 2026 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212623;
	bh=ztxcXFe4zIVtQHuE8AfO2z5LRJuc1TXj3GJ0tUV6mmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCzkifae76G4mnTUh7LZjJq+xLxLStxeJuTO9WviERJu8sf9q7wEALH0zy9pyI233
	 jL/sCxhk1E/ntZlwa+CTJreWoe1rZhMBlvddp63QG6Ganrl15MbfgfAUZqkiqPAb4+
	 jFCStbYSHofM/pGGd6n5/veL8qDdAoAfbXtl1SUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0220/1887] wifi: wfx: validate MIB read length before copying to caller
Date: Wed, 28 Oct 2026 17:38:36 +0100
Message-ID: <20261028170504.239070499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit ce67ebe9d8629776ce38e6995ae72fb903c828db ]

wfx_hif_read_mib() copies reply->length bytes from the firmware
response into the caller-provided buffer without checking that
reply->length does not exceed val_len. A firmware response with
a length field larger than expected overruns the caller buffer and
reads past the end of the reply allocation.

Replace the dead -ENOMEM check with an active validation that
reply->length fits within val_len before the memcpy.

Fixes: f95a29d40782 ("staging: wfx: add HIF commands helpers")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB000155034FC391A2A54B9803C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/hif_tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/silabs/wfx/hif_tx.c b/drivers/net/wireless/silabs/wfx/hif_tx.c
index 9402503fbde3c..852406fc7f3c6 100644
--- a/drivers/net/wireless/silabs/wfx/hif_tx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
@@ -189,9 +189,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id, void *val, si
 		dev_warn(wdev->dev, "%s: confirmation mismatch request\n", __func__);
 		ret = -EIO;
 	}
-	if (ret == -ENOMEM)
+	if (!ret && le16_to_cpu(reply->length) > val_len) {
 		dev_err(wdev->dev, "buffer is too small to receive %s (%zu < %d)\n",
 			wfx_get_mib_name(mib_id), val_len, le16_to_cpu(reply->length));
+		ret = -EIO;
+	}
 	if (!ret)
 		memcpy(val, &reply->mib_data, le16_to_cpu(reply->length));
 	else
-- 
2.53.0



