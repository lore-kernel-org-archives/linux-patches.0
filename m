Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEDD3EE1DA;
	Wed, 20 May 2026 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296293; cv=none; b=HuxXsHjtBuyQSSFkJt8sc3eQmeEd67jT4XFGcAm/2ywgly+2jrNXNctrYh52HMp04JP6t3ETpD9NKuFUyKCQGDe1gSDXwK8FL6/PIKmitlhvJNBgmDi9QKj4ebalf9Hj+H1V2qaW/+wGY6Ls3p0ldEVOQ0NsKRDcGP8e9hLrs1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296293; c=relaxed/simple;
	bh=CsT62k9xZczJ+FXQ7FRk5dPOb8znyX9gn7H1Ivg90oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBasft+9we93j9s3q/Gq0d1PdjnaIsFg6gIg/O/ezCyvWtkTaXuRhJlPFtMDJN1rOzE7MVTBuFIcIWE4GTzeqe5k/r8fI/cuMh3q0NzbQQZEyCzLlJIzyhrnxFLjnIljHqWqpwZTTIHjPE62ggk4CPsmhqZVaRxK6IByeY/+Xx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4nioBH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4nioBH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96F01F00894;
	Wed, 20 May 2026 16:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296292;
	bh=PYgD9+ngn1y3m8y9QJoLnE+DdTg/ScDaLJtJEVZkodM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4nioBH4mvF7o7wgrzBtL1MqTAM4s9OpSnjSIdqqQrYGF3UD5/PXCvwGFElmz3Iz4
	 MNThZMdw6m4LuuGlS1iyfSK1w6SRmjwGB4ItZ4KZodFMbzcwUM05hpAx/d3b/00Loj
	 cWiuq3pzzuMZ0tKa+qVpaA9wx2oulDGzGGBfi7VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	kernel test robot <lkp@intel.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Lee Jones <lee@kernel.org>,
	Jingoo Han <jingoohan1@gmail.com>,
	dri-devel@lists.freedesktop.org,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0745/1146] sh: Include <linux/io.h> in dac.h
Date: Wed, 20 May 2026 18:16:35 +0200
Message-ID: <20260520162205.067126444@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 57b3ec396dd898aadc073bb16f3d05ee64b2c8af ]

Include <linux/io.h> to avoid depending on <linux/backlight.h>
for including it. Declares __raw_readb() and __raw_writeb().

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510282206.wI0HrqcK-lkp@intel.com/
Fixes: 243ce64b2b37 ("backlight: Do not include <linux/fb.h> in header file")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Daniel Thompson (RISCstar) <danielt@kernel.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Lee Jones <lee@kernel.org>
Cc: Daniel Thompson <danielt@kernel.org>
Cc: Jingoo Han <jingoohan1@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/cpu-sh3/cpu/dac.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/include/cpu-sh3/cpu/dac.h b/arch/sh/include/cpu-sh3/cpu/dac.h
index fd02331608a8d..323ec8570bcd1 100644
--- a/arch/sh/include/cpu-sh3/cpu/dac.h
+++ b/arch/sh/include/cpu-sh3/cpu/dac.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_CPU_SH3_DAC_H
 #define __ASM_CPU_SH3_DAC_H
 
+#include <linux/io.h>
+
 /*
  * Copyright (C) 2003  Andriy Skulysh
  */
-- 
2.53.0



