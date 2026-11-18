Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053547;
	b=p3fVvPO4qhoCKOvGu/edjKCGoX+hdxBWQCmdHR60CeH6qGG5KIxKx37b8+VX8bwr1Iwx
	 SnN+xyyYmY7bROOOfG95Gb9kP8oNQmSO1fz1Lb4gS79N1MetEAN2XWoYEKItMcS9NRadl
	 g9P+zUpBUqXGHKVAlj5kBWBdDra+f1eaUby5BktCaKwdIvxyBFLCQDy9BQPSV1fSzNgb4
	 zjKRG+URm3mi7hMPZqeS5J1HtESh1sISEhiK3dbUSnu92lqOYLm43Z75SSVgTDK/RHp+z
	 GNDpINX5ZlWYp6S1s4gnz3VMrO/DZhvwc9MCibzvQvPhOMYz4T+kfRDRIetQaDdnXeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUv4Cf8E2GmNNSuYb2j6DY1kxS2n0tbPVxB+nTlJUgA=;
	b=Q3R5qOKt28cfjUv4Wgzn16Fk4ls9HBeBv2CJLaaYJZguudGu4qMDD6frfxsH+kjcGxpi
	 NPPo7ACp4ASfn1t/b2ydJG3hzkJ7UnpOpoQyoVQEBRLEGmqOKS7hcmnOBvaoHVYwTWkwJ
	 T56dFd5ZRYrm79xPTlEe12c1bmMKqB4riyvKpITwzAxheGAJVa4ZMr+pd5COJ5hFAGJxd
	 T6dd4a1TuWFf9P8M+JS4wogV6nUXjOCpPDW2utLU/+vRZbb0XApq7nSVjn7LoySqb5hdy
	 355vzHWzZI9qN0FEzlcQBWrKbUYo9ig4sqzM9PCc5jUNsadWfqgOzfz0nGFGt7ke3hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCV1rmOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8499E606A31C;
	Thu, 19 Nov 2026 01:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCV1rmOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3241F000C4;
	Thu, 19 Nov 2026 01:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053547;
	bh=tUv4Cf8E2GmNNSuYb2j6DY1kxS2n0tbPVxB+nTlJUgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCV1rmODvT9BDXcr4E6Mrk3109W5teD6UQVsTonbpS1c/Ux3uzRviQNr0myXM3oC5
	 fS+gZsN1a06quJNEXhYmVdNSJAMKalmhhOxhbDEtfHn7DL1SmX5yn9b+KL5XWvV3Yo
	 OFRc1F6fjygXm3Boa7saPWg84eah3QdOOMPzLaZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunpeng Tian <shionthanatos@gmail.com>,
	Gongming Wang <gmwgg05@gmail.com>,
	Mingda Zhang <npczmd@qq.com>,
	Qinrun Dai <jupmouse@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0958/2214] udf: Make sure theres enough space for LVID implementation use field
Date: Wed, 18 Nov 2026 15:43:54 +0100
Message-ID: <20261118150050.627390579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit a61fb39759d719a4f4966742b4d28387e33d81c4 ]

udf_lvid_valid() verifies that the LVID has enough space for all the
tables and the reported length of ImplementationUse field. However it
doesn't make sure the reported length is large enough to contain
logicalVolIntegrityDescImpUse structure which OSTA specification
requires. This can thus lead to accesses beyond the end of LVID buffer
for suitably corrupted UDF filesystem. Add the length check.

Reported-by: Yunpeng Tian <shionthanatos@gmail.com>
Reported-by: Gongming Wang <gmwgg05@gmail.com>
Reported-by: Mingda Zhang <npczmd@qq.com>
Reported-by: Qinrun Dai <jupmouse@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 781d2a9a2fc7 ("udf: Check LVID earlier")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index f9fe3f950de85..6857c15f5a0f4 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1582,7 +1582,10 @@ static bool udf_lvid_valid(struct super_block *sb,
 
 	parts = le32_to_cpu(lvid->numOfPartitions);
 	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
-	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	if (sizeof(struct logicalVolIntegrityDescImpUse) > impuselen ||
+	    impuselen >= sb->s_blocksize)
+		return false;
+	if (parts >= sb->s_blocksize ||
 	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
 	    2 * parts * sizeof(u32) > sb->s_blocksize)
 		return false;
-- 
2.53.0



