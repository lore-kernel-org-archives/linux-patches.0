Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704472;
	b=uhxo/L+SauiLdMPMgIzxdiMSw4TjtNw2qc3UNPsX+mrFZ3NcJNeDO2sBoAc52IUpTB+E
	 FwDpKPo4eJfjcgCmOJ7IydA5Mc9ccIO0oYcxL75I/M9iS50Lmza407yR5jtisVGECq8Gx
	 1LbASvJZTdEizBuJFUSNthN53kgCFwQjvkWh3o9sVzGdTz8g3j43XBhJ/Z96J3xF1PONh
	 Njdb05BYwcBmEdiPI9Mol8slwyNyGJ+dyMWUqY85irw9j1NLpViDCNHgjpdOdRm8IjVaq
	 144b+Yw/VEywX83f3fhqCiVwj8Ng8agrs0mCWWppmpG3D2rcv6IjM7Qo61qNAKKas0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oMSSIlI5W4eDc/bg6MUw4n6dg/m+6m4YF51SCSBeCgg=;
	b=nt4tGhQGGo3ODe6Iy8sXqO45uNI2XNOOG0w9FpDeBOfu97CEY5mlmQ204fVOdnqWpwz/
	 RWBzkXAtv9YlX0aAw7xHXxgRJiN16DnESeLRr6SPkXXdYdzTrkWYhToiriOM7AW13bKv2
	 BRZEWB38bo6CpyGmFXahk7SRL6/5FEhKCvySfHKDWrF8Apz+ZT4+uP5kQ4XhIn2Qv9eGX
	 JcyuQUxXZhVTEl8W23nv6wUkiKFmn8PXCswHSZcpnx+HDGUQ9Dkpn1YGl+gEapBHbdrJE
	 X1Jag3lN/5j25X56zX4qtPH3GdLn0fWbqzHh6Ox3loJAoiTQIZ5eZnDovklEnGQJwZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reo2ZLcF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EBF606A31C;
	Thu, 26 Nov 2026 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reo2ZLcF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EF61F000C6;
	Thu, 26 Nov 2026 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704472;
	bh=oMSSIlI5W4eDc/bg6MUw4n6dg/m+6m4YF51SCSBeCgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reo2ZLcFCTmaCWvSeGX7nFv/l6W2S8B4aDdciH5WfVtYsGgTpbYIg0idPQFbkiKpa
	 wPL1eSNxuX7Pd4KZEOWGmCPQtSUkzQvbQxE7uwUUC3nTVnB7PjzpeSI730G5OMvqB0
	 pfPkRl3XC9WZ2Fl6f6Dcbj/bo/GU5klgOcMtGOus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenwen Fu <wenwfu@qti.qualcomm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/265] tracing: skip boot kprobe setup when no events were requested
Date: Thu, 26 Nov 2026 15:37:45 +0100
Message-ID: <20261126143614.475385373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 044df6073211e..cfba33f74813c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1967,6 +1967,9 @@ static __init void setup_boot_kprobe_events(void)
 	char *p, *cmd = kprobe_boot_events_buf;
 	int ret;
 
+	if (!kprobe_boot_events_buf[0])
+		return;
+
 	strreplace(kprobe_boot_events_buf, ',', ' ');
 
 	while (cmd && *cmd != '\0') {
-- 
2.53.0



