Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1226B748;
	Tue, 30 Sep 2025 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243894; cv=none; b=cHo0DGcz8z3KR/OXNTRTEPMPhInzsl/cczSex1A9eP6gatqR/qlWxkJ3gyeRon9VvZPkV1ODIgLohEf7VfonQljkpW7cI4bYQq+lsRFnicUfTaA5umaioLVzWfn5cRtrz7Fsb/bb37DlewxW5SysNQFl2X2VgIAKyRwZpRuGqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243894; c=relaxed/simple;
	bh=jWbJRXF4XIstRx4ocP4MPmdfh1EW5XkjhMIdDwO8gH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqfvEJwPP+obcsXjCCXb1SbtSML9bAwWxtOgfNnv/01SG37NDSLdgx0yspOVb1Rnua7ytHBeoWOK5HjAt0ZJn3Aa8Jh3apvARrVCzXvWQOj/F6ySniXRBVO9xp7RHH0SPzMDgPoo/2vI/nkkKKPdhCypOgrd810iL7wvCF1u7II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TC8Ylnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TC8Ylnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9ADC4CEF0;
	Tue, 30 Sep 2025 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243894;
	bh=jWbJRXF4XIstRx4ocP4MPmdfh1EW5XkjhMIdDwO8gH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TC8YlnmtEoTYB0FFhkAXYN8dDUyUfk9ohZLeGcpZiKKqiI7piBiTjup8Z/R1dUqj
	 7ySfbHLZa4ox+DaU/GEPgG3J/6xvMnUoGEJW3CVMt1y5sRevQNoDiyx+4JH/v+DjwK
	 VVk1amMLxKXKjuTr4fOz1ohkoXiJ2I6UqyLzMkxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/81] ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message
Date: Tue, 30 Sep 2025 16:46:50 +0200
Message-ID: <20250930143821.688491480@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0c11fceb28a7a..d3edc40c7f473 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -655,7 +655,7 @@ int hda_dsp_stream_init(struct snd_sof_dev *sdev)
 
 	if (num_capture >= SOF_HDA_CAPTURE_STREAMS) {
 		dev_err(sdev->dev, "error: too many capture streams %d\n",
-			num_playback);
+			num_capture);
 		return -EINVAL;
 	}
 
-- 
2.51.0



