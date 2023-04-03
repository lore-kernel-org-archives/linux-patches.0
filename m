Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0506FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA317C433EF;
	Mon,  3 Apr 2023 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533391;
	bh=BML+I3nOveJkWdAOgxel/c36NkkJSeTGD2sjU0O6seI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZZ1QscW7nLinnjG+kyMT6pj+VjLzR+DhF/MfeUoRlzepuoZLkqOEr9uO0XVvTEWq
	 RNigG77PclPm1l0a9ZCJHHvwef6iASqLW3+qhdWEf0Qe/4XD1ysH+GNjlAlwkutDsF
	 vgRHUPRqtMQyAz93w+kVcokZHpMG41QfwqtuB7N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH 6.2 166/187] s390: reintroduce expoline dependence to scripts
Date: Mon,  3 Apr 2023 16:10:11 +0200
Message-Id: <20230403140421.642822033@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 7bb2107e63d8a4a13bbb6fe0e1cbd68784a2e9ac upstream.

Expolines depend on scripts/basic/fixdep. And build of expolines can now
race with the fixdep build:

 make[1]: *** Deleting file 'arch/s390/lib/expoline/expoline.o'
 /bin/sh: line 1: scripts/basic/fixdep: Permission denied
 make[1]: *** [../scripts/Makefile.build:385: arch/s390/lib/expoline/expoline.o] Error 126
 make: *** [../arch/s390/Makefile:166: expoline_prepare] Error 2

The dependence was removed in the below Fixes: commit. So reintroduce
the dependence on scripts.

Fixes: a0b0987a7811 ("s390/nospec: remove unneeded header includes")
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230316112809.7903-1-jirislaby@kernel.org
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -162,7 +162,7 @@ vdso_prepare: prepare0
 
 ifdef CONFIG_EXPOLINE_EXTERN
 modules_prepare: expoline_prepare
-expoline_prepare:
+expoline_prepare: scripts
 	$(Q)$(MAKE) $(build)=arch/s390/lib/expoline arch/s390/lib/expoline/expoline.o
 endif
 endif


