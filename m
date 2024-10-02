Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91CE1D0DE1;
	Wed,  2 Oct 2024 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877654; cv=none; b=Ptht7YrKyjMXPzaITiTqje3nTwC3vDEDupoibdBRG2WzSmerId6rXVvjPYJPx5KzK4tK0uhnbfFh0SzEsFNTpEea2tySNTtobj8Guz96/tGe1fa1B7zAMBX2syDv0pOG3N+4QmurRX9npqBhs+GORJfLFj4OmjiGhUODqANF34w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877654; c=relaxed/simple;
	bh=Auul3T/2fuOTnks+6mC7qSyvHRfbVe4VXFDqCbb2Ia4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNVbtKN78PTKBrB/VTO4HFUT/wWdAFrahjghWXfRvCyNXD3+PXQkM40DA5ImQPe6gfH190LLhLtpesfE3fb8Wmtvab1ovBvlJHg7Sk7jYKEmiJWwM/TJo3uLo9+wq+ZtNo3F8MYi8YgezjNoQ+LZ5Hex+211Y8L3k+z6lrGwwFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuUc1NKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuUc1NKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEEBC4CEC2;
	Wed,  2 Oct 2024 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877654;
	bh=Auul3T/2fuOTnks+6mC7qSyvHRfbVe4VXFDqCbb2Ia4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuUc1NKXvlE+ik9cy3AxOSI+LPEVbDGFQ5OsD1MH5vngWSQrol1VOwoBPgKS61k58
	 h76BAcJeV8dpgq+FURACXsJxFyy1eNJs1bcA3H60TK1Y97BvkPeE2Sk2NkRKo4H108
	 WuDk7sbCmRTcOndXZTIlhnuOfCkRJ8IVzonaCN6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 149/634] ALSA: hda: cs35l41: fix module autoloading
Date: Wed,  2 Oct 2024 14:54:09 +0200
Message-ID: <20241002125816.992397136@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b76c0dfd5fefc..f8c356ad0d340 100644
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



