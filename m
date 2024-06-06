Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6CA19884D;
	Thu,  6 Jun 2024 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683363; cv=none; b=IAJ30xJlqLjlZRIWMAOuWeznx2cRnSDpWwzaUKCAs1twNypnLNy122BIqNlLnSlkwlpih66bIE7g+Kn0ZBIu8mNkW0Mj1mIb+Ujeiv+L/Noigtg2zHJu4q/3pMVfpxnuMfBXr4pmh0pH0kwY09UsqXeeT/382jfHZezRRILDzJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683363; c=relaxed/simple;
	bh=E6WwGDbzzCTVStALOIo0Y2oOBOu4tqnCDm70Jxmr7uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/HbLT6Xw7icc9hpmdof4lH2ukGS9/nh5C5QARmAI5HXmeWNo3vvP8792IbqksG2Zpfw18lbjZlf+FEH+hr1V3p5t4CUGNOmxYEFhzdg78dbfpLadyx+9OdUHjBNlQWocy0WIOxVfc9e468DhB3rJRJgrSeEaQswVVP0BOd4E1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYR6UIQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYR6UIQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5839AC32781;
	Thu,  6 Jun 2024 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683363;
	bh=E6WwGDbzzCTVStALOIo0Y2oOBOu4tqnCDm70Jxmr7uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYR6UIQiSDKjpgthxc6xUHDirciU8eMPkhHFCgjLr9hgevB4Ndu8pDq9jIMtV1NW4
	 Tx6gzrvdCEuccXh3pGUk8bTHr5VIhPXmDLx00A+SPoCZ4Xl8DZSx36YhcSyPTXiuuB
	 RGWd3UYXkyiMwUJQFwb/VEgdfDDiv3CsvghJlePA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/744] media: radio-shark2: Avoid led_names truncations
Date: Thu,  6 Jun 2024 15:59:37 +0200
Message-ID: <20240606131742.163968444@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 1820e16a3019b6258e6009d34432946a6ddd0a90 ]

Increase the size of led_names so it can fit any valid v4l2 device name.

Fixes:
drivers/media/radio/radio-shark2.c:197:17: warning: ‘%s’ directive output may be truncated writing up to 35 bytes into a region of size 32 [-Wformat-truncation=]

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/radio-shark2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index f1c5c0a6a335c..e3e6aa87fe081 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -62,7 +62,7 @@ struct shark_device {
 #ifdef SHARK_USE_LEDS
 	struct work_struct led_work;
 	struct led_classdev leds[NO_LEDS];
-	char led_names[NO_LEDS][32];
+	char led_names[NO_LEDS][64];
 	atomic_t brightness[NO_LEDS];
 	unsigned long brightness_new;
 #endif
-- 
2.43.0



