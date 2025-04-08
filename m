Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C0D268688;
	Tue,  8 Apr 2025 10:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109744; cv=none; b=lW7ZyJ0BGZYveDDW+udL/RhPXyuGdsz5uh3Je/e+vSYcKcjhVAWnLrQCwXroJX41UBAVq3dEB8W2I/uIooraT/SceecIs4YPsy6PFmH3XQgEDRWc4axwWNcuw8uYsicTlIEU4XdlxyR2bTgBFG1vFh/Z3zW9W8dH2Tt4lACcN4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109744; c=relaxed/simple;
	bh=bp3mEkVdNUNPKAMXS1L/Atf8eLLx4IMtAs9lRUdqGBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IrxtZ60FBYYw2hCuMyEd0oKGYKHd6FnotQ6Jyq4iyPtmtGfTUnDYRymDBW9OodLyYJSjRF0UFQnSPqG8jCU92iRgOSNu0O18L76b/dAjfvj0ytNV57JCfYsF38QUUdCJIVYIDInCVfDBfIk8dgEhVB4BT3bHfOB+0jiAaaAt/80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQZ/2nKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQZ/2nKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD02EC4CEE5;
	Tue,  8 Apr 2025 10:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109744;
	bh=bp3mEkVdNUNPKAMXS1L/Atf8eLLx4IMtAs9lRUdqGBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQZ/2nKQcoo83LSh48N+I11Sc7YTWkW6FuuF10TtN8xUZIwuEVp6KVwKwKepKuz8/
	 UT/9QGTxy43giHQv8ZNceekBJvd/ap6aRrOl1uMLEctQaVXXV+TW/DsyhdWO1j6KC+
	 r6WE1le25Pg2WXlg7sx5e2Es9rjVaGsqAohAivOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Cheong <htcheong@chromium.org>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Johny Lin <lpg76627@gmail.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/227] ASoC: SOF: Intel: hda: add softdep pre to snd-hda-codec-hdmi module
Date: Tue,  8 Apr 2025 12:46:53 +0200
Message-ID: <20250408104821.463509849@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Cheong <htcheong@chromium.org>

[ Upstream commit 33b7dc7843dbdc9b90c91d11ba30b107f9138ffd ]

In enviornment without KMOD requesting module may fail to load
snd-hda-codec-hdmi, resulting in HDMI audio not usable.
Add softdep to loading HDMI codec module first to ensure we can load it
correctly.

Signed-off-by: Terry Cheong <htcheong@chromium.org>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Johny Lin <lpg76627@gmail.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250206094723.18013-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 8d65004c917a1..aed8440ef525a 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -260,6 +260,7 @@ int hda_codec_i915_exit(struct snd_sof_dev *sdev)
 }
 EXPORT_SYMBOL_NS(hda_codec_i915_exit, SND_SOC_SOF_HDA_AUDIO_CODEC_I915);
 
+MODULE_SOFTDEP("pre: snd-hda-codec-hdmi");
 #endif
 
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.39.5



