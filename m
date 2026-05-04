Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355B35A3AD;
	Mon,  4 May 2026 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904396; cv=none; b=fZhhxCxzdl0Yp9svC9W+UAI2IQnlerNrNZEo2YcdIDdJR+2PT8W3omzMSs5TskcHTylGlhlIDcXHEHSEZWu6EUtuzjWxylYZqVYTJmvQDgp/2+wHRdfmlOUnPd4yE/Rcf6Ied3MggOuSwC2DCIxIoi8cHHH0LrmTO071OhwiNaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904396; c=relaxed/simple;
	bh=mFyBGfVgPCk3t2pOsI9j1//lQtcbieOSG/tqOO3i+KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaBPNpQcX+S4hu6jWsJ4U7Sb+PYvsYkj9Vmjt7BzwrRIivBHDrnCLANg9IP20lgYTjdE6ekSP5gTWGW88mjGrXPwrqFpjXwTHOd5HuIhaWizQiyKVGoqt+TtDtOi+7WLMcBNt/JQt0vzUarZv+IF8EnNWIBSA4oDzc3Vbe+PzCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IiXVMBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IiXVMBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6B4C2BCF5;
	Mon,  4 May 2026 14:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904396;
	bh=mFyBGfVgPCk3t2pOsI9j1//lQtcbieOSG/tqOO3i+KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IiXVMBw1ggbkxVu2qWUuyx8VVuSIl/Yk/s2wTl9LminSxS3h8MpgiJWDV1ok51Cr
	 JaYer65k1diEoNtEjPts9Toj9hqf6A/BXfEj2lJpU0qkYRRoKWpqP40MGqUOfKyfxJ
	 MmMH4Cp87WvIjnMAogPgZFgLZTvvIEcelOcKYda4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bin Lan <lanbincn@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/215] padata: Remove comment for reorder_work
Date: Mon,  4 May 2026 15:50:41 +0200
Message-ID: <20260504135130.987545786@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
index b486c7359de2b..765f2778e264a 100644
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



