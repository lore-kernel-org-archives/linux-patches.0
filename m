Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED84189900;
	Tue, 30 Jul 2024 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355575; cv=none; b=DG9ctEI/tnN0hGWk+K2/qVoNlfB4XgUn9rxtFOTPiI+m53jZAmeYHVtgGV2Y9sBHIMcXUUFQfKt8i4IX6kxe/fgXiBrg6K6W+gyahO1kumyCmib65/yzdTGlGe9USRHIwmjnLE57a/tshTNF/A/Dg3kWHIe4aWAIl5nltY3Th/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355575; c=relaxed/simple;
	bh=XILw5by/BYZHvCQZtUcb5VI3UNFAUAwVQs9uLu8AiGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GecKg5eIQUuT1Yltl/+7lZHajU2bRu0CHVVaRGX4HnumQZTdbRdDj7q6taXtEZOV+8FFUWj8kOHc/yzmNOImmiQjJJZbgm7/KKwZm+3rofWjNG8eYeqJLgmZYCwRUVjO9GHy1f9kI3t46wA9WKbEll9mOuTSIhMPMOsEPmnfRz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5COjNaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5COjNaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1535DC32782;
	Tue, 30 Jul 2024 16:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355575;
	bh=XILw5by/BYZHvCQZtUcb5VI3UNFAUAwVQs9uLu8AiGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5COjNaKcHyzz75NjKnyaZ/xGAIHM8fvoztDfoAYM2kOUa5ibi8622NRCSF6y1VAw
	 0UZ4sGuaPivhPJ0TCiTtHZXr+ap177jWIyzSP7WTK/wHLcFsf7tFZ8YA0PMvKYsR0R
	 BYTt7lezRPy3UX09s3SZWN4hhOuo954vD7vz5u1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/440] netfilter: nf_tables: rise cap on SELinux secmark context
Date: Tue, 30 Jul 2024 17:45:40 +0200
Message-ID: <20240730151620.069116296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e29630247be24c3987e2b048f8e152771b32d38b ]

secmark context is artificially limited 256 bytes, rise it to 4Kbytes.

Fixes: fb961945457f ("netfilter: nf_tables: add SECMARK support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 707af820f1a97..672b2e1b47f24 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1324,7 +1324,7 @@ enum nft_secmark_attributes {
 #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
 
 /* Max security context length */
-#define NFT_SECMARK_CTX_MAXLEN		256
+#define NFT_SECMARK_CTX_MAXLEN		4096
 
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
-- 
2.43.0



