Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019357;
	b=dz0d192aEyvdYXuvxb6wQrUqs6I7rT2IcVOjqBY3m1MjPsHlp/ENcpOvZKcXXwW7uLma
	 JX926lpACcD8zJGVNcU4NY2fvESGgD1O7rgsVZoppv8ZKwwpyJp7NVdrS8/Xhat3YjxqB
	 LboVqtu01fQ7Q7IcvOrhF5IrcAupbKAgu28shN8GfYz4GK3brzHrHOtHKC2k4zkBjkThD
	 SDXj5obuomOrk/BKHQuXqIDlVzKqlmFk0JVhLYqCI9t5m0u54BKXuozQeXRJA5Ik+eZQ0
	 tmgD4mJkJJn0aSjrKOtxnEhGgkwDOnWonp1SaJqNpRGvGuvU5Y3NmSfrhvBeHEqOd7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M7NMaduMdhMBMebJ3PIVbP0Obi+qT6N/M5OKbxIlu+Q=;
	b=swZzkmRIjYJuQAGZxbWM3XnQSUf6l8tuJODBgzmqb1mr33mMMdGgm9su1IO8OO4Wyumm
	 8R4pLitUkY9gIIg2jZFMru/JU1ACE3d2B4tVxRl3w61K6gDnzkvHox6fK5Ok3Y9FytcAQ
	 Kj8koXESsg6hxJlG968+86tPIOM83+ig2ezGogFcETtWjPpdZAojCM9myZiUj48J2yk5t
	 IFT/em3JNFJBQr8rFxDHE9vA9TVa90ojdji80uUYXUkK+JZPneC30MzjnBK0Bmaxl8g5C
	 o2N1UpmJtISWVxPHFqfgjFcbbdpEZH7NCHEn6b8p09mY/SdX/hgOhckJ7mON1LmjurQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Ae7Cksv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7A5606A31C;
	Wed, 18 Nov 2026 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Ae7Cksv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391A31F000C5;
	Wed, 18 Nov 2026 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019357;
	bh=M7NMaduMdhMBMebJ3PIVbP0Obi+qT6N/M5OKbxIlu+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Ae7CksvHXpnObKpGkJwXOHele8kmuca977UZdFsAGY1LoADsyaeKuuMGbcN3obvh
	 yhDyIJQ27suLRLg46thchwd72brfQD8/z7iaUQFxsOVebvhpafDgi/Db7yHDpco+yB
	 /rPYUIOTI2+e/XMZyU/V0bmkCFm2ZqF0S0Q00ygc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Cheng <leo-cheng@vip.qq.com>,
	Michael Walle <mwalle@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1565/2651] nvmem: layouts: onie-tlv: fix device_node reference leak in error path
Date: Wed, 18 Nov 2026 15:46:45 +0100
Message-ID: <20261118150344.289617677@linuxfoundation.org>
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

From: Leo Cheng <leo-cheng@vip.qq.com>

[ Upstream commit 9d44e80151dd360fad6155f36b6bfa57efb0f2f5 ]

onie_tlv_add_cells() takes a reference on the child node via
of_get_child_by_name() for each parsed TLV and passes it to
nvmem_add_one_cell() as cell.np. On success the created cell entry
adopts that reference and releases it later via of_node_put(); on
failure nvmem_add_one_cell() does not consume it, so the caller still
owns it, but the error path only puts layout before returning, leaking
the child node reference.

Put cell.np on the error path as well. of_node_put(NULL) is a no-op, so
this is safe even when of_get_child_by_name() returned NULL.

Fixes: d3c0d12f6474 ("nvmem: layouts: onie-tlv: Add new layout driver")
Signed-off-by: Leo Cheng <leo-cheng@vip.qq.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/layouts/onie-tlv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/layouts/onie-tlv.c b/drivers/nvmem/layouts/onie-tlv.c
index 8b0f3c1b8a0e9..4da3a704388e9 100644
--- a/drivers/nvmem/layouts/onie-tlv.c
+++ b/drivers/nvmem/layouts/onie-tlv.c
@@ -128,6 +128,7 @@ static int onie_tlv_add_cells(struct device *dev, struct nvmem_device *nvmem,
 
 		ret = nvmem_add_one_cell(nvmem, &cell);
 		if (ret) {
+			of_node_put(cell.np);
 			of_node_put(layout);
 			return ret;
 		}
-- 
2.53.0



