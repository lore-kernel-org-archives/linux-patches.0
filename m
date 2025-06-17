Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269CE2ED17B;
	Tue, 17 Jun 2025 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177543; cv=none; b=dN51fDlnMIpXyzn06XFd7Nxs4WCdgid242Q8m95aZyBFsQPsiGSQEzM61zsb5ajGgtZPisYJUnFfTqU9eW7wdp+PnjHLj13FbjbA/JuANYQWuPvKUC4q86m1BIQIK7S5obaGqhkq7CUoUYQ4B0N/2BjSiMIRjfw7EP6ZOcpEYLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177543; c=relaxed/simple;
	bh=lf7+I//ydQmjtGjrS78o38ENyjIbotAmuZPj5nGtrVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D0+Bxgy1fCnO4vHOn2JAwAyv0mf+rYRVz28I9dABCgqvf+89D1VVnNuALHNlxmapJJzbeRDhoWR6vMLuRj06CJ6MKTiSKEV6OQnshOSjxXV9uZ19F70z3oBYPyqoTtwuwoG1SX5A1C+RfRA1sCmP5OlppgrWpd3Cz2OtKzi/+rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1DlEuPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1DlEuPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5A3C4CEE3;
	Tue, 17 Jun 2025 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177543;
	bh=lf7+I//ydQmjtGjrS78o38ENyjIbotAmuZPj5nGtrVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1DlEuPq9ratwnGotJ4czPqapDc3IkiTh+QU8cP8lg84xzOsGLgjb2/DVBSdXUG9v
	 awBMivhHGyenZC1w4ZphNxKMbU8ZCewB8Q2KE6XJi4ouGLwtXiQwtSqRDmuWsb1U0y
	 AYCfHxzcMeGW15SHqLw2IIXP/E2Dpt0ijnbvsU84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/512] net: dsa: tag_brcm: legacy: fix pskb_may_pull length
Date: Tue, 17 Jun 2025 17:25:27 +0200
Message-ID: <20250617152434.208963161@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c3c068728e51..fe75821623a4f 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -257,7 +257,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	int source_port;
 	u8 *brcm_tag;
 
-	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_PORT_ID)))
+	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN + VLAN_HLEN)))
 		return NULL;
 
 	brcm_tag = dsa_etype_header_pos_rx(skb);
-- 
2.39.5



