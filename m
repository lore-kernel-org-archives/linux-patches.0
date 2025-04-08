Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1785263C90;
	Tue,  8 Apr 2025 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112372; cv=none; b=mFJMHYVq3hEcdEZOLbB218cVMmR3IENkh4y49xcFd8nDxb+zr568MZRSmUpG4oeBAoHhNM1xnBkGJKpKQDU3vn08UBCJDWup2+wfE1fdm0tMFcqsDv/h5kpaMQ+85XBWXgdNNq50y5LywxR1qvAIstiloa5NjYhcpwbghqtS3R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112372; c=relaxed/simple;
	bh=UlnIQwW2S9684xdzxB8CkwDJCcVVngZ3qXm287ONmR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjlTwLSz/N1a4rvKC+tvQzoR9DOfPXMWWIM2DX82AY0I4ZVRivSoOEOL2tstq+F2shVzYuGCynOmTTWSwa/EP7WdPvRLzQ4ZUPdicX+lU+RZixYmDn3gtylLtPtuVA1TCTEryxckP2P4Hv3okB0NvNOh5iJBRLNbE3drCinsFe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOM6pbzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOM6pbzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F02C4CEE5;
	Tue,  8 Apr 2025 11:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112372;
	bh=UlnIQwW2S9684xdzxB8CkwDJCcVVngZ3qXm287ONmR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOM6pbzBUutYBpCii0mqRcvKSESv2mXX24mCIvByJrKecTRopfda6Do4oRqizVZxw
	 YROyMCnTpCBwTjFD2gWcmNsbSTRJI85746VESEguSUmK1BqKnlxsvNxBFqYtgEy9xx
	 bz3Z1CV+0sx4lOEe87aDIY+WyVBkoQm1ub9CBDOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/279] ASoC: tas2770: Fix volume scale
Date: Tue,  8 Apr 2025 12:47:08 +0200
Message-ID: <20250408104827.595121701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 579cd64b9df8a60284ec3422be919c362de40e41 ]

The scale starts at -100dB, not -128dB.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2770-v1-1-cf50ff1d59a3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index ec0df3b1ef615..4e71dc1cf588f 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -508,7 +508,7 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 }
 
 static DECLARE_TLV_DB_SCALE(tas2770_digital_tlv, 1100, 50, 0);
-static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -12750, 50, 0);
+static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -10050, 50, 0);
 
 static const struct snd_kcontrol_new tas2770_snd_controls[] = {
 	SOC_SINGLE_TLV("Speaker Playback Volume", TAS2770_PLAY_CFG_REG2,
-- 
2.39.5



