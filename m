Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E662EAB90;
	Tue, 15 Jul 2025 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586902; cv=none; b=ld7O1FgarYSVWOX5/yPSDmd0RuqSs9lg5ezf2O5jMYO9FPZUIM3SF7CTjhfs6VYKCJQLazlwMuZh9hc90oYmaoZP7uFz6+W5D33hB0NBsGPV0V2ygnOU5yNkHIBL9+bBEttvOVAmbpsg1x+Q40B+hX78Spo8edCsHpuDi7NbASc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586902; c=relaxed/simple;
	bh=GfLeVbhOn/NuxstkbXtVRbWvjD/SnmGF5xmutByLpZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUPkuTLdbrU985hYFVXpQ1emwRYqb+kw13JufFNSofFA3U3s2sLIsmD/MiBsTbRwpAIKf+M5wwWoyhXzNnpnNXhMS7uplFcK6TELSL9ydMzp9kwOmMi0BnN7GFYKYFOBc+byk0d2lhWmhHvDJKvrLsyJgcHTMkN8tp0gaSC1PTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTtHoPZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTtHoPZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD43C4CEE3;
	Tue, 15 Jul 2025 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586901;
	bh=GfLeVbhOn/NuxstkbXtVRbWvjD/SnmGF5xmutByLpZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTtHoPZNyQMGpJGf9mn6FzwrA0fImHtbcUZxY2tcM2XfRuuCfcBcoDArPR5a3uNtg
	 RbxLo8CeBPfEJ5PlAOZgFOSh1CZO1F0TvFlv9dOTidErbgrJy+OKvY0hDSNMCUfF5Q
	 CnnyJfxoHryB28/k5L5MN1aBfzG59m9zmpnbaRrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH 6.15 061/192] sched: Fix preemption string of preempt_dynamic_none
Date: Tue, 15 Jul 2025 15:12:36 +0200
Message-ID: <20250715130817.391080978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 3ebb1b6522392f64902b4e96954e35927354aa27 upstream.

Zero is a valid value for "preempt_dynamic_mode", namely
"preempt_dynamic_none".

Fix the off-by-one in preempt_model_str(), so that "preempty_dynamic_none"
is correctly formatted as PREEMPT(none) instead of PREEMPT(undef).

Fixes: 8bdc5daaa01e ("sched: Add a generic function to return the preemption string")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250626-preempt-str-none-v2-1-526213b70a89@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7695,7 +7695,7 @@ const char *preempt_model_str(void)
 
 		if (IS_ENABLED(CONFIG_PREEMPT_DYNAMIC)) {
 			seq_buf_printf(&s, "(%s)%s",
-				       preempt_dynamic_mode > 0 ?
+				       preempt_dynamic_mode >= 0 ?
 				       preempt_modes[preempt_dynamic_mode] : "undef",
 				       brace ? "}" : "");
 			return seq_buf_str(&s);


