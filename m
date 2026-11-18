Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043471;
	b=o0bhBW4dzWWRqh3Ox2VhB6RJVt+Kas+CEknG1l40sYFT8Nl2bIuwuxcTmSFj3Pwbx3/1
	 Fgos9NaqfCU09glmVgWt+ETd2kghe+J9AFaaSaz3Cdz1DUbNlEUnT7gl+dre7vagQX54Y
	 1UsC6MVkkhz+xzwW7j9ygKbaPPqW3abGA676BGlFFNm3Muv3T89Djuub7guTmoxtdTiZe
	 Xsw8a53VGvLPqIjJ2RdPT07rQzfHF23+VvJ5OgsEo6RHA5cQdo3+awR+FmTfV+IChQxmR
	 ut9STMW4iLpBCHOJWxFocRjXdU2n94hiZp2YbGQVs2bz5a9kwe2ho8AbuWjp+MgiyEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=urWfOH7tVQZKbEnmuvu/JcGVs8qDk2RNUBPj1GKVQmA=;
	b=z9V96cWPOBvND69qBCiB6F8Wa9w8hCtCngSfRzAkCdfkDR3XmQ0TuGY0UTDGGAf4Q4hF
	 N80QHqIypYk9uEZieiWR97mJbj+qcMLo7xd3NIEgNT73nuqX0N20Zt9gflrarRN5QJrbW
	 tM94LQ1cRN+D7vZf7jycm3AJEgnKf50w+6edJr3c5xVyjhT4I4nWIDEjZR0PHuyKZJZBG
	 0J2ILpMjN8399LYFj4j97S/Ki5jPNBMRCaQrtJgVg1L1/KfKooYoRNa/UhZ0zaIE348+6
	 mnjHVxblMnre3zfpmVIrKXhER2dvhsKNla7cmYyziZPuOTnoNFZYYadBFp8jsNURVFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcD8yCu6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D42606A32A;
	Wed, 18 Nov 2026 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcD8yCu6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E191F000C4;
	Wed, 18 Nov 2026 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043471;
	bh=urWfOH7tVQZKbEnmuvu/JcGVs8qDk2RNUBPj1GKVQmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcD8yCu6Y89fL9Ayn5GbWp8AiQM8MIL6mxGWy1Qr3vNXZ68xD4Q3OH6rzwaXv/69U
	 hBeONI9CXKgiby/nOeXFraZFaQMPrawwGoVYmPgCqUp206FOx9ykSMmkikJp6Es60a
	 OSRiGHA7w8FBYnVU5vYbOhD97v/F/fkRuK06YTD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0195/2857] kconfig: abort rather than loop for ever on EOF
Date: Wed, 18 Nov 2026 15:20:29 +0100
Message-ID: <20261118150208.374592181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6c4ff012a05eb..fde46ed7eb397 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -374,6 +374,23 @@ static int conf_string(struct menu *menu)
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



