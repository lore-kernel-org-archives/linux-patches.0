Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033772;
	b=t/hciSL2TQPsVsqBexY0vryhxqQxcI4xo4BV6xu6BBQlpgBnC7YHVokuibN8Eva0yAcW
	 mTIpSvtSDfwpQv4NJcbFJEKCDeLrNDnX5RbWSCZtIQbJZ2L4uairCOs2ztypfjo+GquTL
	 tZWPbZcvoYBAiVYHpWbRawqHbQet9LIcUgdzgvRqkAeQDBpcf9AekeuRdBXtFQwzHdYkr
	 xHPrrMnC7wschglYzKwKJmqKctdSGl/KUaewxOoOVwWl1mUd1cSJWTELUQ30Jc6X2ihi8
	 n2zRonYEFI/ww+NLgWR1Mz0ZgpJpi7uxGezZh6+gu55tBmT9FX3D0isLqWEXvQWWpSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CddwoBCxqipe2C8LcZPZU3l85ylnkVtw+1AIfD5AMk0=;
	b=upjExcUOvHifTXJu3BmBA/TF0c7+ACkdaj5CmK40YPCofXLpUk/G8KcVpS6+FxkmrQVQ
	 MSuopxyoGulN8gl43AefE7juEZH5QbUMJqwjvPY3ehNZEXw7qPk7UFz2eRwrx7lMr7s7M
	 ok6MTUzN5aeC1Qfj2YTkE0Qz+OPLj0xAgM1FfYDDNkgt+jlm7kAc6ak7bKNLhq2w9LDyy
	 PfwY2A4RhnewwDhyYSEO3mRUs7vDMudgth8Bx55lE+QnA07aQf+jZ4znTlrmEtUE+X0gW
	 Vl30aQAyjImFKGukT4U9fuWJ6/B6ifWJPOfzXXurLRTgflwTIMSbWRDu9l5T/MzHljw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEIAyzQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33B7606A31C;
	Wed, 18 Nov 2026 20:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEIAyzQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDE61F000C4;
	Wed, 18 Nov 2026 20:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033771;
	bh=CddwoBCxqipe2C8LcZPZU3l85ylnkVtw+1AIfD5AMk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEIAyzQaTpHS3vwRgYYbbjU92JhlDouUNRcYU9RMhkuC3G2i9eV7B2vlK/aQg5qq2
	 dTv4S7ML3GFzbliR8C4CoMDso1P+CQAGq88xAU75oJN3AnHXGMKYA545+tNC9reked
	 HO4RvJFWKJlAuuZWaTPpRJ56Bqr3CLeqFIcNtP9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0116/3318] media: cec: tegra_cec: dont break off msg on NACK
Date: Wed, 18 Nov 2026 15:12:18 +0100
Message-ID: <20261118150317.784959390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit be627f257ce283c95fd2988080dc0db3a20d0d2a ]

The Tegra CEC hardware has a bug where, if the first attempt
to transmit a message is NACKed so the transmit is aborted,
then the second attempt can contain corrupt data.

Ensure that the full message is always transmitted to avoid hitting
this bug.

I suspect some internal state is not reset in the case of aborting
a message due to a NACK.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index a199a41589422..7ebd25d3e8807 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -243,7 +243,18 @@ static int tegra_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		  TEGRA_CEC_INT_MASK_RX_REGISTER_FULL |
 		  TEGRA_CEC_INT_MASK_RX_START_BIT_DETECTED);
 
-	cec_write(cec, TEGRA_CEC_HW_CONTROL, TEGRA_CEC_HWCTRL_TX_RX_MODE);
+	/*
+	 * TX_NAK_MODE ensures that the whole message is transmitted even
+	 * if each byte is NACKed. Without this flag the retransmit of the
+	 * messages after a NACK can be corrupt. This is a bug in the hardware.
+	 *
+	 * While less efficient, in practice you rarely transmit messages
+	 * that can be NACKed, with the exception of POLL messages which
+	 * are just one byte anyway.
+	 */
+	cec_write(cec, TEGRA_CEC_HW_CONTROL,
+		  TEGRA_CEC_HWCTRL_TX_RX_MODE |
+		  TEGRA_CEC_HWCTRL_TX_NAK_MODE);
 	return 0;
 }
 
-- 
2.53.0



