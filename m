Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58CF19644F;
	Thu,  6 Jun 2024 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683154; cv=none; b=TIU0GEhb4/qQsNOYkJteuO8qBTUUWykzbxgCYfZDu0zudcb+/NCHAm0cIbv0QuKTo6ZbkGnIqaBOs+g4XlvUZvFtM/3YwccLU3J5zZFq248fUGd45kpCNfoKklEqgx1ZWvrfWPCH1vNaeg51x+Pz5rCKG1nYVfPK5Qtj59zag28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683154; c=relaxed/simple;
	bh=5A+GwBlpDj7h1FGP15yxXlHUbcyAUah0jX1rpGko5Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCIS3efa/xYhtCJfcSdvY3+OZ045QZGHXqXuKBgIb/MGZiAc9eQnhCzAXRzXZKlVOh3a3sc3QGulvQYLT7BOOe+gBjKcWiBuNbZOJK6DU29bozQcSG8gL9QMQdWgmSYsFyUtY+BL9EivOERb+ttps8yFJUI59xhA+oipsAtBtzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwBZQa8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwBZQa8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95568C2BD10;
	Thu,  6 Jun 2024 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683154;
	bh=5A+GwBlpDj7h1FGP15yxXlHUbcyAUah0jX1rpGko5Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwBZQa8//wejMz7mv5ubgmd8hAtse6Y/eULDAopUlY3mMG9gOEBpPR9GI7ySjT3pD
	 bhVH5NR3amUJg8M1dDIN02yw/Y/XIsFKBSLaS/Jwvp3La13E1PxIQMJxk7TM8q1HSc
	 G/F6A+YE75nQ/3ZiQAiMuDOiGjRgGBHFLMRGw/vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/744] parisc: add missing export of __cmpxchg_u8()
Date: Thu,  6 Jun 2024 15:56:11 +0200
Message-ID: <20240606131735.568669297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 6f0c92e8149d8..dcf61cbd31470 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -22,6 +22,7 @@ EXPORT_SYMBOL(memset);
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
+EXPORT_SYMBOL(__cmpxchg_u8);
 EXPORT_SYMBOL(__cmpxchg_u32);
 EXPORT_SYMBOL(__cmpxchg_u64);
 #ifdef CONFIG_SMP
-- 
2.43.0



