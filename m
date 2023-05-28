Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C72D569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF88C4339B;
	Sun, 28 May 2023 19:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302262;
	bh=i+XvamVEAtp7ePMofU3wB+K7KjStmURjyq5IdAbTIPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFfm2pJE+nB8Yb/3knUSLJj4AxoRRyfLcTl7i2tDGZB6g1UWofx8qYg4G7ZKW3STl
	 DS4lQ7jt5VO/lawt6O6zo5XIlTVyEf4J05FTfQZZfswC/LF//bZlz6nOpeuCEB9lgz
	 1O1ru/mT6i3nrk1LhQfE6IRuO+/4MRRrH8IyB5mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.3 036/127] parisc: Handle kprobes breakpoints only in kernel context
Date: Sun, 28 May 2023 20:10:12 +0100
Message-Id: <20230528190837.501317683@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit df419492e428b6a2bce98d0f613c58a13da6666c upstream.

The kernel kprobes break instructions should only be handled when running
in kernel context.

Cc: <stable@vger.kernel.org> # v5.18+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -291,11 +291,11 @@ static void handle_break(struct pt_regs
 	}
 
 #ifdef CONFIG_KPROBES
-	if (unlikely(iir == PARISC_KPROBES_BREAK_INSN)) {
+	if (unlikely(iir == PARISC_KPROBES_BREAK_INSN && !user_mode(regs))) {
 		parisc_kprobe_break_handler(regs);
 		return;
 	}
-	if (unlikely(iir == PARISC_KPROBES_BREAK_INSN2)) {
+	if (unlikely(iir == PARISC_KPROBES_BREAK_INSN2 && !user_mode(regs))) {
 		parisc_kprobe_ss_handler(regs);
 		return;
 	}


