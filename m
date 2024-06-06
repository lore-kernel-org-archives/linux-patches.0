Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A21991CA;
	Thu,  6 Jun 2024 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683169; cv=none; b=S2VkSZ4ul25/YU3NhnZdamjsXzSGBWtZfit0uo3qQh7YKf/9pqONOotRh4VVipd5Nipys2Kny4Rr5FJOpJrV1Q9rseIXNKnln2VuZavSVMoq7PbkQHWSAw8uUoPm9MJV616iNj/LmPeFgXAWjG1FLy2oU0sSfqFhrKAtIW8/D0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683169; c=relaxed/simple;
	bh=rqY1mgVPW3ku95JvNAO1NYxYWJp4bN8SNWNcbueaFLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C49/E63YdHQht/y+tbfXiS0U0rYjY17KCsdRCR+JnX5+DfHCVyNn97V6v7UMjXjhS7rzAxAAMJU0BagImp/RzS8+12BnRKvSvDs5/ezVr2H1alY9BAw2tFtNCqhdMbuZ81R/LTco3SUXzacQyPw8i/Aapt/8GQW3TpvCarCR3/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yD4MajGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD4MajGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F20C2BD10;
	Thu,  6 Jun 2024 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683169;
	bh=rqY1mgVPW3ku95JvNAO1NYxYWJp4bN8SNWNcbueaFLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yD4MajGW43pwe6tpEJYJWS3ZaicZCbiyH/Xp2wlvb097BWSO+uh4gYaJaXnJjCsMO
	 GEGuqJqpaiyUUIeBaMJZPwNQJjcp+cTDoLfy7LZ3QOX+sNN7yshrtQ7De9373dmafn
	 ktuH+H4/uC1N1Bz2azFI4tYPiZO9ZkAjx5dveOT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/473] ASoC: rt715: add vendor clear control register
Date: Thu,  6 Jun 2024 15:59:33 +0200
Message-ID: <20240606131701.345309002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4e61e16470eda..4e35b67b01ce8 100644
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



