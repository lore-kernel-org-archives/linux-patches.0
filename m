Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965BE1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A96C433C1;
	Wed, 23 Nov 2022 09:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194568;
	bh=g6rBtnX8N6x0v9jIEVpqaQTkgz6zPnZzn1UOYWgNPSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4XTnXv8ayiGeElb7q/KjcCSvAlwi/rHfUOj0tzhD6x0W1BGr1OJQgOKExkE+j1pB
	 FZlu11gm7gm/SidX1az7ammyQRLkcKf1+ZEqi5fSKW9QxVmIKUOJF437Q2rueyC4hC
	 ffYpoKMgwVMFIkB9grzN72o+2nmyaZKhuKiNcBo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	Wang Wensheng <wangwensheng4@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 075/114] ftrace: Fix the possible incorrect kernel message
Date: Wed, 23 Nov 2022 09:51:02 +0100
Message-Id: <20221123084554.872124042@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Wensheng <wangwensheng4@huawei.com>

commit 08948caebe93482db1adfd2154eba124f66d161d upstream.

If the number of mcount entries is an integer multiple of
ENTRIES_PER_PAGE, the page count showing on the console would be wrong.

Link: https://lkml.kernel.org/r/20221109094434.84046-2-wangwensheng4@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Fixes: 5821e1b74f0d0 ("function tracing: fix wrong pos computing when read buffer has been fulfilled")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6229,7 +6229,7 @@ void __init ftrace_init(void)
 	}
 
 	pr_info("ftrace: allocating %ld entries in %ld pages\n",
-		count, count / ENTRIES_PER_PAGE + 1);
+		count, DIV_ROUND_UP(count, ENTRIES_PER_PAGE));
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 


