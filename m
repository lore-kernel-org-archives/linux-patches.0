Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E91D1AC43B;
	Thu, 15 Aug 2024 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731154; cv=none; b=Goiq5VXntyFLFak13MOsiL5UuKCnkRnrUJ1PciRGPDYzCZnWKQcBvw/lNO1h4C1iHrinkdi+5I8yF1CdhYKD5HVM2wF6nxwflYJTHndLLWC8os5zoAh07maJBUN8ctwW5arXuvWiD71/fSnOVXg97iznF0CeXZZ15yLzonZBTFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731154; c=relaxed/simple;
	bh=q0mOrHt6fvpfSDVH61HRC8fr3/i3RLUUo0ZQWa6BqNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo1vrMuZKe3wWYp7JpJ35jPkGJ5vf8y3BUtb1i8/ApQs9UDoouX2sobKgEzaTw15JVkQtWk0kXmsiML7G7gDfpUgP88vzM58Vtwf/s8cWIanSV41p2dXUoDmMEMpX4ICuzGAUtHe0tBhfc6Pu0mSbZtNGPj9BbjxH0nzeGA/mQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2tA6/Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2tA6/Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABC4C32786;
	Thu, 15 Aug 2024 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731154;
	bh=q0mOrHt6fvpfSDVH61HRC8fr3/i3RLUUo0ZQWa6BqNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2tA6/KkjWbyTvdSZRRX/3PP937En3Pq4MyARi833Ndnj/5hRJwoeButEPWCJgeFv
	 Il9FqEiVGoVVj9i0LlMFH5syjlAeB8m5XRaNMZANufq4CcF8Oa+Y+8zY66+WfBIQS+
	 GALLToGdHyIYDhV3tIBi0Yfl9Palplm0TFouoz1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/259] netfilter: nf_tables: rise cap on SELinux secmark context
Date: Thu, 15 Aug 2024 15:22:53 +0200
Message-ID: <20240815131904.350154462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bc70d580e8d65..3e6c61d026e35 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1213,7 +1213,7 @@ enum nft_secmark_attributes {
 #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
 
 /* Max security context length */
-#define NFT_SECMARK_CTX_MAXLEN		256
+#define NFT_SECMARK_CTX_MAXLEN		4096
 
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
-- 
2.43.0



