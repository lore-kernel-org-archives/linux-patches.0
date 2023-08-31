Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971B59440
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E28C433C8;
	Thu, 31 Aug 2023 11:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480330;
	bh=PRW5YXXlBRWMKyiU4LyFllrhgIh2cV5Sm1RlS7mKuJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vE0fpVJVFNgqYzVUcx4XzuZgrQSdjSEp3tGOmjNeRnjhgInbJKWCoZsNZigm7Ytag
	 EapS1epLJKraGxlLTEFitloYXY1rMJxS61rGsnKRNIKCdy9clLWEm/bwCYcPhRMwIW
	 lQ/D7ZC1FM4VjsGmYTiRFJjQ0fIm1PAqIA9API20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 08/10] parisc: sys_parisc: parisc_personality() is called from asm code
Date: Thu, 31 Aug 2023 13:10:48 +0200
Message-ID: <20230831110831.385798018@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>
References: <20230831110831.079963475@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit b5d89408b9fb21258f7c371d6d48a674f60f7181 upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/sys_parisc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -24,6 +24,7 @@
 #include <linux/personality.h>
 #include <linux/random.h>
 #include <linux/compat.h>
+#include <linux/elf-randomize.h>
 
 /*
  * Construct an artificial page offset for the mapping based on the physical
@@ -339,7 +340,7 @@ asmlinkage long parisc_fallocate(int fd,
 			      ((u64)lenhi << 32) | lenlo);
 }
 
-long parisc_personality(unsigned long personality)
+asmlinkage long parisc_personality(unsigned long personality)
 {
 	long err;
 


