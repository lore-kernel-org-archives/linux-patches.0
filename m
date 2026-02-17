Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCBE266581;
	Tue, 17 Feb 2026 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361439; cv=none; b=jE6aU4nEphG0nA8CYop6x7tkQ4iDIzHGicZEDbW7NKs3cFy4gIiwV7oXWgwhtdNFlp3x3t/O0EdeAAlvBYlLbAf5fNy97KTPTUwJY4GKNqTWYZln4RlU3mcfK6VoJWgNfY7iXxuRvvZdu2/8u+JOR+mmmjUVel6yV9t+q0mdzR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361439; c=relaxed/simple;
	bh=4HkZdAlsphG/nVMvdqIlDxSQFhbvkhKfbEPklPc5b+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqKGd4/LvgdkhIQ9QASG/dgVQ8C6dO4Mu7BE6WnvrwEhuGwbdmbGJFJKyWufYBmG5BHZrnGdn/ag7iNmvgWsLw6zOPcgYr/F6nI3O6GQJqCnCNkM+mpR5k04BgcRcRXiAHOOS31bZipM6xYmUMf9iFUOR4HGF+ZhF6gBBwU5vUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR7is/n1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR7is/n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D431C4CEF7;
	Tue, 17 Feb 2026 20:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361439;
	bh=4HkZdAlsphG/nVMvdqIlDxSQFhbvkhKfbEPklPc5b+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR7is/n1tJH03mLRMHUwFG4l32f/g303FYdMDc71sEU0mKU1bomW+RQZ5aLEn7VzK
	 /jZitYE26pMag++/6fA+VrSeyRVxvKAbwQskSoEWekvvn6uToOsy5eV9K1np9cjjku
	 6RmQcNKyaovoaen7dUstaSmYH+f6xh8rm/4f7rI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 17/43] ASoC: sof_sdw: Add a quirk for Lenovo laptop using sidecar amps with cs42l43
Date: Tue, 17 Feb 2026 21:31:57 +0100
Message-ID: <20260217200007.128238218@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 1425900231372acf870dd89e8d3bb4935f7f0c81 ]

Add a quirk for a Lenovo laptop (SSID: 0x17aa3821) to allow using sidecar
CS35L57 amps with CS42L43 codec.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260128092410.1540583-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 92fac7ed782f7..6c95b1f8fc1a5 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -802,6 +802,7 @@ static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
 	SND_PCI_QUIRK(0x17aa, 0x2347, "Lenovo P16", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x2348, "Lenovo P16", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x2349, "Lenovo P1", SOC_SDW_CODEC_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x3821, "Lenovo 0x3821", SOC_SDW_SIDECAR_AMPS),
 	{}
 };
 
-- 
2.51.0



