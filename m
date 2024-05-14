Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31CF54903;
	Tue, 14 May 2024 11:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684611; cv=none; b=pGMTX4HO+Bxr0werpjAVGkFpgSjJ+AW33+a3HefUAbofExCGixLCHcSHXo4S3FnUzDueLL2p+tTr0dnOwR8RdQDHVMwcxYgYJLBSSonJcZurN5nFbPp84PhDFM0993zw6zKYCEPDbLVUaG/yhOs98MYph1/ECy7o7iuvTmMj4b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684611; c=relaxed/simple;
	bh=n78LNEiO5tI3lyaawOPoa+TYJWHTCwMSueNsafi0CYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sRYzlk+tnbHfBL8+NkT//DIBeCoVZR2zTqPEbg+VM8WXht/6tCbbxdsbMT7+FdThfOovDoIP1+edjXsSruvk9Eh+rIoAKtwiGz0pXVIikCXpDeFScu8FYSMhmtNCzQpVpiNrpArzOd3mJPi0EA2YvexTtm6uD9USGJqIp37gZaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5MzxVxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5MzxVxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9359FC2BD10;
	Tue, 14 May 2024 11:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684611;
	bh=n78LNEiO5tI3lyaawOPoa+TYJWHTCwMSueNsafi0CYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5MzxVxYs5fwZeEuPVtTT+/BW1WEJ8wkoy5ao8ufemo3oQSttZA19K62lXra3Sa/+
	 ghkpCuTRd/730lCDLhB+fh495f4vb2kOl0kZ1eAy3Z3em0X5B4IZEEFGfcHq6A7kLL
	 Fn67Jr5h7u6H3FolyfswQTQNSa87xtG8J/qePW4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/301] ASoC: SOF: Intel: add default firmware library path for LNL
Date: Tue, 14 May 2024 12:15:03 +0200
Message-ID: <20240514101033.459746884@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 305539a25a1c9929b058381aac6104bd939c0fee ]

The commit cd6f2a2e6346 ("ASoC: SOF: Intel: Set the default firmware
library path for IPC4") added the default_lib_path field for all
platforms, but this was missed when LunarLake was later introduced.

Fixes: 64a63d9914a5 ("ASoC: SOF: Intel: LNL: Add support for Lunarlake platform")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://msgid.link/r/20240408194147.28919-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-lnl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/intel/pci-lnl.c b/sound/soc/sof/intel/pci-lnl.c
index 1b12c280edb46..7ad7aa3c3461b 100644
--- a/sound/soc/sof/intel/pci-lnl.c
+++ b/sound/soc/sof/intel/pci-lnl.c
@@ -35,6 +35,9 @@ static const struct sof_dev_desc lnl_desc = {
 	.default_fw_path = {
 		[SOF_INTEL_IPC4] = "intel/sof-ipc4/lnl",
 	},
+	.default_lib_path = {
+		[SOF_IPC_TYPE_4] = "intel/sof-ipc4-lib/lnl",
+	},
 	.default_tplg_path = {
 		[SOF_INTEL_IPC4] = "intel/sof-ace-tplg",
 	},
-- 
2.43.0



