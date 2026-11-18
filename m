Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048238;
	b=DYXS/JnQkz2yaBNFS6++UkAsRadyR9iYjGakRlPUlNV0GjLbi7p7G+uol0xFpqBK7knS
	 BYhsQrHLDwCihBZIbZrDDe6DR/gJRQ5hlIeoeII85ou0F8a3Op1qc7yq8B1hXXt9sQrqi
	 3LGogoFwqLYwpFF/fBqIpEZ5c6C/TtCf8yte/1bN71Y7yNFnrGHRRlqzL3cG+u/45QKzv
	 AUalR8DOwiT3oyyoHHsxKXe2CLxz2No4aM4hSOqH3nP1Pjh1Fr75ZrFV91w1ew49kjFqN
	 KhE68FF8C3VoHFSkuRk+8M97TH6N7s9XEar79uVwWBReD9YVmgybX4qVVLTwYaONCgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9MmM1fvCsWCPJ9GVAEVYLRM2HTWfBt7HXsbcRWhdS2U=;
	b=XIXnMJvssAU9DkHxZmDaWUTo59hFYgaMZ2EONFGmjPRoPOIPmBIwPQhsoZBsLdnByNGv
	 NeS0ubelRLmc/bLFf82GLQJ9UxBIzOjTMbmB93LXpbcDq/zKiD90ouICIHaC8+ikUvW0W
	 1KtJUwKt31BTPREcvlNw5BcOtsuHdZaiKmX+J+UPxuoH+WEJzjPvcMnsdhg8GjlYfJJsg
	 ILT6yG8D/IO6So8sA88yXCm8Du8jFAxh2JgUFygJBdftDROJx4Cb2C22PjiqGA5sOQA6Z
	 BVOT7P9FiCNVjDV5QaAPVl1YjWvtM3iCZfmsiNquCJQdXisZ8L/S0ghwe4sR2yqH9wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RigfeB1N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF6D606A31C;
	Thu, 19 Nov 2026 00:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RigfeB1N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EBF1F000C6;
	Thu, 19 Nov 2026 00:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048238;
	bh=9MmM1fvCsWCPJ9GVAEVYLRM2HTWfBt7HXsbcRWhdS2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RigfeB1NexAqC98FR88mtTwynhbDJWCiGt4ZAXj8BlvTuA/K7UOdSB0MTzKYLrRjT
	 UrSfCQ5jSMKnPJ7I42tInYEe8rIMzXvUqFnrwu1Wre4H41IzP7eJpqqlXeN9e8vJbk
	 eb/vkhMmRfk03aEDVEA/yJfbjRNR5SRP/hXlP6UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1923/2857] ntfs3: Remove calls to set/clear the error flag
Date: Wed, 18 Nov 2026 15:49:17 +0100
Message-ID: <20261118150310.448547279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 326a6fd9600c52016c3c18c1aeafca2fab254146 ]

Nobody checks the error flag on ntfs3 folios, so stop setting and
clearing it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: a32e893a077a ("fs/ntfs3: zero frame pages on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 7f54f5c712471..aba6783dc64f2 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2252,9 +2252,6 @@ int ni_readpage_cmpr(struct ntfs_inode *ni, struct page *page)
 	err = ni_read_frame(ni, frame_vbo, pages, pages_per_frame);
 
 out1:
-	if (err)
-		SetPageError(page);
-
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
 		if (i == idx || !pg)
@@ -2839,7 +2836,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
 		kunmap(pg);
-		ClearPageError(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



