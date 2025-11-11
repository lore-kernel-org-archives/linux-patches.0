Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CAF342CA9;
	Tue, 11 Nov 2025 01:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823553; cv=none; b=I5ZwZmG19hNndWBbbEZFlczZlRtDpG1udTUH+Me65TTY+ly6dAcPyN4KohPFIyw5hV7yk99+C8lysuZPhjlaV7+LWFvV2YvS3n1/fT+kXHlz7fpOc1wLjW55+N4ktEVj3KJRhmXUsEEjpzjfcyOdIq0DU10QhFjhJ3NgUSLRQAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823553; c=relaxed/simple;
	bh=MyZtydjstefYDgqRaQmj6SvhWx5OJZ6w0lWCYKnrCEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJMruMjM06xrNYOHP8S8gAfMYSelRNTS1KBJbFt+6VY0AoAHR5Ir6neycPDZo8jnuWDzVXIFbM6hUBVaIOY+jz0Eby4k7EsZq5gzcettney9GeNU/Y5xbMAM8IqH6Skf0OGNwugLxJHz2t7xoq6b+m6QxW91zZhMjlG0WOT2wqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqzXpqiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqzXpqiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81FDC116B1;
	Tue, 11 Nov 2025 01:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823553;
	bh=MyZtydjstefYDgqRaQmj6SvhWx5OJZ6w0lWCYKnrCEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqzXpqiSDhzncuaItgi/GtXefGJxRjOWIYr4JLokd5lj7tHlfzIU3sYKY3B7t1rcq
	 nCR3CePwHcjBYNCuCn2sfw56CN9UsvXYR5PDLIlZoTuWvmhMOAIr08bpQ9jhVz9g6c
	 0+n5weDqxMCEurScLPUqPAsf9SSdWx7P9LZdk2KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shimrra Shai <shimrrashai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 322/849] ASoC: es8323: remove DAC enablement write from es8323_probe
Date: Tue, 11 Nov 2025 09:38:12 +0900
Message-ID: <20251111004544.200323304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shimrra Shai <shimrrashai@gmail.com>

[ Upstream commit 33bc29123d26f7caa7d11f139e153e39104afc6c ]

Remove initialization of the DAC and mixer enablement bits from the
es8323_probe routine. This really should be handled by the DAPM
subsystem.

Signed-off-by: Shimrra Shai <shimrrashai@gmail.com>
Link: https://patch.msgid.link/20250815042023.115485-2-shimrrashai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8323.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/es8323.c b/sound/soc/codecs/es8323.c
index 70d348ff3b437..4c15fffda733c 100644
--- a/sound/soc/codecs/es8323.c
+++ b/sound/soc/codecs/es8323.c
@@ -632,7 +632,6 @@ static int es8323_probe(struct snd_soc_component *component)
 
 	snd_soc_component_write(component, ES8323_CONTROL2, 0x60);
 	snd_soc_component_write(component, ES8323_CHIPPOWER, 0x00);
-	snd_soc_component_write(component, ES8323_DACCONTROL17, 0xB8);
 
 	return 0;
 }
-- 
2.51.0



