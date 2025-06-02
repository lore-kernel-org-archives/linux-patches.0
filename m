Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D136A1C5D72;
	Mon,  2 Jun 2025 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875995; cv=none; b=FmSz6eMr11LZ8CCCJxoIB8qMmoP228CiOB8ODZAYHHJv45GFmY6juNEzGhUEJAcBn9cpuf4/CyCRozi6OvAOOBzQXJUH3HD6qSqsnmkwR1Op5VhA6xf47U2ouwqqIE6tSwWwQF5g1uPsEhcCNJSL8OucoGBYlaSMi77+vOy1LPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875995; c=relaxed/simple;
	bh=PgWpPvhPs8IIU2hM+HjcU1w1/HL6lzB5ONkBQ9DpG/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVpMAADWpgZMxQX+DyFbw7HgfdgvkQG0s8h/trL7wojgV1ts2XoqsLCEk9W6xFDNyqSmySKjqaICRhDmLFhhbvaeyEcON5j6ULHobv75MmxBlfxCqGLEEathvbtYQZy7aYSszuy1TARnggwlWAlJA+ueMNoCCCjMS3UZVpqLFGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2B6/Y+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2B6/Y+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40229C4CEEB;
	Mon,  2 Jun 2025 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875995;
	bh=PgWpPvhPs8IIU2hM+HjcU1w1/HL6lzB5ONkBQ9DpG/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2B6/Y+Cpkm9FUdx2Nggy+1W0TKsHAvHSatk1IXh7LPGvA2otFGsZsghLdc7I8ARg
	 4QPzyglJIzMhFXjPxZH7wMgu4/ozhBXiWEfWJ4UNKJS/7kDslIODRHMJ0SyL2ZDCdE
	 wTkblvGVX0qHR1zay2Kz01gw3OOlxc5o+7Ek0KFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/207] um: Update min_low_pfn to match changes in uml_reserved
Date: Mon,  2 Jun 2025 15:46:50 +0200
Message-ID: <20250602134300.251703921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e636ce029495..50be04f7b40f3 100644
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



