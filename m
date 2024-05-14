Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2701118026;
	Tue, 14 May 2024 11:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686468; cv=none; b=CImO4gYkulwbE9gSfVOdnV/XMNLpN6bm0xSasGzNiQmsbWb/3uXDtdEYaiDg/LR/RFNX1zZvU4TyXz26VCIVHGnTTO0UbrLQ1+WT/L8aJp6pg8K5toA9VVkJI4xMqNv72QEi2LSuVSYB0eNHRGFttIcjm9y7rdawDrQWFZGVSF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686468; c=relaxed/simple;
	bh=1TPMJABp9AaJiroNlniiESK30ZQ0a0WrgODXHd8Oy1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5Z7nxtiTr8xnc2na6eZDZZQl3xTW49l0ub8hcMXaOKU+yaWYH3Jpc/JwcmzfrwD+Q1H0AzlEUc3fjF/Qg/vdI3iQb8NnHmSDWts/fjtN9cfH5gayhgsFTCFksmd7tr5Z9hkJNYTM9Xp2WUxx4G9XJpIUeBcSJ2/8z/K36020vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVpLZD14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVpLZD14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A86C2BD10;
	Tue, 14 May 2024 11:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686468;
	bh=1TPMJABp9AaJiroNlniiESK30ZQ0a0WrgODXHd8Oy1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVpLZD14sREyJsfDmxNMxhBsehW3yluyDgd3qz0WeJ3hFLL3BnKJkNYH3dNvcsDzi
	 BDBplqyOQW/E202vWFFOxdBQFpyaNHqOGfiAgaIn6rofE5Yoa7p+8kJryEiX0SuXoI
	 U28jeC6StRbvVMpRoLnqfF2hOALLRajSdGqqdMm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Yajun Deng <yajun.deng@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/236] memblock tests: fix undefined reference to `early_pfn_to_nid
Date: Tue, 14 May 2024 12:17:59 +0200
Message-ID: <20240514101024.813973632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit 7d8ed162e6a92268d4b2b84d364a931216102c8e ]

commit 6a9531c3a880 ("memblock: fix crash when reserved memory is not
added to memory") introduce the usage of early_pfn_to_nid, which is not
defined in memblock tests.

The original definition of early_pfn_to_nid is defined in mm.h, so let
add this in the corresponding mm.h.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
CC: Yajun Deng <yajun.deng@linux.dev>
CC: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/20240402132701.29744-2-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/mm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 43be27bcc897d..2f401e8c6c0bb 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -37,4 +37,9 @@ static inline void totalram_pages_add(long count)
 {
 }
 
+static inline int early_pfn_to_nid(unsigned long pfn)
+{
+	return 0;
+}
+
 #endif
-- 
2.43.0



