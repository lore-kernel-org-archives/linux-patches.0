Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA9012C816;
	Tue, 30 Apr 2024 10:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473910; cv=none; b=FWkakxJVWaQA/Ryfxv9ubuvTJNySm5kLA1QBg8MWnwLF1gVN3/A/6O2IiHrnxhFMrX1DXhuG5MeGqYyByjqHJTIH58s64FSHFaL8t5DaylSMR7w8QO/wHDG+CdNQa/cErYimvFFrNCd697uQVEEktyCLRE3PVa+ilgKFPv9LqhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473910; c=relaxed/simple;
	bh=i2cnyWuSbHYAIah4ws1zlipRdPJJICP7N8juwEU+db0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5pfP64n+C/+Sq0ZNyFrjEsk3KCM74l9zldOUHG/GuRmbrvKg8z1ii1rXSmPcb4VaA2ja+zew3aJkp9zE1zk0WwfhI2UbNgrXjr0829HQ9S5qbhpzwKywkxkyGSJsTwSLyxTIMWkEWOOXiJjId4EALtGiq6e50Sa4CADJBc7chk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3rEDaef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3rEDaef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCCFC2BBFC;
	Tue, 30 Apr 2024 10:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473910;
	bh=i2cnyWuSbHYAIah4ws1zlipRdPJJICP7N8juwEU+db0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3rEDaefVENNI741YbKlYhxC911NIKC3PctZJXhq9v7X0yo5X2pbeuCudGV4LstZt
	 E+d+c9hQgUUNFBDTT2H1tYLwvwfp+LmB7YnLJrYbwAbHldP5qROgJFBUMIvlT5fy3R
	 BUOkNuCiBZDwMLu/S8oEh/U4AUs136MuYuCfEZMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Robin H. Johnson" <robbat2@gentoo.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 4.19 59/77] tracing: Show size of requested perf buffer
Date: Tue, 30 Apr 2024 12:39:38 +0200
Message-ID: <20240430103042.879092399@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin H. Johnson <robbat2@gentoo.org>

commit a90afe8d020da9298c98fddb19b7a6372e2feb45 upstream.

If the perf buffer isn't large enough, provide a hint about how large it
needs to be for whatever is running.

Link: https://lkml.kernel.org/r/20210831043723.13481-1-robbat2@gentoo.org

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
 kernel/trace/trace_event_perf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -394,7 +394,8 @@ void *perf_trace_buf_alloc(int size, str
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		      "perf buffer not large enough"))
+		      "perf buffer not large enough, wanted %d, have %d",
+		      size, PERF_MAX_TRACE_SIZE))
 		return NULL;
 
 	*rctxp = rctx = perf_swevent_get_recursion_context();


