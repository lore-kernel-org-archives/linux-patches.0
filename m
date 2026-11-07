Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064711;
	b=ZepOthmB89tqqwiHy/uZ8uDm790U05/6fskbiZOJEQkPelTevNlEXfdklN7mbB6VupX1
	 Z9jpnQtXwTj81AEvSU8mW8I+QUM5fXyJ3WzcAPwsKPOfXIGkt7uQohU31G6iBbvOwjMzK
	 5khbfKX8o7cBThF9NGCzjehw/XJlIRr2sZuxsGEnk5qsfBm6Cmsnt5bO3pOviK6lcH6B/
	 9HhXfg64yuewj4jc4hXxnmaZ7lo8S8L4Q3obES2pBE4f8ysortyZ/wAvOW2CegwAMJ+ti
	 JkyLGb2iue/JnMU8arPX7ja7UparYN+/MbUwaxJXURRR4Qi7UiIxwhzY9SbGasU0IyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yOZiKaTd+gagVh4GfQ50ZiCAH+gU7f7iYGJHBWVAtfU=;
	b=vlsr6kyWxz6ObSIT9jWT/fa3li3M9PtPbWy91iPFT3S6iICvmkjcbBGGqB6Nv9BbJQT6
	 +fQajejU2uaH7SbPcDBiG0605ojy8iSs82KstuguneguyRG8yIsgYktKwusQOaflTXiKN
	 49sCgU6Bf3XM2ZynlJzjPK8vnJV/sMWU0Q3aWIyBIoOaF8MFVkOfv2I86WToFAlvsZsgS
	 RU5PyGIDtt69NqRGS7smE2jszQ0wZ6qYlMuSaBwxNzqLsjInkGwFBY7cLbeVz3gv59ZMC
	 ai0lz3yhGf5ns55kMlOOGlqlIPXj0xGAzJ2A32OFhq26qa2OpSeej/C+p0g7LM5Iqxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVxwwzEQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D5F606A32E;
	Sat,  7 Nov 2026 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVxwwzEQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CD01F008A1;
	Sat,  7 Nov 2026 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064710;
	bh=yOZiKaTd+gagVh4GfQ50ZiCAH+gU7f7iYGJHBWVAtfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVxwwzEQQ5fbKgO/0NUvOQrNonceUpRvxSwu4DuPdu7FrhV3baAPmDYLN+XqzrVUX
	 KAohYdAiZhc50Crx/ACsq6CkhLNS73A2lyNlLQ+dnLptZkkA5aZYPa5S8qymRhUADJ
	 UvtuVTHf6e1c4msl0De0yPh1z5uJrsujlopvs8B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0668/1257] platform/x86/amd/pmf: Validate the APTS state index
Date: Sat,  7 Nov 2026 08:49:24 -0500
Message-ID: <20261107134957.703441135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 192dddd5aa45166450820cef16521bdf23976a73 ]

The static slider APTS state index is supplied by the BIOS as an 8-bit
value, but apts_config_store contains only APTS_MAX_STATES entries. An
invalid firmware value can therefore cause amd_pmf_update_slider_v2() to
read beyond the end of the array.

Validate the selected index before applying the slider values and return
an error when it is out of range.

Fixes: 8362e862fb87 ("platform/x86/amd/pmf: Update sps power thermals according to the platform-profiles")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260903182927.3556274-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/sps.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/sps.c b/drivers/platform/x86/amd/pmf/sps.c
index 0b70a5153f465..0918fb388fde6 100644
--- a/drivers/platform/x86/amd/pmf/sps.c
+++ b/drivers/platform/x86/amd/pmf/sps.c
@@ -248,20 +248,24 @@ static int amd_pmf_update_sps_power_limits_v2(struct amd_pmf_dev *pdev, int pwr_
 	switch (pwr_mode) {
 	case POWER_MODE_PERFORMANCE:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BEST_PERFORMANCE];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	case POWER_MODE_BALANCED_POWER:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BALANCED];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	case POWER_MODE_POWER_SAVER:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BEST_POWER_EFFICIENCY];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (index >= APTS_MAX_STATES) {
+		dev_err(pdev->dev, "Invalid APTS index: %d\n", index);
+		return -EINVAL;
+	}
+
+	amd_pmf_update_slider_v2(pdev, index);
+
 	return 0;
 }
 
-- 
2.53.0



