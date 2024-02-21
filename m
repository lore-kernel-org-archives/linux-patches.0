Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB9A7C0BA;
	Wed, 21 Feb 2024 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522652; cv=none; b=Kk5NKEqwFhqRC7oj6GJ5uBrEKazPu1bBFhf8WQxi2k3LXmjT8+H27y+EB4iM7rwis7e4eDsjP89XOZzW5B5i/TPZYE2ge+MBSn4ZZ9HskvQ9PtuX+/Hy5GmZ/XNSnn6H75zxGMwi0W5yjUgiJ8YY6OtkywCzIy97DBGi9wWzUOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522652; c=relaxed/simple;
	bh=ybTs8ng27yj31WmLX8eVw1Usd8ZM8/fy3XZRJr+Y6nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HUHQPMYodObbJ+BeqsVjErChVog5ygyCdg4P/fgZhmkOzsE+YFKZCdbie7jb+nvb4HlS4czjniFbOoQF+1Z/WEVhE/M3lrpYtnbvelTDIZbLIRKl72ZWTgJBK07PE2xhTeDEkABQ3DZtdVgnas0t/4tbT99ALx6yLcqwtCpB3os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dK0rrdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dK0rrdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FDDC43394;
	Wed, 21 Feb 2024 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522652;
	bh=ybTs8ng27yj31WmLX8eVw1Usd8ZM8/fy3XZRJr+Y6nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dK0rrduvF13nwOGJzOVkJIwPMQjqJ/v5vTtxmRqJ+nnfLuz2yRx9u0XyFUHKxIwc
	 U7yOWwUAdNpVNAW5OC+EzGgshwZB93+xSGbJNzh96fuqiQ/qje536Uccr9drKJJQhI
	 3+0+UtBDlieduTc4N8gXXVLAgvsLevDW2iCjyB+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/476] ALSA: hda: intel-dspcfg: add filters for ARL-S and ARL
Date: Wed, 21 Feb 2024 14:04:33 +0100
Message-ID: <20240221130016.102034117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 7a9d6bbe8a663c817080be55d9fecf19a4a8fd8f ]

Same usual filters, SOF is required for DMIC and/or SoundWire support.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 774d80f4b101..e4cd6f0c686f 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -389,6 +389,16 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x7e28,
 	},
+	/* ArrowLake-S */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = PCI_DEVICE_ID_INTEL_HDA_ARL_S,
+	},
+	/* ArrowLake */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = PCI_DEVICE_ID_INTEL_HDA_ARL,
+	},
 #endif
 
 /* Lunar Lake */
-- 
2.43.0



