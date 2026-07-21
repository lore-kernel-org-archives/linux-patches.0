Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E0D3FDC06;
	Tue, 21 Jul 2026 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649767; cv=none; b=RLDyDvwp3mAta8cAHqUVp7G6ws/ydli/OLGQPHIoDGlFjJAzEhPwXuTAqFG8vc3shlpJDgOwlBKSahUROtlEqCT7ktAMTWRQ+8rskxF+FigHXCe6FD5kOZ5fwKhv6X2mjpuAJKHV+Wej4HEs5lv5a2ioZHX/WD4jH/soQBWk10U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649767; c=relaxed/simple;
	bh=kMSfiaGGm0Rh1R2ZEDC0f5tzi541c3F1V0IgIYkqWh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNj3Tbk6djP1EHMm614qN3MUoFdMmegu2xdg3TptpwXekmzFWODu5GiLXJvHivA8ULR2ALGV2U6IxgRe12zC560YpX3IRQ7+X+KljOZeEFvgvwL4TC/x+sIjBvJjBRpB7uWb2Wx0hl8+GOtNpfcPrsrjkm7uXeGtTQDmfM5KvMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzkA+heH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzkA+heH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E411F00A3F;
	Tue, 21 Jul 2026 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649766;
	bh=+yWtjVN47xwOYoVkeU72WPPZwFHJQnXRY6AMqfh2JEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzkA+heH7W760v9tc6ccv1eSGJiuHLi1McFzDT7MvuHBsqfNc44cfsEGCqzudSiiv
	 nSHC/1s3Bgd7u6Y1Lwg8ExtD4ybEcJvmvC8rhd5uXwrdd5DNCuknjXWmBFhBGFEtxT
	 5fsIKPYTGfFV5BMwOIEKwaLCVkYizRepFphu6OPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0700/2077] ASoC: cs35l56: Fix wrong error test on simple_write_to_buffer()
Date: Tue, 21 Jul 2026 17:06:13 +0200
Message-ID: <20260721152609.304543476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 3073eb1f1143deabbda6a043238ab9d99672e7c8 ]

In cs35l56_cal_data_debugfs_write() fix the if statement that checks for
error return to only check for negative values.

Reported by Sashiko:

  simple_write_to_buffer() returns the positive number of bytes copied
  on success. Since the condition returns immediately on any non-zero
  value, is it possible that the written calibration data is discarded
  and cs35l56_stash_calibration() is never called?

Fixes: f7097161e94c ("ASoC: cs35l56: Add common code for factory calibration")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260610093432.557375-1-rf%40opensource.cirrus.com
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260611151234.1111153-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 5405f70b7119d8..9928608296d881 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -1260,7 +1260,7 @@ ssize_t cs35l56_cal_data_debugfs_write(struct cs35l56_base *cs35l56_base,
 		return -EMSGSIZE;
 
 	ret = simple_write_to_buffer(&cal_data, sizeof(cal_data), ppos, from, count);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	ret = cs35l56_stash_calibration(cs35l56_base, &cal_data);
-- 
2.53.0



