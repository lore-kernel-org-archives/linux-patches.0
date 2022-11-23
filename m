Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC3F1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87B8C433D6;
	Wed, 23 Nov 2022 09:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194142;
	bh=TTSyH9KpmVD0aSx13PgEXK5/9f1KxHg+JY4u3G4Iqow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUqpyCP6v0EPp+vGSA51ZOKpCwN1fxLNNriHtqF2/Im+7DODK6OhV7i8mDy1IYme5
	 VFGQfaK+XIF8pP4otcy0Ko/Z0VaJL/0MlMHnaKYY6a8VGJPdagFhZ05q2b6ZDJcCK2
	 WnMCbLgR0z6mPYRVc0mEeqhYzSJQAukyO8PHWcIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	Wang Wensheng <wangwensheng4@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 53/88] ftrace: Fix the possible incorrect kernel message
Date: Wed, 23 Nov 2022 09:50:50 +0100
Message-Id: <20221123084550.365620167@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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
@@ -6015,7 +6015,7 @@ void __init ftrace_init(void)
 	}
 
 	pr_info("ftrace: allocating %ld entries in %ld pages\n",
-		count, count / ENTRIES_PER_PAGE + 1);
+		count, DIV_ROUND_UP(count, ENTRIES_PER_PAGE));
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 


