Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268364E4C38;
	Wed, 30 Sep 2026 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783793; cv=none; b=ATmTNIMTcyikAYJA31aITPM6LE02ExPIjuCPtExiVyPNVfgwbYEQWPcz0UZMnJj5k3KEIje6GvFpFjUeXhslH8qYRH9dpg3gbMgIwI4tZgVxfQHaGqgW7zCyZ6TIpngrVf2/Jh+oHkXUwe8Skei/v80rV7XS9nwxv2xBrauUfmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783793; c=relaxed/simple;
	bh=OSIw9TEbl8A+9SwIYfGFMns1vUF46NzjEhzN3HxrQvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZGbGmzwCXSUdjFPQKWBoO1K1L229cMU7Vk7k3oIEl3z9T0AiqG2e5xzYMwj9bvz2Qnyc3C3+2shfpmsfwtH3qwMTkNYJjYwNdJzIVXqJ0vJ1hxeZ2NNaW6+skIlaioPBdczergMPG3MVHejQdOFTz12Fqsyv2cT/ggbHU/Uc/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQBkqC/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQBkqC/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3631F00893;
	Wed, 30 Sep 2026 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783787;
	bh=bMZAYqPKtVMphmMuLhnibm2ALkDCv6d1YsHT9T4KQPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQBkqC/Ozx/mmaie3w7gz/EH/H9WDn78Ms5+hlJr1uOY1puBj5BqlfO0cJfBQEoTd
	 ZkBgSORJDCheCo7lwboMTNg1AbfEsVWbgrdpqOTQZC828+GQuTjl9HBMmqN5nHkPjd
	 KeD5JrcSJLyjJusiisxNP9mMT1df+UaX8LlBkhZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 522/595] nfc: st21nfca: remove redundant assignment to variable i
Date: Wed, 30 Sep 2026 17:26:55 +0200
Message-ID: <20260930152358.932476693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 314fbde95769e0cff68ef74ccc261935bb0c6852 ]

Variable i is being assigned a value that is never read, the
assignment is redundant and can be removed. Cleans up clang-scan
build warning:

drivers/nfc/st21nfca/i2c.c:319:4: warning: Value stored to 'i'
is never read [deadcode.DeadStores]
                        i = 0;

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211230161230.428457-1-colin.i.king@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a653c01ce447 ("nfc: st21nfca: validate received frame size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/i2c.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 6ea59426ab0bf..e7a16e08e0f55 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -317,10 +317,8 @@ static int st21nfca_hci_i2c_repack(struct sk_buff *skb)
 		skb_pull(skb, 1);
 
 		r = check_crc(skb->data, skb->len);
-		if (r != 0) {
-			i = 0;
+		if (r != 0)
 			return -EBADMSG;
-		}
 
 		/* remove headbyte */
 		skb_pull(skb, 1);
-- 
2.53.0



