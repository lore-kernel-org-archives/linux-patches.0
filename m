Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC15047D440;
	Sat, 12 Sep 2026 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217866; cv=none; b=h6B/mQc7OCmGRLmWtJw3ltbHSayDMtQIm8mYTwrJ07RQm4PpfbYsX8udQDUlZ5UNtczhErha02llsvdBaewSsQVGEnbfy8mjuykkSG5+4ZK7Ee0VJRB9lo6C+skXYg9s3qxnxOqtObcgXo8Av4Xf1phMcT9rZ9u3O2PGDPd+pyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217866; c=relaxed/simple;
	bh=WWpkuSjUcpTNPbRlEvnjmirNvTvwsUxlkAEbd2A7jH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt2LhpAgfwHW9EtRxOQjwm/aVNx1pjpcTexoWrQST+c6FbjNC3QuWPX/Rqp5GQHDJU5IbXCX16ZnyG+HS4M9T1z9M6IbBzKO7CADxqZyL8Wc8RA+WnBI+XRSpi+mW1x7++/U40So9+SxiqCCEopx8uKGOQkvHZRomKmZS2tk1kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUGdtLsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUGdtLsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD031F000FF;
	Sat, 12 Sep 2026 12:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217864;
	bh=P6RgV2y4hZCh8HgTTdMVRnBAxjmOg6TJ7+kpzs99POk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUGdtLsgNTVobjp6EdEA6mM8xgSygnda9BjVaUHmDPt5unHb3XBa2y+cQ6xRXEp/p
	 w8dp39QedKkXFA78G2F7XTNNOMzzg4D1IYvFJKTL4dcoT1rSQWjihGi7jh+P1dlAKl
	 gvanwfjwsF5LeQOYAh9ig06GfDv5qC4KXivkl3II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1028/1376] xdrgen: Rename "enum yada" types as just "yada"
Date: Sat, 12 Sep 2026 08:57:34 +0200
Message-ID: <20260912065630.474394807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6e853dcd2d3d6f796597c1042340a2de0ce2469f ]

This simplifies the generated C code and makes way for supporting
big-endian XDR enums.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d4ca0b0a6c62 ("xdrgen: Do not declare union XDR functions in the definitions header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2 | 4 ++--
 tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum.j2      | 2 +-
 tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2  | 1 +
 tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum.j2      | 2 +-
 tools/net/sunrpc/xdrgen/xdr_ast.py                            | 4 ----
 5 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2
index ab1e576c95318..d1405c7c5354a 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2
@@ -1,4 +1,4 @@
 {# SPDX-License-Identifier: GPL-2.0 #}
 
-bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr, enum {{ name }} *ptr);
-bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr, enum {{ name }} value);
+bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr, {{ name }} *ptr);
+bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr, {{ name }} value);
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum.j2
index 341d829afeda9..6482984f1cb71 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum.j2
@@ -8,7 +8,7 @@ bool
 {% else %}
 static bool __maybe_unused
 {% endif %}
-xdrgen_decode_{{ name }}(struct xdr_stream *xdr, enum {{ name }} *ptr)
+xdrgen_decode_{{ name }}(struct xdr_stream *xdr, {{ name }} *ptr)
 {
 	u32 val;
 
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2
index 9e62344a976aa..a07586cbee179 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2
@@ -1,2 +1,3 @@
 {# SPDX-License-Identifier: GPL-2.0 #}
 };
+typedef enum {{ name }} {{ name }};
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum.j2
index bd0a770e50f24..67245b9a914d2 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum.j2
@@ -8,7 +8,7 @@ bool
 {% else %}
 static bool __maybe_unused
 {% endif %}
-xdrgen_encode_{{ name }}(struct xdr_stream *xdr, enum {{ name }} value)
+xdrgen_encode_{{ name }}(struct xdr_stream *xdr, {{ name }} value)
 {
 	return xdr_stream_encode_u32(xdr, value) == XDR_UNIT;
 }
diff --git a/tools/net/sunrpc/xdrgen/xdr_ast.py b/tools/net/sunrpc/xdrgen/xdr_ast.py
index dbd3fcf9c9576..f5788a5585a9f 100644
--- a/tools/net/sunrpc/xdrgen/xdr_ast.py
+++ b/tools/net/sunrpc/xdrgen/xdr_ast.py
@@ -15,7 +15,6 @@ this_module = sys.modules[__name__]
 excluded_apis = []
 header_name = "none"
 public_apis = []
-enums = set()
 structs = set()
 pass_by_reference = set()
 
@@ -294,8 +293,6 @@ class ParseToAst(Transformer):
         c_classifier = ""
         if isinstance(children[0], _XdrIdentifier):
             name = children[0].symbol
-            if name in enums:
-                c_classifier = "enum "
             if name in structs:
                 c_classifier = "struct "
             return _XdrDefinedType(
@@ -320,7 +317,6 @@ class ParseToAst(Transformer):
     def enum(self, children):
         """Instantiate one _XdrEnum object"""
         enum_name = children[0].symbol
-        enums.add(enum_name)
 
         i = 0
         enumerators = []
-- 
2.53.0



