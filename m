Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A73629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25D3C433D6;
	Wed,  2 Nov 2022 03:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358273;
	bh=6X4F1ImfmZP+i5s0+q25rL0TVqnHIkZJW2U9rHt5HtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+HuwKGJjc4uDuZuayS54iesCA5rSQPM3hw/rqxfBY2wSVXVSOcT6phJuKG9ALLCN
	 QgAI+BFbkCwC2CrKXJDppq4+0Ra3WV1zhgzjP2H5KpFFpLwHHIbl8LYUO9uX60thnM
	 Lu8s+wSB8C2xAZDjmljCKYyS1PY2Rnf62w50FTlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 045/132] s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
Date: Wed,  2 Nov 2022 03:32:31 +0100
Message-Id: <20221102022100.809839411@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

commit a262d3ad6a433e4080cecd0a8841104a5906355e upstream.

For some exception types the instruction address points behind the
instruction that caused the exception. Take that into account and add
the missing exception table entry.

Cc: <stable@vger.kernel.org>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/futex.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -16,7 +16,8 @@
 		"3: jl    1b\n"						\
 		"   lhi   %0,0\n"					\
 		"4: sacf  768\n"					\
-		EX_TABLE(0b,4b) EX_TABLE(2b,4b) EX_TABLE(3b,4b)		\
+		EX_TABLE(0b,4b) EX_TABLE(1b,4b)				\
+		EX_TABLE(2b,4b) EX_TABLE(3b,4b)				\
 		: "=d" (ret), "=&d" (oldval), "=&d" (newval),		\
 		  "=m" (*uaddr)						\
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\


