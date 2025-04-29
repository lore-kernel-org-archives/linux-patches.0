Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F032251788;
	Tue, 29 Apr 2025 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945643; cv=none; b=bFGwX82EFSqkoF3JUv4PHUYzWsbwHriATqu0O25xpLh4O8AHbjXBvdrpgLSA0Z9yuaMjB+dHzPWs+pbCFr+fw4p8ZXez5vVl1yHoMDBQDjtlfDsMpFNcr5Ps/M31Bir137KL7v5LieDE0vhMCebtYGEovda5v2az5cxO8NlSP1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945643; c=relaxed/simple;
	bh=Iq0EdHNZ3J4agLhKd2KGDbEJ3ANRR2sUybJQjQqBYMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pnw0eWErG92OirRtT4hrkxj8y6aYAPZii3COLHyWNl4ySgi+cJ7Lx228ylnQ1TXrBw+uHOlFqLWa/eL/+IF8W1MZy0Yrw+oUTKLw3ET3knWKcQqJB9nS3N4XvqEazUeffYr+VCshcAcObgjySg2qxhHkDjxxrz+6RSQfthvDCEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qjt48XEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qjt48XEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93969C4AF09;
	Tue, 29 Apr 2025 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945643;
	bh=Iq0EdHNZ3J4agLhKd2KGDbEJ3ANRR2sUybJQjQqBYMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qjt48XEjAGgIoFGTnXA0dG5hpCUJ82gZCTxWKx493HmeeRUTL62njQ0w8fFaEAoE6
	 wLhOIbQB8oZ6jWEoYQSQB5fqgT/XONWjm19Svl2dIXhMRYB4Q4NxIdoOlZKm9J+HNc
	 b3Q5FtCw7Y5iG5CTWrlR3AmpvS6iQmVtud/3BAQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 179/179] MIPS: cm: Fix warning if MIPS_CM is disabled
Date: Tue, 29 Apr 2025 18:42:00 +0200
Message-ID: <20250429161056.636773338@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit b73c3ccdca95c237750c981054997c71d33e09d7 upstream.

Commit e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
introduced

arch/mips/include/asm/mips-cm.h:119:13: error: ‘mips_cm_update_property’
	defined but not used [-Werror=unused-function]

Fix this by making empty function implementation inline

Fixes: e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mips-cm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -104,7 +104,7 @@ static inline bool mips_cm_present(void)
 #ifdef CONFIG_MIPS_CM
 extern void mips_cm_update_property(void);
 #else
-static void mips_cm_update_property(void) {}
+static inline void mips_cm_update_property(void) {}
 #endif
 
 /**


