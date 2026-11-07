Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062379;
	b=iC8S+mGt8GpDGtSUFNCAPMmJf96JBDZ4u+xvhYoPFBopwGeEODQsdAeDJ/LIjdt7ynhm
	 ahKV1nqnfJ9sARxEo7U+mMYALS5w2/ryrsHCj5xTqzib3nRswdd0hVExSSoYfQ9bFlx7M
	 nPjnvFMV/KrPTgDNFbL3QEwbE7Cx7/6H2eVNVewpB8jP5CZiPcBOg0TsLIeyTJeNN8DhQ
	 /dbZMnU+5oN8QNp0M2ZQ5QJIKIiqAGdsO+A67mT6gCgPy8ZNjdq3tLWqEcVhyIF6r+/is
	 Tf+w55TgB2k9JxmKMbKWvNlxXDGw3CE/St9GdSvt+Um3lppc/eXfw+AFLlxwDmcBfWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=781PaZSVWlsk3WU8iPu7n7JGTd8VKSiZZ/dBGpVB08k=;
	b=eDihO2+NFFcZnvELzZhO/uRgQWo197FYx/JZw9OtX0vAJHAWN2779krW6nqfaZ/2rSAM
	 zp3kwieMpCiW2rugEGfccgvk4pQqJRZmgXz03y6wjw/ZCkRxJTxJs/xdiFUp15XF8XpE+
	 6vZlw5VdKY5/xl9UzPXr+dtKk7tK73oh64BJMeYvULX18a1bCNputwSYyohZHkpCb27Kc
	 B/vYAv9szeRaO3ydjr2aENf1oaIfTVXb4SUjuTtXK5njrwx18DB8mWK4ZDw90hn/GcECO
	 CTt1DlMeTwEx8rRWtVjBRVYUJrivLyPYZcqqDoMB8rtNrHKQoghXfF33FydsmvMN3WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUJCYY+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AFF6083607;
	Sat,  7 Nov 2026 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUJCYY+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854E91F0089F;
	Sat,  7 Nov 2026 14:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062378;
	bh=781PaZSVWlsk3WU8iPu7n7JGTd8VKSiZZ/dBGpVB08k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUJCYY+DVu3ggFQQKiU1rD7/TKNg+0dV3yEqf48ZUrETYZ4yYoZ9PxPzFhyRvnimI
	 giuLqiQm2Umfmbo5kuBuzGtZFCqoBcUvzVJr4w+7qb39ypHEJ0pClCDNzjfXnUiV6e
	 7viZ5TzEsgD+ozgEZJzBDEIWt+BsWZgY5OYvCNGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1301/1536] Bluetooth: L2CAP: Use default TxWindow for zero socket option
Date: Sat,  7 Nov 2026 08:55:17 -0500
Message-ID: <20261107135034.331852526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

[ Upstream commit 226fa3b676cbf2236f803bccd347462433ffc2c8 ]

L2CAP_OPTIONS accepts a txwin_size of zero and
stores it in tx_win. The zero is then sent to the
peer in our configuration request, and if the
channel ends up in ERTM mode it is passed to
l2cap_seq_list_init().

Use the default TxWindow instead, as the mode can
still be changed to ERTM during configuration.

Fixes: 14b5aa71ec50 ("Bluetooth: Add sockopt configuration for txWindow on L2CAP")
Cc: stable@vger.kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index f08512a57ab58..602a7e78e83ab 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -818,6 +818,10 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 			break;
 		}
 
+		/* A zero TxWindow is invalid, use the default instead */
+		if (!opts.txwin_size)
+			opts.txwin_size = L2CAP_DEFAULT_TX_WINDOW;
+
 		if (!l2cap_valid_mtu(chan, opts.imtu)) {
 			err = -EINVAL;
 			break;
-- 
2.53.0



