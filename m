Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F47BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8256C433D2;
	Tue,  7 Mar 2023 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214489;
	bh=VNvO9JWcWvbsA+9KZxtEL+cDxpbfSNx7qWMsu7MNi18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQtDqH2j8hhYKKMhy0wbGkj6yQNtoCfqoKEkIF4IRJVWTTtiqif0Z9gYLq62Ecdwx
	 KjkZVkPQN3/zLj1+De4INZ9PsBqUASav259ZTrJLDaMn4YZX+RmINOVDpz1n6BfUd+
	 1W+GFU0XsdFm8OXyg0Q3xQ1dMKInH8q73nU5dfb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 840/885] tracing/eprobe: Fix to add filter on eprobe description in README file
Date: Tue,  7 Mar 2023 18:02:54 +0100
Message-Id: <20230307170038.339396581@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 133921530c42960c07d25d12677f9e131a2b0cdf upstream.

Fix to add a description of the filter on eprobe in README file. This
is required to identify the kernel supports the filter on eprobe or not.

Link: https://lore.kernel.org/all/167309833728.640500.12232259238201433587.stgit@devnote3/

Fixes: 752be5c5c910 ("tracing/eprobe: Add eprobe filter support")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5599,7 +5599,7 @@ static const char readme_msg[] =
 #ifdef CONFIG_HIST_TRIGGERS
 	"\t           s:[synthetic/]<event> <field> [<field>]\n"
 #endif
-	"\t           e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>]\n"
+	"\t           e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>] [if <filter>]\n"
 	"\t           -:[<group>/][<event>]\n"
 #ifdef CONFIG_KPROBE_EVENTS
 	"\t    place: [<module>:]<symbol>[+<offset>]|<memaddr>\n"


