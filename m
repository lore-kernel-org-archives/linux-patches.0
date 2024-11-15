Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C5E185924;
	Fri, 15 Nov 2024 06:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653540; cv=none; b=etlUKtr+kaGkd8cH5vemIwoU22VbtzURlbGtvjpOB9p7eZotbYD1/e5u0IIzZQu9T8LJ5kA4M6gFmJyAWXWFUeqn7tdcNe1W0SeyFOcvQBCyWOafCIQ7LTXWocn1AeDeMFqavGyXARS6L5VEDHQxKaIpXrz74A7HwSPksbmOnsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653540; c=relaxed/simple;
	bh=AVvwxVBEw9jdSnZMCZa3THBT+Dp/WBKlRG6bBWdxMWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpJrIvzV/uwu1iB/rna4/jPnLXQ3MId1N7wfi9a4eRY/q0Q2JFkvjlFPj59RkPF6kq0ZUixXC7KVn2o4QskmpvmrufBRRz11Z8egJp7+TIWezyPT7V3CIUN3SuYt7w9N1HOSCKLuEU5P3dysy9/pKKJ0+V+9b569aSxBUlgPPiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=es4/NkUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="es4/NkUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEF3C4CECF;
	Fri, 15 Nov 2024 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653540;
	bh=AVvwxVBEw9jdSnZMCZa3THBT+Dp/WBKlRG6bBWdxMWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=es4/NkUlQCK2PV75b1l/+9q1CktdTbIQV4kPOnxnP8jw3L8/yK4OPXmJ2Y5R9+zu2
	 KREqGXhpxmIFGN6HfxfiUSt98MEwNd9IWYkY4Uy6lOk+9Mx3+BuVCpG3KkeqSUldaV
	 xbswjq/ai6j8SvGtp48cqJxdnfWn/OOgPBZ1iv5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@cqsoftware.com.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/48] LoongArch: Use "Exception return address" to comment ERA
Date: Fri, 15 Nov 2024 07:38:25 +0100
Message-ID: <20241115063724.268268381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanteng Si <siyanteng@cqsoftware.com.cn>

[ Upstream commit b69269c870ece1bc7d2e3e39ca76f4602f2cb0dd ]

The information contained in the comment for LOONGARCH_CSR_ERA is even
less informative than the macro itself, which can cause confusion for
junior developers. Let's use the full English term.

Signed-off-by: Yanteng Si <siyanteng@cqsoftware.com.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/loongarch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 33531d432b492..23232c7bdb9ff 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -242,7 +242,7 @@
 #define  CSR_ESTAT_IS_WIDTH		14
 #define  CSR_ESTAT_IS			(_ULCAST_(0x3fff) << CSR_ESTAT_IS_SHIFT)
 
-#define LOONGARCH_CSR_ERA		0x6	/* ERA */
+#define LOONGARCH_CSR_ERA		0x6	/* Exception return address */
 
 #define LOONGARCH_CSR_BADV		0x7	/* Bad virtual address */
 
-- 
2.43.0



