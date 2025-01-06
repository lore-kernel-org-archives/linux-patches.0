Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C071D5146;
	Mon,  6 Jan 2025 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178689; cv=none; b=YkieENqQ93mckbAb0AU98uv38Hbsf8BDzO7OEiSbHu7Gw1oHlHD30e7n+htcj+vSDEobFdPHp15hT304Kw6yFXdmbSIPGxlAaBOrqfevyXjdb1X8ra5WW6TTHLt/nwK8jNVAfqG+VnrRkLKGlVB+oxjujd8BPc5GICCEBCGtF4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178689; c=relaxed/simple;
	bh=qoCvyioFYbDSGRsr2k8AWj0NQRnr2MkgsR77JQpYagg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7tdEQa6mbUeRwiKcxcWWGs2RQxHlf4RXaZ3pQQrLiJNXtOABv+sgiXill8GFg6ry6kEuecXc1QHP762/EPxuKTJ0dAdDFV3linp8W4KmlaTrIRSMWotUbMvcAKzICpOP/Jtec4r7EivszAurV//0t4hU04QmWbJZXtjLZ53PSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Es6ahUXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Es6ahUXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C3C4CED2;
	Mon,  6 Jan 2025 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178687;
	bh=qoCvyioFYbDSGRsr2k8AWj0NQRnr2MkgsR77JQpYagg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es6ahUXPwajzLKi0n9O8D0zepTyHcfdRMN7RJeycIyXF/NyR937cOZ+/sKog8Hw6Z
	 iCF+nhMDfLS1FyILkvk8bHnAqupm4/bQBnROn4RjPU+ysPLp0BwWfPt4vh7/LjzEGh
	 wemEbAkJcZiwfI7eLiUmO9t3YQxXw3+tZt/FLk8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/168] mm/vmstat: fix a W=1 clang compiler warning
Date: Mon,  6 Jan 2025 16:16:06 +0100
Message-ID: <20250106151140.654703436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 30c2de0a267c04046d89e678cc0067a9cfb455df ]

Fix the following clang compiler warning that is reported if the kernel is
built with W=1:

./include/linux/vmstat.h:518:36: error: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Werror,-Wenum-enum-conversion]
  518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
      |                               ~~~~~~~~~~~ ^ ~~~

Link: https://lkml.kernel.org/r/20241212213126.1269116-1-bvanassche@acm.org
Fixes: 9d7ea9a297e6 ("mm/vmstat: add helpers to get vmstat item names for each enum type")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vmstat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index d6a6cf53b127..bcb2b2b037c0 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -447,7 +447,7 @@ static inline const char *node_stat_name(enum node_stat_item item)
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 static inline const char *writeback_stat_name(enum writeback_stat_item item)
-- 
2.39.5



