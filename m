Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029663;
	b=Eu6YNh/4605jjVw5hNzAcWe+iB02RtyiYgJ6OunY9HKDXw6aRP5q6pFzsN/CehtNb5eb
	 2zL7Y85xEco/NnDzUqqxKZhbnG82XQ1mlwW0dl7fCYoG1UUp6jeaJ1QqWBH+0Nzanmyrm
	 /BRj+8rvkbR5JZjVqmO8Pqp2D2K9bWRY+0bx/HaRO483af4eoPrEHcdeKacsu0jln/+Sp
	 9RJusk9HXsSMUwTIFryxv2NeFUxI361zDNGzi9I+O0PwIxEQeBDtB8pLLh07KJAhKunjl
	 cvcna/cSbLBdbQZljM7C0WLMWnv66mkH5wR4xmffr5CpTRQ2BA48VoPQAZuQnY4VWVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NEG3v/d40Fk+V+etZiFmAv+edujRpGHq3xBjaH0sJyc=;
	b=kUCbtwd5ZAOXaMruazbFWlmMfAmaM6uQHnPFKNpa//iLqsU53X5qTuLYqcms8STS60kD
	 IfWFPwO24A14ML7UCgD5SSQvK+QEP4yF9F8W40mqwPWcrZ88XBfzH1qiEGqZab5qf6M9v
	 5WcZ0fc0Y+wQPYhuSvt2jiJ5vnr9vDX8ALgmJC0U53HrHKZvSGNFFvZNxJXYEUW+JLNAr
	 5+zYj9lW5ljOCEex1HQP3YCpBaHVApiA+9DX7/tuFCg3bp95z71yhMcIFwmou0aDH2Z3L
	 08Qgr+78zSPfnXE5rF07lwnOJVYHj0iosVYu7O/2TGeBZRMtjyYl/vNIn9HMT5VMfxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVRbx3rk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF1606A333;
	Wed, 18 Nov 2026 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVRbx3rk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD511F000C4;
	Wed, 18 Nov 2026 19:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029663;
	bh=NEG3v/d40Fk+V+etZiFmAv+edujRpGHq3xBjaH0sJyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVRbx3rkEwO69NXKHNaWO35T3RcyBKY8IKERO2P+LlHcyvjmkingqAtVf2W1wKPIf
	 ZLJyF8LxHATRabxmyDIGhPfTefXEqQbyBHWAs+V/S1VuXvZupUpXB1t1RGi2aSsexF
	 4gOLyHmltiLGOtctnTWxrEVevtmhnDvJk544vBJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C8=98tefan=20Ghe=C8=9Bu?= <stefanghetu9@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0431/1756] ASoC: SOF: imx: Prevent stack OOB read in DSP panic dump
Date: Wed, 18 Nov 2026 15:42:38 +0100
Message-ID: <20261118150025.911033075@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ștefan Ghețu <stefanghetu9@gmail.com>

[ Upstream commit 48ed992bfbe53537ad1cbc8ad68f7031e7ac0af3 ]

Commit 58bb5081cba1 ("ASoC: SOF: Xtensa: dump ar registers to restore
call stack") added a shared Xtensa helper that iterates over a flexible
array of AR registers (`ar[]`) controlled by `plat_hdr.numaregs`.

While Intel IPC4 allocates dynamic storage for the AR block, the i.MX
IPC3 path reads the oops message into a stack-allocated struct without
backing storage for `ar[]`, while leaving `numaregs` unvalidated. This
causes a stack out-of-bounds read when printing a DSP panic.

Clear `numaregs` to 0 on i.MX since the AR block is not fetched or
supported on this platform, preventing unsafe out-of-bounds memory
accesses in the shared Xtensa helper.

Fixes: 58bb5081cba1 ("ASoC: SOF: Xtensa: dump ar registers to restore call stack")
Signed-off-by: Ștefan Ghețu <stefanghetu9@gmail.com>
Link: https://patch.msgid.link/20260908170740.276800-1-stefanghetu9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/imx/imx-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/imx/imx-common.c b/sound/soc/sof/imx/imx-common.c
index fce6d9cf6a6be..e0a99f641e3b8 100644
--- a/sound/soc/sof/imx/imx-common.c
+++ b/sound/soc/sof/imx/imx-common.c
@@ -29,6 +29,7 @@ void imx8_get_registers(struct snd_sof_dev *sdev,
 
 	/* first read registers */
 	sof_mailbox_read(sdev, offset, xoops, sizeof(*xoops));
+	xoops->plat_hdr.numaregs = 0;
 
 	/* then get panic info */
 	if (xoops->arch_hdr.totalsize > EXCEPT_MAX_HDR_SIZE) {
-- 
2.53.0



