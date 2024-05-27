Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869811078F;
	Mon, 27 May 2024 19:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836661; cv=none; b=OfTgEYbgDQpDomFytHlES1dNKy6EqVKKJBRSRVFcIG/M+Zn6LmG+9IboSJYhSDG/8iX9LH/qMGadC7sYXkjMzWNbQEJfiPdraHQGi5Uxgr2EJjhEMvkTtaQdsw+OALUWM9jNodFXSrUFG+36ZlmOaI64VgXrX9g+xT5PWrQUiXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836661; c=relaxed/simple;
	bh=y6uA1OHSMeDhc4v5g26ZV0FF5YHpdsZ6vvHMgsc5fEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8ptqtYbpI9OK+CozR7fPmMwXqz8n1FrdAebbCosxiaGG+ZA2AAGMa5C+CspRGLBAqocXTLEHg0/0AdzvKGmEhXC+fR3fabhOtc520SpDqdkBQ34c8JP0F52VjExF1wSuyTgvQFD1h9CWLzq6tvKzfEFlZvfEFbtbcR0hqgnmnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LxIrdL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LxIrdL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CB8C2BBFC;
	Mon, 27 May 2024 19:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836661;
	bh=y6uA1OHSMeDhc4v5g26ZV0FF5YHpdsZ6vvHMgsc5fEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LxIrdL4i+4QzepNJr3tcjuCe/9ciWqbyUEtkkNHWD6McVDpmGXOPEvAREx/1KrPg
	 z/TDcQnRxDdvA2UyAq2DKnJByfKIKowT2JclnSic7LlEy6znEAFGqgvbFhoqHrgQuy
	 ZEjdofFrHUc4QvJ8UfhCSEUnO3RHBtjkzeLaqMp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 098/427] x86/fred: Fix typo in Kconfig description
Date: Mon, 27 May 2024 20:52:25 +0200
Message-ID: <20240527185610.949405433@linuxfoundation.org>
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

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 3c41786cab885f9c542e89f624bcdb71187dbb75 ]

Fixes: 2cce95918d63 ("x86/fred: Add Kconfig option for FRED (CONFIG_X86_FRED)")
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Link: https://lore.kernel.org/r/20240312161958.102927-2-pmenzel@molgen.mpg.de

 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 928820e61cb50..f5b3d14ff385b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -501,7 +501,7 @@ config X86_FRED
 	  When enabled, try to use Flexible Return and Event Delivery
 	  instead of the legacy SYSCALL/SYSENTER/IDT architecture for
 	  ring transitions and exception/interrupt handling if the
-	  system supports.
+	  system supports it.
 
 if X86_32
 config X86_BIGSMP
-- 
2.43.0



