Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E7249890A;
	Wed,  9 Sep 2026 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962463; cv=none; b=M0gVCccPlVMcS4Y6E87PhTRVTTIwyNZChKZXAni2p91cfSyWzjfCsXTDqn2jnqBqrT5xBlz2GIotGNWdyadArWCxPZsjAWC3d9j87/Pppd4UQNu1QW+gxpk6Hb/rcMmmwqKnqqCaxhDSyJBJZM4l0ZnudeNRxaR6j6DJIGIpMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962463; c=relaxed/simple;
	bh=5rCPMeeTgL69+GIjfOys1cbHv7vF80qGFrqam6++Tlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwSTQnn+u9dw/8ncCUDQ2BPDzJg5KzS7DetaFpRdxvXkT6hV00qnAnn2QPsnHfnzLT1cp1r5c81c3mRhlSgXZqi8aosm7N7M0+2gV1p0sNgFjwuTPLprYVxCq163793i95/+s/BLCCAyzzvvHSipnjwqcRp+9CVsHFMG18DyMCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb5hAnHE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb5hAnHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF061F00A3D;
	Wed,  9 Sep 2026 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962462;
	bh=WFad2ILshhzHfbyyuB2FNCXxmYlXHQInd5TswRe1rz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jb5hAnHEhMIJzJMx8gKCT363ex0HqL0wnyjswvqGme0GLXiBLYJ/v3qroh0HLpSOz
	 NdP6yJeP/bkDBcGU4X8FT4R0rst1rplapnULpDOZbKKN57x57br06rgTRTZsSQm6nT
	 Ngvj/o46sVVFzMWeMG/phO6/7WJLJyoH04AlRMbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 257/556] ASoC: tas2783-sdw: drop duplicate reg_default entry
Date: Wed,  9 Sep 2026 15:38:57 +0200
Message-ID: <20260909134239.556720312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit ceba07ca24fab54e0e38ec96d196fca3e638d671 upstream.

TAS2783_AMP_LEVEL is defined as TASDEV_REG_SDW(0x0, 0x00, 0x03), so
tas2783_reg_default[] lists that register twice.  Drop the open coded
second entry.

Fixes: 4cc9bd8d7b32 ("ASoc: tas2783A: Add soundwire based codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805091327.23944-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2783-sdw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/codecs/tas2783-sdw.c
+++ b/sound/soc/codecs/tas2783-sdw.c
@@ -106,7 +106,6 @@ struct tas2783_prv {
 
 static const struct reg_default tas2783_reg_default[] = {
 	{TAS2783_AMP_LEVEL, 0x28},
-	{TASDEV_REG_SDW(0, 0, 0x03), 0x28},
 	{TASDEV_REG_SDW(0, 0, 0x04), 0x21},
 	{TASDEV_REG_SDW(0, 0, 0x05), 0x41},
 	{TASDEV_REG_SDW(0, 0, 0x06), 0x00},


