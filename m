Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F652421A1D;
	Tue, 31 Mar 2026 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975203; cv=none; b=B91WZ3IWmDJ7SkKfRVsTHeCHfXRAGHZ1sCJagTqBvvkHMrU1zZu8aaRkTwVqNwep65ireNLf9in19JbFBX4+0CSTGRWtmp8xGfDPEb/6m+kCdVCrusnwqqWIrvCJKYXzmvnO2p9ymzeu+XQgst18i+0raQlZTRjsnoyEEwJmrxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975203; c=relaxed/simple;
	bh=TpHp3y4d/MvjaI8m8fN3UkCxSl6rXogVM5AmE6ehRu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgNTBXJGGXnYM0mxWV1zJ5I5Ze3aGA14NO+KyijUVClu52idJJQ2hvZ2DFi/q2Bsv7JZHt+G9w5MP8Q9cRFyLJEBT9JkPMcU2eaywQvH55yxbjJ2JJ32IMVb+MsVcABJJRdBL8eDUp9AcNDf9xXjYkjFUxc/BL0FmHp5aIBwuGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my2AXy6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my2AXy6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C9DC19423;
	Tue, 31 Mar 2026 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975203;
	bh=TpHp3y4d/MvjaI8m8fN3UkCxSl6rXogVM5AmE6ehRu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=my2AXy6k0oYW6Cml+oNh0tnEM7TvXIoRCNrFXQ3r51Il65IrfyoBY3tNPjce58c2s
	 lRmBdUkV5GPrxtaWEOG91HUzccHoP83B/xOHELUTIVokrCrBi6lBSBwCtbWCEhhUbP
	 36RzmdcMhk7x4AkNazJSyYaJNTI40+/Y4mZBDURw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 196/342] s390/barrier: Make array_index_mask_nospec() __always_inline
Date: Tue, 31 Mar 2026 18:20:29 +0200
Message-ID: <20260331161806.204065008@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit c5c0a268b38adffbb2e70e6957017537ff54c157 upstream.

Mark array_index_mask_nospec() as __always_inline to guarantee the
mitigation is emitted inline regardless of compiler inlining decisions.

Fixes: e2dd833389cc ("s390: add optimized array_index_mask_nospec")
Cc: stable@kernel.org
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/barrier.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -62,8 +62,8 @@ do {									\
  * @size: number of elements in array
  */
 #define array_index_mask_nospec array_index_mask_nospec
-static inline unsigned long array_index_mask_nospec(unsigned long index,
-						    unsigned long size)
+static __always_inline unsigned long array_index_mask_nospec(unsigned long index,
+							     unsigned long size)
 {
 	unsigned long mask;
 


