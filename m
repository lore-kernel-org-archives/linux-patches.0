Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5012F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FC3C4339B;
	Wed, 12 Apr 2023 08:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289574;
	bh=BsQhlXOU3gi2fp/Whl3nIHnlYUTBWl+v7UA3NtmQJm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSEGDRec3XkM7wYYs2nz72LTg7+/Ksy+sr4c0G0+kqz4p4tCQJwjdLGJ3rxgSlRwg
	 bGuxsocLGm1IVbiOdExdUc6uGiwFH22xbVgQhn6twyXnD9Gh97iv7Vnn884hBPd8ai
	 tIY2Dno90XI3LV80wZlEeZ9yZUUVITBFpJ2WwO5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 122/173] tracing/timerlat: Notify new max thread latency
Date: Wed, 12 Apr 2023 10:34:08 +0200
Message-Id: <20230412082843.062355003@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit b9f451a9029a16eb7913ace09b92493d00f2e564 upstream.

timerlat is not reporting a new tracing_max_latency for the thread
latency. The reason is that it is not calling notify_new_max_latency()
function after the new thread latency is sampled.

Call notify_new_max_latency() after computing the thread latency.

Link: https://lkml.kernel.org/r/16e18d61d69073d0192ace07bf61e405cca96e9c.1680104184.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Fixes: dae181349f1e ("tracing/osnoise: Support a list of trace_array *tr")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1738,6 +1738,8 @@ static int timerlat_main(void *data)
 
 		trace_timerlat_sample(&s);
 
+		notify_new_max_latency(diff);
+
 		timerlat_dump_stack(time_to_us(diff));
 
 		tlat->tracing_thread = false;


