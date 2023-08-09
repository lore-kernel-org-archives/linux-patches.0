Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C12E17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC80AC433C8;
	Wed,  9 Aug 2023 11:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581221;
	bh=kewrziL5Hub/1PIVYSkHs63X2ux0ZmyLeNffAsgNFTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZdqoCxlp//KroGVQGj2s1B04rb3fnqD4ZH8l6wnma6dxlVNB8+93b4nmohsa5Zoz
	 EpGmKuR0pS8SQnFWwwTIsGBkLs8+fTHUOzgs/poY3KjLeSTXxyh7VdkEo5qZVaIKnk
	 UyWTlceEE+C6AKzAMB/ZMxB2GJBpd0H28ZPwIiug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Ingo Molnar <mingo@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 5.10 119/201] x86/kprobes: Move inline to the beginning of the kprobe_is_ss() declaration
Date: Wed,  9 Aug 2023 12:42:01 +0200
Message-ID: <20230809103647.749163395@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 2304d14db6595bea5292bece06c4c625b12d8f89 ]

Address this GCC warning:

  arch/x86/kernel/kprobes/core.c:940:1:
   warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
    940 | static int nokprobe_inline kprobe_is_ss(struct kprobe_ctlblk *kcb)
        | ^~~~~~

[ mingo: Tidied up the changelog. ]

Fixes: 6256e668b7af: ("x86/kprobes: Use int3 instead of debug trap for single-step")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210324144502.1154883-1-weiyongjun1@huawei.com
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -944,7 +944,7 @@ static int reenter_kprobe(struct kprobe
 }
 NOKPROBE_SYMBOL(reenter_kprobe);
 
-static int nokprobe_inline kprobe_is_ss(struct kprobe_ctlblk *kcb)
+static nokprobe_inline int kprobe_is_ss(struct kprobe_ctlblk *kcb)
 {
 	return (kcb->kprobe_status == KPROBE_HIT_SS ||
 		kcb->kprobe_status == KPROBE_REENTER);


