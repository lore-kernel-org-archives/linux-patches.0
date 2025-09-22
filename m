Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010A81FDA89;
	Mon, 22 Sep 2025 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569614; cv=none; b=RpdpFJGIFP54NI3kiOvSVwxVw+Q0Ae93Zu/OOIpAHMjxCtFzfw+mXDuOpQuhD8Y5KrGmb/+0PuOcTWJ4fw28iSAhPDpljTlBg6wD5H4Ow7km8b6nAa9vaubVlaF0gOrVBPEsBDYVyZ+6sPaxUVFpy0GT7WEQmwnQtpDq8Yxe1YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569614; c=relaxed/simple;
	bh=zQUl31cL3Xim+X1hMIRJ/Jb2SftckTyEOVnYpe/RoZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m072yDc8uW69X26vt9u+bjzJ56iMz1zs1O03DRRjhnF2tL0Kx4YRzglAiu0Z4ZyuhS0LK9Ig8rlK7U1ybJPfG7mFkB6PWZbIxPro041ygvJoGoHfBNnuItx4dTHun/hbJrLWJZM2ABCe2cAAfyGBoEgGWt70HLZqSuAhm8IkkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsRcJQ2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsRcJQ2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C717C4CEF0;
	Mon, 22 Sep 2025 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569613;
	bh=zQUl31cL3Xim+X1hMIRJ/Jb2SftckTyEOVnYpe/RoZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsRcJQ2f0QyDi5n2oKlHLLo5a+Oz8jJVwA5hjF5z2UgDv7TZGo05dy4Y9h6L4un4j
	 VgSI1PQvZUB7Xy7u/m/s3WhBTXSPzj+X41kxtb3ob2BiGdyb/t71/lv/H4FOOPfT5W
	 5P/Xs/OT2J1ftLZ2UXYyknWN2yIImCqGPf9Y3QCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/61] ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message
Date: Mon, 22 Sep 2025 21:29:33 +0200
Message-ID: <20250922192404.675553725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 35fc531a59694f24a2456569cf7d1a9c6436841c ]

The dev_err message is reporting an error about capture streams however
it is using the incorrect variable num_playback instead of num_capture.
Fix this by using the correct variable num_capture.

Fixes: a1d1e266b445 ("ASoC: SOF: Intel: Add Intel specific HDA stream operations")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250902120639.2626861-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-stream.c b/sound/soc/sof/intel/hda-stream.c
index be60e7785da94..fafaf9a8e6c44 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -837,7 +837,7 @@ int hda_dsp_stream_init(struct snd_sof_dev *sdev)
 
 	if (num_capture >= SOF_HDA_CAPTURE_STREAMS) {
 		dev_err(sdev->dev, "error: too many capture streams %d\n",
-			num_playback);
+			num_capture);
 		return -EINVAL;
 	}
 
-- 
2.51.0



