Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042768;
	b=MS0LM/FEpbJ2bdmJ8s1JXFPtsY2ZiVi9XpQFJfAF3jTdzjWUbmLdF0lQBptdSW8H+JdF
	 wuvC2UoE0ptQlHOQW0Ipb5Tix5QcA/k6QR7QWfpu19mEUATbmVYhlaOdk5jWo/V/RcRjr
	 ukq1268sIL/DdXaLICLr7Je5H6LKuJnLDhdQ2y6/KlOHgv0xq+LsIke2m59Np9Dkj6hGz
	 M8h4vmV3by82FdXcCbmcqXBYAMvF7GW54fo7AzvUjhxfEWCNNe0y0Bx76wJfC16lh5VEy
	 5QO3vJBlEV3dvo77q4AEn3gCx3MTuJjnUYHdINHmemY+ic+tbBYNQac5MMgTqF2dZnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1BFildSle1N4XjoTU83BuLycj3HUum/iiKNWz07hX0A=;
	b=YZbg5cnso4BA6mZbEE7F24za6dV5AiT3ww39+kblxlB/SOZ5h3UkhooNdLAnE2EscYdz
	 UhBxIrXX73Q6zQ5gqsmoy50sAM+2yciVNsfepdnF1bKGswVurd2US3H4eA6TdOoDVz5Qj
	 NmwGI2enDpyONAhT3TR113oAwGCXcHpFk4JMoxciOhlpThA4YlITf8LHwkWt9CfWrgzfk
	 5n1+rdEvH89wBL7e6WV9/MlsqZbSXTwKrucG5EHY1kzmtesdd/aha1uYfCMlzgHQTclv4
	 LjngH7ZwwV7bLwgxHvOxpZSoeieQ7UQKkSypTM9BKhkBwqntxCLkg+GBpGXvtNqgIHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3OqxtQi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41696606A31C;
	Wed, 18 Nov 2026 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3OqxtQi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931F21F000C4;
	Wed, 18 Nov 2026 22:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042768;
	bh=1BFildSle1N4XjoTU83BuLycj3HUum/iiKNWz07hX0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3OqxtQi4p+gO5lupj+CAymyBleEzqol2mD2umd9e40EYD+dSW3nJwnNxshynqDhq
	 cSlIK8jZcJPV8OmzNM0ovuXxDe925ZJNam0KkJk8jjKGxbETB6egAvJL/qGCJxiT6U
	 TDXn9B6mQVzF6qId5k+LFBcbEhHfTLzk5Cc08SHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3248/3318] rtc: s35390a: fix typo in comment
Date: Wed, 18 Nov 2026 16:04:30 +0100
Message-ID: <20261118150457.093389251@linuxfoundation.org>
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
index 7895b9f97c51b..7e3dda879b8e3 100644
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



