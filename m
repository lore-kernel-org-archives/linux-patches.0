Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFCE231CB0;
	Mon,  2 Jun 2025 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876748; cv=none; b=GQX51uvwptwjZnmGi6Iu1g1UK/BHgGG0uN04aitylLksv4kctnaFD7RTKCnGrgLYWrSYHxSuqIqtE1bzyaUrdmAxm81dUaWoZnJZm204mLlldANQBmmcStqHWnE3x6sPD+y5StNwS3Zg6G7A4cvzJtsJxtrrxQfQ3IBQeNBDbZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876748; c=relaxed/simple;
	bh=GYWW6vmYjqNYH7QB8Xs1KXiH5zyUcvgNay1nf1+Kozg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pONkstsUxRfx4JzNh8orr9BxE1ESIPfcEWwsYYgVEBLzcAglicS1CpHnGn9a6p8wuWtwu6wWil4yTJi1Yed8uftoYUqYrPtVRC7P2Bz0VdmCAWgzx8BDVG5dVfMm3b2EbGj7cd5iSuNZO5zRBcLvMKLWHU95FbRcQ7tysjG8kqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytBXxUam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytBXxUam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53068C4CEEB;
	Mon,  2 Jun 2025 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876748;
	bh=GYWW6vmYjqNYH7QB8Xs1KXiH5zyUcvgNay1nf1+Kozg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytBXxUamftQ/S/BI9Bf7ltY0+vdw01LP/4FTj1bZ7E6118sGLAqwQNHqDtW4m4S4B
	 TBIJG/WrwucJb0yWjJJRJq1xIy3k/REJ/quBUCc2liRiUqyuMzC4b9jQZXbcz6+ekn
	 mPE9cgxr9Pi0KUv+pt0f4rBB2771h6NvMzcW22Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/325] um: Update min_low_pfn to match changes in uml_reserved
Date: Mon,  2 Jun 2025 15:45:37 +0200
Message-ID: <20250602134322.240613804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38d5a71a579bc..f6c766b2bdf5e 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -68,6 +68,7 @@ void __init mem_init(void)
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	memblock_free((void *)brk_end, uml_reserved - brk_end);
 	uml_reserved = brk_end;
+	min_low_pfn = PFN_UP(__pa(uml_reserved));
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-- 
2.39.5



