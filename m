Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC69D2AE96;
	Tue, 29 Apr 2025 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949824; cv=none; b=Na2ZYEvl83iMywu28hPOHpuLkcUPniBGG6vsfju3rKEffib/DVUCuNY8BMMJUADZtQ2+ou7ftPhtJs5dgUQ17UrHZDdFqEVInoPaLqr3ue2SsZHX6sTFAOIYgVMiBG5i1F4tWBBXG9gCtwxcLxSYtyBw25AjjwFHTIhO6WWXdyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949824; c=relaxed/simple;
	bh=FD6nMFzis0KgU8wmc+Pzl/g51u5jQ1gI7BOrDmRpC4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4z9NXyK+dRpe855VXY/CFm+J9XOe1Uf2qN0LuyKSmLuIejS32C2Ls+2ajlTqrFlAFfk0rgWC43c5qrgZXrq9g/aRWFUokeCHqyZ6m0Cs3X2SgJCcVRbxBQUJhMtoA4aOfNtoOEC/BsGmhSMFAPxhJgnacd4/KX/kxGnN2ntO4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plPPZxqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plPPZxqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2DCC4CEE3;
	Tue, 29 Apr 2025 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949824;
	bh=FD6nMFzis0KgU8wmc+Pzl/g51u5jQ1gI7BOrDmRpC4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plPPZxqPtb6jEd0hTHM03MwZ+11PVyQY0ipAITvfebzlAKw2Udkh34IWBGCOAK9Qx
	 cU4NaGByzrOwAKJ2Nf5TRQYdnZ7UQmtqc3MTQJXNN7ekW5KDP82vlubNHXsV21SBTj
	 KSYECgQYH7VE2knvGgC6Vb5oQtHRtsOJFECL59tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Petr Tesarik <ptesarik@suse.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 069/167] LoongArch: Remove a bogus reference to ZONE_DMA
Date: Tue, 29 Apr 2025 18:42:57 +0200
Message-ID: <20250429161054.563112239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Petr Tesarik <ptesarik@suse.com>

commit c37325cbd91abe3bfab280b3b09947155abe8e07 upstream.

Remove dead code. LoongArch does not have a DMA memory zone (24bit DMA).
The architecture does not even define MAX_DMA_PFN.

Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -89,9 +89,6 @@ void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-#endif
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif


