Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7E84CDDDF;
	Thu, 17 Sep 2026 18:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671336; cv=none; b=RprJ8a0ugiNFRv979A6kfFt5BGrgjIhwhgQ4QrLnhKEi7WQ2JmEZhXcMrvAi3fF7AfZnlKFr26XU79L4vX0YSIm1FxUdQOL7+yLbbKVpFnyWZP4ysnhZw1q1lQEoU4EUEerS0YDRE5ElcZjtkhkhyEP+5FBtoQ6iFeUAe8liEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671336; c=relaxed/simple;
	bh=hAZGhu+C66lkyKx9JdT+M8WyQd9yGNABsRuv14ZB5YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJE4L0SJDLAJLt1W/P8I2VieGMyVQyr59jbLWbJ73vUiqyNbI5XKimcqdfRsJ9qmDLYjnGv7GAy6rcO7+co12kQOR239nISzo+y1LGdRlpVp3kUSGkgAuVziOou0/2gavP+qN5U8TKKUKcMbAdF+qZVaoc7Rzjf1GBWqIH/anxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1QB4JzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1QB4JzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302B31F000FF;
	Thu, 17 Sep 2026 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671334;
	bh=eq4gGX5bFAw3qFkiQuwF2F8NkF8l8p6DdUaX9/ZVt8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1QB4JzFMsdus6qbU9rhHdBlrr5niCwRSeQLXFydssVxnl/QjonkF5AU/3Zrv5l3x
	 uIWxc5ea+B+W0yAHmbmj8j7og0ycCCYw5Gwr9aQwPhJM02IdDQOto6BiNVYLP2o/R+
	 cds3ibAuRpRrQrAfmCHzzDvlpF33cZrMAveZmaOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0942/1102] xdrgen: Fix union declarations
Date: Thu, 17 Sep 2026 16:14:45 +0100
Message-ID: <20260917151604.294686127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



