Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017032FA652;
	Tue, 17 Jun 2025 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179186; cv=none; b=dcea9XTJVVVuDY9KAouGL6RRAa8enX1VG7RmeJKDq+gMapVeX7rH5I3nVClWaueRczG/L6qEfeWcMxVX0QEE/2S2aDjav1gF+e55WPOe3QFWZTL5C9TQ+YBZDPox/CxKTS8Xn6erT4x1CxdSjtwUp8cSwr70uBEZcwqX5oBF1JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179186; c=relaxed/simple;
	bh=pqK+Tj7tHCC43YiOcPaRS1rYPBHtWjaixSoK7uOrnqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJvje3fsO6RwjFknVOvvr15O5AFnckyfkQiyAd10iQHog8fzQDHKyAET6ngvPq3Z5cnf74S7I2ejDwJyxbpeS+I5zC+uoWTemISVcjDS17u/omSNXL09FKTIDUubKZhaJxYUmUY9QPIN6S3iklpnyg3CIQMRpVBATzOIOeWTHg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVMCW3Sq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVMCW3Sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E626C4CEE3;
	Tue, 17 Jun 2025 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179185;
	bh=pqK+Tj7tHCC43YiOcPaRS1rYPBHtWjaixSoK7uOrnqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVMCW3SqvmtvThiCmRZ+PHhgtD1WrSCbN4ca5hYQw7ZlB7rFwr7tNsY7QsSxVVBHB
	 vfJiRQ59xOB21aDKmxQjDzH9QvgQy4Dt/qiV3Xa/QV+XEA3Msw0y9tj4lSni+VNcek
	 bCmvPONhRcaQxc+INgK6/CAhj2ZpKW1eeAqkSB5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 644/780] ASoC: Intel: avs: Fix paths in MODULE_FIRMWARE hints
Date: Tue, 17 Jun 2025 17:25:52 +0200
Message-ID: <20250617152517.705443103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 9e3285be55e6c0829e451b4a341e3059da47ec9d ]

The binaries for cAVS architecture are located in "intel/avs"
subdirectory, not "intel".

Fixes: 94aa347d34e0 ("ASoC: Intel: avs: Add MODULE_FIRMWARE to inform about FW")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-6-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 1495e163d47ef..cbbc656fcc3f8 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -921,13 +921,13 @@ MODULE_AUTHOR("Cezary Rojewski <cezary.rojewski@intel.com>");
 MODULE_AUTHOR("Amadeusz Slawinski <amadeuszx.slawinski@linux.intel.com>");
 MODULE_DESCRIPTION("Intel cAVS sound driver");
 MODULE_LICENSE("GPL");
-MODULE_FIRMWARE("intel/skl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/apl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/cnl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/icl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/jsl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/lkf/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/tgl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/ehl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/adl/dsp_basefw.bin");
-MODULE_FIRMWARE("intel/adl_n/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/skl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/apl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/cnl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/icl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/jsl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/lkf/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/tgl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/ehl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/adl/dsp_basefw.bin");
+MODULE_FIRMWARE("intel/avs/adl_n/dsp_basefw.bin");
-- 
2.39.5



