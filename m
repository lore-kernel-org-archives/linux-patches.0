Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3E2380FCA;
	Sat, 17 Oct 2026 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253389; cv=none; b=AVcUh1nYRm0Bj2Uas6Uqaq0/OAFWLabbjlWFJzFzNSqwyUzpqE5G+KKQEd/k+/bk2IAi9bfrsbwL26Z/8iX4D4C6UhDVRdzZ6gMeG96xfHjjqk3s2Zbh8cWUHG76Igx7/miCEmV21u6ju4tyNFQ0vA6U/uSbuCokvoWbg/BQhys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253389; c=relaxed/simple;
	bh=SWq2dA06dqf3ggnC8RNVBRmDLRjr49CDO3r+IZMtArA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw6ctmLc5crEyyLldmIIyu6Tz01u+M5yGmzruISRGuq8slWPeyN+XsQf83/ZgqTPCU58bpLXo2FQMc/iEvd4YEAu9b9FxtBYbqDj8A4ZIHDETBBXgSqTso36Nbzs+FGf9hwFTF0a6Y0hUj1dEKCCQt3P4JcQ+yiKRmsuZGVZDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+7yS5+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+7yS5+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39731F000C5;
	Sat, 17 Oct 2026 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253388;
	bh=9O73+JVZ5tL/ySr/VnFsstXPw26aQ30/W6YKiJDofac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+7yS5+KN1pnD2sN7saydC+eAbmlLWJL4OonMUMG/dtNafN+KevuSEBlAo3AJNjKG
	 uTHFRIjmz1lD4ViVwtRlDLK7Ogmdp5o7AueM6KGfcIYJWasXW8kJ9kTWmxGRHjFstL
	 cKGtS1I/dGnI3vICNuWtNc0lKNAJYij3XzQCJIUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tomas Glozar <tglozar@redhat.com>,
	Juri Lelli <jlelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	John Kacur <jkacur@redhat.com>,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/869] rv: Remove trailing whitespace from tracepoint string
Date: Sat, 17 Oct 2026 17:49:02 +0200
Message-ID: <20261017160039.624654278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 7b70ac4cad2b20eaf415276bbaa0d9df9abb428c ]

RV event tracepoints print a line with the format:
    "event_xyz: S0 x event -> S1 "
    "event_xyz: S1 x event -> S0 (final)"

While printing an event leading to a non-final state, the line
has a trailing white space (visible above before the closing ").

Adapt the format string not to print the trailing whitespace if we are
not printing "(final)".

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tomas Glozar <tglozar@redhat.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Link: https://lore.kernel.org/20250728135022.255578-3-gmonaco@redhat.com
Reviewed-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 7f904ff6e58d ("rv: Use strings in da monitors tracepoints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rv.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/rv.h b/include/trace/events/rv.h
index 56592da9301c0..17bab55546fad 100644
--- a/include/trace/events/rv.h
+++ b/include/trace/events/rv.h
@@ -29,11 +29,11 @@ DECLARE_EVENT_CLASS(event_da_monitor,
 		__entry->final_state		= final_state;
 	),
 
-	TP_printk("%s x %s -> %s %s",
+	TP_printk("%s x %s -> %s%s",
 		__entry->state,
 		__entry->event,
 		__entry->next_state,
-		__entry->final_state ? "(final)" : "")
+		__entry->final_state ? " (final)" : "")
 );
 
 DECLARE_EVENT_CLASS(error_da_monitor,
@@ -91,12 +91,12 @@ DECLARE_EVENT_CLASS(event_da_monitor_id,
 		__entry->final_state		= final_state;
 	),
 
-	TP_printk("%d: %s x %s -> %s %s",
+	TP_printk("%d: %s x %s -> %s%s",
 		__entry->id,
 		__entry->state,
 		__entry->event,
 		__entry->next_state,
-		__entry->final_state ? "(final)" : "")
+		__entry->final_state ? " (final)" : "")
 );
 
 DECLARE_EVENT_CLASS(error_da_monitor_id,
-- 
2.53.0



