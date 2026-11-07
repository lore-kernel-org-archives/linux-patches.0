Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060890;
	b=v8gywJLhmT/Cc1YbgwyrBKBkQ5O5/fEfxkWmZ8fecHOiCjtbLRcrrtmpw1dykVpZEGx/
	 N17iPXyp5N/522sE9VOxQSEffe0+ELMi92XJpa5EpuB2K6dXs+nI0rwPo8E/g7o8aw2uO
	 3uoYz30nLBXFUTPDC1jr7Ey+uN2hieLpc6J3zH3g6iny+zMsX1P6HE4h000s06HcMVfST
	 7kHvZmychyP0ila6nZajHRTwcytMKnMwyFFHFKisZWvU1N/qIKtzIT6TSrwr8EhTIaSyv
	 0l7wRA2eCXFl3/c9bu+8RQDm/rd57woeIsq8HCgRkgggafJ/qNBk6nELxESIQ5/YTFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N+xDVr5+oMoNzSqCUMKUj0OmAKob8uyJQGGUvpgBXEs=;
	b=cK2M45v5pFXRLz1O23AFvJ5aqpFnBy18wDU/NV0w5pjaF7tYlaZK+UwDoda6k517dN+Z
	 FP9C1sijd0K3AA1xeFIhxU5uVBk1WzKl7qEQgj+RpMHj3MT1acVGqPRXkSDpYurfAPxoU
	 Qw6UJHKDACMMMvFL9yVQWAJi8sgRlpwOzbL0PUeOLikFgf7Bv5ZaFXtbIMuVXQBVNmEOX
	 z1qzOVb5NL5Hna6GFOycovJ56l33XWV31XM2TrLAaU3/k6Bp38hq+9lGQ+JfbCrKj+9qG
	 rvo/seo+8iTpeedV1Yc4vel7BOEPG8VVWTXQBN9V7p/f65Du86y93Xg51apZa+dLDqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmzI2oYw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3BF606A336;
	Sat,  7 Nov 2026 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmzI2oYw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49731F0089F;
	Sat,  7 Nov 2026 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060890;
	bh=N+xDVr5+oMoNzSqCUMKUj0OmAKob8uyJQGGUvpgBXEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmzI2oYwQmVF5k35dAcFIHBd9sYYFq1Nca9pkUBiXjIf8VzVm1ue7MRmlKXU22R7J
	 Lb7IaSbBASBGA11a2gRDI0YXts3EMxuBjK8Hn55cw7NFI1jMHJdwX0fzXZtwHp8bkJ
	 +6TBDDHV3cgxLIggN0tonxFfH1+3KJ/7LgE+Ue64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0267/1536] kconfig: abort rather than loop for ever on EOF
Date: Sat,  7 Nov 2026 08:38:03 -0500
Message-ID: <20261107135005.179871052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7f4b371ef41f3..efc7ae166c8af 100644
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



