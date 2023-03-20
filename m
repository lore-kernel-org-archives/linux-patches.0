Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8D41C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70513C433EF;
	Mon, 20 Mar 2023 15:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324859;
	bh=XTkQ/Vo9zTDOFJKJ2AD9jWdFyK3e6bJsM6weLEXyEeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYrBvm6Hh3AJ5pqHItcEuaUis+1cGik99N400i8Wl/OJirks4PQAZz03UrrLpn1Yj
	 xt36aEZars9rZP03HiF3D9HEX/tkIm2QBajgAx/Vi565iTAJHgqWO5O9Dzv+jtiF5z
	 CWdSjpGc0lxwyNbmZI9JpnqZWgVNZtsWZOP5cap4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Gongjun Song <gongjun.song@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 66/99] ALSA: hda: intel-dsp-config: add MTL PCI id
Date: Mon, 20 Mar 2023 15:54:44 +0100
Message-Id: <20230320145446.170321317@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit bbdf904b13a62bb8b1272d92a7dde082dff86fbb upstream.

Use SOF as default audio driver.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230306074101.3906707-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/intel-dsp-config.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -359,6 +359,15 @@ static const struct config_entry config_
 	},
 #endif
 
+/* Meteor Lake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_METEORLAKE)
+	/* Meteorlake-P */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x7e28,
+	},
+#endif
+
 };
 
 static const struct config_entry *snd_intel_dsp_find_config


