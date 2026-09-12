Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8443C346E75;
	Sat, 12 Sep 2026 07:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197505; cv=none; b=Ucd6qBmr+okU66BIg0k/+qRThgL5Rj4i6vF7emDLqot/CU4oXlFPNaa+Y0iEqfzmHyS/BJPkm6DR8PzTW98xL+MZbml163kMrd5RiCXTtKfhJGSIoBA68PShSrMvTK063iSh/9qakjpUIDS00ZcgaVPxqiYqxZ0YRnicS+n2prQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197505; c=relaxed/simple;
	bh=k0eSBXBCr1MjF09lYJmTTq5/abXCSBksjdvJJVPSzdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0fmE8Ftn6Nb4c5UtgAQhAD7AByPWs3sQj+hFmtAvvLDYMlkX9PRne7riMjUGwZaCLKP1/OfghlhTLOBR+jCpU7NXY9WGNNytJEHpqvkZf8swhI2TtiKG3zgrGX/QjsKnuTl2DcdZegGyJXEcOUnTH4q8RlVxreItEyc2XBkBHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw6Z6Afr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw6Z6Afr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B951F000FF;
	Sat, 12 Sep 2026 07:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197504;
	bh=tlTZPPK0xBVnezLDvXYD3n9/QYtBIqtMNPYetDwpyHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pw6Z6Afrc1Z9FL7BKYA55bWe+2AEQWxosuNtzTgLdhO1XPGAgHTq++Tkmk9QQU3mU
	 UeSzJ7/yXhCMSk91sK4V01XzQzBT+IcpyRcEt8lzvMVh9Eh0YRMznhLrUzCCHxVn9b
	 /KSsjhxa00r/XGbV2rz37ZUEYd9FlbjEeapwUghc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0181/1815] libbpf: Change has_nop_combo to work on top of nop10
Date: Sat, 12 Sep 2026 08:32:11 +0200
Message-ID: <20260912065653.254677666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit ee2862439e5c8763cee84e910706fdc5b97bc879 ]

We now expect nop combo with 10 bytes nop instead of 5 bytes nop,
fixing has_nop_combo to reflect that.

Fixes: 41a5c7df4466 ("libbpf: Add support to detect nop,nop5 instructions combo for usdt probe")
Fixes: 554ba38456da ("uprobes/x86: Move optimized uprobe from nop5 to nop10")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://patch.msgid.link/20260703114917.238144-7-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/usdt.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 57fb82bb81b58..d2ecd3daab961 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -305,7 +305,7 @@ struct usdt_manager *usdt_manager_new(struct bpf_object *obj)
 
 	/*
 	 * Detect kernel support for uprobe() syscall, it's presence means we can
-	 * take advantage of faster nop5 uprobe handling.
+	 * take advantage of faster nop10 uprobe handling.
 	 * Added in: 56101b69c919 ("uprobes/x86: Add uprobe syscall to speed up uprobe")
 	 */
 	man->has_uprobe_syscall = kernel_supports(obj, FEAT_UPROBE_SYSCALL);
@@ -604,14 +604,14 @@ static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note,
 #if defined(__x86_64__)
 static bool has_nop_combo(int fd, long off)
 {
-	unsigned char nop_combo[6] = {
-		0x90, 0x0f, 0x1f, 0x44, 0x00, 0x00 /* nop,nop5 */
+	unsigned char nop_combo[11] = {
+		0x90, 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00,
 	};
-	unsigned char buf[6];
+	unsigned char buf[11];
 
-	if (pread(fd, buf, 6, off) != 6)
+	if (pread(fd, buf, 11, off) != 11)
 		return false;
-	return memcmp(buf, nop_combo, 6) == 0;
+	return memcmp(buf, nop_combo, 11) == 0;
 }
 #else
 static bool has_nop_combo(int fd, long off)
@@ -822,8 +822,8 @@ static int collect_usdt_targets(struct usdt_manager *man, struct elf_fd *elf_fd,
 		memset(target, 0, sizeof(*target));
 
 		/*
-		 * We have uprobe syscall and usdt with nop,nop5 instructions combo,
-		 * so we can place the uprobe directly on nop5 (+1) and get this probe
+		 * We have uprobe syscall and usdt with nop,nop10 instructions combo,
+		 * so we can place the uprobe directly on nop10 (+1) and get this probe
 		 * optimized.
 		 */
 		if (man->has_uprobe_syscall && has_nop_combo(elf_fd->fd, usdt_rel_ip)) {
-- 
2.53.0



