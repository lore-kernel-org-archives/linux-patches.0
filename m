Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD47722576E;
	Mon,  2 Jun 2025 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875454; cv=none; b=bZYfndOo3nkfl4I8fx9BVenQ2V/3tEzdm4W+5Mp0QDnSyE8hv+e6c5/uPdTRXVYpMntCTF5nGyn8/wRsWAOCP2EOnf85YGC91rsbWLNK5/BhzZIjIRYcKSLHR8rk9c1KH5HB4O1NW9aJIo36dxoodM75sqhF0rdoIPeSh3U36y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875454; c=relaxed/simple;
	bh=Qo2yZUOIXEXrdYx+JeaOAllACj4ElIpo4LFq7qjH120=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkj66U1Ori4Vt0Nrr8XMLJUkGohy/fLCzfxYpeN3gozupTNtNoi7r1vA4ZtF5FPqWDJxqLfCGvJssqHShTwfZtYCVf0fiacNJ4YQkwVDs5EsKdNQGAZ7Fg+Cq7v5ECUldIstddw87c8pejgnOV1J7dqgus5cd++7vBUu1CdKJqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFqvPCju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFqvPCju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA66C4CEEB;
	Mon,  2 Jun 2025 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875453;
	bh=Qo2yZUOIXEXrdYx+JeaOAllACj4ElIpo4LFq7qjH120=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFqvPCjudaemWQyK0dVNTIm+sKnfw4yFJ8Bh9HxiEgwWqR7vWPYVIPfAsRGIAQyy4
	 u8PFCOcov/B+KxE/NuBWBG4XHUBvIja1wkZC4vGwnD2zqfdNRa4xKoeYLUceO4cTkp
	 xo3f47vx6/hqNEvwy2foERzsKRWVsahEXTy4d6cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/270] um: Update min_low_pfn to match changes in uml_reserved
Date: Mon,  2 Jun 2025 15:47:05 +0200
Message-ID: <20250602134312.950760832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit e82cf3051e6193f61e03898f8dba035199064d36 ]

When uml_reserved is updated, min_low_pfn must also be updated
accordingly. Otherwise, min_low_pfn will not accurately reflect
the lowest available PFN.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20250221041855.1156109-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 9242dc91d7519..268a238f4f9cf 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -49,6 +49,7 @@ void __init mem_init(void)
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	memblock_free(__pa(brk_end), uml_reserved - brk_end);
 	uml_reserved = brk_end;
+	min_low_pfn = PFN_UP(__pa(uml_reserved));
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-- 
2.39.5



