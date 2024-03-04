Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85C67BAF5;
	Mon,  4 Mar 2024 21:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587612; cv=none; b=HQaPdQiKBQSHvVFja7LLJBgodkCA2lj2gmx7eGEMqEOTuMEDLJqhJ0XQ+Inm925rJ9cuM4ol59F8UQB4p3g42EAXTruM6t5J0vGLaFfWXF700BZpCMuTFGOOrB8gUSNBYq3hLqh09y+awqQGFJEUlhClZqDuOVv0f8UYk+DON10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587612; c=relaxed/simple;
	bh=mFMQ+Dwdpo89a05mZXNMoHhf4TZU4ZtTKZ6fYtIw17g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeyFbDJiE9n0XihvG8A0h6xKUiwOM/bHB5eWfjkeYNuA5xiDJygvCouL+bcyR6Z04GhXe6nGi0jUygWb/qMxlFb2JgNjqZBOaBHOq5M9xZFmyOU9P+NQiEvQyUVqTGKkoDNWZMbLMCR9k+rRR/g2n57m9YnMFDXJU4LGaTC1gHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrnS+TjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrnS+TjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39494C433C7;
	Mon,  4 Mar 2024 21:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587612;
	bh=mFMQ+Dwdpo89a05mZXNMoHhf4TZU4ZtTKZ6fYtIw17g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrnS+TjBgqPRSaASJw+9Yy4qr0P0iNhJgFiev3rQioVIKnQnbZSxYvOoLZqIIyg+k
	 YMFpwUuZXDKwAzMbQYrWYTjN2DP7wv9/pwd0PgYQp5PLSBpiwlOyxigQXV5kVHVya3
	 QTYQ4DwkZe0LtpSFmaZYLN6eBuHt3z1cEbWEhGRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 023/162] uapi: in6: replace temporary label with rfc9486
Date: Mon,  4 Mar 2024 21:21:28 +0000
Message-ID: <20240304211552.574254001@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



