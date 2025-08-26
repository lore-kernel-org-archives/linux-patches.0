Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2A129BDAE;
	Tue, 26 Aug 2025 11:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207627; cv=none; b=kCFPEdkeQANR8YYZtLRVThPJLMTE8b/ee3wGOKamzYSwtyBL/msbyh6rQ/8z3YDXO2dN6ETYkslzByXYyNmXAkT7Fz285nhOg9MbQHlFtxvG8XigjV7b45y62oqDWeqCN51MpcdkLJ3gl2/CsftChLPSm0TEzUN6ER3uPVXnhaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207627; c=relaxed/simple;
	bh=3GTLrMQittrIvipEBSLKz7Rkz9lnQJ96lNsdd8XSzhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7PO7c5f7Ajn5AhEn/OFS860Zratu5Hk3QgWQAn3mUZYfeIolXX7DOBbfgjxPjX2vxuZ7dmcCpuDNtgxQiNoyg2KK63xKJ3YcqnyuxDdu+tQv77sGjiKDxusZJc5AU5zAfv5M79dEdp+TjYws/OLtPE/ZaWU/CqWg3e1WWGrgI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDJUqJcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDJUqJcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F721C4CEF1;
	Tue, 26 Aug 2025 11:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207626;
	bh=3GTLrMQittrIvipEBSLKz7Rkz9lnQJ96lNsdd8XSzhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDJUqJccbvYE5dsH6dMXLD8y1hSk3mNJULK8FHtzt+Z3q5+ZO9h2SBeZXe1/PBnXX
	 cb8FDp3K/ZqrTcyUXbdV6xnM5LfUr4Xw+890gYvin+rYsuOtHqy2Y2gWqMepDCXbew
	 g+2YhnAK97bPGXBmuk3lYoHbsH9uTDAHVYKxKN+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Tomer Tayar <ttayar@habana.ai>
Subject: [PATCH 6.16 256/457] accel/habanalabs/gaudi2: Use kvfree() for memory allocated with kvcalloc()
Date: Tue, 26 Aug 2025 13:09:00 +0200
Message-ID: <20250826110943.682326271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

commit a44458dfd5bc0c79c6739c3f4c658361d3a5126b upstream.

Use kvfree() to fix the following Coccinelle/coccicheck warning reported
by kfree_mismatch.cocci:

  WARNING kvmalloc is used to allocate this memory at line 10398

Fixes: f728c17fc97a ("accel/habanalabs/gaudi2: move HMMU page tables to device memory")
Reported-by: Qianfeng Rong <rongqianfeng@vivo.com>
Closes: https://patch.msgid.link/20250808085530.233737-1-rongqianfeng@vivo.com
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
[lukas: acknowledge Qianfeng, adjust Thorsten's domain, add Fixes tag]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Tomer Tayar <ttayar@habana.ai>
Cc: stable@vger.kernel.org  # v6.9+
Link: https://patch.msgid.link/20240820231028.136126-1-thorsten.blum@toblux.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/habanalabs/gaudi2/gaudi2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2.c
@@ -10437,7 +10437,7 @@ end:
 				(u64 *)(lin_dma_pkts_arr), DEBUGFS_WRITE64);
 	WREG32(sob_addr, 0);
 
-	kfree(lin_dma_pkts_arr);
+	kvfree(lin_dma_pkts_arr);
 
 	return rc;
 }


