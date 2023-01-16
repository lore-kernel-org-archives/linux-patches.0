Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542CF33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0468C433D2;
	Mon, 16 Jan 2023 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884490;
	bh=XalcQgvmaKEiJxgess2rg5blO9B8KGoVgxoeRmUeb4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xD2mHKOWUMFRKkmZWA/p0CLSNjfiDb1D0VXI+ISSvV5uxrGajfJROk9Pwk+rh0kI7
	 qfjBPbSZmjfFo9E23jxx+oruKgdPYucmQSJHWu9cuBj1fC0g8vGjVS7Cd5WbmTvm1F
	 zeKh7acgnYqYnnpsvV3huW+WVdd2MUQ666rhqqUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 025/183] s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()
Date: Mon, 16 Jan 2023 16:49:08 +0100
Message-Id: <20230116154804.441957920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit e3f360db08d55a14112bd27454e616a24296a8b0 upstream.

Make sure that *ptr__ within arch_this_cpu_to_op_simple() is only
dereferenced once by using READ_ONCE(). Otherwise the compiler could
generate incorrect code.

Cc: <stable@vger.kernel.org>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -31,7 +31,7 @@
 	pcp_op_T__ *ptr__;						\
 	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
-	prev__ = *ptr__;						\
+	prev__ = READ_ONCE(*ptr__);					\
 	do {								\
 		old__ = prev__;						\
 		new__ = old__ op (val);					\


