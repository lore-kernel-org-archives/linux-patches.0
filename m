Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C8C3F54BE;
	Tue, 17 Mar 2026 17:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766857; cv=none; b=eOPNXaJd2S+CHFguRXmhlLHYvNsGChpY9CUyYDHM5ywux9kcZhH6GaXv8moWFeby7RYrxVDHobF/iBFUWWteXaFeKyDEcxjdCmh9R07iWvYfYwPJKGGKCwVIb0+P2a7UuNzOW9EIQR6A8iiuo6CsvTfeeHwbyMzjqmDMwez7VZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766857; c=relaxed/simple;
	bh=IB862IXVLOkdzaXq1WEzpcyOujrpOad6op8DVBUb4G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDco82EEbAaRUHPedOtY3a753QNqOUHcuVxOVrdTvGPy5LQsRHbvghgCmuEFoUu+YLMfhvPFC8BiDuaL6keLmE9XYAJ5+N5j9mhU61thCZqBiVFtS/qUIJTGxiHUuY4RGyk3W6/kQew4z1Mal6lCQRnNqT54jUOwhAsblNGOJ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZPMrDpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZPMrDpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70431C4CEF7;
	Tue, 17 Mar 2026 17:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766857;
	bh=IB862IXVLOkdzaXq1WEzpcyOujrpOad6op8DVBUb4G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZPMrDpp732fSLjlrdzgk+jTKhAHyI2q48wF6cZO++vD43QyoiK6GEmKatNHPA+C4
	 jzxMzgUSyrP36/8gTJM9L9svMKdcwhbMy3E0OBqeaT473X4JRZNqnP9ldxankb7wA8
	 2R02h0C1LDFvSeLjsDvoB4HHQ1RP+ZKAVvMvepR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zw Tang <shicenci@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.19 335/378] kprobes: Remove unneeded warnings from __arm_kprobe_ftrace()
Date: Tue, 17 Mar 2026 17:34:52 +0100
Message-ID: <20260317163019.308178199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 5ef268cb7a0aac55521fd9881f1939fa94a8988e upstream.

Remove unneeded warnings for handled errors from __arm_kprobe_ftrace()
because all caller handled the error correctly.

Link: https://lore.kernel.org/all/177261531182.1312989.8737778408503961141.stgit@mhiramat.tok.corp.google.com/

Reported-by: Zw Tang <shicenci@gmail.com>
Closes: https://lore.kernel.org/all/CAPHJ_V+J6YDb_wX2nhXU6kh466Dt_nyDSas-1i_Y8s7tqY-Mzw@mail.gmail.com/
Fixes: 9c89bb8e3272 ("kprobes: treewide: Cleanup the error messages for kprobes")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1070,12 +1070,12 @@ static int __arm_kprobe_ftrace(struct kp
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


