Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E764929D26A;
	Tue, 26 Aug 2025 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207554; cv=none; b=QJpaCfw8PKwN0AuL8BUY4luAyKoW86qi13EISJfdOGzcCS051IqEow8TqewRWLhm+rslhFolYTgSEYR2fLhMmVzqAFfhHX55ZvoAtSJOo9uk7mAnUrRl2soWVzV119GQQaJpeVUs3ntKvhFXWiRW6MOLjz6uMY8A0fh6GsWp9Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207554; c=relaxed/simple;
	bh=rY7X5ipx0rrIIxH5otQ04ryP3+q/u7tO/3Eb97YmKec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z38lphfpBZanGofk2RZdUK1tZF86a8R2HLdt9Xm6i5i0EFA9x/vHRBtYPLt39ajulK2wr0jjd+H2LajyA2j29dWg5tOgVFQeChxqCEtvnLc75MWAFRP4jlB1HbO8TdpBgPbUZpQ/uui3Xn/g3k7F7CLB5pBYuPTvWzp8mODDOsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uW5+4BW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uW5+4BW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E40C4CEF4;
	Tue, 26 Aug 2025 11:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207553;
	bh=rY7X5ipx0rrIIxH5otQ04ryP3+q/u7tO/3Eb97YmKec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW5+4BW/h2cH6o5Rn+bdokchgU+l0JeQpH60ofY6O33/pbB94+QAZOfS6zZwBsCis
	 6TubcKTCYGaa/MkZqhsvpJKHWVmiIQFORKkXwzyRpubkjp/I3Nn+XlZ9Afav2mRaIK
	 h4a+uHOJ1Ib20LcxITjdZLMmsMzDfD4xvb85jIUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.16 227/457] erofs: fix build error with CONFIG_EROFS_FS_ZIP_ACCEL=y
Date: Tue, 26 Aug 2025 13:08:31 +0200
Message-ID: <20250826110942.979957086@linuxfoundation.org>
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

From: Bo Liu (OpenAnolis) <liubo03@inspur.com>

commit 5e0bf36fd156b8d9b09f8481ee6daa6cdba1b064 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

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


