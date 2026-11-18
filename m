Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025638;
	b=Lit1E1yuOUJQHA/V8crjRNe/5/FWHkmRMWZAEWSXlJFULR/f8Y6G/q/hXufpAUjv0Ntm
	 KqUo+HhGUltLcXzYGSFIOTdwoObGviOdTFzDTW1+2zju4ypAlV0pKGB0F8pcsw5nfDBXr
	 9y7I9fEF/62MF63N1g4UF8cbdDx+v/cOP+AjTzIOXu4LyJjyh7Z5ubIm0WGg0Y5qTaYal
	 oBCUcoNmd/hNDb8nzyfi87NZBOUjKJrinTyzJiko9N0E6fo3usL3DpWq9M0MXOGJDh6Q7
	 6TqbXD6VmRFROEApz73s0zUYEgsE8KA9tA5z5qmsWTnOfEV05seJjekqUudcKxxOmTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M5mdi/4WVuSOwWfWQzZ2xJuGzFJmDtb1ISE4ArTIDMs=;
	b=WYCEx99xR/XmnZFZMznPSL6FQdps6ZNS+2isTW7ybBmewR9RzECfk//8ixSdHjxm4j4S
	 tMU4yUvalHilVEbo/D4bd47DeClLz0CSXHrX5HfycxdvRqfsJLWGELi/sIcqVQurl0gAD
	 A1Y2eyyjHJHFKc1/OXnbCCqEjKoVxkXYVIArJ2aZDun7coNBgMOFTz5bHoCCuQaGJ5W5L
	 IljHCIwpFndA6pmuA0CsYQVeGbhpQwry5r/EtWeZlIlPZRkyWdvu0X43dKHNroB7FGNhM
	 XLd3QONEazKcTM6jw85pSZiliaJ15St6++rpGnFGx436KibJIpznKWGSTuBC5YBL0Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XS7jl3Fw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D15606A31C;
	Wed, 18 Nov 2026 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XS7jl3Fw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6201F000C4;
	Wed, 18 Nov 2026 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025638;
	bh=M5mdi/4WVuSOwWfWQzZ2xJuGzFJmDtb1ISE4ArTIDMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XS7jl3FwpiFaQkTgUXPC8ih2DKwfR/8nrYhkjU8TdHSqNMAu17CsdFwXqnOC3xMfJ
	 lWNPowyJVWaaiTvU2vJUjl4clztSWhl/5T/iUwvY74lb25B88gI7zUwz3gvNps0K6r
	 ytWVxrRH5mzZsUzOJc2jIhO8yjWZhDZ8GDTyvLh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1148/2151] selftests: drv-net: psp: test that rx-assoc fails on closed and listen socks
Date: Wed, 18 Nov 2026 15:48:03 +0100
Message-ID: <20261118150204.001835687@linuxfoundation.org>
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
index 793fc772d72b7..f2c4578408755 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -299,6 +299,32 @@ def assoc_sk_only_unconn(cfg):
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



