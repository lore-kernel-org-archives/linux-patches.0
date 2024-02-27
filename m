Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4B613DB90;
	Tue, 27 Feb 2024 13:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040980; cv=none; b=eqpcZqZOWV/RbWuBgnrZ9K6jXzxwUBxKfq8qZsg0HOC/2oO0Tz1wr8UoijdDsNjLSx1y2cRis9+oDH3jWZ7C2wFG71drXhFF3lCJbK1xdh83XzycqRSJuXtFcDEDrymUAA4arKsHKHVT5jqIM6377tOf6EqAj7rbRuPT/jV0efg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040980; c=relaxed/simple;
	bh=2sMLx5hXtqTnf8rIegNCyazw2KUbmnG18nsy8ZjXxsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9fkm2LWVQB1FnE9UE/AlVjWxw42UFu2teoCQCMEa4SMW1ekca1jV1Ogu7q+51cn5uFVGiH00M8yb7x+Eh3HjXuJB8WwdXeNmZ+5ed4M+RhGgeiJVjkLRfXyb+ioxEYbp/9QJMM3yPhGhgd4pbYK7zUiPr/DyUwA5x6b05LG0HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7XWqZms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7XWqZms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFCFC433F1;
	Tue, 27 Feb 2024 13:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040980;
	bh=2sMLx5hXtqTnf8rIegNCyazw2KUbmnG18nsy8ZjXxsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7XWqZmsYhr/yLhILBHj9ZWhe0rLCP6CFadIgBsXD0jju0flAPvd1Z797K5kVfHMe
	 Um7LiXOGZpA2hsVccOFfBXGIkM+OaSP1Y5DeJVKY0feMx18zwJRW50B17Jtyjb/oZ5
	 v6Gj3nk9qhjQ5uAOyiKuCLtetcotgymGhCa2COYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 176/334] mm/memblock: add MEMBLOCK_RSRV_NOINIT into flagname[] array
Date: Tue, 27 Feb 2024 14:20:34 +0100
Message-ID: <20240227131636.248497324@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 4f155af0ae4464134bfcfd9f043b6b727c84e947 upstream.

The commit 77e6c43e137c ("memblock: introduce MEMBLOCK_RSRV_NOINIT flag")
skipped adding this newly introduced memblock flag into flagname[] array,
thus preventing a correct memblock flags output for applicable memblock
regions.

Link: https://lkml.kernel.org/r/20240209030912.1382251-1-anshuman.khandual@arm.com
Fixes: 77e6c43e137c ("memblock: introduce MEMBLOCK_RSRV_NOINIT flag")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2214,6 +2214,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
 	[ilog2(MEMBLOCK_NOMAP)] = "NOMAP",
 	[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
+	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)


