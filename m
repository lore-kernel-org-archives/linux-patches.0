Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BC61A76C6;
	Tue, 30 Jul 2024 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360804; cv=none; b=Y8rgSvua8WoO51dQGRNqB+Ju/J/GnROUPr/dywP6WLk4IfpeUP64YYBjkAqL/f0FGORySj6LaD2LCUM1aJG2RRgds6pSRLaWXTmKg6TnQ9fXoi7RjtZu0OMmQnN4FcGBKeNGEs/q4dGNqkg3bPs6HLyGu0ozjD6DSs0oYOvqDQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360804; c=relaxed/simple;
	bh=PRWXPzEY+xWErpeFmqbCYEqppCFnI+76ejb0vZ3KnJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcdWNIv5RHjF2jTuN2Q+iOVMb3ZfIFLejn5OlaMyFDUQdFAM2vwt+xsKswr09RS/8IpGifSG4UoYLPVBQL0Fr/9LzNnRna3fAByw2X8xHXFhXTeXrbJD4KBKgG+IQMbbup4o0Psi1rXHD5PIm7vQGNwnALMfZYNFzKUKqY8uDaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y78uWCXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y78uWCXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17D4C32782;
	Tue, 30 Jul 2024 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360804;
	bh=PRWXPzEY+xWErpeFmqbCYEqppCFnI+76ejb0vZ3KnJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y78uWCXKW/7vu9vwcMEo0NsDrDsTRG7slE7D+4m6LhuvmKX7cJQ3y1En614Zlw5l5
	 SRzTME7zP7vxVT8iaICSKYURlk/E1gIsxchbSgcG6J7i353tHYeAAiXYaoLcKZV+mk
	 Z+dve+0zeNr+4IUxmoC/eGzq3AkDuUqExcHjJhXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 797/809] s390/setup: Fix __pa/__va for modules under non-GPL licenses
Date: Tue, 30 Jul 2024 17:51:13 +0200
Message-ID: <20240730151756.457621434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit e188e5d5ffd01d484b5255b88739fcf67b300223 ]

The struct vm_layout contains fields used in __pa/__va calculations. Such
fundamental things have to be exported with EXPORT_SYMBOL to avoid
breakages of out-of-tree modules under non-GPL licenses.

Fixes: 7de0446f0b26 ("s390/boot: Make identity mapping base address explicit")
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 90c2c786bb355..610e6f794511a 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -149,7 +149,7 @@ unsigned long __bootdata_preserved(max_mappable);
 struct physmem_info __bootdata(physmem_info);
 
 struct vm_layout __bootdata_preserved(vm_layout);
-EXPORT_SYMBOL_GPL(vm_layout);
+EXPORT_SYMBOL(vm_layout);
 int __bootdata_preserved(__kaslr_enabled);
 unsigned int __bootdata_preserved(zlib_dfltcc_support);
 EXPORT_SYMBOL(zlib_dfltcc_support);
-- 
2.43.0



