Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619446;
	b=sqgw4CsN66qBRQD2bDNvRuLC0bA1rxIGWZytb32UFz7awMM9BGnnUEOGhD49TCRGVSr7
	 LMCdrw28gvOSDy7A/jWon7gTNpo1V0Py67ocNBXT8jzqnYtjY0wAtLOXE9VlWClIflb0g
	 8HTXUamrwfhWV2pxcsMPY0oR9/hxdcSub53JJqwXzxWg9BVYm5oX+jrlOGC8nQJlQEM+r
	 B3FEylNQ5whWPNpCgI2iUUdPDjMdwlQHML/+tu+S0u3jkPBVQwn50ua6qJLZHOPg+joQ0
	 t03kKn/jRL7TOtxB/olc6A5BPhHdBxfBDLZ3FYCIzwPCm2d6kufZdl3I7HknnecdG7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uaD1YvuP7v1TOiJyNZGNtVGQ/gnfSu39hDFnHIBa/HU=;
	b=oXtzP8zTuUf4i3TMh60D1lVRwYI+8T2JTIEqqrDTeqCHIBLT3Dq01eOov/Oq68sPddV+
	 BCBPCxZ8JXW0JPkvD7VmgOD//2wnguftO8hH18+nNyx6QEKztglJHZldHa7DnUIlun0nH
	 GaDwjGd9agfIaQa3v+wcL7D61RHCPFPvpVHjitm2vNFHsah/NcL9dFbtwAFcQHZGRWguo
	 m3sUlotaT0xUoV8pgsiLKdcSMMT+AJjj3+/k9mAt/P7lWDYZrHOITRaZBBNvo3HuZlv8/
	 iyGwyPpBPjjk2hcQPu0W4OIE/c+LfGkipO827mYBoGx3K4Ra9eYaNsKnrvgbRwEcJcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rfzp32Nd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4F0606A31E;
	Wed, 25 Nov 2026 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rfzp32Nd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5421F008B2;
	Wed, 25 Nov 2026 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619446;
	bh=uaD1YvuP7v1TOiJyNZGNtVGQ/gnfSu39hDFnHIBa/HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rfzp32NdI5LHo0ASmwXaJT++eT/qLsApPSDz4qHyiTn6CIbH6Jc7Viiu3C6sAJz7X
	 zRTmu6xOFYMNpV4J3oMmoCU1T/V+Uid73lPMoH9jDsnqFZy/LSjwYqKI+JncFdumPO
	 klwa8QeqoFihmbnXQrBKtS8uopQpYcT8TW2GIh4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenwen Fu <wenwfu@qti.qualcomm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0554/1005] tracing: skip boot kprobe setup when no events were requested
Date: Wed, 25 Nov 2026 15:31:32 +0100
Message-ID: <20261125143834.723497372@linuxfoundation.org>
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

From: Wenwen Fu <wenwfu@qti.qualcomm.com>

[ Upstream commit 2388a673e9276de30c7e917fce50830e497d46cc ]

setup_boot_kprobe_events() calls enable_boot_kprobe_events() even when
the kprobe_event= boot parameter was not supplied. That call takes
event_mutex without any command-line probes to enable.

Asynchronous eval-map updates also hold event_mutex. A normal boot can
therefore wait in init_kprobe_trace() for this background work despite
having no boot probes to set up.

Return early when the boot-event buffer is empty. Keep the mutex
protection in trace_event_update_all() and retain setup for explicit
kprobe_event= parameters. Bootconfig handles its own probe enablement,
and the existing trace_eval_sync() still waits for background work
before init memory is freed.

Link: https://lore.kernel.org/all/20261106021457.2648231-1-wenwfu@qti.qualcomm.com/

Fixes: 970988e19eb0 ("tracing/kprobe: Add kprobe_event= boot parameter")
Signed-off-by: Wenwen Fu <wenwfu@qti.qualcomm.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index e41a7c113646b..6e0fff6b4d91f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -2017,6 +2017,9 @@ static __init void setup_boot_kprobe_events(void)
 	char *p, *cmd = kprobe_boot_events_buf;
 	int ret;
 
+	if (!kprobe_boot_events_buf[0])
+		return;
+
 	strreplace(kprobe_boot_events_buf, ',', ' ');
 
 	while (cmd && *cmd != '\0') {
-- 
2.53.0



