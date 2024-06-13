Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2B9143884;
	Thu, 13 Jun 2024 11:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279608; cv=none; b=ZHGQRY1ZrWuSOXCcrnI5NMKkdVwADDp9/Y4aHx0gNqVobSibGrXSSjaPq2urmtW2JSYDVDSxzMLC17XjfM3SzAo/PsGjbEoqntqhynkEXia707/n2ul6sQy70HXfvFD3MhB+LYdEOAv8dayo1MhdnR+2ZdXU1iVOHprro2nao0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279608; c=relaxed/simple;
	bh=vXN0LsKshKSzSYaldfXFtByiyGzPietc7pDJC04vdqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCZ+Pv1Cdd/LR/esQ7ySdQ+xO38HDQSN4KgKKjrWdni9R4dD8VqZGyhtOhNUvpldW0tO5+U+lJNMHpPH4hlA1PhYs6m3Gkcubeg5Rk1Jb3rEn63FLv6W0KRWv0kqRbrR0vPLGEuYLfixWAWgucxjxatLGNQM6muSzeVHm0NRoJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4kO0nww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4kO0nww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75348C2BBFC;
	Thu, 13 Jun 2024 11:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279607;
	bh=vXN0LsKshKSzSYaldfXFtByiyGzPietc7pDJC04vdqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4kO0nwwjePw1A+WfjGx0lRvTNcSC4VT2eFNVATiXs1oUjDPioO94QBmUCVNguXnd
	 OrnZS3qLGF9rtMk7kfNQwrn3tsfaOTmlSwBN09WXyIFIz2H9KGEZBzzh00jzhzusKN
	 kkB3t3KfezzMWc2Eopzrfi0Uy19lqr288/iw9djw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.9 134/157] ASoC: SOF: ipc4-topology: Fix input format query of process modules without base extension
Date: Thu, 13 Jun 2024 13:34:19 +0200
Message-ID: <20240613113232.589706347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

commit ffa077b2f6ad124ec3d23fbddc5e4b0ff2647af8 upstream.

If a process module does not have base config extension then the same
format applies to all of it's inputs and the process->base_config_ext is
NULL, causing NULL dereference when specifically crafted topology and
sequences used.

Fixes: 648fea128476 ("ASoC: SOF: ipc4-topology: set copier output format for process module")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://msgid.link/r/20240529121201.14687-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -217,6 +217,14 @@ sof_ipc4_get_input_pin_audio_fmt(struct
 	}
 
 	process = swidget->private;
+
+	/*
+	 * For process modules without base config extension, base module config
+	 * format is used for all input pins
+	 */
+	if (process->init_config != SOF_IPC4_MODULE_INIT_CONFIG_TYPE_BASE_CFG_WITH_EXT)
+		return &process->base_config.audio_fmt;
+
 	base_cfg_ext = process->base_config_ext;
 
 	/*


