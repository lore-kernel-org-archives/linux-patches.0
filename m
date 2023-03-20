Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F071C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9905C433D2;
	Mon, 20 Mar 2023 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325430;
	bh=+rgEhBNp+rP7d98kPE1CI3dV00hK44CAysyGGsYin0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmAKuU5aYzLyfNOnW240w5otnqKCGMKNZbtMBrtyeQEZmjZFbuKpk/y+0KVHKnW4l
	 G7/LgBD4rewx6OyFzxHc8Ct/F5bJH7fK64/YxBqof3NtAOtXFerH8Go+7ZvbsnhKSw
	 44SoQXLxu+XWuSaetSZAuSE+xuvQDYu2yMHKtXrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 103/115] trace/hwlat: Do not wipe the contents of per-cpu thread data
Date: Mon, 20 Mar 2023 15:55:15 +0100
Message-Id: <20230320145453.761363825@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tero Kristo <tero.kristo@linux.intel.com>

commit 4c42f5f0d1dd20bddd9f940beb1e6ccad60c4498 upstream.

Do not wipe the contents of the per-cpu kthread data when starting the
tracer, as this will completely forget about already running instances
and can later start new additional per-cpu threads.

Link: https://lore.kernel.org/all/20230302113654.2984709-1-tero.kristo@linux.intel.com/
Link: https://lkml.kernel.org/r/20230310100451.3948583-2-tero.kristo@linux.intel.com

Cc: stable@vger.kernel.org
Fixes: f46b16520a087 ("trace/hwlat: Implement the per-cpu mode")
Signed-off-by: Tero Kristo <tero.kristo@linux.intel.com>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_hwlat.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -588,9 +588,6 @@ static int start_per_cpu_kthreads(struct
 	 */
 	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 
-	for_each_online_cpu(cpu)
-		per_cpu(hwlat_per_cpu_data, cpu).kthread = NULL;
-
 	for_each_cpu(cpu, current_mask) {
 		retval = start_cpu_kthread(cpu);
 		if (retval)


