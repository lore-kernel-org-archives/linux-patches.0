Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A6C1CDFBC;
	Wed,  2 Oct 2024 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876521; cv=none; b=RXDt+Fa7e02ltwyT8qkF00yOud+YaY+faSPyrMgTKm4bUKqDccq2CEFJib2xPcyp2jWW4EOegkCB54lfwsFMIo4MYug5TD0KPHtezzNyuS/3E7SS/Fi4F1NcMAqQSMZo8T8ZXxIkOlLpE+wSKl/OWS9odcBwpUXwl9pmzZ6FpxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876521; c=relaxed/simple;
	bh=OsdGkctfVmb116tRWpsv4Ou8QrXSk6z01Q/b3gRJBnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzZBJXO0t1O0OtL3vaNyBfaDHa9fJ1WOWa8N4/v4gg3kRlQfYJ2/oUVDifOG5gKY3GS58PWRgY073tbffC+1kU/eTAseySn05pBJpU/9r4XZlqP4cI+5A8bC7wXXtgEaRYcBwhLZhU1Ari50zHpEusk0aeFbz3l4zUnoiZOeT8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSC2WgnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSC2WgnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF95C4CEC5;
	Wed,  2 Oct 2024 13:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876521;
	bh=OsdGkctfVmb116tRWpsv4Ou8QrXSk6z01Q/b3gRJBnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSC2WgnIROvUgVnaf6fIjWya9Id90rBXWAtH8rnU9T4JiZPFQKkXnKFttZAaOa83Y
	 ZMmSX614ql9k0RxzrBO2ifkfJ39jZeNMycy8NQUSnzLoFeEmL1/AkC1A8iUgZ2kHxb
	 FIiDIBtDXIDP7BEV7Z1J3Fw6WvqunoWXoYgz3jgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lbulwahn@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 473/695] um: remove ARCH_NO_PREEMPT_DYNAMIC
Date: Wed,  2 Oct 2024 14:57:51 +0200
Message-ID: <20241002125841.353209219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 64dcf0b8779363ca07dfb5649a4cc71f9fdf390b ]

There's no such symbol and we currently don't have any of the
mechanisms to make boot-time selection cheap enough, so we can't
have HAVE_PREEMPT_DYNAMIC_CALL or HAVE_PREEMPT_DYNAMIC_KEY.

Remove the select statement.

Reported-by: Lukas Bulwahn <lbulwahn@redhat.com>
Fixes: cd01672d64a3 ("um: Enable preemption in UML")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index dca84fd6d00a5..c89575d05021f 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -11,7 +11,6 @@ config UML
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_STRNCPY_FROM_USER
 	select ARCH_HAS_STRNLEN_USER
-	select ARCH_NO_PREEMPT_DYNAMIC
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_KASAN if X86_64
 	select HAVE_ARCH_KASAN_VMALLOC if HAVE_ARCH_KASAN
-- 
2.43.0



