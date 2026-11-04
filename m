Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829754;
	b=J2wYiAO1VJVAltzV1P5jRWtwZKTDmapXebhah7mUb4f2we6ZpLd8Ry7lspe4jV0/c5H9
	 TKoau0ww9EQmKSl+s3nFBUP/UwFbEjbZKeUl0AWBMB6IdSmrPZ4oKDjI57NpkzIdlFTma
	 KsmRxg1/bntuYFTceBp2270jyv5UrrJEnGXKe5lcMh3mh3UqfHwpLsrWE/IN2ywo8XA3r
	 z27C9pQ1ZeOHiEcgICeQtHLwYbaMHQgCjN5zbyDGExdg1aHEMBSS4qGs4actw14BCDaKl
	 4NACV8SidLZNd96W4scLGgvOWUvFHwGRuR5xmzyYn8x2F99vavHk5gcsHgwbSSEWTVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ayG6Vup8M5EifTjchPlxzlcTwJAik5sP8kwxJRR0Vzo=;
	b=tRBNUXfJ5Jxtza9G+/inXq2pLa1BLmvYxS7emaf5NfPLMLAM0NkYf8XaqdpkqEqRcdxa
	 uEr2Z5xiZ/AxTVRAnGSPHzuuyD/Ej92NcP0HFnqPt6NJjm68Y2r+gHmspBiKhry8IIXPJ
	 6G8iDXL3yWtRBUAnMsCBF3amTmBnOn2s+rdzagLSFdSHvCGFWLV0dzPl17dJ2VPLRM1B8
	 itC22XwqpIktGxxVt+XNpHY7zRXimmAKjDJ5kDTn5VdgIc5FlBk5N7iOF+MupdDQovnrR
	 hqduIwK7JAZzIjmuUNFhOYdKGrLVxvml4FRgEN7VMdhmc8ZVEGzUXoTfRKbrHrFc1Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AkqL/9GQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8165E606C922;
	Wed,  4 Nov 2026 22:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkqL/9GQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B691A1F0093A;
	Wed,  4 Nov 2026 22:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829754;
	bh=ayG6Vup8M5EifTjchPlxzlcTwJAik5sP8kwxJRR0Vzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkqL/9GQ3Lc9NgzA8vplXYWk7hVPtBA6DpmieTi3ofy02/9QIFx6qrwAupUrfYoyY
	 KFRjJ4lsbYC1NRiqIs3w8NPAd3h2Wi10XsaLSBQ4zx4Px/BZGlqfmreKaNZjiAGvzw
	 JXaBJkGZ9yeO3wQvde+4Lo3nTWIb8aVeCmCy1uf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0322/1005] kconfig: abort rather than loop for ever on EOF
Date: Wed,  4 Nov 2026 16:00:55 -0500
Message-ID: <20261104211052.964284299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Glass <sjg@chromium.org>

[ Upstream commit f915149f5cfbd0d4406ec0b0f57b1d2c8685ae55 ]

When a non-interactive 'make oldconfig' or 'syncconfig' meets a new int
or hex symbol whose default cannot be applied, conf_string() reads a
value from stdin. At end of file fgets() returns NULL, no value is set
and the loop asks again. The result is an endless loop which fills the
output until it exhausts memory, rather than a clean failure.

Detect this in conf_string(): if the value cannot be set and stdin is at
end of file, stop with an error that names the symbol.

Note that a symbol with no default doesn't trigger this, since
sym_calc_value() falls back to 0, which is accepted at end of file. The
loop is triggered by a broken Kconfig file, with a default whose text
fails sym_string_valid().

Such mistakes do creep in from time to time and are hard to debug, since
the build fills the log with repeated prompts instead of pointing at the
offending symbol. Some bad defaults draw a parse-time warning, but
menu_validate_number() accepts a reference to any int or hex symbol, so
a cross-type reference loops with no warning at all. For example, "0xff"
is not a valid int value:

  config HEXSYM
          hex
          default 0xff

  config VAL
          int "Value"
          default HEXSYM

Interactive use is unaffected, since feof() only becomes true once a
read actually hits end of file: an invalid answer at a terminal still
re-prompts, while Ctrl-D at such a prompt exits with the error instead
of looping. bool and tristate symbols and choices already accept the
default on an empty line, so they still take their defaults in a
non-interactive build.

Tested with int and hex symbols carrying such defaults: with empty
stdin, the code without this change produces around 190MB of repeated
prompts within two seconds, while with the change it exits 1 naming the
symbol. Piped and interactive (pty) sessions still re-prompt on an
invalid answer and then accept a valid one. A new string symbol with no
default still takes the empty string at end of file, since any text is
valid for a string.

Signed-off-by: Simon Glass <sjg@chromium.org>
Link: https://patch.msgid.link/20260714133545.3294648-1-sjg@chromium.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index c368bec5ab601..fe8ba09b00391 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -348,6 +348,23 @@ static int conf_string(struct menu *menu)
 		}
 		if (def && sym_set_string_value(sym, def))
 			return 0;
+
+		/*
+		 * A new int or hex symbol whose default fails validation
+		 * cannot be set from an empty answer. When standard input is
+		 * exhausted, as it is for a non-interactive oldconfig or
+		 * syncconfig, re-asking would loop forever and grow the output
+		 * until it exhausts memory. Stop with an error that names the
+		 * symbol instead. String symbols accept any text, and bool and
+		 * tristate symbols (conf_sym()) and choices (conf_choice())
+		 * accept the default on an empty line, so they are unaffected.
+		 */
+		if (feof(stdin)) {
+			fprintf(stderr,
+				"\nerror: no value for new symbol '%s' at end of input\n",
+				sym->name);
+			exit(1);
+		}
 	}
 }
 
-- 
2.53.0



