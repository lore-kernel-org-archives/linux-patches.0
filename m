Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3A01D04A2;
	Wed,  2 Oct 2024 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875911; cv=none; b=ed85e32FOjLn/83oaD1OR3r+ZnV16V+m3tfl+3htLc3d/l4TlxDKNDAeD5yptGhmT/CN7bP/33649y6U0nM7Mk67apgL7KZOo4H1a/2wFjnMs5EQown5JYBPMilC1PNx22AHosM1+XD0fx2GyupAvFacOCm5pjLcop6jy2zw3yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875911; c=relaxed/simple;
	bh=gO9iyBCGcNdB1qTTaBR/gg8l2D+9D2AQbErgToHuaqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gim2tnQy8EtgIH6IwsBIXDFAIy/C7Tcb+M+53QYfHCHplqO36xoChpQob39QZkgq+GRsRO0UGJ5F4nC8GJBm1YOrEgxg++I2PHaoklo1jvzdaAZCXyjR7Ppch1UkE7i44YtfM6y3i2j7aFo71sg9O/KtZGyOLn1iUvxffa8Q6zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E04SyyXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E04SyyXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33262C4CED4;
	Wed,  2 Oct 2024 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875911;
	bh=gO9iyBCGcNdB1qTTaBR/gg8l2D+9D2AQbErgToHuaqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E04SyyXWonP60AZhm38moVf8i7hSRw+6iItXzlMt+FQIlGJjN7WLyJvPTNzN0fp7r
	 nTLk8iuqNXWgdSo5+ArzmJ1ypofa0uJGBDAthChdiLGixXolviAgEEsSkg6jqUqej4
	 gp9KapfqyQ4oK9C0LK/MtYA3cMbn8CdZZq4cUaV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 264/695] selftests/bpf: Use pid_t consistently in test_progs.c
Date: Wed,  2 Oct 2024 14:54:22 +0200
Message-ID: <20241002125832.984581763@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit ec4fe2f0fa12fd2d0115df7e58414dc26899cc5e ]

Use pid_t rather than __pid_t when allocating memory for 'worker_pids' in
'struct test_env', as this is its declared type and also avoids compile
errors seen building against musl libc on mipsel64:

  test_progs.c:1738:49: error: '__pid_t' undeclared (first use in this function); did you mean 'pid_t'?
   1738 |                 env.worker_pids = calloc(sizeof(__pid_t), env.workers);
        |                                                 ^~~~~~~
        |                                                 pid_t
  test_progs.c:1738:49: note: each undeclared identifier is reported only once for each function it appears in

Fixes: 91b2c0afd00c ("selftests/bpf: Add parallelism to test_progs")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Geliang Tang <geliang@kernel.org>
Link: https://lore.kernel.org/bpf/c6447da51a94babc1931711a43e2ceecb135c93d.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 89ff704e9dad5..60c5ec0f6abf6 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1731,7 +1731,7 @@ int main(int argc, char **argv)
 	/* launch workers if requested */
 	env.worker_id = -1; /* main process */
 	if (env.workers) {
-		env.worker_pids = calloc(sizeof(__pid_t), env.workers);
+		env.worker_pids = calloc(sizeof(pid_t), env.workers);
 		env.worker_socks = calloc(sizeof(int), env.workers);
 		if (env.debug)
 			fprintf(stdout, "Launching %d workers.\n", env.workers);
-- 
2.43.0



