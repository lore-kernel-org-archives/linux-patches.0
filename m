Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCD03081AF;
	Wed,  3 Dec 2025 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776502; cv=none; b=T3OdVuz1UtqKzg/wbco//rFUU03kK/gFQdWTTeGp/lXOytMABfXui7A+mkS9rVAr4QHpws433ixFIDcx5XcQE344j8NfiIR/2K1r6m1BjQE3JusZvlZHsx8hLZ1yJ4jrPA2hMrNmLBTmg/+uaJhWu8KzW2s3ZhqI+w0FzM2t0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776502; c=relaxed/simple;
	bh=va/jygWQ+i9KpzqxdOj1O3kNxHVpMmdEQJYCjaqaUhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+6TcOszG06uupFerwCQsDrQzfcl+RNrx/cvIpT+zjFlZyx+2V6ztWgFnTufK6hEMjb0zwE6YdFvn0fuDL2WHaq5vpTYXTmFND85onNFsHZ5Dduvapnh6v+mrlaqWvunSNcBBVYszbXQYCslYxqdK4wFfFghXMWvZsQPBC4rlnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFWCpW/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFWCpW/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49966C4CEF5;
	Wed,  3 Dec 2025 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776501;
	bh=va/jygWQ+i9KpzqxdOj1O3kNxHVpMmdEQJYCjaqaUhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFWCpW/COAE0qWgJhsx/7YalIRNvHtqlw89OLXIdYRTV+TPQsaTmkY6kBYhRAfTII
	 fGYa2nsxoBACvNCaYaKQ3NerI7Zh1LLrkvRHhj4TdQjWynSlUDUFgtwHOtpyIU+OS1
	 wIKdEJfno7WoH/HVtw0B3P78dEeBWYMxZyb/yAQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eliav Farber <farbere@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/300] fsdax: mark the iomap argument to dax_iomap_sector as const
Date: Wed,  3 Dec 2025 16:26:44 +0100
Message-ID: <20251203152408.033844627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7e4f4b2d689d959b03cb07dfbdb97b9696cb1076 ]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 91820b9b50b73..2ca33ef5d519d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1006,7 +1006,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
+static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
 {
 	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
-- 
2.51.0



