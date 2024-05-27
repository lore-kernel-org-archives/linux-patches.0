Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6950B17E90E;
	Mon, 27 May 2024 19:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837094; cv=none; b=A2knWD1vWE/pliKbangWsJE5oeBrJzUjR1hEgJ8ssHAtBfZN7WFswx4Z9ouHqUCuTJkPtpOWvooXj3Oc6PK4bajYoEM6eoR75IH6shmyFpp0FSWdmHAxXMe2wrVV8X3ukDetI78OJr6D9TKZ3Trp6krkPC3pm/0VXwnAR5lDi58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837094; c=relaxed/simple;
	bh=Mza6/cJIN8FsNp7pinJoojHrjZ74UR5YZtH++1OYrW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJ4KQYFkGmyHrnzxJKfUFv6UFz3AzgWk8oWDZ6nSmHibLE+F98EuMQCVmwTIL1bSOiVjWqWTZyo2kvPzBAQ/+Jfwk5nkdTUurXhMFKuLXZm0ZVTC2XtOp0rDt+nApwVYYHBuqIqieosKKKitwyBFm7I+B7loVzp1ZxcCttdnFEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFTA/4wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFTA/4wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13CAC2BBFC;
	Mon, 27 May 2024 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837094;
	bh=Mza6/cJIN8FsNp7pinJoojHrjZ74UR5YZtH++1OYrW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFTA/4wTVxu1cGBpurZrqw7hKWrlLRifvMU5xRpxL2LTUDbzF+oxyg6darU/jCkt9
	 kC/6Fe8Hv3n4QV+6NWdufG704bPmtdOwJ5gx4IUtUDpa8m0rUa9AwkNGJ8QnY92q34
	 AbISVYKvTqrMzD6+Ivu0fOZsPZTTF54VGmJdc5Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 307/427] ASoC: Intel: avs: Restore stream decoupling on prepare
Date: Mon, 27 May 2024 20:55:54 +0200
Message-ID: <20240527185630.674450521@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 680507581e025d16a0b6d3782603ca8c598fbe2b ]

Revert changes from commit b87b8f43afd5 ("ASoC: Intel: avs: Drop
superfluous stream decoupling") to restore working streaming during S3.

Fixes: b87b8f43afd5 ("ASoC: Intel: avs: Drop superfluous stream decoupling")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240405090929.1184068-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 2cafbc392cdbe..72f1bc3b7b1fe 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -356,6 +356,7 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 					   stream_info->sig_bits);
 	format_val = snd_hdac_stream_format(runtime->channels, bits, runtime->rate);
 
+	snd_hdac_ext_stream_decouple(bus, link_stream, true);
 	snd_hdac_ext_stream_reset(link_stream);
 	snd_hdac_ext_stream_setup(link_stream, format_val);
 
@@ -611,6 +612,7 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	struct avs_dev *adev = to_avs_dev(dai->dev);
 	struct hdac_ext_stream *host_stream;
 	unsigned int format_val;
+	struct hdac_bus *bus;
 	unsigned int bits;
 	int ret;
 
@@ -620,6 +622,8 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
 
+	bus = hdac_stream(host_stream)->bus;
+	snd_hdac_ext_stream_decouple(bus, data->host_stream, true);
 	snd_hdac_stream_reset(hdac_stream(host_stream));
 
 	stream_info = snd_soc_dai_get_pcm_stream(dai, substream->stream);
-- 
2.43.0



