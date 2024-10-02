Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2122F1D173F;
	Wed,  2 Oct 2024 14:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879434; cv=none; b=JS1vsUD7c7YV04+6yzcPxb7Ob/iKNi8ojc/WfyWlDb0Zm0MrhJ18jtez5/KYxVsCp7epK/OmE3WVAvrzY+rObWgpwK8qeZGIeSDo2ONsp3SGWXFh0WsTGfX1Ba2jW1fdSqC7IjmGvldIz5ar3zTNy5OOdTGxULEEG0AV+YmCz9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879434; c=relaxed/simple;
	bh=astyGdODtYBNQrnr0PJ2K8kCCUjpXgYc4Z4QwPk2iSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWwmNREO64Y0lBmdl3qU1QnZVDmfZkCTsPSparwuc054EtNsfPAp1Y56yH6s+Ny4YJ2VclRGWWy1ViMeVJ9P1v3EHii9gyI4M1YuopgIel3BsSxTDnVQkzlEGvzBDwWMVOnYtPTiEKXF1uQeLOFu7KR4h0PIBc5ygvw1CAHx4t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1GAZsNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1GAZsNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF72C4CEC2;
	Wed,  2 Oct 2024 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879434;
	bh=astyGdODtYBNQrnr0PJ2K8kCCUjpXgYc4Z4QwPk2iSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1GAZsNuUU7EeO0BT/FWOsX2k57GgVJuG0GA0fACNc8azuWcxeGpcqWWf7gJywVBf
	 tpXgdYW1KNN+j9Ig3K46IqcwDDChK8rpV+H+aj2b4ICfoRqfI9jjZg8CkVMJNmEBRM
	 /pQ6RMTTHqN8dbCiWWQ6AU9gYbk2WSgqZkxolPsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/538] ALSA: hda: cs35l41: fix module autoloading
Date: Wed,  2 Oct 2024 14:55:56 +0200
Message-ID: <20241002125756.864761464@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit 48f1434a4632c7da1a6a94e159512ebddbe13392 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from spi_device_id table.

Fixes: 7b2f3eb492da ("ALSA: hda: cs35l41: Add support for CS35L41 in HDA systems")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Link: https://patch.msgid.link/20240815091312.757139-1-liuyuntao12@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda_spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/cs35l41_hda_spi.c b/sound/pci/hda/cs35l41_hda_spi.c
index eb287aa5f7825..d95954ce55d81 100644
--- a/sound/pci/hda/cs35l41_hda_spi.c
+++ b/sound/pci/hda/cs35l41_hda_spi.c
@@ -38,6 +38,7 @@ static const struct spi_device_id cs35l41_hda_spi_id[] = {
 	{ "cs35l41-hda", 0 },
 	{}
 };
+MODULE_DEVICE_TABLE(spi, cs35l41_hda_spi_id);
 
 static const struct acpi_device_id cs35l41_acpi_hda_match[] = {
 	{ "CSC3551", 0 },
-- 
2.43.0



