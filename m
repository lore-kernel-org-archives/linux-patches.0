Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045525;
	b=BgqMk2bXZfIWhuydkRYKdE9/gOeRiLqAW88bcxXgM5pAIZy1yKcNYdosfpQQC0O86FJ0
	 CP4tSGenocg+vVZaOE2kPboD4IizJ9tobS9vER6pq8e1jL5KnV6habahXSjH8Qqb+EySk
	 BO02eh7BrlOyMs16AVa2qxkF/phMITRpXOEsTGk7x6+85VxgqPReTSaliJgPvn0fADHvi
	 +MOBRSHIXnhF2UhFRX/E7rror8fb4QmM13FgjOJAe5voCUYhYhFdKWSsScFJlTliFn9oc
	 dd64UvSYD50oS4QHlbkdUoeKmPBVltJ04D9bFPBeDAIqaiRca1ahT3g79AEYAOPyb2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w42Csbgv12U2XDc3ssUC7a/qOd0j83TD8PD7k+6DdsI=;
	b=017UWIvAJUkN4cgcKyBHzteJPCYP4mTsV1fMzFvFydXGjbHeY6YOSLY37HfLGxxuyGFO
	 BirWkTLhI6EWiwArH7ZVvbpsrmA+HHcgXaOayT0uLrnXraOIEKgukF3+IYNjJlukegtrH
	 hMfNszkuLmzP+HMpwY+40teAf9mEzoTvSxu7Lv1XLZS0mrRZyFPesqnvFrk4UVK+xcPbN
	 XF/G8VGk3lo/e52D/PllS2iWwhJu4AjHL39BtnW32eKOkh/A06n+wA+Qq0QdVwBh14Txj
	 efu7giDLbTyp9k/MFcDvj5vh46m6Mhxo7BBN3jW5EV18wFjGg7swdYAxQWJxAIsfY9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6Osn6hF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ADC606A31C;
	Wed, 18 Nov 2026 23:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6Osn6hF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929251F000C4;
	Wed, 18 Nov 2026 23:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045525;
	bh=w42Csbgv12U2XDc3ssUC7a/qOd0j83TD8PD7k+6DdsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6Osn6hFMn9KJ5IWw0ank6eb2LsBn4Gh8ohvSN8JH7TULfGPlbFVfMNymeDVrpgwx
	 BzY4B6N1cCzpL4APMWo+VFr5dCPFxPUQscMZ7prDT96ztJE8sUDytywQW1yPMZ0Efs
	 m5qVdf9ekn1mfbTuyCfhb3p/xSkIUw0SamsyLzsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0955/2857] Bluetooth: L2CAP: Use default TxWindow for zero socket option
Date: Wed, 18 Nov 2026 15:33:09 +0100
Message-ID: <20261118150235.991031661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 655922aa82f1f..46d73d46e2973 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -803,6 +803,10 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
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



