Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057070;
	b=tOJBNwvFBr+Ityphjn3wAx+3jDgTN8R9X+7M5N2/4WZc3I1wP34YjmNS65dePx2uXSsm
	 IdMuw5GlIEQSu49+ekd5uUMXwp3k8WbSsaJjYq8JybJrLKMA+gPkPm2EMt4rXxr81Si8U
	 uqD0o9Cwe4YYoHYEI81pCQLN3yaaVscpjjY6kWeBHcOKbrNihZQZjQWD9YsbbW6d0VvMP
	 zDvLhaZ9Fs7nYgjrsYE/Zf//DqwBbiThfql7gjW6TqZK+YtfrmHQQL3+Le20jplzZDn+j
	 rhSF16Lt2vA7ZjcjAfP/NuWfdFuzQu/QXZXGBv9wgBPwC17rEklX5P/XFVKX8pqpTSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D/3RFcxWGTR3A7NnI/EKH2hx5ZqBLkRBxjplQyE+074=;
	b=kt4KD78aKHgxNdJLDsJbRfvFckeDegrjXW7eXMIlIkzHI4SwntpfEXDddjT0uSJyMOoI
	 aZxQgqO2yR9nbq1n1NUQeDjCOzphN8VlW7PuXDn2CZZ/Y6ynsHNxpKXg3fQ3jSJZj563y
	 NVLZQQYhtMcVpFeB5TVzb5qh8HCQlGk+hqAkp1DXS3RCZdWZDPtkkxRtTYleNPVMAkhgp
	 KI1xqZ5UHfV79spbGDuvNJt4ttNhhHng7z0W1w1Uzv4FcV3O9PStiiU0wDwuLOtB678U1
	 UBgAEodJpPM5uHYRaJX+WOTWJG3NqP39K4+3bxKuy5j1iWweriWUmb2sxdns5Jl7uYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXbG2g1w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582C2606A32F;
	Thu, 19 Nov 2026 02:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXbG2g1w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0451F000C4;
	Thu, 19 Nov 2026 02:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057070;
	bh=D/3RFcxWGTR3A7NnI/EKH2hx5ZqBLkRBxjplQyE+074=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXbG2g1wbEbivs7fSpN5sXxrVBBFp9VPzDre3dUtcq/NfZw3mF/GOyss8VlGiDiRU
	 e5YMpRjanCdpZY/5lav/kdlVLWcv+ZUoGfjtO5FnunomYSkcBVeTdYFRlyBNY22HQO
	 +O2dIWWiRgkvE1v3jdYOnzHBejt2n90RBrZjPenY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2172/2214] rtc: s35390a: fix typo in comment
Date: Wed, 18 Nov 2026 16:04:08 +0100
Message-ID: <20261118150137.288135090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 50ccdc31010ed623e68e496aebd4b1d3d8430664 ]

Fix trivial typo

Link: https://patch.msgid.link/20260624204223.1479003-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index a406e2d6b30c9..9ce9051bfadc4 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -315,7 +315,7 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	else
 		sts = S35390A_INT2_MODE_NOINTR;
 
-	/* set interupt mode*/
+	/* set interrupt mode*/
 	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
 	if (err < 0)
 		return err;
-- 
2.53.0



