Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6DD27B320;
	Mon, 22 Sep 2025 19:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569745; cv=none; b=V77OoUb2qL9TKKvZQleSUQXymPKCBmMZlBSoZv5I698jGKgTwv+y8cm1PGlAv413rAwYMGN6xGD7suK5FaOpivIT9r+gf78YrRaYygsNrepHrE/+/FxwbqpC8QXPAu4dPZmMel2gXxSk6QxxtSFdoNjpSjqEOwpnp2ti2dKUU2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569745; c=relaxed/simple;
	bh=yxlIa5f0j+oK/EP5NZ8LqDvOwE++VjYnS6yl8Td2TxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1UGKw/DGYh84x7IB9zyiDQrEDsanpELrxQe2lAVKh72Zgl1ii9wpeqy4XIHSurtkL2faa182q8cu+s0UC6a7FdYNgQ+bCA6ZrsfET+YKmTOLLfF45NlK8a5M3PCMJCgmDrdMSbi5o97WkQF7JPpH4sFEempCi0kdo2lcy7++Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdnKgyFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdnKgyFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C45C4CEF0;
	Mon, 22 Sep 2025 19:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569744;
	bh=yxlIa5f0j+oK/EP5NZ8LqDvOwE++VjYnS6yl8Td2TxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdnKgyFuLSr8/UdNFBog5ocu0+fxozSKePvwizYbnORp6KFcxoYn4A0KXm/L2iEhn
	 LjA9DsAmt/8ZOHIofytdEU8KcdPZLDmJ3yeTMwstdxi1bNQfXbKOX8Mc/1MfIVmFZf
	 dksbqxNd15T1/XzGp8M7Gl8qTRJ4TI8gLDVvuT6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/70] ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message
Date: Mon, 22 Sep 2025 21:29:52 +0200
Message-ID: <20250922192406.003940044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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
index 0b0087abcc50e..3bb743cb167a5 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -842,7 +842,7 @@ int hda_dsp_stream_init(struct snd_sof_dev *sdev)
 
 	if (num_capture >= SOF_HDA_CAPTURE_STREAMS) {
 		dev_err(sdev->dev, "error: too many capture streams %d\n",
-			num_playback);
+			num_capture);
 		return -EINVAL;
 	}
 
-- 
2.51.0



