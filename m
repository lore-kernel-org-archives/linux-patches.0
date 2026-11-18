Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018781;
	b=PE7RZB+SrmfDSgCm9FSiJHmUjk3IMs0dSd5ZURg2ZcJF/n0K4g+mlYksb6Ptzt21kt1B
	 EfUM35ydfYBtv1hvR2t9uxytOyrCI0VBusbD2gSacziFKT89QFqbrLOi0Uo69HT5ZuKH+
	 5hNvWRLJXK3US9RAnnMmqWKC6pFADeVJbN5BIKXG86yEjY403x8Gb779fymR2P5coDW+0
	 LNfYGTvLx66hM1AQCNLdk77JqMIWcjr5V5yTFGq6vN9WQhuCdetE1LtTLKuEo2GRJHsTA
	 vqgEh65uvWGNR7DCPhlc/5l4JiTzzbAPQ8OS7XPAWPglRGjKcbIy42m8Sn/5a3g0MXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gx3onN8hsrsqx0MHd3YN0LoemrUaN+1bvTLrB9phqD4=;
	b=XPzktEb4fEnDj3q3K/K7nSfyK+rErrJ15pZaZH9AKpRAY6m2sRaNxtJXiA96fppdnru+
	 85wWEOah6qCBrTsJNBJU3JJnwJM1FjVgvlKBasrAe3+9+UN7Jd/jvOe6d/T8irweS8muj
	 AdEIYAAbKJNIrFUsRhNSPgT//aEOuz0x6CIWIrpJ5ePLscnvryjv9G5FMGPwNqmcUsTOq
	 Nqw22YUTU62+MvxMa7Du6GNrPKGPCrtuG3vem0calOgLYLjf6drmp1f0zRecfOodIZiTk
	 oCcaENdefaz6gwbGkQqIMu5F17LLC6oszFf8xN91ZPFnnSOLkrwTz2XiftRpdyER/DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rm4YnwDB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93F4606A335;
	Wed, 18 Nov 2026 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rm4YnwDB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A02A1F000C5;
	Wed, 18 Nov 2026 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018781;
	bh=Gx3onN8hsrsqx0MHd3YN0LoemrUaN+1bvTLrB9phqD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rm4YnwDBJ4xC8Xo5lEzzALpD0tlHnaVLjvjuKa05q58m72FkfcNj4LjE4YZPde0JD
	 FZiUjzcIHqWyczvlE73FLyaJG1H01dF3vmLp4neUrlEUCJGTJF33jVrJy6Zepf/JNE
	 eu6felsWhWpUJkGrUOC8qozTcrv5RtbfSH3voAs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1363/2651] selftests: drv-net: psp: swap closed for connected sockets in assoc tests
Date: Wed, 18 Nov 2026 15:43:23 +0100
Message-ID: <20261118150337.095842349@linuxfoundation.org>
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
index a5b1e14f120f0..22d2f43d109ac 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -11,6 +11,8 @@ import struct
 import termios
 import time
 
+from contextlib import contextmanager
+
 from lib.py import defer
 from lib.py import ksft_run, ksft_exit, ksft_pr
 from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_raises
@@ -58,6 +60,17 @@ def _make_psp_conn(cfg, version=0, ipver=None):
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
@@ -200,20 +213,18 @@ def dev_rotate_spi(cfg):
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
 
 
@@ -221,7 +232,7 @@ def assoc_basic(cfg):
     """ Test creating associations """
     _init_psp_dev(cfg)
 
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         assoc = cfg.pspnl.rx_assoc({"version": 0,
                                   "dev-id": cfg.psp_dev_id,
                                   "sock-fd": s.fileno()})
@@ -234,7 +245,6 @@ def assoc_basic(cfg):
                                   "tx-key": assoc['rx-key'],
                                   "sock-fd": s.fileno()})
         ksft_eq(len(assoc), 0)
-        s.close()
 
 
 def assoc_bad_dev(cfg):
@@ -320,7 +330,7 @@ def assoc_version_mismatch(cfg):
     # Translate versions to integers
     versions = [cfg.pspnl.consts["version"].entries[v].value for v in versions]
 
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         rx = cfg.pspnl.rx_assoc({"version": versions[0],
                                  "dev-id": cfg.psp_dev_id,
                                  "sock-fd": s.fileno()})
@@ -393,7 +403,7 @@ def assoc_twice(cfg):
 
         return assoc
 
-    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+    with _make_lo_conn() as s:
         assoc = rx_assoc_check(s)
         tx = cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
                                "version": 0,
@@ -402,7 +412,7 @@ def assoc_twice(cfg):
         ksft_eq(len(tx), 0)
 
         # Use the same Tx assoc second time
-        with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s2:
+        with _make_lo_conn() as s2:
             rx_assoc_check(s2)
             tx = cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
                                    "version": 0,
@@ -410,8 +420,6 @@ def assoc_twice(cfg):
                                    "sock-fd": s2.fileno()})
             ksft_eq(len(tx), 0)
 
-        s.close()
-
 
 def _data_basic_send(cfg, version, ipver):
     """ Test basic data send """
-- 
2.53.0



