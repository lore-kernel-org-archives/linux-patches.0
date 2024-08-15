Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E899263C;
	Thu, 15 Aug 2024 14:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732130; cv=none; b=OUWuRIQu2iHJGOG64aU1Dz0g/NmlPTWmK+GzP4035UIRwa6+qpeoPBOyR7953goMPprjJmUbt0rYCG1RbKSwA3Q2RC1PxXSNBSCXG7JZoNAySaFR2WPzFNLXYvTReldPkADD4bghtqmrOM7jYqh8ViJ4KTJoGlIExd3ePJg/Vwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732130; c=relaxed/simple;
	bh=dhMiq162tpvEIhVZ4EuwPpmQ2RSp5sIjj+Re7+B7RlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uodomEaHMaA6hVTYwSLiL9HDpABSx5yYC8GMxf3Qi62AzQD/v/N3UtHjLftB+lhJ9JFXBWDzpLpGx3V81wLIJE2gfjsMtidRmzyz65563ljsD1aMjOcSs45wqUf4VB45LK0nSw9cDpU582ZXTya3I3Vp5XXLwbFtL+hSaXqHqGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEW2w7IZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEW2w7IZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E395C32786;
	Thu, 15 Aug 2024 14:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732129;
	bh=dhMiq162tpvEIhVZ4EuwPpmQ2RSp5sIjj+Re7+B7RlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEW2w7IZ6fYaMQ0ya5BWM9yRysnQTY8uucRw/x8pfJsQW0XpHyPz5MWMy839f0MnU
	 TvTLgom67V1/U+0/Jd4n7/+vrozWfmOSv2KZpOtq6IVWwzgJPInlG6nbRdhFzEOUBJ
	 k+UI919Q8ZntqdYM0H2UIQDGu2eKwIhA7H9SJnVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/352] netfilter: nf_tables: rise cap on SELinux secmark context
Date: Thu, 15 Aug 2024 15:21:58 +0200
Message-ID: <20240815131921.251102935@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f93ffb1b67398..40d9005370939 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1284,7 +1284,7 @@ enum nft_secmark_attributes {
 #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
 
 /* Max security context length */
-#define NFT_SECMARK_CTX_MAXLEN		256
+#define NFT_SECMARK_CTX_MAXLEN		4096
 
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
-- 
2.43.0



