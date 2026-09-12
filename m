Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEB947D928;
	Sat, 12 Sep 2026 12:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217871; cv=none; b=aQguCe3fIOldwdY8Q7s7Znap/OKSJZx3Z0IGeOwY7hskesaYwom1yTBvGNCubtJUpbhnlFBnSLX0SWxyQXuvOhac72VUjxcCvNuceYi1cLl2StXm0cJqXUnkt0IrMx/y53FFQ7DlwkhAHbjKmCpT3Qjb/l3cvl7fNRaQp8+8Z64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217871; c=relaxed/simple;
	bh=avOXrYfc+HJFMxcBvSDw1BPjnxzUzeV6O9tqOz+lHFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAT00vUhdNYpe/J2PyK+bBuZ23x0xGuOxxzaN4FaswF/Ry2k2LT/mJKN2Zsvi6n5Jrw7RgZo3qBZSFMBQxf7ftdZDm2lh6LAW+wlNpS9SCSezcKEOxLFgRDBh9t+dVxxNjgAQ+nD2p+HZccyQytvQsdNWFlMwSeCS2gdrHKaBD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPecDx9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPecDx9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B951F000FF;
	Sat, 12 Sep 2026 12:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217869;
	bh=8hzJyW7uQAWxPuHWikyJPlhZpR4Xc2oi+dV9uHjU6P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPecDx9+7wlLlnOhxzLTZuHUqZZPnhiPaDAGaGZ5qaUDHL9KoF8uERJI9ikR9lxN7
	 uOSSB90ZRmhUg5w3++RbbEBf16lK8ZLKugM6pDcgtE11Xq/lqY0qwlTZrIs0ayoGSb
	 IHZNJcRTPKG/yHXntyebwMtcnAuebzPTfgudah2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1029/1376] xdrgen: Implement big-endian enums
Date: Sat, 12 Sep 2026 08:57:35 +0200
Message-ID: <20260912065630.495776452@linuxfoundation.org>
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

[ Upstream commit b376d519bd142c65ba9bba35db12b6be95b46893 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d4ca0b0a6c62 ("xdrgen: Do not declare union XDR functions in the definitions header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdr.h                    | 21 ++++++++++++
 tools/net/sunrpc/xdrgen/README                | 17 ++++++++++
 tools/net/sunrpc/xdrgen/generators/enum.py    | 17 +++++++---
 tools/net/sunrpc/xdrgen/generators/union.py   | 34 ++++++++++++++-----
 tools/net/sunrpc/xdrgen/grammars/xdr.lark     |  4 ++-
 .../templates/C/enum/decoder/enum_be.j2       | 14 ++++++++
 .../templates/C/enum/definition/close_be.j2   |  3 ++
 .../templates/C/enum/encoder/enum_be.j2       | 14 ++++++++
 .../templates/C/union/decoder/case_spec_be.j2 |  2 ++
 .../templates/C/union/encoder/case_spec_be.j2 |  2 ++
 tools/net/sunrpc/xdrgen/xdr_ast.py            |  3 ++
 11 files changed, 117 insertions(+), 14 deletions(-)
 create mode 100644 tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum_be.j2
 create mode 100644 tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2
 create mode 100644 tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum_be.j2
 create mode 100644 tools/net/sunrpc/xdrgen/templates/C/union/decoder/case_spec_be.j2
 create mode 100644 tools/net/sunrpc/xdrgen/templates/C/union/encoder/case_spec_be.j2

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 0a3cbbe4a4cdf..6bc486214c536 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -695,6 +695,27 @@ xdr_stream_decode_u32(struct xdr_stream *xdr, __u32 *ptr)
 	return 0;
 }
 
+/**
+ * xdr_stream_decode_be32 - Decode a big-endian 32-bit integer
+ * @xdr: pointer to xdr_stream
+ * @ptr: location to store integer
+ *
+ * Return values:
+ *   %0 on success
+ *   %-EBADMSG on XDR buffer overflow
+ */
+static inline ssize_t
+xdr_stream_decode_be32(struct xdr_stream *xdr, __be32 *ptr)
+{
+	const size_t count = sizeof(*ptr);
+	__be32 *p = xdr_inline_decode(xdr, count);
+
+	if (unlikely(!p))
+		return -EBADMSG;
+	*ptr = *p;
+	return 0;
+}
+
 /**
  * xdr_stream_decode_u64 - Decode a 64-bit integer
  * @xdr: pointer to xdr_stream
diff --git a/tools/net/sunrpc/xdrgen/README b/tools/net/sunrpc/xdrgen/README
index 92f7738ad50c3..27218a78ab402 100644
--- a/tools/net/sunrpc/xdrgen/README
+++ b/tools/net/sunrpc/xdrgen/README
@@ -150,6 +150,23 @@ Pragma directives specify exceptions to the normal generation of
 encoding and decoding functions. Currently one directive is
 implemented: "public".
 
+Pragma big_endian
+------ ----------
+
+  pragma big_endian <enum> ;
+
+For variables that might contain only a small number values, it
+is more efficient to avoid the byte-swap when encoding or decoding
+on little-endian machines. Such is often the case with error status
+codes. For example:
+
+  pragma big_endian nfsstat3;
+
+In this case, when generating an XDR struct or union containing a
+field of type "nfsstat3", xdrgen will make the type of that field
+"__be32" instead of "enum nfsstat3". XDR unions then switch on the
+non-byte-swapped value of that field.
+
 Pragma exclude
 ------ -------
 
diff --git a/tools/net/sunrpc/xdrgen/generators/enum.py b/tools/net/sunrpc/xdrgen/generators/enum.py
index 855e43f4ae38e..b05553981f27a 100644
--- a/tools/net/sunrpc/xdrgen/generators/enum.py
+++ b/tools/net/sunrpc/xdrgen/generators/enum.py
@@ -4,7 +4,7 @@
 """Generate code to handle XDR enum types"""
 
 from generators import SourceGenerator, create_jinja2_environment
-from xdr_ast import _XdrEnum, public_apis
+from xdr_ast import _XdrEnum, public_apis, big_endian
 
 
 class XdrEnumGenerator(SourceGenerator):
@@ -30,15 +30,24 @@ class XdrEnumGenerator(SourceGenerator):
         for enumerator in node.enumerators:
             print(template.render(name=enumerator.name, value=enumerator.value))
 
-        template = self.environment.get_template("definition/close.j2")
+        if node.name in big_endian:
+            template = self.environment.get_template("definition/close_be.j2")
+        else:
+            template = self.environment.get_template("definition/close.j2")
         print(template.render(name=node.name))
 
     def emit_decoder(self, node: _XdrEnum) -> None:
         """Emit one decoder function for an XDR enum type"""
-        template = self.environment.get_template("decoder/enum.j2")
+        if node.name in big_endian:
+            template = self.environment.get_template("decoder/enum_be.j2")
+        else:
+            template = self.environment.get_template("decoder/enum.j2")
         print(template.render(name=node.name))
 
     def emit_encoder(self, node: _XdrEnum) -> None:
         """Emit one encoder function for an XDR enum type"""
-        template = self.environment.get_template("encoder/enum.j2")
+        if node.name in big_endian:
+            template = self.environment.get_template("encoder/enum_be.j2")
+        else:
+            template = self.environment.get_template("encoder/enum.j2")
         print(template.render(name=node.name))
diff --git a/tools/net/sunrpc/xdrgen/generators/union.py b/tools/net/sunrpc/xdrgen/generators/union.py
index 7974967bbb9fd..4522a5b7a943e 100644
--- a/tools/net/sunrpc/xdrgen/generators/union.py
+++ b/tools/net/sunrpc/xdrgen/generators/union.py
@@ -8,7 +8,7 @@ from jinja2 import Environment
 from generators import SourceGenerator
 from generators import create_jinja2_environment, get_jinja2_template
 
-from xdr_ast import _XdrBasic, _XdrUnion, _XdrVoid
+from xdr_ast import _XdrBasic, _XdrUnion, _XdrVoid, big_endian
 from xdr_ast import _XdrDeclaration, _XdrCaseSpec, public_apis
 
 
@@ -77,13 +77,18 @@ def emit_union_switch_spec_decoder(
     print(template.render(name=node.name, type=node.spec.type_name))
 
 
-def emit_union_case_spec_decoder(environment: Environment, node: _XdrCaseSpec) -> None:
+def emit_union_case_spec_decoder(
+    environment: Environment, node: _XdrCaseSpec, big_endian_discriminant: bool
+) -> None:
     """Emit decoder functions for an XDR union's case arm"""
 
     if isinstance(node.arm, _XdrVoid):
         return
 
-    template = get_jinja2_template(environment, "decoder", "case_spec")
+    if big_endian_discriminant:
+        template = get_jinja2_template(environment, "decoder", "case_spec_be")
+    else:
+        template = get_jinja2_template(environment, "decoder", "case_spec")
     for case in node.values:
         print(template.render(case=case))
 
@@ -136,7 +141,11 @@ def emit_union_decoder(environment: Environment, node: _XdrUnion) -> None:
     emit_union_switch_spec_decoder(environment, node.discriminant)
 
     for case in node.cases:
-        emit_union_case_spec_decoder(environment, case)
+        emit_union_case_spec_decoder(
+            environment,
+            case,
+            node.discriminant.spec.type_name in big_endian,
+        )
 
     emit_union_default_spec_decoder(environment, node)
 
@@ -153,17 +162,21 @@ def emit_union_switch_spec_encoder(
     print(template.render(name=node.name, type=node.spec.type_name))
 
 
-def emit_union_case_spec_encoder(environment: Environment, node: _XdrCaseSpec) -> None:
+def emit_union_case_spec_encoder(
+    environment: Environment, node: _XdrCaseSpec, big_endian_discriminant: bool
+) -> None:
     """Emit encoder functions for an XDR union's case arm"""
 
     if isinstance(node.arm, _XdrVoid):
         return
 
-    template = get_jinja2_template(environment, "encoder", "case_spec")
+    if big_endian_discriminant:
+        template = get_jinja2_template(environment, "encoder", "case_spec_be")
+    else:
+        template = get_jinja2_template(environment, "encoder", "case_spec")
     for case in node.values:
         print(template.render(case=case))
 
-    assert isinstance(node.arm, _XdrBasic)
     template = get_jinja2_template(environment, "encoder", node.arm.template)
     print(
         template.render(
@@ -192,7 +205,6 @@ def emit_union_default_spec_encoder(environment: Environment, node: _XdrUnion) -
         print(template.render())
         return
 
-    assert isinstance(default_case.arm, _XdrBasic)
     template = get_jinja2_template(environment, "encoder", default_case.arm.template)
     print(
         template.render(
@@ -210,7 +222,11 @@ def emit_union_encoder(environment, node: _XdrUnion) -> None:
     emit_union_switch_spec_encoder(environment, node.discriminant)
 
     for case in node.cases:
-        emit_union_case_spec_encoder(environment, case)
+        emit_union_case_spec_encoder(
+            environment,
+            case,
+            node.discriminant.spec.type_name in big_endian,
+        )
 
     emit_union_default_spec_encoder(environment, node)
 
diff --git a/tools/net/sunrpc/xdrgen/grammars/xdr.lark b/tools/net/sunrpc/xdrgen/grammars/xdr.lark
index f3c4552e548d6..2eb30dddcaea0 100644
--- a/tools/net/sunrpc/xdrgen/grammars/xdr.lark
+++ b/tools/net/sunrpc/xdrgen/grammars/xdr.lark
@@ -87,12 +87,14 @@ procedure_def           : type_specifier identifier "(" type_specifier ")" "=" c
 
 pragma_def              : "pragma" directive identifier [ identifier ] ";"
 
-directive               : exclude_directive
+directive               : big_endian_directive
+                        | exclude_directive
                         | header_directive
                         | pages_directive
                         | public_directive
                         | skip_directive
 
+big_endian_directive    : "big_endian"
 exclude_directive       : "exclude"
 header_directive        : "header"
 pages_directive         : "pages"
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum_be.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum_be.j2
new file mode 100644
index 0000000000000..44c391c10b42e
--- /dev/null
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/decoder/enum_be.j2
@@ -0,0 +1,14 @@
+{# SPDX-License-Identifier: GPL-2.0 #}
+
+{% if annotate %}
+/* enum {{ name }} (big-endian) */
+{% endif %}
+{% if name in public_apis %}
+bool
+{% else %}
+static bool __maybe_unused
+{% endif %}
+xdrgen_decode_{{ name }}(struct xdr_stream *xdr, {{ name }} *ptr)
+{
+	return xdr_stream_decode_be32(xdr, ptr) == 0;
+}
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2
new file mode 100644
index 0000000000000..2c18948bddf75
--- /dev/null
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2
@@ -0,0 +1,3 @@
+{# SPDX-License-Identifier: GPL-2.0 #}
+};
+typedef __be32 {{ name }};
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum_be.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum_be.j2
new file mode 100644
index 0000000000000..fbbcc45948d6a
--- /dev/null
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/encoder/enum_be.j2
@@ -0,0 +1,14 @@
+{# SPDX-License-Identifier: GPL-2.0 #}
+
+{% if annotate %}
+/* enum {{ name }} (big-endian) */
+{% endif %}
+{% if name in public_apis %}
+bool
+{% else %}
+static bool __maybe_unused
+{% endif %}
+xdrgen_encode_{{ name }}(struct xdr_stream *xdr, {{ name }} value)
+{
+	return xdr_stream_encode_be32(xdr, value) == XDR_UNIT;
+}
diff --git a/tools/net/sunrpc/xdrgen/templates/C/union/decoder/case_spec_be.j2 b/tools/net/sunrpc/xdrgen/templates/C/union/decoder/case_spec_be.j2
new file mode 100644
index 0000000000000..917f3a1c45888
--- /dev/null
+++ b/tools/net/sunrpc/xdrgen/templates/C/union/decoder/case_spec_be.j2
@@ -0,0 +1,2 @@
+{# SPDX-License-Identifier: GPL-2.0 #}
+	case __constant_cpu_to_be32({{ case }}):
diff --git a/tools/net/sunrpc/xdrgen/templates/C/union/encoder/case_spec_be.j2 b/tools/net/sunrpc/xdrgen/templates/C/union/encoder/case_spec_be.j2
new file mode 100644
index 0000000000000..917f3a1c45888
--- /dev/null
+++ b/tools/net/sunrpc/xdrgen/templates/C/union/encoder/case_spec_be.j2
@@ -0,0 +1,2 @@
+{# SPDX-License-Identifier: GPL-2.0 #}
+	case __constant_cpu_to_be32({{ case }}):
diff --git a/tools/net/sunrpc/xdrgen/xdr_ast.py b/tools/net/sunrpc/xdrgen/xdr_ast.py
index f5788a5585a9f..d90dd6ce61004 100644
--- a/tools/net/sunrpc/xdrgen/xdr_ast.py
+++ b/tools/net/sunrpc/xdrgen/xdr_ast.py
@@ -12,6 +12,7 @@ from lark.tree import Meta
 
 this_module = sys.modules[__name__]
 
+big_endian = []
 excluded_apis = []
 header_name = "none"
 public_apis = []
@@ -480,6 +481,8 @@ class ParseToAst(Transformer):
         """Instantiate one _Pragma object"""
         directive = children[0].children[0].data
         match directive:
+            case "big_endian_directive":
+                big_endian.append(children[1].symbol)
             case "exclude_directive":
                 excluded_apis.append(children[1].symbol)
             case "header_directive":
-- 
2.53.0



