Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035998;
	b=AFkKRBBWrXt+HM06RKkxOFmbjPQr4rQv3k5cNo3GHTSdrv0GfRRH3BBvBf/a51aHsg6K
	 UxqT2283tIaKOVTiTpwogKBV/nzouJRTggdHVVHcXq9ccSEj1ZcbWp5LlOFlCM/SvA3nK
	 FjdFPBOp8t+NmRU6Y7Uxn/wfEt9/DO84c81Elo3UPcb2bj+t0OMp3VDtDoLxvM6GtqSGZ
	 z16qL7Rohh+6w1UnvJNLGOil7SUmlX0TfKCMUp0uokl6WSBWkSSPw/XgcfGyW2UDG9cj0
	 bm+c0MzYith3XtY4kDORA7m3Nl8ef+e0S41cm9nweFkFyYkHw0gU8lS196B4/cDsz/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=czL8N75iR+WWeddD/ndUXhP9MTZDtm14pesrXV0+mgg=;
	b=SNDD2bgmF+jHOS58WdxXifAyzLBSAX3k/5r2fZaHmV30v33eb9w3W9naiTLFISwsaknr
	 y0JKwhPjXOOEWyayePQqpk2jf9RvO0yMwDkdSKZJ+QbCk1FaVbdyaqKr9FCEoQp5mjhiQ
	 o/WK8hNLEKosDbv83kydIK9Lqf70N6rrGHlGNrsJPnN1e/xSbGtuAIG9/WVyQ3ztLbUM5
	 zo1xvkrf5yFn2u3EMQIL0q0vmSmWUThvnM0o6V5Z7Xnda8w63U9hNK9l57+q0zIn7q4TR
	 USLRKZpTg7PZ0lDh43Ogk6HJnU5ovg/woPHpMVmXbt+YGA7DzcX8d9PdxhCTx4nPi0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQJNmA0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188A5606A325;
	Wed, 18 Nov 2026 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQJNmA0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7120C1F000C5;
	Wed, 18 Nov 2026 21:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035998;
	bh=czL8N75iR+WWeddD/ndUXhP9MTZDtm14pesrXV0+mgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQJNmA0OlrWSW1mrPXhvHLLB96eg6X04xBpKspGOssBwXUr7My5RHbFBcZYhPlJa2
	 1gWxq7IzgYY20XDsSVNX6He5vSQvDpBYr0yN++N5SMpPmkvWTMl+XrtcUFSk4ULqYP
	 6kyieBg+Wohie4308TAWOZj2q/J/NGxtSYplNUSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0902/3318] ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()
Date: Wed, 18 Nov 2026 15:25:24 +0100
Message-ID: <20261118150346.549474926@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ba593d662183de74d2b733b4c6e8cd26f04f0a65 ]

In __davinci_mcasp_set_clkdiv(), pm_runtime_get_sync() is called at the
entry of the function. If an invalid div_id is provided, the function
hits the default switch case and directly returns -EINVAL without calling
pm_runtime_put(), resulting in a runtime PM reference leak.

Add pm_runtime_put() in the default case before returning -EINVAL.

Fixes: 4ed8c9b737b6 ("ASoC: McASP: add support for clock dividers")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Tested-by: Sen Wang <sen@ti.com>
Link: https://patch.msgid.link/20260916073136.1971673-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 8c8b2a2f6f862..9d659c2987e20 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -649,6 +649,7 @@ static int __davinci_mcasp_set_clkdiv(struct davinci_mcasp *mcasp, int div_id,
 		break;
 
 	default:
+		pm_runtime_put(mcasp->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



