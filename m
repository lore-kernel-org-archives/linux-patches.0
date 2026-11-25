Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620030;
	b=MHrFfGZ45+5M6Q4k7H81lL3ZND15BA4mmNvV3o3uxPnqQm5EYev5Q23+oWBKmGoUHr2T
	 4/AeIxj+OtTzB+keX/I4id44y1nvaLkv/cMt5wX1+kYIoDJHqccNRRFe0lhSGytsOV8Lz
	 HXF4VPtmxeRNvQiAYiSRI3/6Po4ChkYnQaW3TqRmS8ROM6T/1dcYz9AU/upNUqSVmvemP
	 tAzUajg/Ybphsp48Si73v/Yqtt7cy2m39RrhgQdVv79+aitIbCuarD3sH+XiI3w2jWzu9
	 QwYZ/wvkRpoxLI/ti0wblY2mg+BoFfED80tV0vOcXgWZbz9Pr9NGSi7UaScWe5ZvvWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xc4m/xQSH/h/Og3u3iW34p73b7qPihl5wIGmPtd0CP0=;
	b=RFCUuQLyphtOpOmt/KcEhEq4iKVHQo+9Zl36adIMHDEgG+6jRvo2Pj6H2ClFjwDjM/G/
	 QxMh4+RaBXBEBw/q3CSpjBSRDLDnXktLRF4H5mtmYeOZsyGJSxcGRYJI74XKNbnurKDc/
	 Uj90laEoVkG566ZLz6TKXExI5Tk2e69PFt73+PhyddhNG0lTCBnNsirf/RrE4m4LDMDmE
	 yOFp9yLVXCxdMyfU12anG/Rb1TOcHceom1oxLCRc2QapTBe5S2l2zUYG28EeJHAoQvlJu
	 fGLGutiFe7qjrPJgeCSUr+4RwrQzOYpRlNqoNIXhnOVxSezdfmLJado3uD+1f72DBpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdYbaZgg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED5B606A323;
	Wed, 25 Nov 2026 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdYbaZgg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF6E1F000C0;
	Wed, 25 Nov 2026 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620030;
	bh=Xc4m/xQSH/h/Og3u3iW34p73b7qPihl5wIGmPtd0CP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdYbaZgg6Dhq307/3HEAIn/ury4/l1tS1W6yJgW85fZgiuHdQYp0Y/356cllJSRzg
	 tuIqqTN3y5UaWW+5MC4OwDEInmrp6jfa0lS4hBf6ZcXKnnf228vqvmWgL54geb4R4H
	 v5rBDMKCvJpfzM/+0A18i8Av4WCXXbQR7vCbmeDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0784/1005] tracing/eprobe: Disallow attaching eprobes to fprobe events
Date: Wed, 25 Nov 2026 15:35:22 +0100
Message-ID: <20261125143840.107795832@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 92d9fa0ed69e1f724feed908bd0a462a42df4b88 upstream.

Event probes (eprobes) are not allowed to attach to other dynamic probe
events (kprobes, uprobes, and eprobes) to avoid recursive probe chains
and lifecycle dependencies. However, when fprobe events were introduced,
TRACE_EVENT_FL_FPROBE was omitted from the exclusion mask in
find_and_get_event(), allowing eprobes to attach to fprobe and tprobe
events.

Exclude TRACE_EVENT_FL_FPROBE events in find_and_get_event().

Link: https://lore.kernel.org/all/179455853457.403392.14549390017750529531.stgit@devnote2/

Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -758,7 +758,8 @@ find_and_get_event(const char *system, c
 		    (TRACE_EVENT_FL_IGNORE_ENABLE |
 		     TRACE_EVENT_FL_KPROBE |
 		     TRACE_EVENT_FL_UPROBE |
-		     TRACE_EVENT_FL_EPROBE))
+		     TRACE_EVENT_FL_EPROBE |
+		     TRACE_EVENT_FL_FPROBE))
 			continue;
 		if (!tp_event->class->system ||
 		    strcmp(system, tp_event->class->system))


