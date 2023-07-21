Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C729E20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405DFC433C8;
	Fri, 21 Jul 2023 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967252;
	bh=n2cmZDKxFRU5721MQgRaF/SZcBv9QhljQdZd53m0sZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07VDELuLg4HmRKG8evVfA/lxaXQhEkHJMn+s08qwDBRbQK67jw3p3HSan2NG7qS69
	 7g9m6A84zrNcTpCY/A3jTE8RracRsIN472gVJ01TgfjlpyuE2kkJmXmTPBUfpqH6R4
	 nLA5ZGWR7AGoa0rPoZd9S/xCEIXkEI3VgrBM3/Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	sunliming <sunliming@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 097/223] tracing/user_events: Fix incorrect return value for writing operation when events are disabled
Date: Fri, 21 Jul 2023 18:05:50 +0200
Message-ID: <20230721160524.998807656@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: sunliming <sunliming@kylinos.cn>

commit f6d026eea390d59787a6cdc2ef5c983d02e029d0 upstream.

The writing operation return the count of writes regardless of whether events
are enabled or disabled. Switch it to return -EBADF to indicates that the event
is disabled.

Link: https://lkml.kernel.org/r/20230626111344.19136-2-sunliming@kylinos.cn

Cc: stable@vger.kernel.org
7f5a08c79df35 ("user_events: Add minimal support for trace_event into ftrace")
Acked-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_user.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1456,7 +1456,8 @@ static ssize_t user_events_write_core(st
 
 		if (unlikely(faulted))
 			return -EFAULT;
-	}
+	} else
+		return -EBADF;
 
 	return ret;
 }


