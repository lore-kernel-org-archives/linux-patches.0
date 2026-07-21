Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8D635C68A;
	Tue, 21 Jul 2026 21:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669228; cv=none; b=lHx4PvqbPy//fwW0V8S1a0oYmUEEX7YSTCrksrvb8ptlVZCP1OdG23ZnaPLZ61MDZce+8dbxhw7sqpFPgaK7Q5Yhckn5vga2HEjohTHkvt6bH4Ui0nmZgqmGpibs/B/2X9og36THtNntRNFr7crW4u6gizUX21vfOZC5ti8gsuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669228; c=relaxed/simple;
	bh=jw6sqnSeXLx5Y3Ox3hyeSU1xDgk5uVX3AoApHXRTWdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axnAKr0CV1vhoXNN1B16C95/cE/GRKUamKwkLH5C881qvzcFL+MEaPBuZq+3apYydV6i9UFxyvqV1GVA5olAtb+DoBC0hsxQVxiXM8RMHATc9CxM4jkakl9ryKKlzoj1sMim4T8N2oZrUnanIfx8j6Zh0+ilf3rjP/M2U13px8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fx4zw/pB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fx4zw/pB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C9F1F000E9;
	Tue, 21 Jul 2026 21:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669227;
	bh=UQ01q7W1HunHE+Lyz8lCOdMLXXqG0KnPiFTYi2lQS7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fx4zw/pB94r83XGrcYFWq4Wa55gobNQE/NaEU8Kpj1W/aXzhiEbCHJzkhUwwJqbWd
	 dzNlXy/SgcTAf1qj7/KNgsoF45rMaXcwiBH+AMrQMf4Q8OzPnZyYxiXCfqz0bqa+1h
	 3SPprURE0WFZNdukJewmhl6lSwf+YV412wrCX/Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0422/1067] s390/process: Fix kernel thread function pointer type
Date: Tue, 21 Jul 2026 17:17:03 +0200
Message-ID: <20260721152434.062869576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit d0478f5d3cba1095bfdeb43a9b063c10cdebef14 ]

In case of a kernel thread __ret_from_fork() calls the specified function
indirectly. Fix the kernel thread function pointer, since kernel threads
return an int instead of void.

Fixes: 56e62a737028 ("s390: convert to generic entry")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 42af4b3aa02b85..407500eca5328e 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -48,7 +48,7 @@ void ret_from_fork(void) asm("ret_from_fork");
 
 void __ret_from_fork(struct task_struct *prev, struct pt_regs *regs)
 {
-	void (*func)(void *arg);
+	int (*func)(void *arg);
 
 	schedule_tail(prev);
 
-- 
2.53.0



