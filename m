Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D841C2C21E3;
	Tue, 12 Aug 2025 18:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025064; cv=none; b=H+CB1J4wHh81L0dFS36/Ski4J1BnT6eA2Slv9Sk5hpncP1/lc50PoDQUqV+a1i+BLERULCH1xQDjO6gibMiXrHD98ogN94O1oy/CpddhWkthc3g8wGCCaW6cV8vpBuPbJMhRcSUEgtJDZUby3kBvypEt8VkmGNT4TRty1suD1XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025064; c=relaxed/simple;
	bh=9PWgzA6yvqOZFboVz918izK94CjvPTLRsClouWuk5Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsKegLGWqo729XU4oocQtEWK2uAg+Vjy1CJC0gZrKLPCeLCKl7tkRs/7xbW9Oba50aJWnu5znS982E7LqXBqUZzSjmlJmAZst54gA5rGHtdElLD2puV2HmphYxmqGWeHMn8L19M8oEfDIkQwqEDQRnhrmOahNlLWLSskzX7IBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuRN4s7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuRN4s7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF09C4CEF0;
	Tue, 12 Aug 2025 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025064;
	bh=9PWgzA6yvqOZFboVz918izK94CjvPTLRsClouWuk5Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuRN4s7FWc5dZ+b4VqpnJiEz6LmxbDC+luUvl4O/BzBdPoUAuLzYWtAYTJcKIpyIF
	 wmv57F4dK5IAMj0URF/C6C0cjKX+Z/RJIw7AJlrhcCk+KUK67FOY8XClhFFcnzet5W
	 VWCMvdxJl0fkb8qs6gtVqG0uytq9+qfDKSCquNo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 558/627] s390/boot: Fix startup debugging log
Date: Tue, 12 Aug 2025 19:34:13 +0200
Message-ID: <20250812173453.122846023@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit e29409faec87ffd2de2ed20b6109f303f129281b ]

Fix 'kernel image' end address for kaslr case.

Fixes: ec6f9f7e5bbf ("s390/boot: Add startup debugging support")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index da8337e63a3e..e124d1f1cf76 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -384,7 +384,7 @@ static unsigned long setup_kernel_memory_layout(unsigned long kernel_size)
 		kernel_start = round_down(kernel_end - kernel_size, THREAD_SIZE);
 		boot_debug("Randomization range: 0x%016lx-0x%016lx\n", vmax - kaslr_len, vmax);
 		boot_debug("kernel image:        0x%016lx-0x%016lx (kaslr)\n", kernel_start,
-			   kernel_size + kernel_size);
+			   kernel_start + kernel_size);
 	} else if (vmax < __NO_KASLR_END_KERNEL || vsize > __NO_KASLR_END_KERNEL) {
 		kernel_start = round_down(vmax - kernel_size, THREAD_SIZE);
 		boot_debug("kernel image:        0x%016lx-0x%016lx (constrained)\n", kernel_start,
-- 
2.39.5



