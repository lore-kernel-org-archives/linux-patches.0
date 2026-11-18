Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020795;
	b=XgDyCz71UBRP460WiLdlHJCEl3lmRYCtzOwHJbud9BrPjagBK+yi0D7KM4TNZXLwC4J9
	 Kb5oOv3+veH4wmWOpbo6H504+3rRGcD7eSLdPJ3LszFQS0N0vy2Fv3A3CTg/HRQwhSHsR
	 5BAs4Aj4ONl0yx2pk2/uWTkKiadvWwGU9SUt7VGNbCbuNdw1CUhZ4Z3b+SuWTbtxmpb71
	 slgCD8nGSEzXG4oCzGc3+8MUichlrnVjL+2/suUOxVPqxFjFYWX+bLrCo2H3H4JrMNjC+
	 go+caPjVgD+YlLN4dsWUjFHQ0EH7mBd0SGuoP9Hef9W/0goK4LTBvsnqO3e9sl9pfMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g8GKn2GeKFqTRDctHKGN4ZgyImdXTMS5S//yTOY+4jE=;
	b=bANAUwg3OdoCQIrwv9qEeNfD8MNePJ1gPXe57tR14Ek3op1pUAcmxhmpQJqRjNEjTrDK
	 Yo7svuaoLp19YQt2re4QNfWHb4WXYshMd6VlmKeSeU8o8Fgjv2u1fxulmkzZ9UJqt10+z
	 FwFw34OPWawN3vBNAFUD3B8yTCjTcjHh34fYvnfFe1nWSNd+YexfodI+EcMAp68UB59bk
	 RrJPqAnx6iZxKpSTplqElm3jHQvNYMIykWfxes1eCz3YTwSOnQGTDc37+pajBmjEkYoTD
	 qi5sPcS4gUcXu1VBZFDNsj/wTKYoCmFhlrH42xtSrtzHtFKV//TvenP1bJaaIg2WyiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLo082WZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD15606A330;
	Wed, 18 Nov 2026 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLo082WZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9ED1F000C7;
	Wed, 18 Nov 2026 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020795;
	bh=g8GKn2GeKFqTRDctHKGN4ZgyImdXTMS5S//yTOY+4jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLo082WZWK9mDS8Ao5EpLhqcoxFWodeYSgooHEublibwNcQV/lzDb3KYOXHbLmPI2
	 3Im274boONtARaXAe8968hKnEw9As1Nbz2paFxqrVDRT5wTFGk/R7Z1vTxuT/7KXfO
	 Zv5SEeBeu234a6IBYK3kTIwpnzdYmFs951yKogHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2079/2651] perf test attr: Fix record dwarf sample_type expectation
Date: Wed, 18 Nov 2026 15:55:19 +0100
Message-ID: <20261118150400.876722120@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 10e2992e5438c39d8404714aebf3261a391bc76d ]

Since commit bdd051e24914 ("perf record: Split --data-mmap option"),
record_opts__parse_callchain() sets record_data_mmap instead of
record->sample_address for the DWARF unwind mode, so -d/--data and its
implied PERF_SAMPLE_DATA_SRC are not enabled implicitly anymore.

As a result, --call-graph dwarf no longer sets PERF_SAMPLE_ADDR and
PERF_SAMPLE_DATA_SRC, making the test fail:

  expected sample_type=45359, got 12583

where 45359 (0xb12f) is:

  IP|TID|TIME|ADDR|CALLCHAIN|PERIOD|REGS_USER|STACK_USER|DATA_SRC

and 12583 (0x3127) is:

  IP|TID|TIME|CALLCHAIN|PERIOD|REGS_USER|STACK_USER

i.e. the values differ exactly by PERF_SAMPLE_ADDR (0x8) and
PERF_SAMPLE_DATA_SRC (0x8000).  The mmap_data=1 expectation is still
correct as DWARF now enables record_data_mmap.

This went unnoticed until tests/attr.sh stopped ignoring attr.py's
return value.

Fixes: bdd051e249141c79 ("perf record: Split --data-mmap option")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/attr/test-record-graph-dwarf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/attr/test-record-graph-dwarf b/tools/perf/tests/shell/attr/test-record-graph-dwarf
index ae92061d611de..fbe0faa8cdb6a 100644
--- a/tools/perf/tests/shell/attr/test-record-graph-dwarf
+++ b/tools/perf/tests/shell/attr/test-record-graph-dwarf
@@ -4,7 +4,7 @@ args    = --no-bpf-event --call-graph dwarf -- kill >/dev/null 2>&1
 ret     = 1
 
 [event:base-record]
-sample_type=45359
+sample_type=12583
 exclude_callchain_user=1
 sample_stack_user=8192
 # TODO different for each arch, no support for that now
-- 
2.53.0



