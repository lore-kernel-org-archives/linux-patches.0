Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AD17E90E;
	Mon, 27 May 2024 19:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837002; cv=none; b=GpgtmI3b+sShc8Y/Cl8gteJw2YP8dl1nEb3S8mkTsyyScwnLFUBSpu6MpbkAxl9HIS6IEiJdBTyYy4x1hKO7L2orGTe3gZBfI46Wv3oQzQX+qS2qElrNpp1iqfeuaLlSePmE9Q3hRpO4cLMykZ4zFdqFXyjKuEvPxBmvcIkjvXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837002; c=relaxed/simple;
	bh=vW9gzegt78S+MTNc1qZxH0bZxGIABcPO+/nu2L92fO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtUglWKlYgthuqM/l+fkTXNJTk4mtaFzSpIXVZG2QH3Tn5GDu0C5aVLgTmqyMoZMMExGIY3Ilz09IE5RbJ0Nr9ZleRDyIxLwj7SqmVfsNUKMCZBG2wo4wUAO7MhJvgCaJ5b12CUkIEnQhJ1a4eAedJa+2wiuxcf+18OC+3t2x+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpuN9m7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpuN9m7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A13C2BBFC;
	Mon, 27 May 2024 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837002;
	bh=vW9gzegt78S+MTNc1qZxH0bZxGIABcPO+/nu2L92fO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpuN9m7DeVEyt6ypOR8F/zPFpqN/fcMv4W0o6vpix7AjXwn8bVJ8Tq5DqBM1o6BXU
	 2H7zJEtMKvibwr/3gxjjT5gkRD1e5BZcY835WtIBrhCXq4gvnGxKs5yr8mUmXYcY+4
	 mbsScKDz5TK5zOPr7uY/zq04EedgfsK2hrDNlwRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 230/427] m68k: Move ARCH_HAS_CPU_CACHE_ALIASING
Date: Mon, 27 May 2024 20:54:37 +0200
Message-ID: <20240527185623.968481813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit c66b7b950bbf45eadcdee467e53f80568f4a0a7f ]

Move the recently added ARCH_HAS_CPU_CACHE_ALIASING to restore
alphabetical sort order.

Fixes: 8690bbcf3b7010b3 ("Introduce cpu_dcache_is_aliasing() across all architectures")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/r/4574ad6cc1117e4b5d29812c165bf7f6e5b60773.1714978406.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6ffa295851945..99837d4e8c977 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -3,8 +3,8 @@ config M68K
 	bool
 	default y
 	select ARCH_32BIT_OFF_T
-	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_BINFMT_FLAT
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_PREP_COHERENT if M68K_NONCOHERENT_DMA && !COLDFIRE
-- 
2.43.0



