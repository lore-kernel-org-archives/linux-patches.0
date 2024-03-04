Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A52C11193;
	Mon,  4 Mar 2024 21:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588659; cv=none; b=ctwNYNFP4o9B4jRDwQYow9HeS+7cAoqp9FSO0X9h9UkO6/KcCVgGZZPLbkQc+E2gcUme2kimc1xwtToz92vaFuFQlFTUcM4T1bQ+RzMQgNCB8AUxwjvo6BPFHaAv7WKrc8cEMsRlaGhvStmZCySqfcIjd81UDfNFOEQvQd3BLtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588659; c=relaxed/simple;
	bh=mNKcchx8l0Pe0vriT/DoTIxgtvzs1caJN3sNvmp+A/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6J2/qB9EWM1XlcW/XDzM/gW1+K/dJ3so3EJPTh3SvQmHBwNuaLj1C2gD/nFYuh5wZYBque/2zJa2nv9SZG693PmTKDOLeu/QAepAr+W/dzxGGFLFnKsse2dF57ly9dc5qmWaI0v4wK0tyIhF7CxT6FEJNVheNJVqWOCaf7byKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/NcYlmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/NcYlmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D81EC433F1;
	Mon,  4 Mar 2024 21:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588659;
	bh=mNKcchx8l0Pe0vriT/DoTIxgtvzs1caJN3sNvmp+A/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/NcYlmNivyt0ZdQhvveDGG+QW5OW8reBSw2ARum5ynCY8CI9otZ7qCC+ANpPQOCM
	 PBN4/HvxnG1YZgNRzYCEiW0O1kPK3ggJiQPOQuw8a76EOvhnbhHuY+POPgOqypXygY
	 6IVerpttUX2aIhL0Iz/vvOVbPP10FRwddk0nrcPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/215] uapi: in6: replace temporary label with rfc9486
Date: Mon,  4 Mar 2024 21:21:43 +0000
Message-ID: <20240304211558.275996809@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 6a2008641920a9c6fe1abbeb9acbec463215d505 ]

Not really a fix per se, but IPV6_TLV_IOAM is still tagged as "TEMPORARY
IANA allocation for IOAM", while RFC 9486 is available for some time
now. Just update the reference.

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240226124921.9097-1-justin.iurman@uliege.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/in6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index c4c53a9ab9595..ff8d21f9e95b7 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -145,7 +145,7 @@ struct in6_flowlabel_req {
 #define IPV6_TLV_PADN		1
 #define IPV6_TLV_ROUTERALERT	5
 #define IPV6_TLV_CALIPSO	7	/* RFC 5570 */
-#define IPV6_TLV_IOAM		49	/* TEMPORARY IANA allocation for IOAM */
+#define IPV6_TLV_IOAM		49	/* RFC 9486 */
 #define IPV6_TLV_JUMBO		194
 #define IPV6_TLV_HAO		201	/* home address option */
 
-- 
2.43.0



