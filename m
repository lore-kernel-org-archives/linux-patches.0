Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033962;
	b=yGgPN0VN/5Obp6PMgL2y/NuZlGjWcRF6WpkH4Dk3Tcdcf0NBMhMCbH//F5asBMMcklKQ
	 rn6Vcqx6sO6dAjSQv4W3odD49NXRPG2v8aFEaOp02CBMnidiPrboBcS6FQ9Kh3EfUD643
	 unLohBeSWyMAt5fVIiKNA+cYkS1fbMNMYphRL+cXsBd52ROL4iUEXXU2odUWD4x9mf3l7
	 cHp51au63VIgLoVyXsu2wsva4AoYxBv86W9tEh0pwV1MOd3zFrEeTAgeKoar3uRILl2dV
	 uxAe6Sgxn+Ij5B2ohz8VYTea5YiYzbxugBzd5+slbncVzJ2zbWvcRSmv8p0JZIO7MGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cY2PQKbPVykbpRZJGHQOj/jqXpHGGl2wELLn0Sc4CBY=;
	b=qrcx+x92YPDOLWPKPVoJKycWFjx3UEQom9u0wReKA62XGh0Zc6pC6Sg+fydlJyT77GHY
	 BRwor6kj7y5CBRTT2aV6B/LchGHPZZ5Kv5fknawQvZkdCE3FkCXiese0KzVeSrkWtTpuc
	 lASQHGYE+DmOugR0mrleRerz19pMz8xfVL2NKLMouHQakpQAxHBclPMyfMvdPp6TTQ1Xl
	 NEVTH/W6LiNREe5CL+h/4mmiKCdwYN/R7K9MkIYh7hbxZOBF39/a/sGKPVVwOhKrAMMOw
	 CdGAtxprh4TVp4McEYxzWkoCOKjb7+2xiB1bnAFrz7uuXqXOgMdgr2DS6ilP1+T9Qmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m88P6sTZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8202A606A333;
	Wed, 18 Nov 2026 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m88P6sTZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB42F1F000C5;
	Wed, 18 Nov 2026 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033962;
	bh=cY2PQKbPVykbpRZJGHQOj/jqXpHGGl2wELLn0Sc4CBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m88P6sTZCRBzKObZtJEZmCj3eevb/p3+KTd7dvE560Lham9Cg9a3628+dB3hPL4Vs
	 n1UxSHASL+SBihdS5sIdIWWgALnHozYL4XNLg6Elmsq/90lXlJ/TSI6xj1P9rrox4o
	 Ld7VuudeoOUb5PgAB2NdgjZT+ttoZkcEaV03CZSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0199/3318] nvmem: brcm_nvram: reject empty NVRAM partition
Date: Wed, 18 Nov 2026 15:13:41 +0100
Message-ID: <20261118150320.819451160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit fde46579cf8872138b296349c2bd8a3cd3f132e2 ]

If the partition is completely erased (all padding bytes), the trimming
loop reduces data_len to 0. devm_kzalloc(dev, 0, GFP_KERNEL) returns
ZERO_SIZE_PTR ((void *)16), which is non-NULL and bypasses the NULL
check. The subsequent cast of priv->data to struct brcm_nvram_header *
and dereference of header->magic causes a page fault on address 0x10.

Reject data_len smaller than the header before allocating.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260729094647.111468-13-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/brcm_nvram.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 5cdf339cfbec0..fe663f5fca9ca 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -84,6 +84,11 @@ static int brcm_nvram_copy_data(struct brcm_nvram *priv, struct platform_device
 	}
 	WARN(priv->data_len > SZ_128K, "Unexpected (big) NVRAM size: %zu B\n", priv->data_len);
 
+	if (priv->data_len < sizeof(struct brcm_nvram_header)) {
+		dev_err(priv->dev, "NVRAM data too small (%zu)\n", priv->data_len);
+		return -EINVAL;
+	}
+
 	priv->data = devm_kzalloc(priv->dev, priv->data_len, GFP_KERNEL);
 	if (!priv->data)
 		return -ENOMEM;
-- 
2.53.0



