Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5083CB2EB;
	Mon, 23 Mar 2026 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279199; cv=none; b=ejq44dPA4owEkpXVgmGdQxjEonT4zr8fCjQ0tK97ZBbzznaZZT7m6qd4P+9AWqukDulAK2KEfeM1UQRovP2D8B6IozmktOaMv3r/rSiaF2IQDGWEvJn9ciGNhpur+axb0vbb6EmsPWOq1zNCgwmuP22ubRN7d+1/jgb99bf1pa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279199; c=relaxed/simple;
	bh=o1phMiveFS7z9JkDU2SiyqeBcWVkIQTxWp5mlDhOlxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUrgzFlN6kfrQW3QQlY9d+7DoiBFRur81eVBeefb1R/nt8LSw9uThxq134GLpgNZ/dG4ND229tub5F7Ut6hclUaMmmIweYP+IcgnDK68mfFMUg5293YtyR5H/MMfB/S5V9bDNneVZaoSqL73amlk/Yc9pAq+u7HIKWFRfWTTeM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVBjMdu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVBjMdu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F125EC2BC9E;
	Mon, 23 Mar 2026 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279199;
	bh=o1phMiveFS7z9JkDU2SiyqeBcWVkIQTxWp5mlDhOlxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVBjMdu+p5CxBFpPdWePedOmptjdYnT9NtSVAxS1GiktyWZq8bLzS1kvI86v/67R4
	 LUiEXS7o7uk/GT8U4z/vEZWDrbq/ZPxoHFsjuNmvlLMVppNwTI7DhjnqGfEB7ry3mp
	 na/rBa/k9FiG1QgnP77B+GMNbHSW/kD5BHo+jasU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zw Tang <shicenci@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 464/567] kprobes: Remove unneeded warnings from __arm_kprobe_ftrace()
Date: Mon, 23 Mar 2026 14:46:24 +0100
Message-ID: <20260323134545.464999559@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit 5ef268cb7a0aac55521fd9881f1939fa94a8988e ]

Remove unneeded warnings for handled errors from __arm_kprobe_ftrace()
because all caller handled the error correctly.

Link: https://lore.kernel.org/all/177261531182.1312989.8737778408503961141.stgit@mhiramat.tok.corp.google.com/

Reported-by: Zw Tang <shicenci@gmail.com>
Closes: https://lore.kernel.org/all/CAPHJ_V+J6YDb_wX2nhXU6kh466Dt_nyDSas-1i_Y8s7tqY-Mzw@mail.gmail.com/
Fixes: 9c89bb8e3272 ("kprobes: treewide: Cleanup the error messages for kprobes")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1078,12 +1078,12 @@ static int __arm_kprobe_ftrace(struct kp
 	lockdep_assert_held(&kprobe_mutex);
 
 	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 0, 0);
-	if (WARN_ONCE(ret < 0, "Failed to arm kprobe-ftrace at %pS (error %d)\n", p->addr, ret))
+	if (ret < 0)
 		return ret;
 
 	if (*cnt == 0) {
 		ret = register_ftrace_function(ops);
-		if (WARN(ret < 0, "Failed to register kprobe-ftrace (error %d)\n", ret)) {
+		if (ret < 0) {
 			/*
 			 * At this point, sinec ops is not registered, we should be sefe from
 			 * registering empty filter.


