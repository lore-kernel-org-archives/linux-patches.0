Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D171EA65;
	Thu, 28 May 2026 20:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000111; cv=none; b=DiGXbBkpJ7OC7q9dVny7L5Ti4AGPyOjU5TXA5UU0mKgZaAHX7ycMCJogi7uC963JwywpOblrZ5NAGsMTVsOi4Nyh6O8i9YSWrMOUpANX03JDNdVZduvKCSo8M2FsG1smiiXLBDj4W7h0Tu2If5vEWsmrYedr5RDnPJQS/K6LMnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000111; c=relaxed/simple;
	bh=TG6mbm7SZIRnRLG8DEtuZDqWWGEwvkU1/ouQoHTd59o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LeQADL87JXZCslUPNRylpTQkFW+t0tmJt4runQPha9HTOg4bJkGutJFvcObAzjNBSI8+HS+QuZkN84I1tjIhBD2A0gwh/zbV4hbSHrgJ/owcQ1+CkUs3BJhUq7CveakHB1KVXPKe6hQTBSMwc+L7BzMazAuZ5Mr142bcIPspVtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3mXAU07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3mXAU07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987B81F000E9;
	Thu, 28 May 2026 20:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000110;
	bh=sz+QpVytAl3Y8HUTOEtJONAk4C042OzcejtE1HxLqZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3mXAU07jqVpom5w8NlbcUtsSMfXs+8YQZ5IOTxqu1bCyaimV0HBwDd3NTjsUTd+f
	 pNrQ6JO0g04bfEVsh1CWGKy8Hf6KVX/R9S8lzKHGOm5B9keXltZ+NjhSKXSELagLXy
	 e2za2gVbIcRRF+YUQ8/oNvcDUK57ad6qTarZREeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 305/377] ASoC: amd: acp-sdw-legacy: check CPU DAI name before logging
Date: Thu, 28 May 2026 21:49:03 +0200
Message-ID: <20260528194647.194815547@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 1afd8f06dcb1d561af3b239c5b14a88b87c13454 ]

devm_kasprintf() can fail and return NULL. The legacy AMD SoundWire
machine driver logs cpus->dai_name before checking the allocation result.

Move the debug print after the NULL check, matching the ordering used by
the SOF AMD SoundWire path after commit 5726b68473f7 ("ASoC: amd/sdw_utils:
avoid NULL deref when devm_kasprintf() fails").

Fixes: 2981d9b0789c ("ASoC: amd: acp: add soundwire machine driver for legacy stack")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260511-asoc-amd-acp-sdw-legacy-dai-name-null-v1-1-dc6151b6da8a@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 798c73d7e26de..e87d9e9991e1c 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -244,9 +244,9 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			cpus->dai_name = devm_kasprintf(dev, GFP_KERNEL,
 							"SDW%d Pin%d",
 							link_num, cpu_pin_id);
-			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 			if (!cpus->dai_name)
 				return -ENOMEM;
+			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 
 			codec_maps[j].cpu = 0;
 			codec_maps[j].codec = j;
-- 
2.53.0



