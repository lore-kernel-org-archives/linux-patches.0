Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AD62BB1B;
	Fri, 15 Nov 2024 06:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653276; cv=none; b=T0jQaKl2cgbcMEsE7f6wyF6h2YKr7aHNfPPVhuIgRvTf9YquJkPOUxCM4kpnWDXgWA5mVzw+YQ8WgOyIEUqt2rxzGDowLDTZtBUAuryndSNHTlkvJkbvBFLMqBRKokNnRby373C5lpSIbvWXQHUbrfKIo4hAB1iEpShAKKrIIa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653276; c=relaxed/simple;
	bh=2isIp9lXkCibkXHz3ULOCrIXnwtQ5COGOaKBV6ot6Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqNoXlwoO/zc33FirRunbSQ5GwNnK9vlXUs3UJpu6Hz1pQ8zyAYOPUQakwwz6jrz+MElvMoYqKK1sCaIRuFhMeUX28Ki1qpLmHUVwIhBy2bb98FNWrDmVoHXJ0f2B/l8zwuPc+s2+c/aZw7g3EkxSUwA5kYgQqqQ8dgGdoD4sCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB4AfJGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB4AfJGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84586C4CECF;
	Fri, 15 Nov 2024 06:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653275;
	bh=2isIp9lXkCibkXHz3ULOCrIXnwtQ5COGOaKBV6ot6Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TB4AfJGTt33qicGGrO5VEKXM22Re1kFNI0DZiP4FKY61cKERQwdZAY/NdRv1vGR53
	 mKMbwnXHwA01qyaayPDJMRQkt+AEFJEb6RyhxrIIGEXFffpYrq6W/TP8/WWl6rywOt
	 IHEhUUIQlh6f8CV2s62oaoepv5IvIrw0+3qO6jlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 39/63] ASoC: codecs: Fix error handling in aw_dev_get_dsp_status function
Date: Fri, 15 Nov 2024 07:38:02 +0100
Message-ID: <20241115063727.327002762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

[ Upstream commit 251ce34a446ef0e1d6acd65cf5947abd5d10b8b6 ]

Added proper error handling for register value check that
return -EPERM when register value does not meet expected condition

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Link: https://patch.msgid.link/20241009073938.7472-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/aw88399.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/aw88399.c b/sound/soc/codecs/aw88399.c
index 8dc2b8aa6832d..bba59885242d0 100644
--- a/sound/soc/codecs/aw88399.c
+++ b/sound/soc/codecs/aw88399.c
@@ -656,7 +656,7 @@ static int aw_dev_get_dsp_status(struct aw_device *aw_dev)
 	if (ret)
 		return ret;
 	if (!(reg_val & (~AW88399_WDT_CNT_MASK)))
-		ret = -EPERM;
+		return -EPERM;
 
 	return 0;
 }
-- 
2.43.0



