Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9AF331220;
	Wed, 20 May 2026 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300426; cv=none; b=EkMuES1AjbBxEeylHtv2qkEPMk8FAZzm8iRuHhJde/q+w2kk0HgmcCS3wmH5KY9rLdO46U/UUzMPI4o3eB2Xki5j7TUQvBD5tCsUkz7xLLm8Iw6HpLhU4wwubvGEIlqXFmeRppCHXANC1zaVlep5UXWMbg0aPfu30qhIJAQHJ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300426; c=relaxed/simple;
	bh=G0ttr6sph585/H5ALdAlRYWr0m1Qn8z87cyLMQZHyz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7rP3p3i9wrD78yIfRpPnk7jrBMsnGYIZqW09/P7ptTo7YTSNsIPQ8Ln6n3fVEgK6FclqvrlvDXEmvlpoj6K0CId0AdjI+fIZcVLpwmFB16QRdhBRcat71faK8kVbiHwdc1hqXMpRyDtBh7V/zA5P5Iog9bNuMS7+v/jxT9CHNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8lsGh3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8lsGh3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9113C1F000E9;
	Wed, 20 May 2026 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300425;
	bh=jMgY1cGEvZ4Suz03RLADJHlnmgC2HaPG3apLtUiOj6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8lsGh3WUd8uleE2wOQGrH9hsYg3RhuU4YK4oEZvhOngU7tI28i7xQ7bTbetnZ7pv
	 BS2O5SWtloBA6ikzOCLNKHdefsODXh0y0f7fTuQkl4Wuq4jVDTvDPGAp/yP3AJginb
	 GKMuuoW9oFzkdocOy0tai7iEmaTfClsh7IjMSH9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/666] ASoC: SOF: ipc3: Use standard dev_dbg API
Date: Wed, 20 May 2026 18:15:30 +0200
Message-ID: <20260520162113.797102020@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit 55c39835ee0ef94593a78f6ea808138d476f3b81 ]

Use standard dev_dbg API because it gives better debugging
information and allows dynamic control of prints.

Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20240926090252.106040-1-daniel.baluta@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 07c774dd64ba ("ASoC: soc-compress: use function to clear symmetric params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc3.c b/sound/soc/sof/ipc3.c
index 83c22d4a48304..7de5e3d285e73 100644
--- a/sound/soc/sof/ipc3.c
+++ b/sound/soc/sof/ipc3.c
@@ -226,7 +226,7 @@ static inline void ipc3_log_header(struct device *dev, u8 *text, u32 cmd)
 static void sof_ipc3_dump_payload(struct snd_sof_dev *sdev,
 				  void *ipc_data, size_t size)
 {
-	printk(KERN_DEBUG "Size of payload following the header: %zu\n", size);
+	dev_dbg(sdev->dev, "Size of payload following the header: %zu\n", size);
 	print_hex_dump_debug("Message payload: ", DUMP_PREFIX_OFFSET,
 			     16, 4, ipc_data, size, false);
 }
-- 
2.53.0



