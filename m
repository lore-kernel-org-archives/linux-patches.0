Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EDD4EBAC6;
	Wed, 23 Sep 2026 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173304; cv=none; b=CIoPPClgisoQxjLIZsrnYzezIc1Z/YVXlbKeFmdWaawguWwnaWruHx1arGf50b8qEt2nVdhj7eUF3nP3HUeoFG8qe45KFHd1JVsfp73bblg7PIpC3z9EHX3kampbXGKzl2rjmoWOrOEpVXY/hoA5D2Exwu1Cm7cQLcmfsRNLE1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173304; c=relaxed/simple;
	bh=xsQZNjCWkTfKuzZ2aeWgOSP4OiCMTXsHzR5cPm3k2xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyJ5OOmWF1R1KmS+O5F7Uuw73sZ3kPt4QcKZaXjz16pVIQVxctriMZmFKEzytzP4FD8kCHBxNQAMOw3qVFAyoXCTSTmkBRkjA7kPF6QeRo0WASpyT/8Ih23JVlyyaWdnXcc1OIMLu7z3Txj2Wk9ewADpaP93bGcpKPffP/lplok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBlgrd4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBlgrd4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BE21F000FF;
	Wed, 23 Sep 2026 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173303;
	bh=cjt/fSHDrbkFcFsyM07U+3JGvDRxDZV2ipI/mrSm4qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBlgrd4rLSqFJvC7mqtVU3uMkyzsK8f3d3hBE8JVn0vZ6uSjk3Q5fen6UPdziYs9Y
	 CkxJCQrLYXbSRbq8jSOSZtzy8ntkciw1MHYtU/jE0kFUhPFd1DXUvawZDsZ4XsRzq6
	 Eef9SHLYLn6BjkBc2TJ3j/GswY3yhupdPy3UIL3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 204/438] ASoC: amd: acp: fix ffs() operator precedence for SoundWire link ID
Date: Wed, 23 Sep 2026 16:03:45 +0200
Message-ID: <20260923140650.050683341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 27098aaf28b96ab4e6891709062c343566d4882b ]

ffs(link_mask - 1) computes ffs on (link_mask - 1) instead of
subtracting 1 from the result of ffs(link_mask). For a typical
power-of-2 link_mask this returns the wrong link ID, causing cpu_pin_id
lookup to select the incorrect SoundWire manager.

Fix the operator precedence to ffs(link_mask) - 1 in both
acp-sdw-sof-mach.c and acp-sdw-legacy-mach.c.

Fixes: 6d8348ddc56e ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260910161728.1452808-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 4 ++--
 sound/soc/amd/acp/acp-sdw-sof-mach.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index fa31bb848d9df..9e3d5d3ed1d75 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -217,7 +217,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 
 		switch (amd_ctx->acp_rev) {
 		case ACP63_PCI_REV:
-			ret = get_acp63_cpu_pin_id(ffs(soc_end->link_mask - 1),
+			ret = get_acp63_cpu_pin_id(ffs(soc_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
@@ -225,7 +225,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		case ACP70_PCI_REV:
 		case ACP71_PCI_REV:
 		case ACP72_PCI_REV:
-			ret = get_acp70_cpu_pin_id(ffs(soc_end->link_mask - 1),
+			ret = get_acp70_cpu_pin_id(ffs(soc_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index f58ef8953dbc2..13885ca20168b 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -132,7 +132,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		}
 		switch (amd_ctx->acp_rev) {
 		case ACP63_PCI_REV:
-			ret = get_acp63_cpu_pin_id(ffs(sof_end->link_mask - 1),
+			ret = get_acp63_cpu_pin_id(ffs(sof_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
@@ -140,7 +140,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		case ACP70_PCI_REV:
 		case ACP71_PCI_REV:
 		case ACP72_PCI_REV:
-			ret = get_acp70_cpu_pin_id(ffs(sof_end->link_mask - 1),
+			ret = get_acp70_cpu_pin_id(ffs(sof_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
-- 
2.53.0



