Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1DA41B8CC;
	Sat, 12 Sep 2026 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210651; cv=none; b=XLgLXg1nB5Imp7oXnIH8Y4cX4qHTXjK2Vh3uRZHEud9gB+3PhmAhQOTWAaMJfZg3BEPXzuJqGlPJwzOM9SKrKBEOoOpCbUW/dCrT4wH5BTXJPACMpYFA2/ikfTHC/Qod5XT5dH/fwM74EYzJGq7ehaEg90dIYkd/7aw/nXR6JIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210651; c=relaxed/simple;
	bh=RhyYqiXLXLSW3U/zyuJT4QsU690GRY+pCb/duDfOseM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q078CWs+IjbfoYl7n08Os35cg1KvITDIOemjBJsG5ZvchTtKPmZHTyuoWxQqBP1+G74wZMZqnlWT2bPUzys9E83sxgmdwmM3xwIKLqgxfRpWLYxxD0IDB/r6jpoy41ZbOar5F/UIr0NbBoDxAVTYXbTTdckjjVoSeNkxwhscnQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq1JEeAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq1JEeAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAAA1F000FF;
	Sat, 12 Sep 2026 10:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210650;
	bh=OIY+1PtWARruKMM2tw/Vxq5B9OJ4V9I+j/67qyiPvEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq1JEeAZCLPxSJI/SCz5gavYFNlAIQNmgwywGXHOiw2WasM5yjOh43N3tauaj+kxl
	 3zz3Wl9zD9SNIOCGuhsGIFUSt5fShIBWwMvnzxoHFmPncVUmLqhBMt9jpiAf+32O4A
	 14/JUjSBxsL3eK+BfTBCV/OQoUDxwEU4sVCumMZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1071/1518] xdrgen: Address some checkpatch whitespace complaints
Date: Sat, 12 Sep 2026 08:54:00 +0200
Message-ID: <20260912065647.675755523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4329010ad9c36775e7092e451c37c24c4f90243f ]

This is a roll-up of three template fixes that eliminate noise from
checkpatch output so that it's easier to spot non-trivial problems.

To follow conventional kernel C style, when a union declaration is
marked with "pragma public", there should be a blank line between
the emitted "union xxx { ... };" and the decoder and encoder
function declarations.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d4ca0b0a6c62 ("xdrgen: Do not declare union XDR functions in the definitions header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/sunrpc/xdrgen/templates/C/enum/declaration/enum.j2    | 1 -
 tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2    | 1 +
 tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2 | 1 +
 tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2   | 1 +
 4 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/enum.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/enum.j2
index d1405c7c5354a..c7ae506076bb4 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/enum.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/enum.j2
@@ -1,4 +1,3 @@
 {# SPDX-License-Identifier: GPL-2.0 #}
-
 bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr, {{ name }} *ptr);
 bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr, {{ name }} value);
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2
index a07586cbee179..446266ad6d17d 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2
@@ -1,3 +1,4 @@
 {# SPDX-License-Identifier: GPL-2.0 #}
 };
+
 typedef enum {{ name }} {{ name }};
diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2
index 2c18948bddf75..cfeee2287e68a 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2
@@ -1,3 +1,4 @@
 {# SPDX-License-Identifier: GPL-2.0 #}
 };
+
 typedef __be32 {{ name }};
diff --git a/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
index 01d716d0099e9..5fc1937ba7744 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
@@ -3,6 +3,7 @@
 };
 {%- if name in public_apis %}
 
+
 bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr, struct {{ name }} *ptr);
 bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr, const struct {{ name }} *ptr);
 {%- endif -%}
-- 
2.53.0



