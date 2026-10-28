Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212874;
	b=13uzdCP6ZE9/IjwpDWM1D2qBTcydVnAQ8lpiIolBkmtzgaCS70gdJnjZ5H5GWk0vkZtj
	 +WNtFxetTTJyYq7GlCRoCOtV6a4SPLp0SOfbl7h09d3iAFnZsGAxOkCrh7vyHV7snUXvL
	 7A8IeeFBldq1vlF1VceFOyZZTxvDrP6bP7ZaCVLYafmBx8qZYmeO1kM86RmmnMcFq2I9H
	 Dc439QBpSkNzSiDpjVDlD+rM6rYgyjdu18y9FQ8pmErpvk1hLwgTj4VV6tgDQ9RmbNZn2
	 L5RDRUvZr+OMo0YhJUB+nuzgv6zfOm9RCUNOeoP+rzblXHGWdzmft2fQv1BMwYXWL+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pCRbm/0wQgrb17Axk6iKHrnaOS9GThA0RXArZIAjmo4=;
	b=JqksvVAWYQFQh+B43ukWktIfOXcRa6nFdSvDNnDM7SPhGX+zzEXZ5XqXK+jRQEijyYq0
	 QKi4w3D95mwt0kxFY3WpTKaC5zIDF9Sz8SLKqtMgfIjVqDjbjk/r5ll+UKwezki7xkKvW
	 qb1TwFRtSFubhoCwXasZUK+vlNxmR/A2SPny7SnRXAq0XnP0mRuui7h5CBkuOtQBNCR5v
	 ohvRdV7y6l7OaKxUV626LAtABaKrKV118wS4wm8VT5etU38GBr8lC/YtOzEnPl5zBy6bF
	 SH3yEbtjBlKnalq4lp+5R9Qyu7YAolLG8wISLouP2OWAYoZxdJnuANX+Ce+bUMxPxmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEFactBr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA40606A31A;
	Wed, 28 Oct 2026 18:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEFactBr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE261F01825;
	Wed, 28 Oct 2026 18:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212874;
	bh=pCRbm/0wQgrb17Axk6iKHrnaOS9GThA0RXArZIAjmo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEFactBrfEA7sGChrqSfz+6XswKr8MplJp9zbnJRqWk0unK8sUXVL5SMq/J28IxoQ
	 HxWEQ+ioFdKBN19nZSf3h8XtuPC0lDkxNFvYVlxkmn4/ubxIYIuFeF5wahxKQQzX43
	 eFQGsSlmYg5DgicOXL2eOhOchbDOfBSAJLupGdaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0308/1887] nvme-multipath: fix underflow in ANA log bounds checks
Date: Wed, 28 Oct 2026 17:40:04 +0100
Message-ID: <20261028170506.239134343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 63fa2d9c9c37020bd2703fe2a6a38027b5abeb15 upstream.

The number of ANA groups advertised through Identify Controller sizes the
ANA log buffer. The ANA log header and group descriptors independently
supply the number of groups and namespace IDs to parse.

Both bounds checks subtract an untrusted object size from ana_log_size
before comparing the current offset. If the object is larger than the
buffer, the size_t subtraction underflows and lets the parser read beyond
ana_log_buf.

Check the current offset before the first subtraction and compare each
object size with the remaining buffer instead. This rejects inconsistent
ANA data before dereferencing a truncated group descriptor or walking an
oversized namespace ID array.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -616,7 +616,8 @@ static int nvme_parse_ana_log(struct nvm
 		u32 nr_nsids;
 		size_t nsid_buf_size;
 
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc)))
+		if (WARN_ON_ONCE(offset > ctrl->ana_log_size ||
+				 sizeof(*desc) > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		nr_nsids = le32_to_cpu(desc->nnsids);
@@ -632,7 +633,7 @@ static int nvme_parse_ana_log(struct nvm
 			return -EINVAL;
 
 		offset += sizeof(*desc);
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - nsid_buf_size))
+		if (WARN_ON_ONCE(nsid_buf_size > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		error = cb(ctrl, desc, data);


