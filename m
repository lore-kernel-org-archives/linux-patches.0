Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F6E3438AE;
	Sat, 30 May 2026 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159818; cv=none; b=dXXPRLMoEGrR3MmG4K4ArwgNtN+v6WB2X1dzYONFGjxGFpbX3hsBFEOXDMHjcAYLIr5tqrmQQwaU0wUe1XFhoZxcA645tMapImpjRPKP+lcDNzl/j0saWaci/mFeildMN/xhgI0q8Xk8irqp81S7nF7Q1OUiLvbZ+9KPFvpiZYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159818; c=relaxed/simple;
	bh=Bc7e2sG1Pz+iKve2fp+CVYRUoBmaVEAGFTXga3PS93c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTCCKTeUKlUAeXpoVO1+WAZGPjRzi5iTfk/Hr6tqjuS5rQvilDBjWVNAXtJwa/SMMULkyVE4sRDhpj7XDer4fK5UHk0tHIszzfDcNNcnAVEZOkqf6AgQzV6yHHr+KaTdnQTxcBcNrr3hCnffcXw7Md4SnW4oxMQSyKICaFMlPKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVByuF3r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVByuF3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B431F00893;
	Sat, 30 May 2026 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159817;
	bh=qgsAbTsUFnPY5cIJMS7pfmXVlVDyphBoDbEf52AQouA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVByuF3rbuTafsN/H+76lo44W6oK510eaaeZywAmYha5o8Kaf1syrNqi5l0Khz8sY
	 9fajRv6oSW21A7KJsTPwtVHaKNeDIrQSN+l0rech9g13qIr2LiiX0QlmIShwRqN7hp
	 m6/xRz+ECEfSdBU0CjApWvsqpARD3AgwZ8jCSu/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bin Lan <lanbincn@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/969] padata: Remove comment for reorder_work
Date: Sat, 30 May 2026 17:54:54 +0200
Message-ID: <20260530160305.202799331@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 82a0302e7167d0b7c6cde56613db3748f8dd806d ]

Remove comment for reorder_work which no longer exists.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 71203f68c774 ("padata: Fix pd UAF once and for all")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/padata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 9ca779d7e310e..6f07e12a43819 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -90,7 +90,6 @@ struct padata_cpumask {
  * @processed: Number of already processed objects.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
- * @reorder_work: work struct for reordering.
  */
 struct parallel_data {
 	struct padata_shell		*ps;
-- 
2.53.0



