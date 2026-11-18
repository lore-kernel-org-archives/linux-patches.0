Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017482;
	b=Z2jhH4h6SC38BLUabHeC9q0ebjJS/CmLvfNjTZfqmHZx4AziklfUFpm+YNXmez9vllFe
	 kgLdDwp8vfJPmhhfYZ+32mHr33oLrKCtVepM5SpEgT/xXrByKSgwmSI1fIwUfzP68TpXs
	 ExzC+zcQ+dknfEKz56SUX/eruVsCa/x4kLihtc3OOyvEZIHda7LMBnOll3A/SftQ1jiXN
	 OkMh+XGV43z5cEA9hmiCf6pGMEAPKWqF170fx3rIAr2JsZCfPdNg8iOX5LwrUT37kSIoO
	 MY75YEgkY8p6zkKZ8+/BRa6BNI2xVrl1IPxwrTXE/5gEYCeMuVVY6ICsXMj+4BAajiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cU6nGXDacfcssg7rq2y2Nv9M+8KIyXr2DtMKJIBvtmI=;
	b=zy2vmYoV3XXTmrHLdQC8FCIKzAcs2XslttRGRHJoV6xsvbWlPfpTVGo1H/fErmBeNYFv
	 zRb63PxPkn47U4u2KMjEmBIJOJN8jLEusv9PweRciH780IG2q89yPpHiXmV5mFOA0Q7Im
	 Z/kik7Ul6+74JRv4aCfXZDFLD1Iteyxjq68wM2CGHEUreg7HMeKvT4dDJT6Hfw67C1H3u
	 rcSqv901mhFbiPNYI/GNtOt28XmaunkU2A2gC0/lmmEFseZ1Nt+r0BxX006boagapWhXX
	 NSHCl9CljJRLGIrv49GDVo678J1e3ZOzPi9EiQu/963N6bHN5EXKAZNlEW+osU3QLSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQKxjCWe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE56606A31C;
	Wed, 18 Nov 2026 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQKxjCWe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F891F000C4;
	Wed, 18 Nov 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017482;
	bh=cU6nGXDacfcssg7rq2y2Nv9M+8KIyXr2DtMKJIBvtmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQKxjCWeVECGi5E88HDWtAR29J+1WYIwsJJUo0XcFJ5bVFg+JG5534faskLXOSe2u
	 M1A3YzvcXrbX4v2AiQlqMd5nj006N6ofkVbPROZo/XCIW+HOQg2lgrGuuNB3xhJxyw
	 hcIUJQqzXqbWNp3RIklu5uAJOtt5py2RSq4RUR4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0899/2651] MIPS: dec: Add missing <linux/interrupt.h> inclusion to reset.h
Date: Wed, 18 Nov 2026 15:35:39 +0100
Message-ID: <20261118150320.226488718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 271e680b17a40347cfc2d33f721249cbb82e34c8 ]

Pull the header directly that is required for `irqreturn_t' type.

Fixes: 0eb77376912e ("MIPS: DEC: Fix prototypes for halt/reset handlers")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/dec/reset.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/include/asm/dec/reset.h b/arch/mips/include/asm/dec/reset.h
index 6af49f3f24da8..caf60ef0edd0c 100644
--- a/arch/mips/include/asm/dec/reset.h
+++ b/arch/mips/include/asm/dec/reset.h
@@ -10,6 +10,7 @@
 #define __ASM_DEC_RESET_H
 
 #include <linux/compiler_attributes.h>
+#include <linux/interrupt.h>
 
 void __noreturn dec_machine_restart(char *command);
 void __noreturn dec_machine_halt(void);
-- 
2.53.0



