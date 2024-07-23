Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F341E13D600;
	Tue, 23 Jul 2024 18:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759692; cv=none; b=AgiRTSIRp1vjWdKEzm/eSUfoGyB5tFu5Rmw3DPTtRnlt/z6t1FJTSrX9FcltX4Bz12lrHaQVtgpBv1muokULNvU6pAGt9rvjGjfpylvOnEBDUWy+9flVdKVNOno9wNpvqLxc7uw/DnFg5m7s6vGAh0ZG8aWAT1m2R/3mA3yKhw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759692; c=relaxed/simple;
	bh=1B11/NAhkpqSYyYQCIWkXNnusz1pvACc6phGIWHEiEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2R3Y6K6maMiDNWKwZJK//34fJgjYYxw6RE0Ybf5jMByTMMwfKYFgCBe/YUqIn+oCoOJ/3P6j2Q05/AW6+YH5gAuuni1efSZgZWoZyfppxRLAg0NnM3aJFW9wGM/EmPIJpZRG7ADhomYXI/LaawGQd2Jz1a3EOlWJyzD4cpDl+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kh308vnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kh308vnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796BCC4AF09;
	Tue, 23 Jul 2024 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759691;
	bh=1B11/NAhkpqSYyYQCIWkXNnusz1pvACc6phGIWHEiEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kh308vnwxnjJlzlRSwyBBG5gx37cuRDmn35kCOrO9Ro6T8X4LtR+OCoyKhqH7BJan
	 bm90pvO4EZFvxeMo0bOOtN99+94tyJPyibdeRG9aZEsUw3mSmLviFkT5nw7LUk7ARW
	 /BCy5k+08ndQjYFsX91YFXCeX4l+wptbQTymKbfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/129] ASoC: rt722-sdca-sdw: add silence detection register as volatile
Date: Tue, 23 Jul 2024 20:23:33 +0200
Message-ID: <20240723180407.297307207@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 968c974c08106fcf911d8d390d0f049af855d348 ]

Including silence detection register as volatile.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://msgid.link/r/c66a6bd6d220426793096b42baf85437@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index 43a4e79e56966..cf2feb41c8354 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -68,6 +68,7 @@ static bool rt722_sdca_mbq_readable_register(struct device *dev, unsigned int re
 	case 0x200007f:
 	case 0x2000082 ... 0x200008e:
 	case 0x2000090 ... 0x2000094:
+	case 0x3110000:
 	case 0x5300000 ... 0x5300002:
 	case 0x5400002:
 	case 0x5600000 ... 0x5600007:
@@ -125,6 +126,7 @@ static bool rt722_sdca_mbq_volatile_register(struct device *dev, unsigned int re
 	case 0x2000067:
 	case 0x2000084:
 	case 0x2000086:
+	case 0x3110000:
 		return true;
 	default:
 		return false;
-- 
2.43.0



