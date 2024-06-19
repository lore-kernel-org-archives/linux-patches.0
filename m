Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C04DAD58;
	Wed, 19 Jun 2024 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802963; cv=none; b=ZNK179j3k5xLw+GyfpxUqJxl9i3iZAT/JoOKvzNkwYGZzBH8WyeExuWcfGmnt78MglTeiH94RQNLRUena5Lsz1VPLmZGB+ehWboLaV9yEflGshCTcg1MT6h85M5zK+n/nVO8o9GDo2CJjJq1RMI2cvrbEAUZYth0zrSI8HiZRLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802963; c=relaxed/simple;
	bh=Egeh1QLE3n4ITCatH8BaFa/kQ5/FKX+yzPO1ymBA0DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCoOVeBmCR+Rhyd1w++IFst/4hm2/dm5kpvI/w56MiOJA3u8UzvhxSAu0JejFUVUICAYrLoUTTNTIPCbQXTWmwvTfzGMO95MZQOpWUlPSkRa8t4UA067KPQ6bEerXiPiQoEF5YK+aKFg/3HEJ/ShbRYUrGPCHquxOhKJ/LwuJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vsefiia4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vsefiia4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7173C2BBFC;
	Wed, 19 Jun 2024 13:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802963;
	bh=Egeh1QLE3n4ITCatH8BaFa/kQ5/FKX+yzPO1ymBA0DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vsefiia4vXx57lgqfNwmJEC8Ft3956+RqK7Nq5o4I+swIBWrZLY0CjFuhWOJu1bjx
	 W0E+ZPlb1se2oMqx9+B5uBCg9D6IV2MLErvFmA5pQbjJs8jmePYehJ2SW8FpdvXNhH
	 wwYa348muyL5rSa1EhMvHwFZ04k6w8hvxxkam0oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH 6.9 105/281] powerpc/85xx: fix compile error without CONFIG_CRASH_DUMP
Date: Wed, 19 Jun 2024 14:54:24 +0200
Message-ID: <20240619125613.886769824@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Hari Bathini <hbathini@linux.ibm.com>

commit 7b090b6ff51b9a9f002139660672f662b95f0630 upstream.

Since commit 5c4233cc0920 ("powerpc/kdump: Split KEXEC_CORE and
CRASH_DUMP dependency"), crashing_cpu is not available without
CONFIG_CRASH_DUMP. Fix compile error on 64-BIT 85xx owing to this
change.

Fixes: 5c4233cc0920 ("powerpc/kdump: Split KEXEC_CORE and CRASH_DUMP dependency")
Cc: stable@vger.kernel.org # v6.9+
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Closes: https://lore.kernel.org/all/fa247ae4-5825-4dbe-a737-d93b7ab4d4b9@xenosoft.de/
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240510080757.560159-1-hbathini@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/85xx/smp.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -398,6 +398,7 @@ static void mpc85xx_smp_kexec_cpu_down(i
 	hard_irq_disable();
 	mpic_teardown_this_cpu(secondary);
 
+#ifdef CONFIG_CRASH_DUMP
 	if (cpu == crashing_cpu && cpu_thread_in_core(cpu) != 0) {
 		/*
 		 * We enter the crash kernel on whatever cpu crashed,
@@ -406,9 +407,11 @@ static void mpc85xx_smp_kexec_cpu_down(i
 		 */
 		disable_threadbit = 1;
 		disable_cpu = cpu_first_thread_sibling(cpu);
-	} else if (sibling != crashing_cpu &&
-		   cpu_thread_in_core(cpu) == 0 &&
-		   cpu_thread_in_core(sibling) != 0) {
+	} else if (sibling == crashing_cpu) {
+		return;
+	}
+#endif
+	if (cpu_thread_in_core(cpu) == 0 && cpu_thread_in_core(sibling) != 0) {
 		disable_threadbit = 2;
 		disable_cpu = sibling;
 	}


