Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334F72C21F7;
	Tue, 12 Aug 2025 19:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026673; cv=none; b=MEvvdANbScoHrlxIUPjTKi5VxbVKLNeqA4w5IDhoNlx+fe/ngUjQKmZ0m5KPJTzbSR+vr8GPpwcAAjRNzn7ugSY5NvY/ZWS+n0h5LsNdOpBMAJUEWjOIpSZuzKv2oIXiGLSWUpuBwt2PPe6tV9GHq6VD0jYBMGATuLJXdPCU2/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026673; c=relaxed/simple;
	bh=RyxL7jXsCir5hpc9Z2Hq6jpemDzzTqbNH9Ff9Vhdd3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB0RaxiFXm/m+Vy8dZgWPy2V+2smHTtVMTcTcXhDB6jWjpju4kVOW30aHKay+Kp9C7atqY4R21umpyfoRc1ZoHn+NJp8AbM5TmokIAJUs5i/QTeqasb5tHvkm+f1YkEodkjp26PPjTgWhRXew+0hsK1PIeR0vcZ+bTcyBMt1ZmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bK2Ba5gy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bK2Ba5gy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F67CC4CEF0;
	Tue, 12 Aug 2025 19:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026672;
	bh=RyxL7jXsCir5hpc9Z2Hq6jpemDzzTqbNH9Ff9Vhdd3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bK2Ba5gyPwd5umVF47QgDR3y460/qbHpTgv3cFSnfELZBeil/Luwe+hRLsJUI7f9l
	 TQ+Yk7kak1oiNC2zonTqVBA28bnHQvrgUpRIF8tRpbsu6FT8qluCeteWn7rAGAm0UX
	 OhX2GTQCXYuiNUWRBt+hNrplCBH9e0rZIejVfsX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 373/480] padata: Remove comment for reorder_work
Date: Tue, 12 Aug 2025 19:49:41 +0200
Message-ID: <20250812174412.818069982@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 82a0302e7167d0b7c6cde56613db3748f8dd806d ]

Remove comment for reorder_work which no longer exists.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 71203f68c774 ("padata: Fix pd UAF once and for all")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/padata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index b486c7359de2..765f2778e264 100644
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
2.39.5



