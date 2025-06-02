Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4792236F4;
	Mon,  2 Jun 2025 14:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873287; cv=none; b=PpQqtMo5icA/rARNxaUtSvTL5UNPDwRDBAMJY81IWfOauUEFiexUYab0zgPmNnf27JUCx7xLugfSOJzm2idiLmMH/ptaR9U8qmVZGAZxDw4mSEXsjOBHgHu+4sX3qODxogXsZi13qyaXeC+m91Uy95LECvKP3Z39y1mX7Jd5EVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873287; c=relaxed/simple;
	bh=pxHP9v3CskiihWtXMUQDGNo7d3lWUSFQO4zMlJwlXas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3j7/M0bb5lYkEM7qbM0mCmA9TPGfL1vvMj29sTY7OLm7gGZXoUrxoZLwfB6chLLqEbrhuI5pPLIlgzWMJPmaPl31L9H6X17rP8G7Cbkx5QWT7D2ULs1rmZCOJAFIabX3uy2/PTb+oOkf0DPCTaa+pUZPpfBok5sAn2OmKQNAOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cm4v16R4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cm4v16R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6C7C4CEEB;
	Mon,  2 Jun 2025 14:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873287;
	bh=pxHP9v3CskiihWtXMUQDGNo7d3lWUSFQO4zMlJwlXas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cm4v16R4LSgAmXw5NqaOWtqyheJdELoUI8rZG2tGrWoaKMabp6MdUHFcfl+lAm7hQ
	 0l/ov+P3ZvAN1Y9aH64KVY7zB0Z0EUbbWyfWVRtkqZ/qjoC6E7L/Ij+3z5jieRjmke
	 hBJRdzH5Eqtc6jnWZrEUp8AZVES/RwtNvHdgd4hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/444] rtc: rv3032: fix EERD location
Date: Mon,  2 Jun 2025 15:42:38 +0200
Message-ID: <20250602134344.709055665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit b0f9cb4a0706b0356e84d67e48500b77b343debe ]

EERD is bit 2 in CTRL1

Link: https://lore.kernel.org/r/20250306214243.1167692-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3032.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3032.c b/drivers/rtc/rtc-rv3032.c
index 35b2e36b426a0..cb01038a2e27f 100644
--- a/drivers/rtc/rtc-rv3032.c
+++ b/drivers/rtc/rtc-rv3032.c
@@ -69,7 +69,7 @@
 #define RV3032_CLKOUT2_FD_MSK		GENMASK(6, 5)
 #define RV3032_CLKOUT2_OS		BIT(7)
 
-#define RV3032_CTRL1_EERD		BIT(3)
+#define RV3032_CTRL1_EERD		BIT(2)
 #define RV3032_CTRL1_WADA		BIT(5)
 
 #define RV3032_CTRL2_STOP		BIT(0)
-- 
2.39.5



