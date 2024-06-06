Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87E419924D;
	Thu,  6 Jun 2024 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683200; cv=none; b=icKmxUQq+muKebgFmQzz0Ck4i1137u1aYWYfr1e4r36ubgE47pCZK9K+Os6QwfkFmIgdsGuiAmfIQNZZjNyhK52BtuiY0+QmlkiQg88dR6fojt2rPr3A/cWDQO98nnr1aPhWZFaMERNobDzkPZfGfl+BbiTIajDWRp4ReR7Zq2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683200; c=relaxed/simple;
	bh=SKJTGNp49ZIz/TzbWXiqAkFkkz2GkGq8AU/6VCPldw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQUabULkmN7HPwXyJ/Nsuxaf3jf0Cfg2XVTFaoUMo5Ah9l6g7hI3vdQH1w0DFkezHXvqShmK6jFey8vgOp4Qyg5+yTameelxiPRcQXT6mfBdRa9czg/iZpIlIqxfEeQS2H31eCWnypbkK64+9DR02mj3k+RTXUY39k6ddpdtYhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnVSX321; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnVSX321"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C833CC2BD10;
	Thu,  6 Jun 2024 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683199;
	bh=SKJTGNp49ZIz/TzbWXiqAkFkkz2GkGq8AU/6VCPldw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnVSX321YCBE91v5C+k+rdyhRXbr6j0jy40Qk9BNMjlZeF5VFh8tyzOpEb9zj7lpJ
	 PS3NGwDb+eihifwidWww5LTMLMwUKTsa2sTL0DhACpsBZ+zgnwzBL0sJ0/UJX6nvuZ
	 apC1uS8+0CUlORkL+oOZvTEWNuMYztqIq1x+hP+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/473] parisc: add missing export of __cmpxchg_u8()
Date: Thu,  6 Jun 2024 16:00:01 +0200
Message-ID: <20240606131702.264219624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit c57e5dccb06decf3cb6c272ab138c033727149b5 ]

__cmpxchg_u8() had been added (initially) for the sake of
drivers/phy/ti/phy-tusb1210.c; the thing is, that drivers is
modular, so we need an export

Fixes: b344d6a83d01 "parisc: add support for cmpxchg on u8 pointers"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/parisc_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index 00297e8e1c888..317508493b81c 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -21,6 +21,7 @@ EXPORT_SYMBOL(memset);
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
+EXPORT_SYMBOL(__cmpxchg_u8);
 EXPORT_SYMBOL(__cmpxchg_u32);
 EXPORT_SYMBOL(__cmpxchg_u64);
 #ifdef CONFIG_SMP
-- 
2.43.0



