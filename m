Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F151F76B5;
	Tue, 17 Dec 2024 17:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456113; cv=none; b=J3KQMEPspQv2aGmlC4ifuEWXo+O+FSWjht8Nu9d0oX1C0mcR0knTg7r/jXXdcobsqmJlYsW0SZ3MTcq5RLhtDNwwnC2FFcjPS6/83mFRNmX2qoentavehnQRNrCgiBLSR8qoowJwA91pwSPN1Bg3x1meRX7VRcgTE+XDflZSCf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456113; c=relaxed/simple;
	bh=AmNT3mrSL+GmpolllFeGlVjA2x2qKRouYPLhoPZvt3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHy9QH9Sufcn0gK6E09KmZODiFSRbuZyBNGCiAJnNETRS6pecZ/h8hGh9JB7lEhZh2wM6TM8B/5qCNWxhNgjd5dvhSZuH5bxSgmFUyTBIeDltLibq4iy/dEBZg6Fyx6V/weoQ7+e+FnpJ2A727F1yaLMolGsziNf0iFGDZmOwDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpSw3/Tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpSw3/Tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50C0C4CEE2;
	Tue, 17 Dec 2024 17:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456113;
	bh=AmNT3mrSL+GmpolllFeGlVjA2x2qKRouYPLhoPZvt3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpSw3/Tuy/eKWqLDHAAs93BRbwJG/ByddKM2mn9slVllQOWZsF0YSG+T6ZpFFq7YX
	 LF+1rcDrJoeWct+xWczBE9Eo/iBSilR6WBSMmKc79zUtCYLcOeDRdBgUkWg7uNgSYS
	 EezHDR8B21vEzzYIZb/SjEl51ofiA9UJ+594EdYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Attila Fazekas <afazekas@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 034/109] rtla/timerlat: Make timerlat_hist_cpu->*_count unsigned long long
Date: Tue, 17 Dec 2024 18:07:18 +0100
Message-ID: <20241217170534.801422065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

commit 76b3102148135945b013797fac9b206273f0f777 upstream.

Do the same fix as in previous commit also for timerlat-hist.

Link: https://lore.kernel.org/20241011121015.2868751-2-tglozar@redhat.com
Reported-by: Attila Fazekas <afazekas@redhat.com>
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[ Drop hunk fixing printf in timerlat_print_stats_all since that is not in 6.6 ]
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_hist.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -58,9 +58,9 @@ struct timerlat_hist_cpu {
 	int			*thread;
 	int			*user;
 
-	int			irq_count;
-	int			thread_count;
-	int			user_count;
+	unsigned long long	irq_count;
+	unsigned long long	thread_count;
+	unsigned long long	user_count;
 
 	unsigned long long	min_irq;
 	unsigned long long	sum_irq;
@@ -300,15 +300,15 @@ timerlat_print_summary(struct timerlat_h
 			continue;
 
 		if (!params->no_irq)
-			trace_seq_printf(trace->seq, "%9d ",
+			trace_seq_printf(trace->seq, "%9llu ",
 					data->hist[cpu].irq_count);
 
 		if (!params->no_thread)
-			trace_seq_printf(trace->seq, "%9d ",
+			trace_seq_printf(trace->seq, "%9llu ",
 					data->hist[cpu].thread_count);
 
 		if (params->user_hist)
-			trace_seq_printf(trace->seq, "%9d ",
+			trace_seq_printf(trace->seq, "%9llu ",
 					 data->hist[cpu].user_count);
 	}
 	trace_seq_printf(trace->seq, "\n");


