Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829708;
	b=SLcLYjcQu/LQluBs0VCZZ8v3++5mTjQYp+WhIj2zwgIw21VolqySJEqNMq72QsoPPl84
	 v+CLX8RXCHJ/WyVN0Fz6gyDFSqTt5V+wOf4+oVF2s8ZkpG9mCjPWEL3ZdkhsInqYBxETX
	 kfVBeUrE0G+82bwlCr165HnpXxsQBYlTI8Rpk2zO5mYE64h79jURhbh7gD1JLY7IvysWy
	 n/B5wHuyts9WmIV3DDVXE2hqI529f35J2RbMlAhTcNPfEXoOwBhaUu5Y1+E6v41H2rxMB
	 UnR1rWGIBX5rvZ8uX/UzwNScsI6EGk/moFU9lH07XL/T6os3jrfyJZk35/egW0tunJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KL6MZakt0hQOonDU0X5JnT8kBiGg5Qr5u0I5yGAQfG8=;
	b=UILIfro36ivyLf6TSQmP5zDZHSSHGbVJHyBgSc2SKhrt+jPNwOP008ZWpLy+/sxcGmOj
	 tv8bcJr56C1za9z8uKxZM6Ta3alVeXRtM2zuAES1CcCuBaEsAijIlkwEpz2jDA6aUIe4H
	 PMz1ai/1a5FMqqzavMxNm0A9LWv0N/whLS6EBFgwlkljbraY++Uwtu6TXbTKrraEMONqm
	 QqriwX+hc5Nh4/BMfEdfuxS1W/c36SimD6oFQOA02MxsZ20uSzZWb8ZdN+pTks3DSq4fF
	 AKXuuaOBfjH4Ba3ti82kfTTf9upH29SSn7Qp1qWxTg08jSO7Zin6QsK+bySu0EQ8DPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frwF0i1e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DC606C5A3;
	Wed,  4 Nov 2026 22:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frwF0i1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D6E1F00919;
	Wed,  4 Nov 2026 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829708;
	bh=KL6MZakt0hQOonDU0X5JnT8kBiGg5Qr5u0I5yGAQfG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frwF0i1eWvfRI5cys51ySOsjISZZH9VdUtsJ8NDVukPa9wgxz0dZZ0wYfwB3BN00c
	 VG8iFP+UDQGhcGF5Bom24c129F3POhVFB/wd1CozYNAQBDYXzliEFEiptHPq7LcqT6
	 fNQIeTR5ktUiqly6AcETiz9cd/NmUxtUHulTLk54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0292/1005] nvmem: brcm_nvram: reject empty NVRAM partition
Date: Wed,  4 Nov 2026 16:00:25 -0500
Message-ID: <20261104211052.092478527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index b4cf245fb2467..4b3781a70222a 100644
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



