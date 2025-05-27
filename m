Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02D3277808;
	Tue, 27 May 2025 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366806; cv=none; b=lncNDeMGnhJLBdVwFluCO1YR5qvOcIXMswPsIrtR6uHlb6D+8lSr7gcncyMIXzAlq8et7a99ZAj0b+ukOWtEBrSLTUPcz19y9429ZBOfwzviXQawCzVGjrnsSNCJ2C3auCZSGqjk92YiYsSoXlG8QftNgtxqKD7xiEUEJmJGejo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366806; c=relaxed/simple;
	bh=x7LSQXLEce69z6N4oqkhYOM+pEQ0uYm9MQKndI9WqGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ9oxxRN4B4/elVr18AkCIM4g/jKaTsRanMlRT0Sq6KaMGRfxS0Vs4Zel54KIOsWmQ6my+oTDOvTW6MUl5YAN9/hLlGwp8AGjq6f5erUHLXXWYwXrSOuR4WE31wqDyTPFvRehKU8FLpvQ149jDBfhSZSpt4Cpagwl33cUDREQFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqkLZKlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqkLZKlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3096AC4CEE9;
	Tue, 27 May 2025 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366806;
	bh=x7LSQXLEce69z6N4oqkhYOM+pEQ0uYm9MQKndI9WqGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IqkLZKlmlpeQEk4xWFdKurRuGi3sU2y6+/FkjSxH/Zfc/KJdfZ+oFyTrOBq+HpTd4
	 DP/ewcAk6+/FJDl1laZRt14ZNygcep9z2hn9iQE+wF6zLoAKSVPJLvnQceKVWLWb6p
	 BObxGekjKraa8w6QN7F7MeN+Ut9jc0dzghfdYaNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 151/783] um: Update min_low_pfn to match changes in uml_reserved
Date: Tue, 27 May 2025 18:19:08 +0200
Message-ID: <20250527162519.308967504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index befed230aac28..91b7710c0a5f4 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -66,6 +66,7 @@ void __init mem_init(void)
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	memblock_free((void *)brk_end, uml_reserved - brk_end);
 	uml_reserved = brk_end;
+	min_low_pfn = PFN_UP(__pa(uml_reserved));
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-- 
2.39.5



