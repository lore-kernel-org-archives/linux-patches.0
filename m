Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016578;
	b=EgvL9WccA/W+UHuKkudl8mbcXSaLwJSGh6FonfWX2pcdinX0S/YqIXdKTlI1oaW0ZzPC
	 iTBd12+p4KY9Cf2WbHfaEN4pDIOZZK7YrvLUlN8sd+8wi/fmTsvdnxtEpYcxucpsNCu5+
	 7o+VdBiyWWiwmJe14eoYlrz+IlGUqeXz5WXnOIrk8TfSF1+Sbb6rBF/ccKbUqXTaRZE22
	 O83Sm4ke5vZ9qtvAHS2u5UIYKj8g4h/8+VqAbbh6xXr4CtOS8S1R7QwNEHb2cbUGlDO/o
	 rR7IyScn3X/TXmog8VpdwebBdzEiDGtSL7VQpe1WyYgVgcnbEBL/t4JVWbIHxZHYhEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5BwZYsqmb918zQodyVcF+7dYnMBVVr/Jddczp+Pyr/s=;
	b=Jps2cRcBIEIzip58uB1tTaVx5e63iG4nTCovllW4XtCIl2HxdD/0DWj+UBpxgSs3MSkY
	 ZBrSSSkvA/sQip+VVj73resAkNib1Lc7T2Zo/RPYvBiCVVmRsTuUIIlEFHp+x0m//IQ5W
	 YcJui/BPqR1KI8MoHoxsPCoF1pRGC6JMY9yFPtZ6SQkCAcWZnLpGic3S7yXrHBNWjjuw3
	 xD6wj4bAUqgtZAPSFpna9sB4q/InkGPB1LF3va3maylSGdeUOMsc1B5v9TP/NuVeiCaHZ
	 HKZ3JJRRfCMcONwwyoXbHnkWFWYwTEDWGKxLdxXwSQqpySxVZDdKftz/s0vEudaraKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvXYGQxQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731D260A2610;
	Wed, 18 Nov 2026 15:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvXYGQxQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80001F000C6;
	Wed, 18 Nov 2026 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016578;
	bh=5BwZYsqmb918zQodyVcF+7dYnMBVVr/Jddczp+Pyr/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvXYGQxQ1NsBOJafYi2zFSh3Xj7ZpqBf+CTxO/2KEeSAT4TTcVbJe5Tk0i51JUTiC
	 v7AJ6h3AaDqWJuBNSetbJ4eb+WHDVHr7iEl6DQD+S8jbbh1j+UhpNAeZYgpxCqoZ/j
	 XoITmSUvu6J+Q9NI6GGkOgjH4so6CHqf9kPFMkn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0561/2651] netlink: specs: devlink: describe DEVLINK_ATTR_NESTED_DEVLINK
Date: Wed, 18 Nov 2026 15:30:01 +0100
Message-ID: <20261118150307.935360905@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6338e31e68551268fa65b5fb1f67eecb3b7a8e3c ]

The "# TODO: fill in the attributes in between" gap before selftests
(176) hides exactly one attribute, DEVLINK_ATTR_NESTED_DEVLINK (175).
devlink_nl_fill() calls devlink_nl_nested_fill() unconditionally, which
emits one of these per entry in devlink->nested_rels (mlx5, ice).

Unlike the other TODO gaps this is a single attribute of an already
modelled type, so just fill it in.

Link: https://patch.msgid.link/20260915161341.1053476-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 150079380e4b ("netlink: specs: devlink: describe the netns id in the parent-dev nest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/devlink.yaml | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/devlink.yaml b/Documentation/netlink/specs/devlink.yaml
index 38b1190f3d269..c4dfc814873f5 100644
--- a/Documentation/netlink/specs/devlink.yaml
+++ b/Documentation/netlink/specs/devlink.yaml
@@ -845,13 +845,14 @@ attribute-sets:
         name: linecard-supported-types
         type: nest
         nested-attributes: dl-linecard-supported-types
-
-      # TODO: fill in the attributes in between
-
+      -
+        name: nested-devlink
+        type: nest
+        multi-attr: true
+        nested-attributes: dl-nested-devlink
       -
         name: selftests
         type: nest
-        value: 176
         nested-attributes: dl-selftest-id
       -
         name: rate-tx-priority
@@ -1338,6 +1339,19 @@ attribute-sets:
       -
         name: index
 
+  -
+    name: dl-nested-devlink
+    subset-of: devlink
+    attributes:
+      -
+        name: bus-name
+      -
+        name: dev-name
+      -
+        name: index
+      -
+        name: netns-id
+
 operations:
   enum-model: directional
   list:
@@ -1363,6 +1377,7 @@ operations:
             - index
             - reload-failed
             - dev-stats
+            - nested-devlink
       dump:
         reply: *get-reply
 
-- 
2.53.0



