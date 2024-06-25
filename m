Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD8C148315;
	Tue, 25 Jun 2024 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308477; cv=none; b=jSit361Ne8BrJE6p7umpVNqbBI2TD4tbXITD5X2hKkjw90KFLW8pye4O4KUtj5wCQzwZw3YQ7LZADT42uoEjt1XyOSVHUtOiPrdFOsYW/YkGZfaGMEmTOWRO2I6eIH3VbKQ/rcQ0a1951MIo/awLjlxfFJeewmHZgS3rgbuTBBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308477; c=relaxed/simple;
	bh=TGM6OWbs48OkRWdidSoP4efpWpQG2zWOXYGh3BIPaWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJCS2IfWviHkdeRqhJyW42l38sacfGXGUh2OcVTDHSbCsZUoa1FQqUv6mrO6hEKRmAqbyvCDQs05Lu2eZFK8sAEsy2CFoO2IFR8xLWKgJjaS07Ls6VT9Mp77pNqhf5LWfHaIjWbym0lcDUDntpr0Ui9DWOeW6nBWxgSNlpNjBLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvufVkdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvufVkdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B36C32781;
	Tue, 25 Jun 2024 09:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308477;
	bh=TGM6OWbs48OkRWdidSoP4efpWpQG2zWOXYGh3BIPaWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvufVkdA4Hw6Ejxk/Lbso4UGtq3YM8jGb2Ncw5wYJ67SBjsChSy4Sx9eHFYLqCqU2
	 yQ01ukBbd1xZNHU5HEEURU9B4z7ocV41O5i2ichMOAGXbdqcpmQ3+y79JOlwNvdMfK
	 PxXB0E7JW+unjvddx989OsGvDCT/KqvkaUDJSLC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 103/250] ALSA/hda: intel-dsp-config: Document AVS as dsp_driver option
Date: Tue, 25 Jun 2024 11:31:01 +0200
Message-ID: <20240625085552.024039985@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 2646b43910c0e6d7f4ad535919b44b88f98c688d ]

dsp_driver=4 will force the AVS driver stack to be used, it is better to
docuement this.

Fixes: 1affc44ea5dd ("ASoC: Intel: avs: PCI driver implementation")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20240607060021.11503-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index d1f6cdcf1866e..e7c2ef6c6b4cb 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -16,7 +16,7 @@
 static int dsp_driver;
 
 module_param(dsp_driver, int, 0444);
-MODULE_PARM_DESC(dsp_driver, "Force the DSP driver for Intel DSP (0=auto, 1=legacy, 2=SST, 3=SOF)");
+MODULE_PARM_DESC(dsp_driver, "Force the DSP driver for Intel DSP (0=auto, 1=legacy, 2=SST, 3=SOF, 4=AVS)");
 
 #define FLAG_SST			BIT(0)
 #define FLAG_SOF			BIT(1)
-- 
2.43.0



