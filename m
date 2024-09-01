Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1D05381A;
	Sun,  1 Sep 2024 16:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208409; cv=none; b=fo6e/fsMchmxV9VpAbEOYWJ7Fs54YdB6c1TGvzLbO8CJfkNRrHZ5eS155E++w2V8ITs413aXzPHR70/XShmdmNGMiUN702L0P7D6rcr7aGIzxAVF8PetAEH1/cUxdH8mcnH30RReyrtdw8qLlrDpIcK3DXVYDBuZuVCWruae0fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208409; c=relaxed/simple;
	bh=dFSaBCnhyHkUQeoEdUvGPTjuOQ7NcfRhdze7qJIhtk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqImBG/rm5TwseUxh/rnv6fdYd/2iU8zyroJbpEptXOULC54tBr2FNFzyjwNpalsKV5G67+Ce2pcoK5cHCqHxZEnLgW8wFbhmMgS3Crj7DY7VElCqV8XAPaYvBoXnYT+kTWW6c52Jfv8Ess21+XBqaJtNdTOedFlSRHJ3db8d18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgvDOzr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgvDOzr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDCAC4CEC3;
	Sun,  1 Sep 2024 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208409;
	bh=dFSaBCnhyHkUQeoEdUvGPTjuOQ7NcfRhdze7qJIhtk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgvDOzr3d1ZSiBJIeKlPrkhUvMbYP4Cjj+JDgQppL7CpiVsYkL2m2ADlsi2qdRX0o
	 5eCgimI/tkpHDCWLbIPvY+DxjISATTNtHIMJV02I8I2dXqsQY1ey/jfYBkrGBLjSW9
	 SlZ9Q4lTOkH+IjQrBWk9snjpl6cgiKnEtoq3JDN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 056/149] ALSA: hda: cs35l56: Dont use the device index as a calibration index
Date: Sun,  1 Sep 2024 18:16:07 +0200
Message-ID: <20240901160819.576027090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 91191a6e50a2ff752da244493171037663536768 ]

The HDA driver cannot assume that the order that the devices are
specified in the cirrus,dev-index matches the order of calibration
entries.

Only a calibration entry with a matching silicon id will be used.

Fixes: cfa43aaa7948 ("ALSA: hda: cs35l56: Apply amp calibration from EFI data")
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://patch.msgid.link/20240821124711.44325-1-simont@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index e134ede6c5aa5..357fd59aa49e4 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -980,7 +980,7 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int hid, int id)
 		goto err;
 	}
 
-	cs35l56->base.cal_index = cs35l56->index;
+	cs35l56->base.cal_index = -1;
 
 	cs35l56_init_cs_dsp(&cs35l56->base, &cs35l56->cs_dsp);
 	cs35l56->cs_dsp.client_ops = &cs35l56_hda_client_ops;
-- 
2.43.0



