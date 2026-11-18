Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060272;
	b=NLosd3C0gWn+msbBTTCY5NOUUpL5HimusskTrzNKx8Sk9hbwZIi67mk3NBTOgAU7hMCo
	 cLjwJZcyiRh7xQR53WHv/TPygOcUEf0fRM2ZGjBfqLtiLKu4ZCKe/6w8jaFXqyEP1eYWO
	 fnRerecHml13CH78lKMvEiFnTR5myHimFXOPZqo+pHeNp4DuKXQETnyPCOIXm4HoRqPsY
	 riXVhASrigcG6YSInOMI6XP7+m3zEMX5f6dQ0wPSFtY/HTVexNmCNl1z/1V69AtYu6RaS
	 ghdq0EyqfyXKSN4TngvfUc/Est4HCElEwVHl1BHgM3jQzDVxplvly0VuPpNKBu646oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5o7/Hf2mXo2GdVZn1g9hUDSilHPvivGi+9fxS00JzB8=;
	b=QBxzXEDpHwEQQA6B4XZO3daCbe1qUYT01G5IBm8v8MowytZlqYo3rUFErkTn0++2+s33
	 mzK9nKYn2X6TdCif1jqkIBH3vwnYrz3wtu8d5W//V2fcfCGwu4sYCAsE+bbVFbW3WkSlN
	 ROzEzFUWzGAXI9p164PGcWmjLB9Vc0rkzk8CePT24myGoWq8kIj+XNUKgtYRdrsmH5XMq
	 U3jZEDD2Iwj2SKcn/btPG3Sm4PBCTLTk/YoIQ2myj0sqF3GMKujgg2PWzplyu0hqYTA3j
	 Lt3s5l1iND54JoGoSpVmaVqKdRUTHdITcUa1JxjzmsWOD6wGC9dVGyYXsEhfcV0RI+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1N7s8Kbk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD69606A320;
	Thu, 19 Nov 2026 03:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1N7s8Kbk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8D61F000C4;
	Thu, 19 Nov 2026 03:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060271;
	bh=5o7/Hf2mXo2GdVZn1g9hUDSilHPvivGi+9fxS00JzB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1N7s8KbkP9Ws1YwvTuRygr53FwVqfGN8ZlNzOzdBTs+j2B4s220bsPpuxaE5uWzU2
	 7pY/cO6s4GHttyWIyfKfJamhR6H+C8WPW/m/71RbKyxYa6Cf28TWt3MfM+FDSeiE2s
	 nHFO1tlytgQ9aGyXNfOdzWC8Wd+/K3qbFOV4wdSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1138/1848] perf jitdump: Check snprintf return before computing header size
Date: Wed, 18 Nov 2026 15:52:56 +0100
Message-ID: <20261118150007.178330837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 0155f05ea6e133c18a04b8b5945cac59870da156 ]

snprintf() returns the would-have-been length on truncation.  When the
jitted filename exceeds PATH_MAX, the unclamped 'size' value inflates
sizeof(event->mmap2.filename) - size into a massive underflow, causing
the header.size computation to write an oversized header.  The
subsequent write to 'id = event + header.size - idr_size' then corrupts
the heap.

Clamp size to PATH_MAX - 1 after snprintf in both jit_repipe_code_load()
and jit_repipe_code_move().

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index c928f5a22a201..a9f2be429ebf2 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -470,6 +470,9 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 			jd->dir,
 			pid,
 			count);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
@@ -581,6 +584,9 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	         jd->dir,
 	         pid,
 		 jr->move.code_index);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
-- 
2.53.0



