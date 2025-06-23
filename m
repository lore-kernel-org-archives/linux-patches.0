Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E47628EA;
	Mon, 23 Jun 2025 21:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714201; cv=none; b=Z+EWsaFeJwBFFWBJdcFl0/bNyr8IbiZEy+YLY7MoPx/hIqT6y83mAKRc5vdPurBv99kJsK3dAjAPltq5CgFnPfBVIfT3osu9qkoY8/4dQQ3+GjP31zA//Hd5pJ3KZzHzBE7DbOb8jTDcilz3fKMtc5oz+qXSkvC+KPB/fpJoNVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714201; c=relaxed/simple;
	bh=Ki5PEygmHevPTQV3N4//0FfZR7hkN5aJHBzXxNtaKQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFJl8cNoTd15m6aJ8ukqWkkXCKzq3xvnWTdZ/+G+RuFmMhttId5HpCeJ52ZCXlndYlafx/RrsyKdbzTq8+WZUDSrR0G4OK27O2P+Cdt5N+1sw9xPWNfXu/IU5B0mxX/JWCjcSi/3dU6HjZ0yAWK3ZF9O0bNj9COYjja56eOv5ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAdIdASf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAdIdASf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16036C4CEED;
	Mon, 23 Jun 2025 21:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714201;
	bh=Ki5PEygmHevPTQV3N4//0FfZR7hkN5aJHBzXxNtaKQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAdIdASfTncnScns1Vd7o2akfRQWSUxF12+M1E6RqtCnegOfktvYiZXe2fe1kUOdN
	 97dy4qX77vuE6nhn/RliPzIUDK1Qat0OrrxLjOmkuBuNGz/YXmY0V96AqKX6t5SAAc
	 K1xAkAOIM0v8GD91LQNlY8ExyoMByHr0YAUi3TJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/508] net: dsa: tag_brcm: legacy: fix pskb_may_pull length
Date: Mon, 23 Jun 2025 15:03:43 +0200
Message-ID: <20250623130649.652304574@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit efdddc4484859082da6c7877ed144c8121c8ea55 ]

BRCM_LEG_PORT_ID was incorrectly used for pskb_may_pull length.
The correct check is BRCM_LEG_TAG_LEN + VLAN_HLEN, or 10 bytes.

Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250529124406.2513779-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index a65d62fb90094..04b57534fe4de 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -253,7 +253,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	int source_port;
 	u8 *brcm_tag;
 
-	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_PORT_ID)))
+	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN + VLAN_HLEN)))
 		return NULL;
 
 	brcm_tag = dsa_etype_header_pos_rx(skb);
-- 
2.39.5



