Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8F42F9C23;
	Tue, 26 Aug 2025 11:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208694; cv=none; b=aCBC8JEIOHXOu9B5uVg4p65RqJdBR0uqZ3qrDWM7flvZ5VVsgxeOYSBj0V7wnLv0+O5aLuMichu0vKLjf3C+1DBbg8oAHwfKQGayms+TSSU52ApuCdB92M5YNIOfCeqOorhjILOLb1F93diSg1NNKB8YV1csnjhjJMSki3csdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208694; c=relaxed/simple;
	bh=WByepcIbCPruavbIkKL485Za4jYesReSp79qirv6rKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtVzOwCjs/8C/jjYl5YSSDis3q1Y6bGzjGhNAmr/oVMnUG/qzg5Wr7vGcTM+9qGI/mqfwbGhzwG/WIPTg0H19IZb322U9ZcvsiKrk9nrMSptLjST43UsvSoI3RqvmVXp9T/dlPy90LUIF2wwPXfoPVxk1ZmNygNoG658N8za+FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLhZo+OC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLhZo+OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C521BC4CEF1;
	Tue, 26 Aug 2025 11:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208694;
	bh=WByepcIbCPruavbIkKL485Za4jYesReSp79qirv6rKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLhZo+OC41+bL6Cs6GaBUocGehHuScBwCuevT8VYp02zWWwuN6r6lOqKFUJBOw5R2
	 nRe+VWcAzLdilUs764DukFz3jyXoVdBTBzCepVsRjiBO35NH9pgamjbLKoeKSzvHL7
	 YdBM/JPb6M+32cavWgeEnput6C7UUkhiKQY1uryo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Tomer Tayar <ttayar@habana.ai>
Subject: [PATCH 6.12 179/322] accel/habanalabs/gaudi2: Use kvfree() for memory allocated with kvcalloc()
Date: Tue, 26 Aug 2025 13:09:54 +0200
Message-ID: <20250826110920.282858201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/accel/habanalabs/gaudi2/gaudi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2.c b/drivers/accel/habanalabs/gaudi2/gaudi2.c
index a38b88baadf2..5722e4128d3c 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2.c
@@ -10437,7 +10437,7 @@ static int gaudi2_memset_device_memory(struct hl_device *hdev, u64 addr, u64 siz
 				(u64 *)(lin_dma_pkts_arr), DEBUGFS_WRITE64);
 	WREG32(sob_addr, 0);
 
-	kfree(lin_dma_pkts_arr);
+	kvfree(lin_dma_pkts_arr);
 
 	return rc;
 }
-- 
2.50.1



