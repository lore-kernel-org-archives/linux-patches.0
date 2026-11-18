Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025621;
	b=4/BJCyD8njUT0bml82I80OB3MTyuFM5tRL9Ms0OCrPDztbBpU9YSb6zkf12WgkSyduzs
	 WWnHn7ZyK+xlRPZ6fMdbIfSC51jYYL4WEhSZeM9xZcJgGd9dLI/BsR6DJ5mHwlb+jMxGg
	 iUBSQjPTxj10/npozSC2YjB8v5zdXwvqa4pWfMSoeUhQm49kqcJ4RprbbRIQRUbrozsxt
	 1Ghwk8zucxQSsJzpcZngJZ6/dmeVEfbj0VmzyNmWAbbbP1RmRl2Q4aGvWEvMMW970qs6M
	 dQLkOBFlXMpb6huG9WNiBK1Oq8mBLOpoCZn+up1il8iBbYYrCTUblnUIximzOAvIDUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tI2mqFvlMMVs2RTh2Y8/qxRf7fXDWxr00UEDFHRogTw=;
	b=XT8+PfUieWFIOth9WJf6dr+Z1rz/Tqwn4GjEBMWwyNeJhHeELzseWuUNFhpuiW8QCUck
	 klDhjW2oTTbvxdRYjKnsBm+FiwCbC5tTyoiU9rjX3GFXVTU4QaF0784HweT3QO8PDbCu6
	 9KnyZGB75N4ABdpziy3ok1+7FCAw03WaouvN581n2rCJHpji3Z9AGIFkSGEh/HNfNLr0h
	 SBwnFnxDVOwKze0LES+bnKmRUWMKxGkZniJVahMm6mzxm9C0fS+pYtfDvghPmGv9nRJ2R
	 auhBVA7fPZ4qwRGlPZTk04ffagw2Roqy6fWGIMQ3qtXNSZEqQpAllmxKL1KBJmkR9Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DaFi/GGH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FC9606A32A;
	Wed, 18 Nov 2026 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaFi/GGH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCB21F000C5;
	Wed, 18 Nov 2026 18:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025621;
	bh=tI2mqFvlMMVs2RTh2Y8/qxRf7fXDWxr00UEDFHRogTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaFi/GGH90T2EPCn4qurS2AdrYi0fFz3IcVBXExVylonc/zWoc8xuKGv5UA2YVAOQ
	 NIieFnIhw1wGnVQtKvrHKqbTK/XcdYmL6w6WfHrUhZCk1l6LkZcdNGNmMKxhawwuEt
	 KJgXJk4PpDCkqDkdIKlh+FxaN0MrllMBlvCgZTIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1143/2151] selftests: drv-net: psp: swap closed for connected sockets in assoc tests
Date: Wed, 18 Nov 2026 15:47:58 +0100
Message-ID: <20261118150203.833910501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit e404a2de7ed1a19ed356086e3b012e2227c1024d ]

Future work will only allow rx-assoc and tx-assoc to be performed when
the sock is in TCP_ESTABLISHED state.

Several assoc_ tests, as well as dev_rotate_spi, test using the rx-assoc
and tx-assoc uapi calls against sockets in TCP_CLOSE state.
These tests don't involve sending or receiving data, nor involve looking
up psp device by dst entry, so using a disposable disconnected socket
was just a convenience. These can be replaced by a disposable loopback
socket.

The loopback sockets are IPv4, where the sockets they replace were
AF_INET6. This doesn't reduce coverage, since the assoc handlers accept
any TCP socket and don't look at the address family.

Some users of rx-assoc and tx-assoc on closed sockets are left if they
validate errors that are returned before the kernel will check the
socket for TCP_ESTABLISHED.

Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930-psp-defeat-v2-1-f266e7447129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/psp.py | 30 ++++++++++++++--------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 473573e216e34..793fc772d72b7 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -10,6 +10,8 @@ import struct
 import termios
 import time
 
+from contextlib import contextmanager
+
 from lib.py import defer
 from lib.py import ksft_run, ksft_exit, ksft_pr
 from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_raises
@@ -51,6 +53,17 @@ def _make_psp_conn(cfg, version=0, ipver=None):
     return s
 
 
+@contextmanager
+def _make_lo_conn():
+    # After tx-assoc, the client's egress is dropped, since lo has no
+    # psp_dev, so its FIN never reaches the server. Closing the server
+    # resets the unaccepted child, and the client accepts the cleartext
+    # RST because it hasn't received any PSP traffic yet.
+    with socket.create_server(("localhost", 0)) as srv, \
+         socket.create_connection(srv.getsockname()[:2]) as s:
+        yield s
+
+
 def _close_conn(cfg, s):
     _send_with_ack(cfg, b'data close\0')
     s.close()
@@ -182,20 +195,18 @@ def dev_rotate_spi(cfg):
     _init_psp_dev(cfg)
 
     top_a = top_b = 0
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         assoc_a = cfg.pspnl.rx_assoc({"version": 0,
                                      "dev-id": cfg.psp_dev_id,
                                      "sock-fd": s.fileno()})
         top_a = assoc_a['rx-key']['spi'] >> 31
-        s.close()
     rot = cfg.pspnl.key_rotate({"id": cfg.psp_dev_id})
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         ksft_eq(rot['id'], cfg.psp_dev_id)
         assoc_b = cfg.pspnl.rx_assoc({"version": 0,
                                     "dev-id": cfg.psp_dev_id,
                                     "sock-fd": s.fileno()})
         top_b = assoc_b['rx-key']['spi'] >> 31
-        s.close()
     ksft_ne(top_a, top_b)
 
 
@@ -203,7 +214,7 @@ def assoc_basic(cfg):
     """ Test creating associations """
     _init_psp_dev(cfg)
 
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         assoc = cfg.pspnl.rx_assoc({"version": 0,
                                   "dev-id": cfg.psp_dev_id,
                                   "sock-fd": s.fileno()})
@@ -216,7 +227,6 @@ def assoc_basic(cfg):
                                   "tx-key": assoc['rx-key'],
                                   "sock-fd": s.fileno()})
         ksft_eq(len(assoc), 0)
-        s.close()
 
 
 def assoc_bad_dev(cfg):
@@ -300,7 +310,7 @@ def assoc_version_mismatch(cfg):
     # Translate versions to integers
     versions = [cfg.pspnl.consts["version"].entries[v].value for v in versions]
 
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         rx = cfg.pspnl.rx_assoc({"version": versions[0],
                                  "dev-id": cfg.psp_dev_id,
                                  "sock-fd": s.fileno()})
@@ -329,7 +339,7 @@ def assoc_twice(cfg):
 
         return assoc
 
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         assoc = rx_assoc_check(s)
         tx = cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
                                "version": 0,
@@ -338,7 +348,7 @@ def assoc_twice(cfg):
         ksft_eq(len(tx), 0)
 
         # Use the same Tx assoc second time
-        with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s2:
+        with _make_lo_conn() as s2:
             rx_assoc_check(s2)
             tx = cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
                                    "version": 0,
@@ -346,8 +356,6 @@ def assoc_twice(cfg):
                                    "sock-fd": s2.fileno()})
             ksft_eq(len(tx), 0)
 
-        s.close()
-
 
 def _data_basic_send(cfg, version, ipver):
     """ Test basic data send """
-- 
2.53.0



