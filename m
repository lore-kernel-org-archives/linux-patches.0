Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064859;
	b=oQRmEqRRhVf+RnO3pUi9lK1K6TlPy9iiDXVG64CmwMNBkRkBxflg82agZcUhxb11bxPh
	 h4Tu0zY/20gS/SkbnWtHxQdcVoNlXCrbS8cmeknDG7Y77fQppjddysYxx2lAEI3z3Up9n
	 YxifHvymSGiBxgSEbLZCl+ol4Ns8q36BHfwh8qx/H8sceHvSy0uA2GmCtC0Vf0U303Y8Q
	 fn8GY+jN7UNJaPP5YV/5RT3CC7TI/hl6LHythLmqJvwgZItMQP18Cogg8zgWJidIepI9Z
	 MA8nsY6ttdcDv0klmdzE3v/+RZGvF3urczCxu+sLQKdZd9Z3fmoPmwZXcuksK02WjsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RbBvZ3b7jdaEIxkqKLZ2vAdLdX4QPmn9IJ3ESAJutQ4=;
	b=Eic5sZBLnoKv5oxbTytiQ1pPoVGLBNNHHYtZQrK/xOzb9KRZqVGxgHkpZJh6MkmTq1Cb
	 u+Dz6zpqAav7mpmUraOh6y6miUAOhg/9qkgyLjbdEpV6iwY3vUsXdJIuAKz3mgikINs3L
	 AXBnOSMyzaHtzJDyB9MUJFLf/0q16SvVH1BHuOPpKWLaYoEyf5koNzXKk3lRSSYxdMFSe
	 Wye0gt++DYDJQl4CAoijTvy5SG2FlMZOuuERnoVFSLHbQIO3hHO1jwUfhKNA9weSCkZU/
	 m9NTQbG+X3hXdH3gGXs0m4OhBuX3GsgOEM59e2mfyNy0Jl1vpiO/+SbbfGCkHBpUurQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUkyXZpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06164606A326;
	Sat,  7 Nov 2026 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUkyXZpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C791F0089F;
	Sat,  7 Nov 2026 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064858;
	bh=RbBvZ3b7jdaEIxkqKLZ2vAdLdX4QPmn9IJ3ESAJutQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUkyXZpTaj/F7sIH6XYH5o7cFB6x7rg5GXWUyUdS833wNwCjPT4abPR45jjZvfmCD
	 cnF9AeXwkjQGSbkjCO1RbuFBWtSSlwoyNslahF4CeN2O4o5Hs3nAG/Yxaub8EjeSbE
	 0ezCjEbf5EzdO1W6EU4zqmG/JoBCNIARXC1lxAk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0778/1257] Bluetooth: L2CAP: Use default TxWindow for zero socket option
Date: Sat,  7 Nov 2026 08:51:14 -0500
Message-ID: <20261107135000.796528149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 38aedd7b00d33..1eab4478abf4a 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -815,6 +815,10 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
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



