Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD9168CB
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512F5C433EF;
	Mon,  8 May 2023 10:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541157;
	bh=W8lqNiXZSDiPJgwfLs3aykEqTVqtcqZXDhKB4Xg3YeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnA8nyx5futy6es6gBD3F7cHJaR9XyEk2RhHwJQWjUUKNyk08PxDBaqd2fdublAfz
	 BxuLAw+OvsuVUGUeqkMVs47kL/8cX+JaCIiyPhe51mEr4Uazu5ckr9xtoCrzvXOnEw
	 mhCRgkaCIUR8WjTcoGxb7PY/xY9dLISuYLDb++zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.2 024/663] powerpc/boot: Fix boot wrapper code generation with CONFIG_POWER10_CPU
Date: Mon,  8 May 2023 11:37:30 +0200
Message-Id: <20230508094429.227794099@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Piggin <npiggin@gmail.com>

commit 648a1783fe2551f5a091c9a5f8f463cb2cbf8745 upstream.

-mcpu=power10 will generate prefixed and pcrel code by default, which
we do not support. The general kernel disables these with cflags, but
those were missed for the boot wrapper.

Fixes: 4b2a9315f20d ("powerpc/64s: POWER10 CPU Kconfig build option")
Cc: stable@vger.kernel.org # v6.1+
Reported-by: Danny Tsen <dtsen@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230407040909.230998-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -34,6 +34,8 @@ endif
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		 -fno-strict-aliasing -O2 -msoft-float -mno-altivec -mno-vsx \
+		 $(call cc-option,-mno-prefixed) $(call cc-option,-mno-pcrel) \
+		 $(call cc-option,-mno-mma) \
 		 $(call cc-option,-mno-spe) $(call cc-option,-mspe=no) \
 		 -pipe -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 $(LINUXINCLUDE)


