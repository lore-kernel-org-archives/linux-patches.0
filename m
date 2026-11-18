Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029545;
	b=iHe9AEg2s7WdGLg9BSlyqwxAsXpCzpXh93WEHjoxdJYkPNxtt2t2jSz1ZrNmu7AJLAgo
	 KMZ/Ls7vAuWWNps4OF18t2m2y6JH3UruZ7OJIB//dEZzQeCv3q7Mv8YftrHfsK9JHnEj9
	 36kK4QM7jKQA49BiK1gNGYZq2wylY4jQJ+X5uzePjt1BTwD0YWA+fAORDJiBPlIigiFeu
	 V0ADHstqtBDunYSvvo1v11NTyWwkW1TGJW3oq4oFWukVzmL/T8cOmuiGSdwki6JgVHBDg
	 eQx1PpjwXNL57c6eNe/AoEti5pMRuDb05NkgbT0HY5NVNIPhZwibjbJKfU4UFNSAn2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ty+ASm390XmjGkfOcpXlnanxvkHVbJ4gTj7WZwMbulg=;
	b=IntQjiKr/63m7oJvB3INNT9HdWNxMSnQSqsvKYzoERbNaMCzEoyfbhydkvda+6YSvGGN
	 Rn3ee7169DAFaldcTXDqKXjQbCN/yahk/C6G0pKKGfYa7U8vsXiT/flEA6Lgwf6kd27zI
	 v2Gspjfm2JGHa50/yngJt9lchl1+Q6WHHMoaxlfJKvVR1tDB1WRcOsgw7kWZs389NL7c9
	 vqumuIs9YLoLERRDs5fNaRR4hbgz3pz6L8ydZAiPv0LdUK+RVWgKi6TS9eVbuaBnXSYwV
	 rCsserIwkgiv+eICskZWR34r+VnWUzAIsOn5LO4lIXtWkHSxYkYpwvjM+GD03JYud/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2vCqlRz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908BF606A31C;
	Wed, 18 Nov 2026 19:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2vCqlRz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2ADB1F000C4;
	Wed, 18 Nov 2026 19:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029545;
	bh=ty+ASm390XmjGkfOcpXlnanxvkHVbJ4gTj7WZwMbulg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2vCqlRzR+CguHt77QXQTUcwbXSGz5kTjXy0YRC7DZ0T60S1IXOQqgMfVMPaMCTpD
	 24ovYp64gwzhQdvvbL5GyULUpEbjHlsXtCUKTE2BuXwi1JxwGifiiS3MOlWJJGeqjN
	 qOeKkqI7PHr4ec9eO44tdQ4PXUl+AKeZSaHgWGLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0389/1756] regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc
Date: Wed, 18 Nov 2026 15:41:56 +0100
Message-ID: <20261118150024.172984088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 51d6888b51e0c962250311b2cbfe5666da31dc0e ]

rpmh_regulator_vrm_get_optimum_mode() returns REGULATOR_MODE_NORMAL or
REGULATOR_MODE_IDLE and cannot fail, but its kernel-doc says "0 on
success, or a negative error number on failure", which was never true.
Describe the mode.

Fixes: efb0cb50c427 ("regulator: qcom-rpmh: Implement get_optimum_mode(), not set_load()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912000606.34614-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 62fd0da48407a..9cc6459d2e63d 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -319,7 +319,7 @@ static unsigned int rpmh_regulator_vrm_get_mode(struct regulator_dev *rdev)
  * This function is used in the regulator_ops for VRM type RPMh regulator
  * devices.
  *
- * Return: 0 on success, or a negative error number on failure
+ * Return: the regulator mode to use for the load
  */
 static unsigned int rpmh_regulator_vrm_get_optimum_mode(
 	struct regulator_dev *rdev, int input_uV, int output_uV, int load_uA)
-- 
2.53.0



