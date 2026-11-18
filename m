Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016631;
	b=KiofWpZsvfVNyvKT9vjKk6G1R26jyZaHr7Y6lVdZvcK9cTSaZZnRjQ/sfmcccmWEIdiv
	 gK8JkEvHVcymcGZtMbWoiMQyV0niVzIEZxZO4WgGVufzSGc7SMP7GB6lqvhNBXPdfb0ne
	 tBEU907feQzJiSiF1DNmMSL7hUZ/CZBUTJ99c949r+VqolpBj5CiDNO9ehMBgNK3LlYFb
	 3sZDCRZYAasaB+Hi98FkCnTHuiLgPDU3sx1raw4h9QvneR4ZA0BNOn1cBN6P95tSolyir
	 fAPeRW8f78zyNjBa249zIagtBx5MpZBqgjYIkpqFDfo5ofKQNtjlwWktcFQPEWgZpXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JZB/h32wtFFGd983U6OTX/F1Ts9cElG3nxNV1rjpNBU=;
	b=VBd2zCZQe4xed+dnD1LRh9IrWHyt3oapQEoAjL6xlf+5CAsi04CCoFWghyW6t+0BLlp+
	 3mP8nStJDUba4JlV+EMyR384Vv9CJ5DhBu85LV6pSclR/EIebtPfcWh4LtTl1Mlqnxxhi
	 KZgyxRTI2+dfWOGyGQukd9LmY70oZ1PSrVeRA4TiQQKjnDu0NUU0o4lCBxL4bUMO4xHNA
	 7NJwnly8P3ep6xd1DTmEx7T1/f8HIvEsxWiSHXeSK0lBmQoaK71c4hgRQtQOEN560K1ld
	 ZMKRRL1c7rX22Mwb4zEYa6Q53R8dnZqQybIX4CMH57GfZquXkackZQwwAAFNIrJnJPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAGq8mXV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D299C606A320;
	Wed, 18 Nov 2026 15:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAGq8mXV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DCC1F000C4;
	Wed, 18 Nov 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016631;
	bh=JZB/h32wtFFGd983U6OTX/F1Ts9cElG3nxNV1rjpNBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAGq8mXV8dedEesXp5bfvwcJPrjKIBToGKhJER5VzcWSJkAwWolJb1jttWHcOC3Aa
	 EUmkOoiZ74rhD0sKt1UnKgQOZWfgzUnmDKCCwRV2S8H2yRDeOhT2UTyFJFj165F+xL
	 6akiqAF/XZyD2UWxjuwpGdU1AcMTO6J66hZOVubI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0596/2651] perf libbfd: Report success when an address is found
Date: Wed, 18 Nov 2026 15:30:36 +0100
Message-ID: <20261118150309.173583374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 3d8fb5a4a1d793f6afdfe6df6868f82e610e447e ]

libbfd__addr2line() only reports success when the caller asked for a file
name. addr2inlines() passes a NULL file as it just wants the inline_node
populating, so libbfd__addr2line() returns 0 for it unless
bfd_find_inliner_info() happened to find an inline frame.

addr2line() in srcline.c treats 0 as a failure and tries the next
addr2line implementation, which appends its own frames to the
inline_node libbfd already appended to.

Every frame that isn't inlined is then reported twice, which happens by
default when perf is built with libbfd but without libdw as the fallback
order is then libbfd followed by the addr2line command:

  $ perf record --call-graph dwarf -- perf test -w inlineloop 1
  $ perf script --fields +srcline
  ...
	    56051a994f8e parent+0x2e (perf)
    inlineloop.c:32
	    56051a99503a inlineloop+0x8a (perf)
    inlineloop.c:47
	    56051a99503a inlineloop+0x8a (perf)
    inlineloop.c:47
	    56051a95841a cmd_test+0xb7a (perf)
    ??:0
	    56051a95841a cmd_test+0xb7a (perf)
    ??:0
  ...

Report success whenever the address is found, like libdw__addr2line()
does, and clear the frames appended so far when appending fails so that a
following implementation starts from an empty node.

Fixes: 257046a36750a6db ("perf srcline: Fallback between addr2line implementations")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Cc: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libbfd.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 2a73124b76b85..936555217e81a 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -258,6 +258,7 @@ int libbfd__addr2line(const char *dso_name, u64 addr,
 		int cnt = 0;
 
 		if (node && inline_list__append_dso_a2l(dso, node, sym)) {
+			inline_node__clear_frames(node);
 			ret = 0;
 			goto out;
 		}
@@ -271,23 +272,32 @@ int libbfd__addr2line(const char *dso_name, u64 addr,
 
 			if (node != NULL) {
 				if (inline_list__append_dso_a2l(dso, node, sym)) {
+					inline_node__clear_frames(node);
 					ret = 0;
 					goto out;
 				}
-				// found at least one inline frame
-				ret = 1;
 			}
 		}
 	}
 
 	if (file) {
 		*file = a2l->filename ? strdup(a2l->filename) : NULL;
-		ret = *file ? 1 : 0;
+		if (!*file) {
+			/* Leave ret as 0 so that another addr2line is tried. */
+			goto out;
+		}
 	}
 
 	if (line)
 		*line = a2l->line;
 
+	/*
+	 * The address was found, report success so that the caller doesn't try
+	 * another addr2line implementation that would append the inline frames
+	 * above a second time.
+	 */
+	ret = 1;
+
 out:
 	mutex_unlock(dso__lock(dso));
 	return ret;
-- 
2.53.0



