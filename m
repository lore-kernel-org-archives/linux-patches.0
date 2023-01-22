Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861012590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD1BC433EF;
	Sun, 22 Jan 2023 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400511;
	bh=AjWonwVyqfOTXNPDMcb3qWV3g35RFtnOo09DdjNpHQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnLEgk8dl/Nt5dVG8CgK/tc5S/7XBf7/RijXbks/LJa2bD5wb3JnruukenrMXxaXG
	 Nc8DpKvo9wmRTZZqHTjbOCn7aKSu5/V9H7HKbnw8/SqDKmHn/1vJ4sZSY6x25M4VA1
	 vLv/QZ0uV2ciXUfQc8oD7qnLJw0yqEkcWUUi3nIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <David.Laight@ACULAB.COM>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 84/98] tracing: Use alignof__(struct {type b;}) instead of offsetof()
Date: Sun, 22 Jan 2023 16:04:40 +0100
Message-Id: <20230122150232.989955248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 09794a5a6c348f629b35fc1687071a1622ef4265 upstream.

Simplify:

  #define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))

with

  #define  ALIGN_STRUCTFIELD(type) __alignof__(struct {type b;})

Which works just the same.

Link: https://lore.kernel.org/all/a7d202457150472588df0bd3b7334b3f@AcuMS.aculab.com/
Link: https://lkml.kernel.org/r/20220802154412.513c50e3@gandalf.local.home

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/trace_events.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -400,7 +400,7 @@ static struct trace_event_functions trac
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))
+#define ALIGN_STRUCTFIELD(type) ((int)(__alignof__(struct {type b;})))
 
 #undef __field_ext
 #define __field_ext(_type, _item, _filter_type) {			\


