Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F8A2141B3;
	Tue, 12 Nov 2024 10:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407770; cv=none; b=cbSTqfFVNnFd73Tm2yDLjyr1v+z1rUBmRdLSoyK1kZygawJ9XsboUiVUd4Cwlxmzsd+xeijZ43D5kyxFH/pNKfFX3Ptvs3AOGoQFaYqKCcqh5y9vJ5AXvlJXFCY4qaPFwHI/tcr4TsnV7iFBV/eql/bhOF+WQu/W2ViTRedDk24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407770; c=relaxed/simple;
	bh=bpltndSOcXnJY6Y54QHfpIB2/p9+VuX0huBlgHKNUHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAaS0Y3rEwZE6vGXm7y6OXFzZtgxKr+r7Ex6/6VNZlPiTcoa3uS8gIvjXhIX7OHnTdHCXe5RfuxwAK+E1F7hMmXhY9cM52ZDibRrJUT1nqp9sgzbX+LH8ivIYzwru3cxPaZU2t33/HJhyH5yc0rhad2N2KP0H10+eDUIarXVcOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRv/jup/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRv/jup/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B9BC4CED6;
	Tue, 12 Nov 2024 10:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407770;
	bh=bpltndSOcXnJY6Y54QHfpIB2/p9+VuX0huBlgHKNUHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRv/jup/EC+ZL6mhVETvRBx32apHjPDAgiMiVq5+vC6espDXyNtI9B5gFjOVPNMs4
	 Nkbd49WDW6jHTFp2p1uQ97oxp2/yFi823fpmbmNswdKuM2POtJsjvE/9+8deXik5am
	 O0i8Lx7OcZ1wzxsDz2HnmK00fxT97TYRtmhBLh0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jyri Sarha <jyri.sarha@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/119] ASoC: SOF: sof-client-probes-ipc4: Set param_size extension bits
Date: Tue, 12 Nov 2024 11:21:08 +0100
Message-ID: <20241112101851.008668021@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jyri Sarha <jyri.sarha@linux.intel.com>

[ Upstream commit 48b86532c10128cf50c854a90c2d5b1410f4012d ]

Write the size of the optional payload of SOF_IPC4_MOD_INIT_INSTANCE
message to extension param_size-bits.

The previous IPC4 version does not set these bits that should indicate
the size of the optional payload (struct sof_ipc4_probe_cfg). The old
firmware side component code works well without these bits, but when
the probes are converted to use the generic module API, this does not
work anymore.

Fixes: f5623593060f ("ASoC: SOF: IPC4: probes: Implement IPC4 ops for probes client device")
Signed-off-by: Jyri Sarha <jyri.sarha@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20241107132840.17386-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-client-probes-ipc4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/sof-client-probes-ipc4.c b/sound/soc/sof/sof-client-probes-ipc4.c
index c56a85854d92c..07bb143823d77 100644
--- a/sound/soc/sof/sof-client-probes-ipc4.c
+++ b/sound/soc/sof/sof-client-probes-ipc4.c
@@ -125,6 +125,7 @@ static int ipc4_probes_init(struct sof_client_dev *cdev, u32 stream_tag,
 	msg.primary |= SOF_IPC4_MSG_TARGET(SOF_IPC4_MODULE_MSG);
 	msg.extension = SOF_IPC4_MOD_EXT_DST_MOD_INSTANCE(INVALID_PIPELINE_ID);
 	msg.extension |= SOF_IPC4_MOD_EXT_CORE_ID(0);
+	msg.extension |= SOF_IPC4_MOD_EXT_PARAM_SIZE(sizeof(cfg) / sizeof(uint32_t));
 
 	msg.data_size = sizeof(cfg);
 	msg.data_ptr = &cfg;
-- 
2.43.0



