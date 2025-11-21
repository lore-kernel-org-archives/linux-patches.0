Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6D13559D2;
	Fri, 21 Nov 2025 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733437; cv=none; b=VCjvqV2emK24DwIhCAyjiW0Ne9x+YjPu7PAQMPGk2gTYzJuquq115INUdt12CsKpTlnk/eD9baR1wMMuctruv4hTpmiSTPzvxl3gA2ulGy2dOq9ziYJ+L3bRbHvNqJ+aCwIB1st4NFN23knuaiTfRRxVxxKOm48zCF++YeBP3UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733437; c=relaxed/simple;
	bh=kjWNCiiOCY2sdjlHZna1cD3PZaBun+F7soFSps9zQKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO84AkYj1Bl9SisGHxtiO2G5WJRwJ9JUemy6JinG1rMMhB/T53tiVfh2hR3aS0L4R5atX26zZ7AC/YkRtUG5gR+vr8/xHQ3EivCWF5NB+GsDlLjah8/8AgqF+DUJlD6b/VuVzHmjzQy0tgUBP9+igtDBPy5GBCRnJrttI6jWIaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmYyL5dP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmYyL5dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DA6C4CEF1;
	Fri, 21 Nov 2025 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733436;
	bh=kjWNCiiOCY2sdjlHZna1cD3PZaBun+F7soFSps9zQKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmYyL5dPMx/Mv6j031LOlXBw+HVkGcUkUUeeyYFxETIdsG0uCobH2x7jEze/aT2iY
	 AKploOfbTm6uJMTOwU2PwKMIy0loKCYbiUkTnKiU5oezPV2m44IAfXvF2EjZO5HGCB
	 cWYp0I1yI02NBCn/QdrzOmuKMdlE4LV5U90NGEv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 468/529] LoongArch: Use correct accessor to read FWPC/MWPC
Date: Fri, 21 Nov 2025 14:12:47 +0100
Message-ID: <20251121130247.662715798@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit eeeeaafa62ea0cd4b86390f657dc0aea73bff4f5 upstream.

CSR.FWPC and CSR.MWPC are 32bit registers, so use csr_read32() rather
than csr_read64() to read the values of FWPC/MWPC.

Cc: stable@vger.kernel.org
Fixes: edffa33c7bb5a73 ("LoongArch: Add hardware breakpoints/watchpoints support")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -134,13 +134,13 @@ static inline void hw_breakpoint_thread_
 /* Determine number of BRP registers available. */
 static inline int get_num_brps(void)
 {
-	return csr_read64(LOONGARCH_CSR_FWPC) & CSR_FWPC_NUM;
+	return csr_read32(LOONGARCH_CSR_FWPC) & CSR_FWPC_NUM;
 }
 
 /* Determine number of WRP registers available. */
 static inline int get_num_wrps(void)
 {
-	return csr_read64(LOONGARCH_CSR_MWPC) & CSR_MWPC_NUM;
+	return csr_read32(LOONGARCH_CSR_MWPC) & CSR_MWPC_NUM;
 }
 
 #endif	/* __KERNEL__ */


