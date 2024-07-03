Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4801516C688;
	Wed,  3 Jul 2024 11:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005900; cv=none; b=XFzYi3kbyPM1go6Zz4Mg5XWWd2J1gWSSmBwjtgvT265NPpwaW8XFkV1gcgW6LJhH8m6gWvKpHBCdwgx+Jw2zPonDVdVg559IO9J/ypfxpZxXa/3UQnEXNspHv10TXH8YFTa4mx3FtchyaZvCa4eImnZKlL2El/40/VtnDw+bLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005900; c=relaxed/simple;
	bh=AcRDbfIO9XL9QBVk6GbCg9r2x5FyYhd4fZ0qB149Lkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY040ktMIYWDGSmDsNdzfXJJ03h5UYyn/8tfoo4wo+4dBNzOgXqzosEdyFdNN4rouUHg5TT4cxkDsrO0rd+zyONuR2ex4hWNJLYJmjghNVoLnRMhdZxz3HLdtMQlNvn+HAPADc6NkmO0SmtkvqI3Vm06JDE0uTlNiny5oU1OFNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u05+5S9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u05+5S9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750D7C2BD10;
	Wed,  3 Jul 2024 11:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005899;
	bh=AcRDbfIO9XL9QBVk6GbCg9r2x5FyYhd4fZ0qB149Lkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u05+5S9ON7Jf17hUn2pxvn+ovAI+uy4F89YyXbf+YpceKbIuHbt5YZjWmtURJMaaO
	 vKxvDx3HLpb1qYLzVJ6pDXExNQyHNGxo4hRpVTsc428s3luy6s7yeBaxthHc4hwNsl
	 HlICDv/ON6xj1cR5nejnjBR4C+MVUTsBqMr1Nzik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/356] perf script: Show also errors for --insn-trace option
Date: Wed,  3 Jul 2024 12:39:29 +0200
Message-ID: <20240703102921.930931355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d4a98b45fbe6d06f4b79ed90d0bb05ced8674c23 ]

The trace could be misleading if trace errors are not taken into
account, so display them also by adding the itrace "e" option.

Note --call-trace and --call-ret-trace already add the itrace "e"
option.

Fixes: b585ebdb5912cf14 ("perf script: Add --insn-trace for instruction decoding")
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240315071334.3478-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 45ccce87d1223..78ee2c2978ac3 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3603,7 +3603,7 @@ static int parse_insn_trace(const struct option *opt __maybe_unused,
 	if (ret < 0)
 		return ret;
 
-	itrace_parse_synth_opts(opt, "i0ns", 0);
+	itrace_parse_synth_opts(opt, "i0nse", 0);
 	symbol_conf.nanosecs = true;
 	return 0;
 }
-- 
2.43.0



