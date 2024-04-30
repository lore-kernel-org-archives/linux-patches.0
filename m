Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E6812C487;
	Tue, 30 Apr 2024 11:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475036; cv=none; b=EKQ1HbiUQnO013FRbCYDOBvxmqx3KS8/ix7VwJhFohJ0WBSqgZvZrj1sD6+YBLYjlaIBKkun4hSWg+snDYRkLPzWF284noEy5kESXILfs4iftKMNaYVco88vXLLURDd2gTtQ1KzQKNnxtxG2M4Pc2ZywdkyYh6fKM6/VEm16KPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475036; c=relaxed/simple;
	bh=PeYMISmSCuIyN8qBMQ5Yqf0nDpi5Cc+6oFRcn2+aS/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJld0I6RfVq1IkeznBAjxw3OgpqRhg7p8bzSNZqzTYoO/sjdu3pWnoabJpUTA7Dzowg0vHGoGdP41cm992vuno/aK6E0h7yGh5cRZDz1Ed+7NLqGyl74rhPA0+kvYhf4sA4m3xHovOgipJXlxhKrjG43J3LGaC1jghhlxh9c7nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3CkvH1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3CkvH1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036AEC2BBFC;
	Tue, 30 Apr 2024 11:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475036;
	bh=PeYMISmSCuIyN8qBMQ5Yqf0nDpi5Cc+6oFRcn2+aS/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3CkvH1FQ1O9OVvbj/aUabRiHiBi60mHOgKqU37wDiNJUjMkKj/0LJb6g4z+ResZS
	 NsLREPpOyhttE19MQTkRLYiPqz5KNmCrVVBhAVQrSRJbcCzvskxBGihLRP564MLD6E
	 4BIWhCoBApAgReN0s/yVBjD04GM7S034QRy50uGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Robin H. Johnson" <robbat2@gentoo.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.10 111/138] tracing: Show size of requested perf buffer
Date: Tue, 30 Apr 2024 12:39:56 +0200
Message-ID: <20240430103052.678258520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -400,7 +400,8 @@ void *perf_trace_buf_alloc(int size, str
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		      "perf buffer not large enough"))
+		      "perf buffer not large enough, wanted %d, have %d",
+		      size, PERF_MAX_TRACE_SIZE))
 		return NULL;
 
 	*rctxp = rctx = perf_swevent_get_recursion_context();


