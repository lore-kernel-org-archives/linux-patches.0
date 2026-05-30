Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAED279DC9;
	Sat, 30 May 2026 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165671; cv=none; b=PrQXb0Lu1Kj5GEwtTm9sy64+x9C+syprriUA9EtbBf61Wtt15zcWo4IClcQ2bm4ObpmjuD6V9j+36NNRy3FIIXyxJxXF/I3/X7zxHQYnjVINyX2EPbPCNWX08DR0avcLZa+QIVFQ7pfdR2W873rdArK0K8fG2/nAK74SAiHFmsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165671; c=relaxed/simple;
	bh=RxHSd9MX7TKjbZGUHElORCbTH5V3WI+vWsFxOxrCvIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjVghhmD8aQUItCVuB3eUmzyoa+t3AtPI2JSPjzUqjeDXYSR6KOc2GXRKuJcwb8/7qa/MjD/TxUmr/RskFafKjsufMmDQ7b2/p5A8dXLbrRw7dTr5dxRJWqjn9dz/2MX4ZoezFzF/AcFGoR+CW1B0+BxXNHwUJaipgIGqhFaEPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7HTOqNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7HTOqNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006701F00893;
	Sat, 30 May 2026 18:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165670;
	bh=Pk0zSkUZw95eBrAtd/rbWcZVFL/GfnBRmN4OtVquo3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7HTOqNjuPJ2cCPLQa4pTAFZ+65SEiO017i1NMQ08zfHDYL0DM/lHaSpC9bCoOKx5
	 CN5MNVjh8+eu+TRvXD6rbDvseXaON7PFrBR1NHcPBZWVRlSPvqhbxMrly8jeDAaIai
	 LaOt+E3E8DT8WZVy8I3q6B5AZxPkiyxj7LN9Zxko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bin Lan <lanbincn@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/589] padata: Remove comment for reorder_work
Date: Sat, 30 May 2026 18:00:29 +0200
Message-ID: <20260530160228.674114872@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



