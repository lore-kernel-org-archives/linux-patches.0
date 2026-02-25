Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F13B18B0A;
	Wed, 25 Feb 2026 01:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983380; cv=none; b=opS98CgWDRCxJogkBRMHvKlRdY05KlGPRWAc320Gcjq1YI8rtxQMnsrCEtny0RghbEQS92xRm0Pwd0XPHNAqK6UXXkQj4yfyd04gs0fnOD7pQBW4X6ZdkLOnoWnfBKC1BWTR/MuIHOIGbPSXN2SFR2Eo6pMLzqqOmTZa+qaEq7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983380; c=relaxed/simple;
	bh=42b7k8eY0+23K/iluDarGj7GVbw4o1UloqtJXnY/49k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp5ZQWcdGq4IgiOVbaZfrbuhH7TjoQrmipX3JVI3y1+Q8BXnrM28ABXMNyFffibgKvvcdTi/k0DOhYKGRP0LkmnUArakAxHim8v849H7YPO2Be9AzZ+kTJ7exMmxs/zImisZrsS2hBxDAAdchvPcZAV6dpo+FBW/SsvEwttM030=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esShA4X4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esShA4X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4282AC116D0;
	Wed, 25 Feb 2026 01:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983380;
	bh=42b7k8eY0+23K/iluDarGj7GVbw4o1UloqtJXnY/49k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esShA4X4EMmjzk+cDZzRS/jNme9m3+hufKixekqKqiyVj3pu0JVwfkp1T9lMilRqZ
	 6GWraILRrS7m2ae+91P4tAgkLIwswZsYQd8zKH+Vy/FGjfk8ZuhPy2VjUxcDZeZiuU
	 fAlLbJqjOo4PImFa7slNFT4867Hwu+yz9zIoRaY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 504/781] tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros
Date: Tue, 24 Feb 2026 17:20:13 -0800
Message-ID: <20260225012412.164777372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 9df0e49c5b9b8d051529be9994e4f92f2d20be6f ]

The macros ENABLE_EVENT_STR and DISABLE_EVENT_STR were added to trace.h so
that more than one file can have access to them, but was never removed
from their original location. Remove the duplicates.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://patch.msgid.link/20260126130037.4ba201f9@gandalf.local.home
Fixes: d0bad49bb0a09 ("tracing: Add enable_hist/disable_hist triggers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 137b4d9bb116d..2c6d3e33b9fb4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3963,11 +3963,6 @@ void trace_put_event_file(struct trace_event_file *file)
 EXPORT_SYMBOL_GPL(trace_put_event_file);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-
-/* Avoid typos */
-#define ENABLE_EVENT_STR	"enable_event"
-#define DISABLE_EVENT_STR	"disable_event"
-
 struct event_probe_data {
 	struct trace_event_file	*file;
 	unsigned long			count;
-- 
2.51.0



