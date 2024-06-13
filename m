Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE6344C6F;
	Thu, 13 Jun 2024 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280732; cv=none; b=N6UKEQN3laN63sftM8INh/FlJqrESYeMhrnZJYo5T2Apzsa2bJVCji5oFbxG5NSDjoQqg8mu089y+kjSssU97T+5ZrKTjUIYrPmeGkY83NIaH4eO0lr5sj3eTrOfAy0aveRCiOZUFGgK6r62+QceAKxB5X3a0Q3iuKN16c2ccZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280732; c=relaxed/simple;
	bh=0hu71nydnPmo7kAfNSlF+/v6CN7UKQ+ljKQl6Bi1lFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PToPRilZrmGXxP6SgaqJ7ny/ovzThy8ztOnuj7pKlZwpZqG3ISIyaRbUkgmuZ+s0C3J6vToEnnfqv3Gssk2mXcO7F1AjjhByQL5YbdEkfGCk3XIkyrJMZPl+XvVIa9S4n65+hDfzlMng8J/Iw1sYPPDMEt/5ecwrO3OJlw4NalY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lhf5TQsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lhf5TQsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23474C2BBFC;
	Thu, 13 Jun 2024 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280732;
	bh=0hu71nydnPmo7kAfNSlF+/v6CN7UKQ+ljKQl6Bi1lFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lhf5TQswgS/WzqMEje+yxEBKLvtlmgNL+dg4NTI0qwDbcSytuJnbnZaeuWQBN3SNS
	 y/KWvg3WuUQT25k4VoHyvO3sEdScAaHONQxde6WjubxS+Az6Nmg1Op5t5brD5ujY1s
	 snUC7iJ8WBzrVXG5FOi8EsZgvI+oWRVrIzfRqOjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/317] ASoC: rt715: add vendor clear control register
Date: Thu, 13 Jun 2024 13:30:34 +0200
Message-ID: <20240613113248.169562091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 361a90ae594cd..c0f09c3bcb6e3 100644
--- a/sound/soc/codecs/rt715-sdw.c
+++ b/sound/soc/codecs/rt715-sdw.c
@@ -110,6 +110,7 @@ static bool rt715_readable_register(struct device *dev, unsigned int reg)
 	case 0x839d:
 	case 0x83a7:
 	case 0x83a9:
+	case 0x752001:
 	case 0x752039:
 		return true;
 	default:
-- 
2.43.0



