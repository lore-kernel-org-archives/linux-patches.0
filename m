Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AC533D6F5;
	Tue, 16 Dec 2025 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884572; cv=none; b=kMNMn1CQ8w2dm9UO6bd13WOHykFtTW8CsPMA+GzPqt/2mJ51jf5Quiv2lgHq7XBXzG/OhPtv0C5dq2y3Lma+rxIe2kOn+WQg52AX41w/bwFPigUyli7RZfp8jKUofVHjUM5TlPw5MN0DtPeKGGeKufQc4G/b1U4zfCnByODfy3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884572; c=relaxed/simple;
	bh=D+f8UZTqw79aSrgWxWNReDC2JQ1xZkdYyydeb2cdk28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp77sb0foaBwZlDZcvQeGB8uo7F0FG/tmIqYsp2MFod2Z2uKoF4xU8ZKN+KxlRF5IvvGQV3XtlPzkNwIVoiuXDdphgFBb8ZXuAL5lBcxgfMD7JbGkAGKhDS7BEL56SycUuN0TgSfbuYie0QTJS4gvu27cNHDHsLkwxWkhxIAioc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLsWXu+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLsWXu+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8682C4CEF1;
	Tue, 16 Dec 2025 11:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884572;
	bh=D+f8UZTqw79aSrgWxWNReDC2JQ1xZkdYyydeb2cdk28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLsWXu+8VfXHBQg5ZMSD15kScUwA6OCWnhgBhbYzl/a9hoPlNGwr2NqLQYITQTcLE
	 152aQq2gstlE6aAyi+LA7OqC2ncILDQQNKWJhzaRlvKbmqHUgxbxt8swK8jzcvhL5f
	 hvgwBMJKaFlM4OydSGfHe72tyXDzNVshoeXC0kpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/354] ASoC: nau8325: use simple i2c probe function
Date: Tue, 16 Dec 2025 12:13:21 +0100
Message-ID: <20251216111329.393236905@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit b4d072c98e47c562834f2a050ca98a1c709ef4f9 ]

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://patch.msgid.link/20251126091759.2490019-2-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: cd41d3420ef6 ("ASoC: nau8325: add missing build config")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8325.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/nau8325.c b/sound/soc/codecs/nau8325.c
index 2266f320a8f22..5b3115b0a7e58 100644
--- a/sound/soc/codecs/nau8325.c
+++ b/sound/soc/codecs/nau8325.c
@@ -829,8 +829,7 @@ static int nau8325_read_device_properties(struct device *dev,
 	return 0;
 }
 
-static int nau8325_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int nau8325_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
 	struct nau8325 *nau8325 = dev_get_platdata(dev);
-- 
2.51.0



