Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5878E350A39;
	Tue, 16 Dec 2025 12:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887892; cv=none; b=LLKrmolRRobZV1Z/9fJE2FjssgRiMWTQCAX5A03x7rFLIAhUqx/GMxaklh4OFCggTnQ06KYRGiuV/fopSx3vSfC7ck7xD7zjyfQlHptvxW3vgl0zfwxT3GKBnQ45PeYpgmaI3vJ9a6iipSa5FXBnIn3lZpIuQ5JBnyjnVY1cEiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887892; c=relaxed/simple;
	bh=D3d0PUvB0fPjUkvS6T8IRpKasY0+RA/p2QKAZggWjdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWpIIokLGEotgC8LgPd9v+3/hMmP3HKmWpOJ2VckwcnHBSOoHxs+ceGfC96GsSVZndg7YjlqQZkniwz5lipTvzX8eANr0zECdds2Y/2mhE+1cB/iLqkArFt+T25brFatvsuSWO7X+6Ze9wywD1usGMUYJWraATqpkxpemuZws70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWBKVOHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWBKVOHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C90C4CEF1;
	Tue, 16 Dec 2025 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887892;
	bh=D3d0PUvB0fPjUkvS6T8IRpKasY0+RA/p2QKAZggWjdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWBKVOHHe58O+zVks3ki8cR03kReAqCED9SFLiFDH7mr1uoXAFwKV2xGa1k9ixn79
	 FKxBxSJmgCiAW40jGe/PVZIQr6h+UljoXHaSeX/hVhw/3a0Kew4hUcIjpFDf+POoHd
	 pKeNqhgEiE3u8QFAQEycApsx6tiw5l3cBWTK4gWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Guo <higuoxing@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/614] selftests/bpf: Update test_tag to use sha256
Date: Tue, 16 Dec 2025 12:12:16 +0100
Message-ID: <20251216111414.729533193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xing Guo <higuoxing@gmail.com>

[ Upstream commit b7f7d76d6e354a5acc711da37cb2829ccf40558f ]

commit 603b44162325 ("bpf: Update the bpf_prog_calc_tag to use SHA256")
changed digest of prog_tag to SHA256 but forgot to update tests
correspondingly. Fix it.

Fixes: 603b44162325 ("bpf: Update the bpf_prog_calc_tag to use SHA256")
Signed-off-by: Xing Guo <higuoxing@gmail.com>
Link: https://lore.kernel.org/r/20251121061458.3145167-1-higuoxing@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_tag.c b/tools/testing/selftests/bpf/test_tag.c
index 5546b05a04866..f1300047c1e0a 100644
--- a/tools/testing/selftests/bpf/test_tag.c
+++ b/tools/testing/selftests/bpf/test_tag.c
@@ -116,7 +116,7 @@ static void tag_from_alg(int insns, uint8_t *tag, uint32_t len)
 	static const struct sockaddr_alg alg = {
 		.salg_family	= AF_ALG,
 		.salg_type	= "hash",
-		.salg_name	= "sha1",
+		.salg_name	= "sha256",
 	};
 	int fd_base, fd_alg, ret;
 	ssize_t size;
-- 
2.51.0



