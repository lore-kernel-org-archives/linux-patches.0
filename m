Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015783;
	b=p4Jc14SuQ+HU4stYlsVOrZYWDFMmMHGXgbuswjKnKhDKmw92AAs7nZdtpmRTSdhqhrM8
	 +R7erc47wU5Plyw0Woqszn/jIrVKCHD/9AimOHF4ywO3o3Nz2RWf72ggvXFp1P1tfcSF2
	 0TvZhj2zXFflZDc4eiCubRotA+BxVG5S/7+4hlnMzwMT763srgUs7UhiDifU8JI4fzcDP
	 14tzgp6IA0LBeEJ9YbuwDisH8z6qGxLM8nmSsN4496eAoLtrai41JnUBa6PaNsggLz1to
	 BkRzi41zPKt2GTv+B2PPdtmBo2MFTixpYbLKU7VKIXUqC/QOBk6+TTHjIrKk4km1J2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hGnEW3m7PFvv2w0n0ZrIYFxYc4kQ/QqPE1ZmtXlUcWg=;
	b=BacnYZRlxdFD8BgiZqB/CDUExG51dJDOQ/C2+sECLY3Z2lpaA9ZFUBIE3M1h92quvYik
	 Oz6gtXjKTlwU8BH+0bcNFit9QLbQaLEnlg6GR47xFbNAni07ODYpp5RC3BY8YP2JyIuMu
	 elA2WW06ZUABivwgUocyhY3QTLQR89fj3LalpQJMcqq8lOvwct6Q6k+KQRyM2twC6uNF3
	 zd8UNwI6j8iM46DgxCdh/jYOEdWq0LATUPOO+YIZqGNT/S3/ns48H53ljnyD9Gq95nzlq
	 cVfnyQKgMfMm48d/r8UIy3690TfQWq43uqynT2dlw/Y6Pjc8VvlVtdIfEcjJ0O5iLPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e2/6L3/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA63606A33A;
	Wed, 18 Nov 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2/6L3/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E0B1F000C4;
	Wed, 18 Nov 2026 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015783;
	bh=hGnEW3m7PFvv2w0n0ZrIYFxYc4kQ/QqPE1ZmtXlUcWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2/6L3/W2ICfkuvQ7CTjhgDB8ih205jNkejNTrYBkkHJMh72ZWsyUSmwnLOKYcdv5
	 mYy6lwItjBxxLmpxyHv2LYg55A+JwGP6UhSV+uSODVSWbXqGBDLAMmu9CTSGoHqcA2
	 wstHPr85G0d3DyFp5QEqMnv0UhMZrr4zzTyoNGCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surendra Singh Chouhan <kr494167@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0254/2651] pwm: ipq: Prevent potential 32-bit integer overflow in hi_div calculation
Date: Wed, 18 Nov 2026 15:24:54 +0100
Message-ID: <20261118150257.005833803@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Surendra Singh Chouhan <kr494167@gmail.com>

[ Upstream commit a662d944da1e9236a99355aa3e8a93735d8b3521 ]

In ipq_pwm_get_state(), hi_div was calculated as:
  hi_div = hi_dur * (pre_div + 1);

hi_dur and (pre_div + 1) are both unsigned int (32-bit) values.
Evaluating their multiplication using 32-bit arithmetic before assigning to
the 64-bit u64 hi_div variable can overflow 32-bit unsigned math.

While effective_div explicitly uses (u64)(pwm_div + 1) * (pre_div + 1) to
prevent overflow, hi_div was missing the (u64) cast.

Fix this by casting hi_dur to (u64) before multiplication, matching the
precision used for effective_div.

Fixes: c436e3e9c265 ("pwm: Driver for qualcomm ipq6018 pwm block")
Signed-off-by: Surendra Singh Chouhan <kr494167@gmail.com>
Link: https://patch.msgid.link/20260724044854.33274-1-kr494167@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-ipq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-ipq.c b/drivers/pwm/pwm-ipq.c
index 6b7aec566f7eb..3e1231b212b10 100644
--- a/drivers/pwm/pwm-ipq.c
+++ b/drivers/pwm/pwm-ipq.c
@@ -186,7 +186,7 @@ static int ipq_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	state->period = DIV64_U64_ROUND_UP(effective_div * NSEC_PER_SEC,
 					   ipq_chip->clk_rate);
 
-	hi_div = hi_dur * (pre_div + 1);
+	hi_div = (u64)hi_dur * (pre_div + 1);
 	state->duty_cycle = DIV64_U64_ROUND_UP(hi_div * NSEC_PER_SEC,
 					       ipq_chip->clk_rate);
 
-- 
2.53.0



