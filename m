Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256801EB5A;
	Mon,  4 Mar 2024 21:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588941; cv=none; b=Kv4DmiiLrh5d/V6i1JOQYSg318zhu/VI+e/OU5Y1Yp938bNewAD07hgg/cctQxo4BgeZu5ndY9lhKXm+Jptk4mCXFLKhT469hfXGSGWLQTPQ8k/fM4RizCwcSEOZ4uu2SpNhfRfAoUUOqwcAyCWmOnHj1/hbyTKoeCVgx8HKINo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588941; c=relaxed/simple;
	bh=SUpGazP7vv8zJwQDnzmTv+SZ0F9qCT74g59sPl8lXQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9Orocroe20ak3wYctRDZ+SZ2Npij6ejX7S3jqWOGspLTOGR9CuJjO2EFZtOTlMtyzsotLm4RA+v2cI9oc0sRc/Ru/n8Z6IuxSqCsi+ujRV3cOKsjhVPbEwqLqSOx7FQCNdY2t2S7GHlS6E2s7TBEQqGcbsA9OTt3TXQgOp3s04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rT3PEu6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rT3PEu6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4CFC433C7;
	Mon,  4 Mar 2024 21:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588941;
	bh=SUpGazP7vv8zJwQDnzmTv+SZ0F9qCT74g59sPl8lXQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rT3PEu6DhSCEbxTOmxY/b8xD7RBVPFpH5AcGddAD/eWh2Rt3WcBnq7Lzt6EBu8yuA
	 l1FY4AxGH8Z2iSn87L+DUzGx/tjKVyhHwH1J5tyjpRTIwOSPzdGMCiRlZ529ehbn4t
	 SGTb3vaF78ppNBhuRXKUUw94UruRZihSnGps6FKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 140/215] decompress: Use 8 byte alignment
Date: Mon,  4 Mar 2024 21:23:23 +0000
Message-ID: <20240304211601.502033472@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 8217ad0a435ff06d651d7298ea8ae8d72388179e upstream.

The ZSTD decompressor requires malloc() allocations to be 8 byte
aligned, so ensure that this the case.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-19-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/decompress/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/decompress/mm.h
+++ b/include/linux/decompress/mm.h
@@ -48,7 +48,7 @@ MALLOC_VISIBLE void *malloc(int size)
 	if (!malloc_ptr)
 		malloc_ptr = free_mem_ptr;
 
-	malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
+	malloc_ptr = (malloc_ptr + 7) & ~7;     /* Align */
 
 	p = (void *)malloc_ptr;
 	malloc_ptr += size;


