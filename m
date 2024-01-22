Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AA21078B;
	Tue, 23 Jan 2024 00:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968249; cv=none; b=E2AuoLc6qgT7Fo+9nR9YQX46fbWhpvycYLjijNmftykXuibWr5xaj9ze2+P5UdpmLvRKyQ3piI9jSE0LHAM6PsVCxECRIupSOW4nSmLo0cOPMASlqMxnvfyRSKHdXO+etAGZEUcn/Uu4S9yQ4ogHtE4z7x0C3cefEKjt/9npTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968249; c=relaxed/simple;
	bh=oiLn084h36rL4VahC4EwflRdtdt0DGIaGlaWDCNb2ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leXUQ6qulhIF5Ahbb58mZWF7p/LXGvUNUNfuS5A+79BN9aMR0uIdcAh9vioEg7cdJMBfBUMueKul1mu/tPle8GngVve/KOLShIILqy51D49TGjzeSeSQcWsHZeNKI0Xi/Jt7QRMXnQF+Hbm0v16dsnGSRuAMeaj+2XCNHhaUZos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5IPh2qd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5IPh2qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C49C433C7;
	Tue, 23 Jan 2024 00:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968249;
	bh=oiLn084h36rL4VahC4EwflRdtdt0DGIaGlaWDCNb2ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5IPh2qdrpHKYB2ye5OmD6nrW727R5fulkDthKXVBoXj3BXAnLE7l2qcoc9Et8/q0
	 CZDuyHEipLDy9qeAAG9ICPPthOyZq27/dGtUigUTM6fJFyhkybxPa/nLiSImQ1Ux5Z
	 YYorNSGqd5uPjFSWnb3mVwIp5FadAmw63qlAAsfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 4.19 024/148] binder: fix comment on binder_alloc_new_buf() return value
Date: Mon, 22 Jan 2024 15:56:20 -0800
Message-ID: <20240122235713.409184501@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit e1090371e02b601cbfcea175c2a6cc7c955fa830 upstream.

Update the comments of binder_alloc_new_buf() to reflect that the return
value of the function is now ERR_PTR(-errno) on failure.

No functional changes in this patch.

Cc: stable@vger.kernel.org
Fixes: 57ada2fb2250 ("binder: add log information for binder transaction failures")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-8-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -535,7 +535,7 @@ err_alloc_buf_struct_failed:
  * is the sum of the three given sizes (each rounded up to
  * pointer-sized boundary)
  *
- * Return:	The allocated buffer or %NULL if error
+ * Return:	The allocated buffer or %ERR_PTR(-errno) if error
  */
 struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 					   size_t data_size,


