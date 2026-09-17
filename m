Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4079951596C;
	Thu, 17 Sep 2026 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666904; cv=none; b=NotOQ5sdyBwSyOqiGvJ4FeMmuZwhKs+whK2PZaBy547Y/a832ueMB9lY26NOqdXNrlHVBbTdUBq7nXSHwG0uTb6yxUGWZYu21xJbQ9+jfBQY1MdAVUrLs8Hmmm9AqkAuxfU95YU7B+8WGZ7i0bT2nTMR43VIWkY/zg5HccJxNuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666904; c=relaxed/simple;
	bh=y8QeQBQAJUGguRf+Rb0iQdBINHu0gsjA7CW2w87CuPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEEuMB1BoLDibT5W/+tlSmWjC5H+uLvR/sxvdiDy/FuCWAl3/opdqDpi3OLr9o1+mV30957Gz267JoQxvOhtVVj+vkMw8nQTjvXTfBOhg0O7brmmrZtiuNIm6MrRQHFNT+kE/F80I3SCQH1Mb1zxLrb2MqQborKvq13H3MSZnus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaNlDj92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaNlDj92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553541F000FF;
	Thu, 17 Sep 2026 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666902;
	bh=lSl9WBF4p26MEXIwLT4iL8os4DmHZ91WtlLG77pL4VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaNlDj92ax4HIsNB0Obt16opiSsZz1Pb+12tVDtDizpzRi23j5jxbPpaNlLIR7+Vu
	 dcZi/Zx/DmajhqB4aDbAEBsGX4a53d2xzrpCnpzbpujFNLiVDqlB2ksUCdTM4V4GaL
	 syTlfIhnW426pjaHXLaUW0o00qsj+bq9SzQjQ/tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1146/1250] xdrgen: Fix union declarations
Date: Thu, 17 Sep 2026 16:15:41 +0100
Message-ID: <20260917151623.329631785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit f7cb94fad4e6cec354a3ea779f91fe5560fb72b6 ]

Add a missing template file. This file is used when a union is
defined as a public API (ie, "pragma public <union name>;").

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/sunrpc/xdrgen/templates/C/union/declaration/close.j2  | 4 ++++
 1 file changed, 4 insertions(+)
 create mode 100644 tools/net/sunrpc/xdrgen/templates/C/union/declaration/close.j2

diff --git a/tools/net/sunrpc/xdrgen/templates/C/union/declaration/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/union/declaration/close.j2
new file mode 100644
index 0000000000000..816291184e8c5
--- /dev/null
+++ b/tools/net/sunrpc/xdrgen/templates/C/union/declaration/close.j2
@@ -0,0 +1,4 @@
+{# SPDX-License-Identifier: GPL-2.0 #}
+
+bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr, struct {{ name }} *ptr);
+bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr, const struct {{ name }} *value);
-- 
2.53.0



