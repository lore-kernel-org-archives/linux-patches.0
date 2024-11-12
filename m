Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CA2212F00;
	Tue, 12 Nov 2024 10:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408145; cv=none; b=aZKNdZNGofFfTJJy7rqdZP4mnOuHn6DvyCIu0WVlGHK1fYnsCCnVGWAly0TuvIlUAqlNtvdtjAaiPdVEWD6IjoAk+OsC0J8OFVjpQsiLWdjNoTBjthUqYG3VT8ZC7CTrX2b825vrbWH76iBz9dsbUA9R3oaHXP8UQsvInEEYTCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408145; c=relaxed/simple;
	bh=t2ZpYIBq91YuG34TtUslOheSHMjPAPfMdOutRYMhVdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtKUt12GyMDspeSeDWUKTmJD7TCYB8uYmPgrjRsMTqzK3CfsZNPEphMMOt9RSt98kRZtLFnjkpdU81kecudNgKBcmefZ3m5iUBW8UVRNOYoZikD01NHhBklWfZCqjG58HKvpKjHzulV3FlIL6jgeIiphgUAznq77AExtEBcWXNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSu/888R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSu/888R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A06EC4CECD;
	Tue, 12 Nov 2024 10:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408144;
	bh=t2ZpYIBq91YuG34TtUslOheSHMjPAPfMdOutRYMhVdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSu/888Rh2476cIrj7ecLteiGVacTszB51mF54ePXOYFlaYuTRjc4OBt3S+5+I9FM
	 Ocg5u1JH4/C5QeoJmxzg4BNFhc3RULtUqs0JLrDCQNksQ+aUeSRB7NQNMbSZuRn+DW
	 g/Iv5euwkVJTD/M2eQRI+hs//x279CfAvyixkXPw=
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
Subject: [PATCH 6.11 074/184] ASoC: SOF: sof-client-probes-ipc4: Set param_size extension bits
Date: Tue, 12 Nov 2024 11:20:32 +0100
Message-ID: <20241112101903.702808908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 796eac0a2e74f..603aed222480f 100644
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



