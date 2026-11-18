Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024403;
	b=XB8sTQ+85RCyKI4dWDIUjK4ZKOAeNOUgFFileV8m1hLU7W5Qp8TCKCUmKamYUezBQyu+
	 G2t+3bFgQJptSXS36xSYZkcWjE6gjifOFiKLk/8F83TFd+fH2dJXVJXYuvCbRqc7wimuf
	 Fy0jVXK7U1gu1CNe9M8qwfjAu7mMH0RFxLyC4SBb5ax1wq0SVqHjsflJuMFy0ueiIgVWI
	 2ns8s3+ehbTC92X5AWDM3Zl/hxL5fZ2Mp+EYF3XM1DjaU8JyiP2hPEZPU+OHIImXV0bcQ
	 0LtEIZ7LDFWeX4JT+KeKxi1E3YULVXVXVdcQZlfSdzvzQajdjjQk9HtAMziA0TIuwmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=44caSlDJKxuEaMNwElK4YiC3rD1bE8zK9l9Ej0VVGPI=;
	b=YEGq46RhlR/9hovaObksKIr4beS8uDTipen3NzGFSGJKZtgERW8uGGQhc1HD2bjeB0uQ
	 9iscGNBTUgUSWFduwfWpPT81dk77NocmjhL/TZeK1mw6EtwaUTxxHFechoA8r4vMIsv22
	 /+GZ2OUSWQiN/oWeclqLIivOawpd4PgG436hmvkGeCyECEyigf6eaD4700EMEER5/ptye
	 nXcrJbmbI30KiXX0YJKe1XGFQmu62CpDhc1DKx8fV/p4rnAH17X+aIiZseuN8x7irpHQ9
	 fOp20dPqncNkneql5/NsrQYTolqPDdaYWPLPB9LNjdVR9BP06MhUumPs0xAQO6kiGVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtWq1JhI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7F6606A325;
	Wed, 18 Nov 2026 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtWq1JhI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB1C1F000C4;
	Wed, 18 Nov 2026 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024403;
	bh=44caSlDJKxuEaMNwElK4YiC3rD1bE8zK9l9Ej0VVGPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtWq1JhIRv9Nv0l7ZG44BT31wTwAhZA0UWUXRQmgQ3STyKD/EhYxgwQZ6WVeOub/e
	 F5HOF9pij3nzqfvXoJGM2M/gjLI7QhJsYUJjnTq1kLt9b1negrmEBcHnLO3KQuJrGl
	 gKB06wxZMp3tvizoZgyCse8KKwSsAROC7viJhOYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0713/2151] ASoC: fsl_asrc_m2m: fix pm_runtime usage counter leak on error
Date: Wed, 18 Nov 2026 15:40:48 +0100
Message-ID: <20261118150147.854866154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 5626653a4bdf32812d66b970860677cd9d7a2190 ]

pm_runtime_get_sync() leaves the runtime PM usage counter incremented even
when it fails, but the error path in fsl_asrc_m2m_comp_open() does not
call pm_runtime_put_noidle() to balance it, leaking a reference each
time resume fails.

Use pm_runtime_resume_and_get() instead, which automatically drops the
usage counter on failure, fixing the leak.

Fixes: 24a01710f627 ("ASoC: fsl_asrc_m2m: Add memory to memory function")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260917121136.32527-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_m2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_asrc_m2m.c b/sound/soc/fsl/fsl_asrc_m2m.c
index f46881f71e430..88cbfb4cae3ad 100644
--- a/sound/soc/fsl/fsl_asrc_m2m.c
+++ b/sound/soc/fsl/fsl_asrc_m2m.c
@@ -314,7 +314,7 @@ static int fsl_asrc_m2m_comp_open(struct snd_compr_stream *stream)
 	if (ret)
 		goto error_alloc_out_buf;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to power up asrc\n");
 		goto err_pm_runtime;
-- 
2.53.0



