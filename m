Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050556;
	b=eDWIBCRaRgGm9j0pyzE0GA3kBroEr71l4B4H/q5OWI6bPm4+tDuSLBjFhS/MsYf+QZQ8
	 K4aVbPgYaGLOJnVHZb6Nw+8XY4SQoi8ldbUa2+BSP0IG+/wjFvzWJfztRBqHSW/XXnMXF
	 EJtPPDmG+heq0PIP2AHGERMjoWoCIJ0/c3LSuxBKIMRBkXi9ODFTKAn7RW4rSuS9qnVjX
	 6pmlmQSEb8gmQDyExw5u/KDo1Y6PvFmTCTr7/QU7Hg4BxR8Ze7oJ8f18oz/xSYX+1knXS
	 QTrYznDDxXAACWsHpmy36CrFl1V3dQzUKjUKCHbTAmtCQBBaQH8phw+JbG6KEscusNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhUc9CkO+U4XG46tKopJ0ZMZIZAwde1CMhFB/TSEqBk=;
	b=FmUDqw2UnqSSDNPOvHXpB2MkLmOShkrJ/Qx+vreTfBfKhHQO3M7RJ13FZt6hfLlqp8uL
	 XefSyDjuhC+Qm6zy+mHCGl/5wijx4MNrlWRSrSMijV8fodAn9sRJa6I0YGXEvykt5Uvqa
	 n4ZrEA4zkSo1q0Q3L0j/p6ApLcjagMQ3Df/MjZSinp3vhWLOOwxWY/Him/ohK0PMONw34
	 EFu4GxifejP9VgYgHb1Ffo3uPPUoAU0Ln1+jPekZJFaD+u4XTrxZAiH4Vrk4LC7GI0qFT
	 wOo5SLEqnDAOvQMDcQ+etVRyah5df5WL3+/lL+3VnmEe5AsdOdDU4zxJoXLpZMLCIRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0oopqTml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB18606A320;
	Thu, 19 Nov 2026 01:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0oopqTml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5331F000C4;
	Thu, 19 Nov 2026 01:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050556;
	bh=WhUc9CkO+U4XG46tKopJ0ZMZIZAwde1CMhFB/TSEqBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oopqTmlTYza9MFTSyb/TcCFVrZPE9ikH55wxJJQZ7suF4HE4PS//TtDM10srvg/M
	 hlPD4v/vjNRhN/D68Yupasi0a0/5a7n/TGytqYELvBE65IRIsKY1c+vLutK0z5A043
	 HDq+CKW5kjFmBNKuCbw0cagtxTFL6iSAirYaK+uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2713/2857] tls: move tls_cipher_size_desc to net/tls/tls.h
Date: Wed, 18 Nov 2026 16:02:27 +0100
Message-ID: <20261118150339.300298684@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit fd0fc6fdd8896a195cb7b0210a5ee46774718fc8 ]

It's only used in net/tls/*, no need to bloat include/net/tls.h.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/dd9fad80415e5b3575b41f56b331871038362eab.1692977948.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c43c1c24f3cd ("tls: avoid field-spanning write when copying crypto info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h | 10 ----------
 net/tls/tls.h     | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index cd0dfa25c591e..56604e75c8ae4 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -51,16 +51,6 @@
 
 struct tls_rec;
 
-struct tls_cipher_size_desc {
-	unsigned int iv;
-	unsigned int key;
-	unsigned int salt;
-	unsigned int tag;
-	unsigned int rec_seq;
-};
-
-extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
-
 /* Maximum data size carried in a TLS record */
 #define TLS_MAX_PAYLOAD_SIZE		((size_t)1 << 14)
 
diff --git a/net/tls/tls.h b/net/tls/tls.h
index c1be900190376..8ac493a56f38f 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -50,6 +50,16 @@
 #define TLS_DEC_STATS(net, field)				\
 	SNMP_DEC_STATS((net)->mib.tls_statistics, field)
 
+struct tls_cipher_size_desc {
+	unsigned int iv;
+	unsigned int key;
+	unsigned int salt;
+	unsigned int tag;
+	unsigned int rec_seq;
+};
+
+extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
+
 /* TLS records are maintained in 'struct tls_rec'. It stores the memory pages
  * allocated or mapped for each TLS record. After encryption, the records are
  * stores in a linked list.
-- 
2.53.0



