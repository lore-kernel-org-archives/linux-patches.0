Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018790;
	b=SrXVA5dk2/Q48hMREufqZPgGao0aau+h0Whzk25aOtwt9oFUFte+Af8Gd4dd7ZVmkJa3
	 jqpH3dcA9+5VpOuRdoGOrvK7Kvmro00wlRN54Tkkvw74QZbFxI1w5L5JVkbOln8XnH/zo
	 OUzibcUCF4c3TTgygbsH+U3UgyXcnzesiK+fz8P+EPeXojdR7T3M76jIvEFIoBysIeh90
	 2B40GTUyxrq1/TzjfWKte52tiNT8OeWyEZ4l1r25o+3iQVrGDbOLEgeTjjJoIpq1xVSly
	 2wv5orTIRaLOUlxkRuJBadrlHRW8M/+OOokCniIc7cZgr6WTc7J+GFWGGcBm197zOMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QgzLJfGYV4whNzUET3n7Nz06b2FvcN9nh2H3cCT+yR4=;
	b=veeky7O0ycq5TgDG/a8Zx9AwBNZoP3mvuAGG1qafDP2vb7g4wB6YQJWppjSbAH2caIht
	 mfDhQ1zFCnK7w/KJtWxTAg4NB+uARdidHyWSTj86tnRY/q8C2EiUK3BVViiTQ/8c8iUbK
	 LkJ23HO4h3fQM+AoX2h5xMZKA+CU09/X7Qrkk9Pn/HESpsm/vRGQDDLV3Vmy6ifSgf6Sj
	 4Cbr2nBOzdXqMjHiqQqzH5X4tHLam9qwyE5SCMi1I/VOKFTKMnCEIOmOw3PSQcQk8S43W
	 a/ah/hqTSn9E/4+g7xJ3r1cMTChWdVm9Vkcw2hUZ6jnw4HW7JI4u/Mwx6KCVfqVG46g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGmjnQCr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81251606A32F;
	Wed, 18 Nov 2026 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGmjnQCr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E9D1F000C6;
	Wed, 18 Nov 2026 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018790;
	bh=QgzLJfGYV4whNzUET3n7Nz06b2FvcN9nh2H3cCT+yR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGmjnQCrS5TfNgtJmPV5L9L3VNaXrGLXHBLeW8oXncB65Y0ozWgZllAkQGnx1nS8E
	 vlge3CG+QijMbbEZJTBvIUTfgsGWvSuborLGsPvSXkw4EAXxawY6qUjE0SqJPgfsqN
	 IwQvU44xN0vRcvWUve2WvE17RFL+AN9Oxjnvw6R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1366/2651] selftests: drv-net: psp: test that rx-assoc fails on closed and listen socks
Date: Wed, 18 Nov 2026 15:43:26 +0100
Message-ID: <20261118150337.210717654@linuxfoundation.org>
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

[ Upstream commit ab1f1ed8e0bbd7721240fce0150194b232121f19 ]

Cover two of the basic psp assoc states that have been defeatured. Do
not include tests with shutdown(), connect(..., AF_UNSPEC), etc. I don't
think the coverage is worth the complexity. That should be done with
packetdrill.

Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930-psp-defeat-v2-4-f266e7447129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/psp.py | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 22d2f43d109ac..b29d8b58275cd 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -319,6 +319,32 @@ def assoc_sk_only_unconn(cfg):
         ksft_eq(the_exception.nl_msg.error, -errno.EINVAL)
 
 
+def assoc_rx_unconnected(cfg):
+    """ Test that an Rx assoc is rejected on an unconnected socket """
+    _init_psp_dev(cfg)
+
+    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+        with ksft_raises(NlError) as cm:
+            cfg.pspnl.rx_assoc({"version": 0,
+                                "dev-id": cfg.psp_dev_id,
+                                "sock-fd": s.fileno()})
+        ksft_eq(cm.exception.nl_msg.error, -errno.ENOTCONN)
+        ksft_eq(cm.exception.nl_msg.extack['bad-attr'], ".sock-fd")
+
+
+def assoc_rx_listener(cfg):
+    """ Test that an Rx assoc is rejected on a listening socket """
+    _init_psp_dev(cfg)
+
+    with socket.create_server(("localhost", 0)) as s:
+        with ksft_raises(NlError) as cm:
+            cfg.pspnl.rx_assoc({"version": 0,
+                                "dev-id": cfg.psp_dev_id,
+                                "sock-fd": s.fileno()})
+        ksft_eq(cm.exception.nl_msg.error, -errno.ENOTCONN)
+        ksft_eq(cm.exception.nl_msg.extack['bad-attr'], ".sock-fd")
+
+
 def assoc_version_mismatch(cfg):
     """ Test creating associations where Rx and Tx PSP versions do not match """
     _init_psp_dev(cfg)
-- 
2.53.0



