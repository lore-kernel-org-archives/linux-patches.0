Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0912823815B;
	Mon, 23 Mar 2026 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277132; cv=none; b=OUfyjQDAFaWZLzvV4ZSGClUs6ajasIZtaUeQgUM6I8uzG39qr8h5gkdt1ptI2B0QGrZszyQZ7qzMJQU4Q3sA6yoclgO7LnElmbHomjokfUwsE8Ep+z3IsQg+fqOrBrQYbh7aqGUUspOO2bPjjCnv/WMAd+Jx73ydrcLj/LYKrG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277132; c=relaxed/simple;
	bh=yaIVoEsvUNRJubtyQ5g6w2mwJwJCqH21/joGbt9lMrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOEoervbSY/vEqBPY4TK9olrjG9TfHFF7MaNSTa5xgwhkfNY5d5sFhvIVo72v7h0T6XDDsOTSvVFrw0E5PDop20T8pXB6RliJU0+L6kxuaG7/EoOOkdp25UJs+dO6lVVxj570yB/cmyrib6jXUJxCGHD0ngn/4CBkhNSC7vn8QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZC77o2tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZC77o2tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA86C4CEF7;
	Mon, 23 Mar 2026 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277131;
	bh=yaIVoEsvUNRJubtyQ5g6w2mwJwJCqH21/joGbt9lMrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZC77o2tkYUM/88Th89cayhC7oRrJA0JPBWy7msc8c7PxFfTGKv6arkkvUnTJu1aJ1
	 LdC5BDOzAX947n1A6SlOHlvyukLy9EZAK+j8eUQIUGTbKqVgrpdpeZ1qDGRdIfJVXh
	 aSbUEYnm8HO7JfYlgvZHP24az86hg7k1efhBGLKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zw Tang <shicenci@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/460] kprobes: Remove unneeded warnings from __arm_kprobe_ftrace()
Date: Mon, 23 Mar 2026 14:45:25 +0100
Message-ID: <20260323134534.604793406@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -1077,12 +1077,12 @@ static int __arm_kprobe_ftrace(struct kp
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


