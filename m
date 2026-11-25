Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619320;
	b=Yav+44nuG1Btgv1Or3EzVTFYnQNelTsaeCydoO9L5MWG+PWLIy7bhMOFGLcDFOGNnLxO
	 tjDauiCtmtgGnKXurGX4UuQcWlywx7EhQQZb6KFpTJE8OiWnIS4XKo4BCIWB4X4jnTS7I
	 Ev1ix/xO0ZKRHRzYa90zXQAzli9+4MJwR31KcmjsbdUMoIhXKZddBluIKqSvjENX3OEHA
	 ltxKq1ZZizXaDBMADJE9vAMvo7JCtMLvcuLC7MeJspLnvDGGBEmtaH0uLLFQbxWRz7lLq
	 ddhjQVou8/oTO06JsS21XsDVHMfNpRNK6wyPZjaqq2EkBpWk2GD9HfMGIc2wmYJv62g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QSgBZ6pQ0DlfZPkcun+6nRXP4xRrVB4IBtgjs/8Jgdo=;
	b=MiMvTozuFacYoLbCa6SXDVQuMSVKyt1qNAdgaoCT3ihgQk/8pvV4c9hKcGERLlLie7qD
	 FajFzCM14hrfZTSb6IcnDU3+vbopjUFb3/eOWdbqp8hYZQkgk9VTua19Z6u7aSv/vKJO+
	 V0ul9+wURzKODl3iq4M0R/XipZ2jUeHrkQ6pGvmTOZCNW97V6/SMJrJwLNuOMswVKEyIa
	 CUKTgHpLxzFhhDw53uxnu8DrW4ulEb0hdqigVypTqSYngyrtndP4yQFq0aCIOVyHnYmjN
	 EzW+lZIX12OM6MlFxcFGTgDbR+iMC86fckrZxdw3dxGilqVUssiZLl52C22Q/xfRgsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/kZSYKK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5EA606A332;
	Wed, 25 Nov 2026 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/kZSYKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723611F000CF;
	Wed, 25 Nov 2026 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619320;
	bh=QSgBZ6pQ0DlfZPkcun+6nRXP4xRrVB4IBtgjs/8Jgdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/kZSYKKSzNBETSsMfivM67JTJ85gIkHK6TzTp4UIlGK29UpXcgW0qMQ8EzlDfdhU
	 4PjyMBkRTHDopRWxgyYxqBzLgqSNP1QLGTsFGRmmuWYmBfNP9fX3NlaMY/PuO3cHXY
	 UYY7SKeZRTSuw32X23yejP2JUv5/R13h4uMzm+yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0560/1005] tracing/eprobe: Install the trigger for every instance that enables the eprobe
Date: Wed, 25 Nov 2026 15:31:38 +0100
Message-ID: <20261125143834.869692671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit be94710b1f6ba1bea33e73129c110af80e999b2d upstream.

The eprobe trigger lives in the instance of the enabling file, but it is
only added when the eprobe is first enabled and only removed when the
last file goes away. A second instance then records nothing, and the
first instance's trigger is left behind once the eprobe is disabled
there, so the eprobe can be deleted while that trigger still uses it.

Add and remove the trigger for each file. The file is never NULL here,
so warn if it is and drop the dead perf paths.

Link: https://lore.kernel.org/all/20261107101233.151434-1-devnexen@gmail.com/

Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   58 ++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -644,37 +644,32 @@ static int enable_trace_eprobe(struct tr
 {
 	struct trace_probe *tp;
 	struct trace_eprobe *ep;
-	bool enabled;
 	int ret = 0;
 	int cnt = 0;
 
+	if (WARN_ON_ONCE(!file))
+		return -EINVAL;
+
 	tp = trace_probe_primary_from_call(call);
 	if (WARN_ON_ONCE(!tp))
 		return -ENODEV;
-	enabled = trace_probe_is_enabled(tp);
 
 	/* This also changes "enabled" state */
-	if (file) {
-		ret = trace_probe_add_file(tp, file);
-		if (ret)
-			return ret;
-	} else
-		trace_probe_set_flag(tp, TP_FLAG_PROFILE);
-
-	if (enabled)
-		return 0;
+	ret = trace_probe_add_file(tp, file);
+	if (ret)
+		return ret;
 
+	/* The trigger lives in the instance of the file, add it for each file */
 	for_each_trace_eprobe_tp(ep, tp) {
 		ret = enable_eprobe(ep, file);
 		if (ret)
 			break;
-		enabled = true;
 		cnt++;
 	}
 
 	if (ret) {
 		/* Failed to enable one of them. Roll back all */
-		if (enabled) {
+		if (cnt) {
 			/*
 			 * It's a bug if one failed for something other than memory
 			 * not being available but another eprobe succeeded.
@@ -687,10 +682,7 @@ static int enable_trace_eprobe(struct tr
 					break;
 			}
 		}
-		if (file)
-			trace_probe_remove_file(tp, file);
-		else
-			trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
+		trace_probe_remove_file(tp, file);
 	}
 
 	return ret;
@@ -702,33 +694,21 @@ static int disable_trace_eprobe(struct t
 	struct trace_probe *tp;
 	struct trace_eprobe *ep;
 
+	if (WARN_ON_ONCE(!file))
+		return -EINVAL;
+
 	tp = trace_probe_primary_from_call(call);
 	if (WARN_ON_ONCE(!tp))
 		return -ENODEV;
 
-	if (file) {
-		if (!trace_probe_get_file_link(tp, file))
-			return -ENOENT;
-		if (!trace_probe_has_single_file(tp))
-			goto out;
-		trace_probe_clear_flag(tp, TP_FLAG_TRACE);
-	} else
-		trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
-
-	if (!trace_probe_is_enabled(tp)) {
-		for_each_trace_eprobe_tp(ep, tp)
-			disable_eprobe(ep, file->tr);
-	}
+	if (!trace_probe_get_file_link(tp, file))
+		return -ENOENT;
 
- out:
-	if (file)
-		/*
-		 * Synchronization is done in below function. For perf event,
-		 * file == NULL and perf_trace_event_unreg() calls
-		 * tracepoint_synchronize_unregister() to ensure synchronize
-		 * event. We don't need to care about it.
-		 */
-		trace_probe_remove_file(tp, file);
+	for_each_trace_eprobe_tp(ep, tp)
+		disable_eprobe(ep, file->tr);
+
+	/* Synchronization is done in below function. */
+	trace_probe_remove_file(tp, file);
 
 	return 0;
 }


