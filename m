Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034593;
	b=3bo3Oprq7nPCxiS/l19MDjdx/BzUCwcIocX23DkLN7EYpNRBAjdfmPOrHILEOI9T8iVv
	 mGcfgJNh9YGniyM4wqpleiF5TdHBA0FxYjT4/DUDxaBo2mkdx3wLzHz+bKESNuhDpItvv
	 eG5lFxaZPfcB+DALX2ZjhklQEU9qz6w1Oytu0vMnIrDGbl9lT4oMw12cpmIQ4UhrYf659
	 9k0956ts8XxH8ca9iWPuRTDW7a9gUAVSNJ8xNG8qRPr849G+0XfK1MHQRgMI9nX2dfZ0N
	 E2GGZfh+Il8HmuJDX8yznmuK+YcgDAHIkQBMB3ff/XOynq/tzNexyMOqD7DEp7Ia7Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2vReB3eQI2hnGtieCt5XLJXHAzifjWA0HIKvhMATfZ4=;
	b=UCMz3KJGl2qr9QhjUdu8RGulQObW2NpdTJk1yMh6fI81OpzcA0n9Jm34Hx9BMEYko/zi
	 8ieqMkIHBqu+XK7OgT8zMJvQr3IJOktXY+5XtciAuGWhtJpvoqM1KzhhT+FsH5jAiqkTF
	 qBdOw0+oNUemtcXIII//3ZBsfwzKS5y6L6vpKuoNYTrKHTQ7yIvLEFLHy29znGAKBNolJ
	 8xSR538TVFsq6HftuprMEW+H2rck5icVboY2xDahvJQK2BehcXmhtKWs3LrRQmGwpp34v
	 9f7Uy362clC7GbFHQcFU4ZLRWYvFWGKFzNII33zzT/Buc9K79urqVPZ3hWIwBRo4L+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9FkYmib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A002F606A31C;
	Wed, 18 Nov 2026 20:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9FkYmib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE90E1F000C4;
	Wed, 18 Nov 2026 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034593;
	bh=2vReB3eQI2hnGtieCt5XLJXHAzifjWA0HIKvhMATfZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9FkYmibvS7PbYJKIwrwkoASc3AGKT2yrTMIrXa6IxfQkGPPCKbrDdRBnljc8RoTn
	 cO+Q82wUrWVoTUGSnQLfhoz8ajqIHkuY1JWqtnjIxfbxNhCFmy0IFmk+MYG+/mszqF
	 37Mo2hg29uAVgT/wfMHdCgmxPu7Yh9yckdVdvxTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0423/3318] tracing: Fix logged instance name on creation failure
Date: Wed, 18 Nov 2026 15:17:25 +0100
Message-ID: <20261118150329.268413884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit a9a01be2834a529cbd490ccbab02643f0c1735f2 ]

When boot instance creation fails, the kernel incorrectly logs "(null)"
as the instance name because strsep() consumes curr_str entirely during
parsing.

Print the properly parsed name variable instead. And while at it log
the error code.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260807085423.4175161-1-vdonnefort@google.com
Fixes: cb1f98c5e574 ("tracing: Add creation of instances at boot command line")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ sashal: Prints the instance name tok instead of curr_str in the warning, and omits the error code because trace_array_get_by_name() returns NULL here rather than an ERR_PTR. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e79d2e7f0fe11..d819cc25a1eda 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10437,7 +10437,7 @@ __init static void enable_instances(void)
 
 		tr = trace_array_get_by_name(tok, NULL);
 		if (!tr) {
-			pr_warn("Failed to create instance buffer %s\n", curr_str);
+			pr_warn("Failed to create instance buffer '%s'\n", tok);
 			continue;
 		}
 		/* Allow user space to delete it */
-- 
2.53.0



