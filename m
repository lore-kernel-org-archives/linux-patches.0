Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015752;
	b=whrDCOm6Opg3A4GLCQI5wRZQb0R88dTrLUl4rAoiXetccXcIREYOgOu1jDY8FAVK3MIX
	 mGmhQ8hJj0NRC7UykhPEBX2zANQrv+LyVtNekHba5PT/ajv4RE7ZJlL6L80Xr94tHlrMc
	 j+coQSWvWV9zpRlg0DllND3+USiCn6oe2gwkkExOyF4Twu0RlLje6qSkTd80XKYYi+yrV
	 O+xXJlsbpRu8pZTZf5d9uKBWjQXZO3GxWXsd3aZ2orUpLKW4IHXIT09r7nPbZ138DQdEn
	 X2IDZmpHYxqMhAT7hlC3MZxxM4kCYbpRY+PhCfmoZM0IplnjmePU3VuWYt7vmslbJPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qDGrbLsFJ5BUPxzqwSATxD8/QGICbLdfBarEJ/z72+4=;
	b=Ccbk4WwRCNCiXcQD0+IbBhmci5pFETfpF/TyInXxUL8xvElD+a6UVkZNvzv+xhu21qPA
	 Kg4pyyZsZBmKevI1xXYmSvyiv0wxT9mZEq6OAbitDs98aut60EWGQgIy3URtSu4Irei6G
	 4OwPSne1pKuJ4Nk2nZqQaNpWQa+RKH+BWycLLuw6QYN21nqAau4EwF4AqJFs9zZ+Xx5YL
	 rHekr3URrY0gOm8wQGjLJFMot9iM68ET5DMtswkzYLP71B7qBK65qfwrwrh9JsP1QAdzy
	 FsnyWJpVcFdXdWrPb28DUGk0Xy881l63cj0ER79euyUf1iHP7wvkC8zOfrppEGffD/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2iP8idSP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BCE606A32A;
	Wed, 18 Nov 2026 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2iP8idSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0A01F000C8;
	Wed, 18 Nov 2026 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015752;
	bh=qDGrbLsFJ5BUPxzqwSATxD8/QGICbLdfBarEJ/z72+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iP8idSPAfRT62x31RBKXrSfBnMKsZbGLxjOhH4nndwLBin4ru8+8PMy4QdNPlZHC
	 pcvKbQTVxAI7bF25PGYGmKzGK14QX8EFqWeJ49sbFwjatyASqNrlc4YxuvYwYtEydP
	 SqiAbe/Bc8VzhXQe8y+wl2PiTASCy2EB02nmqAl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Matt Turner <mattst88@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0284/2651] perf thread: Fix live-session detection in thread__e_machine()
Date: Wed, 18 Nov 2026 15:25:24 +0100
Message-ID: <20261118150258.134077106@linuxfoundation.org>
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

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit 15917a3a1ce0695f824892c8f9d0dc51408ee580 ]

When the per-thread e_machine cannot be determined from the DSOs in the
thread's maps, thread__e_machine_endian() decides between reading
/proc/<pid>/exe and falling back to the recorded session environment:

	bool is_live = machine->machines == NULL;

	if (!is_live) {
		/* Check if the session has a data file. */
		struct perf_session *session = container_of(...);

		is_live = !!session->data;
	}

Neither half of that works.

The back pointer added by commit a088031c4998 ("perf tools: Add machine to
machines back pointer") is set by machines__add(), which only ever adds
guests; the host machine never gets one.  Host-machine threads, which is to
say almost all of them, therefore see machine->machines == NULL and are
declared live before the session is consulted at all.

The session test is also inverted.  A session with a perf_data attached is
one being read from a perf.data file, i.e. exactly the case that is not
live, while a live session such as 'perf top' passes data=NULL to
__perf_session__new().

So a file-based session takes the live path and reads /proc/<pid>/exe on
the analysing host, which at best describes an unrelated process that has
since been given the recorded pid, and normally just fails, leaving
e_machine as EM_NONE.  The perf_env fallback that would have supplied the
recorded architecture is never reached, and thread__e_machine() returns
EM_HOST.

For a same-architecture recording this is invisible, since EM_HOST is the
right answer anyway.  Cross-architecture it is not: annotating an Alpha
perf.data on an x86_64 host selects the x86 struct arch, so the Alpha
disassembly is matched against the x86 instruction table.  Alpha's 'ret'
collides with x86's and gets ret_ops, while its calls and branches match
nothing and are left unparsed, so no call target is resolved and no jump
arrows are drawn.

Set the back pointer for the host machine and correct the session test.
The new back pointer does not disturb the other reader of the field,
machine__findnew_guest_code(), which machine__resolve() only calls when
!machine__is_host(machine).

Fixes: 70351029b55677eb ("perf thread: Add support for reading the e_machine type for a thread")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 1 +
 tools/perf/util/thread.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 10a88c070814d..ad29a30a7b891 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -237,6 +237,7 @@ int machines__init(struct machines *machines)
 {
 	int err = machine__init(&machines->host, "", HOST_KERNEL_ID);
 
+	machines->host.machines = machines;
 	machines->guests = RB_ROOT_CACHED;
 	return err;
 }
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index e483ffcb5d937..f0d3773d87db0 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -536,7 +536,7 @@ uint16_t thread__e_machine_endian(struct thread *thread, struct machine *machine
 								    struct perf_session,
 								    machines);
 
-			is_live = !!session->data;
+			is_live = !session->data;
 		}
 		/* Read from /proc/pid/exe if live. */
 		if (is_live) {
-- 
2.53.0



