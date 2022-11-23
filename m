Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE851C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B70EC433C1;
	Wed, 23 Nov 2022 09:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197422;
	bh=h+OpAtOgLGyQkYlELTZvqT6dsEhDilPG4dDcccwImL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEzhn0QNIh4LidULZ6Tyowlp9X1RDBP4nNJfdV+bEAgkpd8PUofniuUWL2kcW5W92
	 eY75E36PcJQFdXv8BYg71CTXm+ybjg2VCTBZhVGBeL4Fh4PFDJLd5JGHRSLUoVn46g
	 K9CqUtvYJFyyl4i1/wrWXnROKtDbywySXHjZI26w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arun Easi <aeasi@marvell.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Aashish Sharma <shraash@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 289/314] tracing: Fix warning on variable struct trace_array
Date: Wed, 23 Nov 2022 09:52:14 +0100
Message-Id: <20221123084638.617638488@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aashish Sharma <shraash@google.com>

[ Upstream commit bedf06833b1f63c2627bd5634602e05592129d7a ]

Move the declaration of 'struct trace_array' out of #ifdef
CONFIG_TRACING block, to fix the following warning when CONFIG_TRACING
is not set:

>> include/linux/trace.h:63:45: warning: 'struct trace_array' declared
inside parameter list will not be visible outside of this definition or
declaration

Link: https://lkml.kernel.org/r/20221107160556.2139463-1-shraash@google.com

Fixes: 1a77dd1c2bb5 ("scsi: tracing: Fix compile error in trace_array calls when TRACING is disabled")
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arun Easi <aeasi@marvell.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Aashish Sharma <shraash@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/trace.h b/include/linux/trace.h
index b5e16e438448..80ffda871749 100644
--- a/include/linux/trace.h
+++ b/include/linux/trace.h
@@ -26,13 +26,13 @@ struct trace_export {
 	int flags;
 };
 
+struct trace_array;
+
 #ifdef CONFIG_TRACING
 
 int register_ftrace_export(struct trace_export *export);
 int unregister_ftrace_export(struct trace_export *export);
 
-struct trace_array;
-
 void trace_printk_init_buffers(void);
 __printf(3, 4)
 int trace_array_printk(struct trace_array *tr, unsigned long ip,
-- 
2.35.1



