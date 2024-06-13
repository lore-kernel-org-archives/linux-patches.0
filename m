Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259316EB56;
	Thu, 13 Jun 2024 12:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281704; cv=none; b=qULJ2AooJ9WtbWaHTh9kNjfDAd4GTaTHMNFPjZkD5oXSRpPh+2bKedtkdU17jyUQFj35zjVauzeRjaKjPBcGajDHD9R73FnvwkIQwQooDt9Pw/FXHV3Bg9Ahp4ADz6Gyupxw5KbKCJ4zNCoHSs8ASLbJdaFwvo0FC/D6bL2LP80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281704; c=relaxed/simple;
	bh=0uqPRv+xerFzg6Xg0LLg0HuWEISrjbGI4H7fUZEOkR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7LWUsrJ6qyw5x3h7Ra9CcwfdfCj+uuefF1kjo8x6a0hXYNd0s9h5aR6xvSn0hyzctjiLOF+Ok3sT/1JH70gzN1sPXx4/sgsiIG5Xk3GN6tQ+3cANfS38SgC1WL5A0lMbLnQjNTwvqH6zIttoqEayg22H8EaB5KTKC155jjNI4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePdxHyQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePdxHyQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0332C2BBFC;
	Thu, 13 Jun 2024 12:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281704;
	bh=0uqPRv+xerFzg6Xg0LLg0HuWEISrjbGI4H7fUZEOkR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePdxHyQsL00CLVLCpgI2axthnTieEreSYjVDqItLXZadxA3zIQCP7Es86v2rNWqnt
	 uhV23T1864/3EeS92LQCaMIp54O4ZQ5S1Egzca3YSawQ6+wEiGMZI/2KF8VDampHQF
	 R84t9im+JKGTwA8vDNLXgriDigVhyldmRa+Jtc+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/402] ASoC: rt715: add vendor clear control register
Date: Thu, 13 Jun 2024 13:29:45 +0200
Message-ID: <20240613113303.236435410@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit cebfbc89ae2552dbb58cd9b8206a5c8e0e6301e9 ]

Add vendor clear control register in readable register's
callback function. This prevents an access failure reported
in Intel CI tests.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Closes: https://github.com/thesofproject/linux/issues/4860
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/6a103ce9134d49d8b3941172c87a7bd4@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt715-sdw.c b/sound/soc/codecs/rt715-sdw.c
index b047bf87a100c..e269026942e17 100644
--- a/sound/soc/codecs/rt715-sdw.c
+++ b/sound/soc/codecs/rt715-sdw.c
@@ -111,6 +111,7 @@ static bool rt715_readable_register(struct device *dev, unsigned int reg)
 	case 0x839d:
 	case 0x83a7:
 	case 0x83a9:
+	case 0x752001:
 	case 0x752039:
 		return true;
 	default:
-- 
2.43.0



