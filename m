Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208562;
	b=RPEwKfDQp9rbw2dskAXl03kGsrVSLwFxXUsoDYSdA4RRS8i5ajZvGIfjNVFNO6n3Qe3T
	 BELb8J6LrBN+LNtlXcOeKJVsKIdxiis0WuQeZNdg0TZ71NgQwjw6cwUek+WPSAC6lZO5S
	 Ye8NINwrn+CQ0ynqHCTEo/uENIpoGj5j9hR0UrOXupi1fliqMqpprB+af9k6AQiUEy0Cy
	 VKpM5X2Ewts4u4fXwExRzf+b4QUAQd32E5gTqOTdULEcqVIHzaIdjh+WA+WMpt3LhVqfF
	 /vAF+OHrxQx9yQ2pDQ6HYo+Vp189pBSbaU2LMWSOOWpyrQYX+ONF1qanqjpotEn0QOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MVx0Yxt0rlR7Rw5V2up9Aj4FBK8UPRrMOEKCKVSWRWI=;
	b=yEoztawvZlT8Ykr85pQvmvnRPo+xN4Ah5GuTzGRFQd0cOv4QkWWLZQG413SkeJOLBIaM
	 fc+AMQiw9BvnlxHLxpMvf3Yyb2oKHxDuehAZ+s/guvO/Smn+DMpctM5iQoW2YyOLhXsLc
	 QoINKBl1hE2NxbpY2YBaLKHPsZV2Nz86oJ0zKBNbe4BPaF0jxqD/6bvfYdKL5HeG85zwn
	 Is7k8W6qz0sXxTGo4MCFa9kBnnXEoo1ifBVytDLaEvw+oeFXadqKrGp6TJXc7R+c9mJsS
	 PphAXDMRzbjlCl28LTDo9ZxX74I8CyIt9cviCDQzOgSfl+RfQ9B7IIlrYVZvZAj2opQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Whcz9LGJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D050606A31A;
	Wed, 28 Oct 2026 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Whcz9LGJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9391C1F01825;
	Wed, 28 Oct 2026 17:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208562;
	bh=MVx0Yxt0rlR7Rw5V2up9Aj4FBK8UPRrMOEKCKVSWRWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Whcz9LGJNpvse8XnSfqaX7W+5OF2Z8EW6grdOjhlDXk72FzYS70Mkkw9qmNrFnMLE
	 inW8Vfh6V7hIVdIrXATg1R2EmqiB5A6vTY2slGcD2HTbxJMJnUI3MfZGZdsW3Ut4lU
	 PwiD7J0OcAW2cKi9PfUtpWZNjszN9SK+Pe45oY70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/516] ASoC: codecs: rt274: Fix format setting for 44100 rate
Date: Wed, 28 Oct 2026 17:55:15 +0100
Message-ID: <20261028170007.367191835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 6eda8938a790f65bd24fcfaae7b40ad4613fb7a2 ]

As per specification, Sample Base Rate (bit 14)
shall be set to 1 for 44.1 kHz.

Fixes: c7e79b2b2d2d ("ASoC: rt274: add rt274 codec driver")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260918111745.3589393-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt274.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt274.c b/sound/soc/codecs/rt274.c
index 70cf17c0aa99e..6b73c9d835eac 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -619,9 +619,11 @@ static int rt274_hw_params(struct snd_pcm_substream *substream,
 	unsigned int val = 0;
 	int d_len_code = 0, c_len_code = 0;
 
+	/* bit 14 Sample Rate Base, 0: 48kHz 1: 44.1kHz */
 	switch (params_rate(params)) {
-	/* bit 14 0:48K 1:44.1K */
 	case 44100:
+		val |= BIT(14);
+		break;
 	case 48000:
 		break;
 	default:
-- 
2.53.0



