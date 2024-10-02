Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA56516F84F;
	Wed,  2 Oct 2024 13:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875625; cv=none; b=S5YUW71cScxJg7AsKL+h5YCstHT4+IV7fAGOkJ/q1fK44to8b51CcT5b2wmA6YcPZ3p5bXjbhb1lPpjEve5N8ZHMDhdGINWJ/qbb+rq7RWlCd7eliF1Fsqnq1F1W7U3vqWxlOYhzmPln4w/xzEQYAMcKqsCAuLoNEeNJoFJLID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875625; c=relaxed/simple;
	bh=Lb50mXujQb3xYWpkKrm+TQ+HSB9SbxSdRmPXWiWWzhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ha+hOL2p4XN8iAXUHoDcRgTasOK8J7hLhTqmBcvzetgroHM1nfYBLFxDBCZSjA0ijUbUXW1JfeeQkuiv6htgOKh8nsd6sp1pJpJlaEqj3zmSFfS/+9xev0hZDHkzNe4ClB4ZJAI6Z61nyc5Xs84e7DyV9q/a2749t5U+gdPQ5ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpG7YpFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpG7YpFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66161C4CEC5;
	Wed,  2 Oct 2024 13:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875625;
	bh=Lb50mXujQb3xYWpkKrm+TQ+HSB9SbxSdRmPXWiWWzhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpG7YpFxRs/Hugnn7z88ipyXAFbg6TjJBybzBr2kdQ4l0cg75qvOAEWQB/sEQaMvr
	 ccu6vr0Ua5s2AP90hydqUN80JamwLddQL5tQClaG43Lc2nNxDZnTBCNEdYpSm21h3h
	 AFmk4av4gL/TvDvwhL8MbO7V79wtFinwZwi71vPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 166/695] ALSA: hda: cs35l41: fix module autoloading
Date: Wed,  2 Oct 2024 14:52:44 +0200
Message-ID: <20241002125829.102840227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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



