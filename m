Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032071;
	b=rS2SShoqI6C53/63ilfOmvkbNyhvCJ7jtNqiGaRg/SQ4hN8QEeua21UX4BlI7LXDMGh8
	 byayJTvYPK4o3D/AP//ovssl0Hm8/wqbINq/o4/7t8goyLYT82xwEU+Ii4egAsLNoiLLz
	 V25xqWr6zlka8EwGQZU6K2H7ipV7JHxB6v8NEnskZObtnvbFwwS7jJt3Wy6mbzoy5yO/9
	 ctmAwoQ1vsRj+VqOl84FnTbLssPO5CaEYEccn+tv+WSvc3J89dN8OdgmOi1Zmyq7Iqfje
	 pBPAMDZL8dd15LnB5p8YTvS1MV8G3PT3Z4o6OvDeF/3Kdz6bs/CH6DFgUP1Og9l4NBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uS1BLHar5v9/6p9WXf5io1RKMhvdDCOxgVMR+mxeDQ=;
	b=Wxos3rr67wmFso/rM1r+r43iV/4o4nmmkqom0QUBkRyqmghdgOktAtXkBwcgcO9HlJOA
	 VNpUf5VVKuZ7fK/1DdY5UFezX4awAWxZ2aI8I8fxLAyis5EsOK9pU32Jz+Pc1U1O2TOFH
	 M4dGjAaU0dmGk5tEyZc2OG8EXf+dghV5dCuzyhyPWBF92GQUHYM4oeWkOGUylSDnifJB+
	 xqY1po/xgNIOv5Y/fKLbJWmnxHyqEs7vzz+PPlR1ADt4h3Az/3rnt7FtkjZX3AbFQdfEB
	 cfVlQItmG0lBwSE5gBATEMnB2eP9RBZkzj/9vXno9yHB7c7MxXpRNwhIJi7WUfqd74g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuNL0ldU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826F860A2603;
	Wed, 18 Nov 2026 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuNL0ldU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D409E1F000C7;
	Wed, 18 Nov 2026 20:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032071;
	bh=4uS1BLHar5v9/6p9WXf5io1RKMhvdDCOxgVMR+mxeDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuNL0ldUZ03Us+VqizQP4jwlF5crBwlFT42l2xAt5dkZnXGl/v6D1LwPGnUioxW84
	 YiQXu7TkO3Sen0BfTzuXhaI4sTZzcK4z+UcTEu6IhG1XSSRJrr4Glwy4wy9KJVU7mk
	 VXMjneWLpjxjXQbQ436Jgro4ODsSlhv2c0xXAdAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1240/1756] Bluetooth: btintel: Zero version data before parsing TLVs
Date: Wed, 18 Nov 2026 15:56:07 +0100
Message-ID: <20261118150059.116339706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit cf87709d7ff83b4de5d42b61e4a9806fe374cb9d ]

Firmware may omit optional TLVs, leaving their corresponding fields
unset in the caller-supplied struct intel_version_tlv. Since the
structure is typically stack-allocated and not cleared beforehand,
fields for which no TLV is received retain uninitialized stack
memory. This stale data can be logged via btintel_version_info_tlv()
and copied back to the caller, leaking kernel stack contents.

Clear the structure in btintel_read_version_tlv() before parsing so
that fields with no corresponding TLV are deterministically zero
instead of containing garbage.

Fixes: 57375beef71a ("Bluetooth: btintel: Add infrastructure to read controller information")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index b2aff2bb09114..ceca209be40bf 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -724,6 +724,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
+	memset(version, 0, sizeof(*version));
 	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-- 
2.53.0



