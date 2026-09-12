Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B6D47CC85;
	Sat, 12 Sep 2026 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217875; cv=none; b=DrGizEKhHUmPCtgcOQBUrku88hjD0dnMOUE/82Xeu9PV6gdIVNqhH7qK+jdi7L4kcCOvbzBFfpwHREHMgIIEiUngrPWMVk2mGtoARdnhwX+hDKcnVsPfTWaJWXnkLETnFdFw+N0Q3E88nJlbNPFXNIitV/8IUEnvAGlsny2wfpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217875; c=relaxed/simple;
	bh=FysDUzH3c3ChyYjCQgXby8tyot9KH9JuExY7ooclHG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thYO3TIaJ0zeux3f0dA4HUIwMNGcf9zzL3Udbo/H6dMZ6XJR24qECcQTa++gr/6tq/d6m0754QbU52zbL5/zt38LzQlMSGZXIG1oQG1JwvvgWQn7RHiLZUhcpScee6EUDNAO5QIh+Gra/gT8QVA20nM8nYbLe4hQiGDzm0OGKjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZY7klSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZY7klSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68BD1F000FF;
	Sat, 12 Sep 2026 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217874;
	bh=b8StzcynL3Vn4NMLQ1S+ulYp+v3gLyAK8azmXxJxDvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZY7klSsz3m/hd2UuD3L/vADFwb86dqAdpNNRXU6SQmFbO4YQl8M7QYQEgvZc2f4N
	 hLyaZF07VDf6XWV5gs1+ID3YE7ldalg0CjRapi6tgttjRt4z37WM/Z4bwAFx1PfZET
	 Cq0VQPwTlpCLitmxlfuwDpR6sxW40IvnwhQwvW/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1030/1376] xdrgen: Address some checkpatch whitespace complaints
Date: Sat, 12 Sep 2026 08:57:36 +0200
Message-ID: <20260912065630.517945487@linuxfoundation.org>
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
 tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2   | 1 -
 tools/net/sunrpc/xdrgen/templates/C/enum/definition/close.j2    | 1 +
 tools/net/sunrpc/xdrgen/templates/C/enum/definition/close_be.j2 | 1 +
 tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2   | 1 +
 4 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2
index d1405c7c5354a..c7ae506076bb4 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/enum/declaration/close.j2
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



