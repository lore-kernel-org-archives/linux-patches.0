Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE005FDD8;
	Tue, 13 Feb 2024 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845062; cv=none; b=lkCGBk0nPQdUUG0+u231Ub7yFazRZoAKgwVHFyG6Q92/0szoqI7dmQ+1PdJNSG4KqiBtbH6GRdSRDwnYY6LtHP3prLKSXNBA2z79QbSP7UDYSI97lzMaaPbYwttrP6B3xIiACJytx4g16rbNIboeIKyrTYoVRnEAllQEUnTYIA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845062; c=relaxed/simple;
	bh=imGVp+TOkA1hF2RPSsKtfvJ6oaFZhY4HrS93RvSBiM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Om1por/SWXVDO04u5ePMt8Y6ZLkmtqy5mcle3/C7b7Se0lrRKs2K+3wTcDv1CZXPYp2nE/cNlkQa39fT2YylM7P8IMSxiMWPhqBwri/Q9AtAux9PJ6QUrHBNOhV4j1+0EJc/MT0GEkFHXV5KS5/ZPThwpAGmhBhAA7+aHRmQO4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlOCOYd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlOCOYd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D5DC433F1;
	Tue, 13 Feb 2024 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845062;
	bh=imGVp+TOkA1hF2RPSsKtfvJ6oaFZhY4HrS93RvSBiM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlOCOYd3ueoXAsJzAqjqG9/kN2Pq2qw4dH/ZalaXpETFbk6d6nlbfMp1Jrgl9dI+5
	 hsVQ3WRyYSCW0NXQY3j5D1jycCw2QSmm7/CJSE0r+Skvjf3i6V9tnqY8BMmTohtj4+
	 ZViD+SWavCjee9PTTEz3bRPmRm+5D0AyddtPizBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/64] netfilter: nft_ct: reject direction for ct id
Date: Tue, 13 Feb 2024 18:21:22 +0100
Message-ID: <20240213171845.886386946@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

[ Upstream commit 38ed1c7062ada30d7c11e7a7acc749bf27aa14aa ]

Direction attribute is ignored, reject it in case this ever needs to be
supported

Fixes: 3087c3f7c23b ("netfilter: nft_ct: Add ct id support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 1101665f5253..8df7564f0611 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -484,6 +484,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		break;
 #endif
 	case NFT_CT_ID:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+
 		len = sizeof(u32);
 		break;
 	default:
-- 
2.43.0



