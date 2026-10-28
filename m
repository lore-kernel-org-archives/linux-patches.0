Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213090;
	b=F8M3FwYI6Y09EFJnSv46KQPSlMXidxmgBago5WXsYi1NAl3AhhbOKkRVBusB3EZlFqaP
	 tKw7JI5X+1zHgGqMq4RfRmcmPDg8+zDsfMwI0hOPcfKzbnecSpnJHFrP9OVipcUhU0omY
	 76VJ8EzETK0KdLLHnUFBx/WvtrmxpY2LuZQ3eOlhxnRqxlyRZcEw/KWLUvpW7o8sQbpjI
	 3q3ORm9iN4NUTf9pIvTCFL7fTkUzV8S7FG8EIMFXW4WQxEl9ZVPsKNGFBa7U+F+zW7vpD
	 53sABQzYdODQgB7lhGIDwRQUDnGSInvL2A59RxRbgJ0RvP3hheKCsdJGIBWXUEAHCtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dT3iNU/F2SIF3eMyYGD9+pm9fmpPlz7Vj4xfgqPHhsI=;
	b=sB21mvoOolLTDih2rNreif5uytAwnP3PwjVeTeJzAQPQOB2ydIUcG76zgpnYSZg+s3Bi
	 ruXaxlscJhxuWPnevVpeYUeGn6pakvaSMo325RvkKYe400ALli0E6rgBWMa97AQ2rsUOA
	 ClHRJhccjGWVlo/AJz9p3DD5yOi5kx/+6cHrtYC2cwkXOSSSG9KHIglz7LdxoSBO6X9Ey
	 GnNAbzPj9mzvOKVMHH9/okkIOxEJjossYhglz2sb9UqEm0iA4R5VUDRAUf+YyLIm3OEGx
	 ss8fM+6qR/m+WdDX1IOCdbDmABNRQVQt3pGdQbCYrDijrG3Ne//DrFudQUHrXMziu9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvB+V7qV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D634C606A31A;
	Wed, 28 Oct 2026 18:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvB+V7qV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BBD1F01825;
	Wed, 28 Oct 2026 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213089;
	bh=dT3iNU/F2SIF3eMyYGD9+pm9fmpPlz7Vj4xfgqPHhsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvB+V7qV5Z9sY7BvMaNXQvd/mQaud4UiTr998xJ4MgNGZmj24mWtrsEwMmVmu95t6
	 vfiAtoUZnxCebCOdXvE1v56DOksuE7jgtKyf/aKQfh5hVN7Fb+ULTWrb5fylF2i/Pv
	 OcGlOH1YbMfm73IPb5kwWUyMK2PsDr6ABwH7aWa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0381/1887] fsverity: add dependency on 64K or smaller pages
Date: Wed, 28 Oct 2026 17:41:17 +0100
Message-ID: <20261028170507.903309079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit a300000233a9ff842e2fb450fb9a79f7827a586d upstream.

Currently, all filesystems that support fsverity (ext4, f2fs, and btrfs)
cache the Merkle tree in the pagecache at a 64K aligned offset after the
end of the file data.  This offset needs to be a multiple of the page
size, which is guaranteed only when the page size is 64K or smaller.

64K was chosen to be the "largest reasonable page size".  But it isn't
the largest *possible* page size: the hexagon and powerpc ports of Linux
support 256K pages, though that configuration is rarely used.

For now, just disable support for FS_VERITY in these odd configurations
to ensure it isn't used in cases where it would have incorrect behavior.

Fixes: 671e67b47e9f ("fs-verity: add Kconfig and the helper functions for hashing")
Reported-by: Christoph Hellwig <hch@lst.de>
Closes: https://lore.kernel.org/r/20260119063349.GA643@lst.de
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20260221204525.30426-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index aad1f1d998b9d..6882f85e0a111 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -2,6 +2,9 @@
 
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
+	# Filesystems cache the Merkle tree at a 64K aligned offset in the
+	# pagecache.  That approach assumes the page size is at most 64K.
+	depends on !PAGE_SIZE_256KB
 	select CRYPTO
 	select CRYPTO_HASH_INFO
 	# SHA-256 is implied as it's intended to be the default hash algorithm.
-- 
2.53.0



