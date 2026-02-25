Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1191421D596;
	Wed, 25 Feb 2026 01:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982940; cv=none; b=AbkGwQXLCMbXUf1x9Z1WahPN96z4KwomJQ3ARb5XIneNfxlEDHx32DMzVVlPnq1sElp2ohFHkDtnw7No/xUJlRJ3/r4NVRk7bZN9/dQPzia+SO9cZ3olh3nUKxDu8PExlUDzV2glxvAik+iIXgl1AqU9XwoUe20qQiNyUE3B5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982940; c=relaxed/simple;
	bh=0kV9cLdn9r1KTG/fVdlfk3uDXSPlh+8lmYkDD5voOdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVIXdC1n9tfWef2I0bu/VWfyLd/xNHx7+Lf4NQ9Mcd/Num3qp2bU/Crub2u3wsxxqSI5Av8BUGbdWM+gUaWvuMyb/+zfkTqRzOeU6pZ77STUrv3F525dbpBQ3XDBABOGVxR9WOVA3UbeMCxiX4HHjUw6j1w8SRY5SQEC8LOy+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAa9BW0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAa9BW0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C0EC116D0;
	Wed, 25 Feb 2026 01:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982940;
	bh=0kV9cLdn9r1KTG/fVdlfk3uDXSPlh+8lmYkDD5voOdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAa9BW0zB1Bm8Ox10iYW6H2yzWkk0UvhfC1bFJrB21jxjlUFewxb7Zy9+PNHK7hVB
	 rOj5A0qTOMQ6UORZTvHLEnfzC8hpMzBbPRcYn2IieCXg1oVSF/vdoc6TGMJzLt3EKJ
	 PCFmSFHC0gGuILFzDkKAW5DzZ7kCPRxSfwKBTOGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 073/781] selftests/bpf: veristat: fix printing order in output_stats()
Date: Tue, 24 Feb 2026 17:13:02 -0800
Message-ID: <20260225012401.494316564@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit c286e7e9d1f1f3d90ad11c37e896f582b02d19c4 ]

The order of the variables in the printf() doesn't match the text and
therefore veristat prints something like this:

Done. Processed 24 files, 0 programs. Skipped 62 files, 0 programs.

When it should print:

Done. Processed 24 files, 62 programs. Skipped 0 files, 0 programs.

Fix the order of variables in the printf() call.

Fixes: 518fee8bfaf2 ("selftests/bpf: make veristat skip non-BPF and failing-to-open BPF objects")
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20251231221052.759396-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index e962f133250c7..1be1e353d40a7 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -2580,7 +2580,7 @@ static void output_stats(const struct verif_stats *s, enum resfmt fmt, bool last
 	if (last && fmt == RESFMT_TABLE) {
 		output_header_underlines();
 		printf("Done. Processed %d files, %d programs. Skipped %d files, %d programs.\n",
-		       env.files_processed, env.files_skipped, env.progs_processed, env.progs_skipped);
+		       env.files_processed, env.progs_processed, env.files_skipped, env.progs_skipped);
 	}
 }
 
-- 
2.51.0



