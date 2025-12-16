Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32208396DD3;
	Tue, 16 Dec 2025 12:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888338; cv=none; b=TAb4SqOmmmcN13pdD/49FctQMz9wuI8SV4IWZm5Uw2w9hFWrr7VhH6CRlW5vMGZPaxFsxI/ipdaJJw0bIWlTJBcSb+xvGQSMP6NG1i8qwHmZRvzIYyyRh76nVGDmDVd/VnBVqTpGnbj7lU+mq8fv4Et64oCxHZ2Oe1sIQCIGFWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888338; c=relaxed/simple;
	bh=o8ZncKbH1pVdpKl2Aiydc+8hE5VKQ2IA+6Eg4bF3eEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOdmC/VPOWN+oKOJtp5J3/s2/3uXU34VYWbw7RWcxgI4oK8MaLTIe33cowK1CU8rm+z3WePt2W1qubbl+PSjeZ5Muwfp5JQFlNHah68HIe+JV6lvgvlo7Zex6wShPsjomWKYKD1Cf006NxveiI0lYyl1lbb3v0ACrtcFj28+6ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c54YgJeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c54YgJeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D78AC4CEF1;
	Tue, 16 Dec 2025 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888337;
	bh=o8ZncKbH1pVdpKl2Aiydc+8hE5VKQ2IA+6Eg4bF3eEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c54YgJeX0hE1sDb3te7MWw65JVwoG7iGLknydjvs4Rc2ImBSfJxtuF6Dgx4WS8XVs
	 UJnW8IwTe48UG2yZc8XIMbtk0G3/t79pVxC3ilVeK/XssG9BedHK6mWf2UlIptBOBn
	 KWmWncLuJz0RzN1/HyFVc4m4fy8D/8m5RW+pGC4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 505/614] um: Disable KASAN_INLINE when STATIC_LINK is selected
Date: Tue, 16 Dec 2025 12:14:32 +0100
Message-ID: <20251216111419.667263494@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit a3209bb94b36351f11e0d9e72ac44e5dd777a069 ]

um doesn't support KASAN_INLINE together with STATIC_LINK.

Instead of failing the build, disable KASAN_INLINE when
STATIC_LINK is selected.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511290451.x9GZVJ1l-lkp@intel.com/
Fixes: 1e338f4d99e6 ("kasan: introduce ARCH_DEFER_KASAN and unify static key across modes")
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Link: https://patch.msgid.link/2620ab0bbba640b6237c50b9c0dca1c7d1142f5d.1764410067.git.chleroy@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Kconfig             | 1 +
 arch/um/include/asm/kasan.h | 4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 49781bee79058..93ed850d508ed 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -5,6 +5,7 @@ menu "UML-specific options"
 config UML
 	bool
 	default y
+	select ARCH_DISABLE_KASAN_INLINE if STATIC_LINK
 	select ARCH_NEEDS_DEFER_KASAN if STATIC_LINK
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_HAS_CACHE_LINE_SIZE
diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
index b54a4e937fd12..81bcdc0f962e6 100644
--- a/arch/um/include/asm/kasan.h
+++ b/arch/um/include/asm/kasan.h
@@ -24,10 +24,6 @@
 
 #ifdef CONFIG_KASAN
 void kasan_init(void);
-
-#if defined(CONFIG_STATIC_LINK) && defined(CONFIG_KASAN_INLINE)
-#error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
-#endif
 #else
 static inline void kasan_init(void) { }
 #endif /* CONFIG_KASAN */
-- 
2.51.0



