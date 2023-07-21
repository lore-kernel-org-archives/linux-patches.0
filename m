Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CA1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CDAC433C8;
	Fri, 21 Jul 2023 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956143;
	bh=j+lhCQDjnFl3aEG4Bo/KFDm6e3CaRFvxMWFYY88P/MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g56F9J/mGoWHvI9UfUIn4+z3Cc5OzV6ADK2qExDU/2H5e9peJ4lOQeSxjuUpciq0s
	 AV6T3X/DQ90KausPEzlsW+c/ZFTnw0v6a72dXV/6Jrnw9pya4k1HGcoMqYwBIDFfXA
	 IPCH25F3abWOcmfLkq/eE0ZHYa2T3E4a/A9qhMK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	sunliming <sunliming@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.4 140/292] tracing/user_events: Fix incorrect return value for writing operation when events are disabled
Date: Fri, 21 Jul 2023 18:04:09 +0200
Message-ID: <20230721160534.871438682@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
@@ -2096,7 +2096,8 @@ static ssize_t user_events_write_core(st
 
 		if (unlikely(faulted))
 			return -EFAULT;
-	}
+	} else
+		return -EBADF;
 
 	return ret;
 }


