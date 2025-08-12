Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ADF1DF27F;
	Tue, 12 Aug 2025 18:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023375; cv=none; b=aOcw5uW8pX835O1jiP2w4854Xgl4xUOTNEyquEz6rOlboWneNe+8VGK1qyBuSE9AjDi7JIGaPRbPJecXj7V/v1BudIQn+veKrM+l4Z3cD3fa33DF0TsqZCAkfXvu/2W1hN/lDI7aQYEOpKqhmnFnWeZNjyn5rTmmJUYioy60xFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023375; c=relaxed/simple;
	bh=6+fpmnFOYIjY9Hf3lYkrKnn5ChUXzPIit59gUB5MPhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oheROVulV2H4xptSc2emHWtR6PDy6XjaLmU9sv/f0FvustF7MPrSysW/a62Lr7fQOLN4mwEF9K2BFAYpNgKthBOgEPLgLdY/1uLqPoJGZZNh8bzZMap0vmYrgEk4Rj9F0bkC27MPXWB2A/MvJFxyM5+B1vnvmNUnIyg7FS7FRFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8rUgHNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8rUgHNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392C8C4CEF0;
	Tue, 12 Aug 2025 18:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023375;
	bh=6+fpmnFOYIjY9Hf3lYkrKnn5ChUXzPIit59gUB5MPhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8rUgHNb2+LI4Z+EoX6OZ+2JSWZioyPLAb5v+bPb5NO7o58Wrmxj8Sq4dmwBNFY1b
	 qkQLxusIgnmZb2UwdRGh/Eyu3nmNCGlQ3T35EmXrlUazl13NIqTP8Tbe+nAKGRewKZ
	 ivGTIAng88Dk4WdQPORXck61Nni/BH9KTqGXlB+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 028/627] erofs: fix build error with CONFIG_EROFS_FS_ZIP_ACCEL=y
Date: Tue, 12 Aug 2025 19:25:23 +0200
Message-ID: <20250812173420.398660113@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Bo Liu (OpenAnolis) <liubo03@inspur.com>

[ Upstream commit 5e0bf36fd156b8d9b09f8481ee6daa6cdba1b064 ]

fix build err:
 ld.lld: error: undefined symbol: crypto_req_done
   referenced by decompressor_crypto.c
       fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in archive vmlinux.a
   referenced by decompressor_crypto.c
       fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in archive vmlinux.a

 ld.lld: error: undefined symbol: crypto_acomp_decompress
   referenced by decompressor_crypto.c
       fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in archive vmlinux.a

 ld.lld: error: undefined symbol: crypto_alloc_acomp
   referenced by decompressor_crypto.c
       fs/erofs/decompressor_crypto.o:(z_erofs_crypto_enable_engine) in archive vmlinux.a

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507161032.QholMPtn-lkp@intel.com/
Fixes: b4a29efc5146 ("erofs: support DEFLATE decompression by using Intel QAT")
Signed-off-by: Bo Liu (OpenAnolis) <liubo03@inspur.com>
Link: https://lore.kernel.org/r/20250718033039.3609-1-liubo03@inspur.com
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 6beeb7063871..7b26efc271ee 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -147,6 +147,8 @@ config EROFS_FS_ZIP_ZSTD
 config EROFS_FS_ZIP_ACCEL
 	bool "EROFS hardware decompression support"
 	depends on EROFS_FS_ZIP
+	select CRYPTO
+	select CRYPTO_DEFLATE
 	help
 	  Saying Y here includes hardware accelerator support for reading
 	  EROFS file systems containing compressed data.  It gives better
-- 
2.39.5



