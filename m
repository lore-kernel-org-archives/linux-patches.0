Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC61422B5;
	Thu, 13 Jun 2024 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278725; cv=none; b=O0eugqUiyEvtFkLWXkYWpWbh0YEFBVuKvlQq5VK2kAg7raVo81VHK7GV7flIFd32hRovlSpsUlzYeYND9VYUzE6xPlQFh5C9CacDTLtc06fHf2E8AS9Zvo+qSVNvhd3NLWjKy3QoKD1EEK17OqqvgOyXJUOtKUbsZAbC5f6P2NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278725; c=relaxed/simple;
	bh=8a2+vc3dp09lkvtBx5kpBdUT7L7CySLbQwbvGfRQNrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1Dxg+xV6oRO4YoDaz56Q9GCCpa9WJvBDANzHVUdzCwWrvBsvKczd+g/QK77Iq1HcfAIlOa/B+nC4ffQluDQMVGnDCPqvKcwFwTw5y3m2/vHLiepjPkZdi1M9I3mvPikklTKm3YXV8VF4Sts8+R6pQxngn2FJea32+5tgYM8sKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpucAxms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpucAxms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969D0C2BBFC;
	Thu, 13 Jun 2024 11:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278725;
	bh=8a2+vc3dp09lkvtBx5kpBdUT7L7CySLbQwbvGfRQNrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpucAxmspNgby0mIwmzxJNQVFYx7ENLDjS2lASc/P7PoHSsA6YLQuSD8k6hcTIYKq
	 RolSkmQpERhxZB++goOlYHSDVAvkPYgXHZITRegpa3+Xbzf/DI8p3HPCCtIgUHlw8j
	 hLihcoFhRLZQfKyvUw2JxYx7cYpk3VJlqrM57pFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/213] parisc: add missing export of __cmpxchg_u8()
Date: Thu, 13 Jun 2024 13:31:06 +0200
Message-ID: <20240613113228.692522152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7baa2265d4392..e0d4b7d20f675 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -34,6 +34,7 @@ EXPORT_SYMBOL(memset);
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
+EXPORT_SYMBOL(__cmpxchg_u8);
 EXPORT_SYMBOL(__cmpxchg_u32);
 EXPORT_SYMBOL(__cmpxchg_u64);
 #ifdef CONFIG_SMP
-- 
2.43.0



