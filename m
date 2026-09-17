Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBDD4C10F0;
	Thu, 17 Sep 2026 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660984; cv=none; b=GMYgfUmF8l/Dt+4+DMTaVJ4ZrBxllPRNRY3INhu1laI7q491IbhO1MxgW0bciA5PtmoxloKVOIShlrOJKidREWXVqOZkLObvusTcHCffmickOjSv4oKUyH8SMhdjyceFD3Q9bJT+eWLG52BbCjY9JOeq9OgTkndWvQjHFZSzEEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660984; c=relaxed/simple;
	bh=SKiGIEehfk/5V0S7ufC81fKgnFfPyYQjEcAQacp81xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jktojNP5lHGItigvch9U9C2XIyjhSYsSm42pDyT8tk1oqCuaSVfA59D8BzKQa+kScrDhlz0jzv9cfC6tBkmVmjRHeNCchoKyLNzjhPuCgh29YBVx2LWVINLDHvMrXjdveQlz1z64UCjYWH2iNQCzqBfR55OFjaTleOgJHAjsZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSX5RLad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSX5RLad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D9A1F00893;
	Thu, 17 Sep 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660982;
	bh=yBstDc6nqXoWMW9koOxtrouQYZUmgojFLuwgF8GG/XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSX5RLadK5qDrgw9/ghp1JNWAtZBsn/5UbrXfXDe8dJdb5J+ZPbEG/Wa3UCuPOSzP
	 tqa2qHLePW7LLC5SjCX1e0l/jxFdJNI3GabZTaOJhxInkC2VGqJk0eCZ7kRa87lXLi
	 yMUXII5P2bmcezD5lc8zI7DudbbS2z6lWPbTrh5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0044/1250] soundwire: intel_auxdevice: Add cs42l43b to wake_capable_list
Date: Thu, 17 Sep 2026 15:57:19 +0100
Message-ID: <20260917151553.130305111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit be6d8daaab654e9b0a8508757534d556d399d0cd ]

Add cs42l43b (both packaging options) to the wake_capable_list
because it can generate jack events whilst the bus is stopped.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260429153614.741899-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 8752b0e3ce74c..c0c8ffcecc6bf 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -51,6 +51,8 @@ struct wake_capable_part {
 };
 
 static struct wake_capable_part wake_capable_list[] = {
+	{0x01fa, 0x2A30},
+	{0x01fa, 0x2A3B},
 	{0x01fa, 0x4243},
 	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
-- 
2.53.0



