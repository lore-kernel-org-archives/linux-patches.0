Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889134DEC26;
	Wed, 30 Sep 2026 18:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792427; cv=none; b=VIwirgkb3LR6aPkonqaCabiyQyh2IcoFjxDSdTeQsgrwQkbCIs5oesI1EopUWqlZAw49FQcCZSKBq93NWjnAtM+4tss1KHuewOQi631rRyjTl/ZMpwZmoYJffEKbIY7iJADLUU2+o4h9Z+Lg6xJzVlOhCgZdhf++IxdPsRHiBeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792427; c=relaxed/simple;
	bh=WuOcm+E9eXkJp2Xcv0l8ILCN9lZhkCGV02XZjdG4Vho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgv97zwtXtZjpf6BGQFqeQq97mFYzh4jACsuy2R79vLTyMmxi7x+un36ZuaQW9yGyPj/OBZ3udUrBLoeAmPCjXUeTrDC5X3b1Aqbr8/qhKchUmytB1/UqXEDgfEcybqaJgMvkYi3ZIrgYK/Qf64LHGH+YkBHbgizL44fJIb2LCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfCdHNxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfCdHNxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40E01F000FF;
	Wed, 30 Sep 2026 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792426;
	bh=50zvJRuPD1XhvKdQEHSfu7wRocEFRl5LxsjJcZUMQkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfCdHNxVKTAi04XKuEIc88pDNnql6w7xB9SRCEPCYXqDpENJK2qbLWXBbXZZTOkUB
	 TuA3xDrXU3Wj1rMfBn0AAIMX7DuFYsNXEgQ7qOMyZ2egVZlmA2mWSyNFOsWiEJ5vKl
	 CFecsrXjovejCpTl+2yetxka0+weZ3Yh/VmnkcGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 649/752] nfc: st21nfca: remove redundant assignment to variable i
Date: Wed, 30 Sep 2026 17:28:39 +0200
Message-ID: <20260930152412.306493326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d56bc24709b5c..7304013ab269c 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -315,10 +315,8 @@ static int st21nfca_hci_i2c_repack(struct sk_buff *skb)
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



