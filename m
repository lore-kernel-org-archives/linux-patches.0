Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AD043031D;
	Tue, 21 Jul 2026 19:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662107; cv=none; b=Cu/DvWKNFxvrfxxg5EWUhWKXamU5WmxKfvldWmOsHTc1BJWXR3ISvk90WJ5HXv/w8DT/ufwHyl6Emrkcv5XULltidGODRlnR+cIVYpVBXLUUlQ0akWYmPu6mEYG7ozIGE6Trz//Cg7cwCVsZMlrw4rYHjelgQ+9CeAl5ExZL3Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662107; c=relaxed/simple;
	bh=mvc7Gn4NVa3xtOIBEtw26bxPBTLd3n75eIjGzitlYpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REf2QLmGivVPynxb2o9QnDqyTfCbrkFDYMXJiFOSykH1JcB351dSKTW8CHNaB89rj+XOFN34ODd80DPoJdrI90B8VN0rDpdkPKDS9JxhgD3MERYUj7NZ+EAzjhUg267WBR28/SEEu5pXc1agKLk5FyQkwTPWvzwldap8w/u4iuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fybzXJHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fybzXJHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BBE1F000E9;
	Tue, 21 Jul 2026 19:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662106;
	bh=vjbckM2ZQbXRgbuTLRCIYnq6QfSUYMEhFDuzy+2p0ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fybzXJHZ1UIdQ6e7VMjteAR/gUVMxM7e+L5+O2ICqNfrACVfSea1St6zkc8SmB5Fr
	 oh178msiQC8gbW4q3lWyJTpmDXa4bqASTTl7b/53udApQ2CJGoQgQ/e7wr1uGjrjxC
	 w0ZrHOhQXPsZo/cv/EmbhYlgigkiPEOx+GP5GCSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0317/1276] s390/process: Fix kernel thread function pointer type
Date: Tue, 21 Jul 2026 17:12:40 +0200
Message-ID: <20260721152453.194653413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9637aee43c4016..73af6d9d9bd187 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -52,7 +52,7 @@ void ret_from_fork(void) asm("ret_from_fork");
 
 void __ret_from_fork(struct task_struct *prev, struct pt_regs *regs)
 {
-	void (*func)(void *arg);
+	int (*func)(void *arg);
 
 	schedule_tail(prev);
 
-- 
2.53.0



