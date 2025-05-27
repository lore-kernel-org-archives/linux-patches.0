Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D801E25E3;
	Tue, 27 May 2025 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368056; cv=none; b=nZNKS5o+XsM3ca73CBUhn5hJgJT+KXrHJYZd9R1drCGV66FGPAwIz4+qsKNCOgzr4XYMtWXoIzAxlK/u7r4CHTpuX7dDnV8aRdKSZzY4uiVEHJR2LsMoC+PGmxe9uhZEjudrFaAItN7gL2+4Ms0WKhdcx9vk7TgQFlef4FEWvgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368056; c=relaxed/simple;
	bh=MpAjt/YLHN1vzS2QkgTUqXEpt7lrb3NakNWCH6RHyQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1B9/3evsy7cBssm1q5fupYyNURozvb9Xi3fXTx0yxqri489Y24sLOSIRxkXBqcMgBVnGzC/XWruUdQZ/Ds0tmgyU30ASUCu8o3bOv+h/K6tOcNK6ZmfiUPDazEsCBdFigPCyXl3jSO1jUN0ae0fxAY5Bz2kOSo+30SKnFDGUYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqTrWpxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqTrWpxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B6AC4CEE9;
	Tue, 27 May 2025 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368056;
	bh=MpAjt/YLHN1vzS2QkgTUqXEpt7lrb3NakNWCH6RHyQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqTrWpxE3xnSh6iN+jl0iQMijcRuul5DIWf6WLYnpYiWgV800wbFVR71tsSBbDULV
	 dDSSJxvXBzDfmLeRD9y/P22Ee4UrkSzjrYtB3gLJNYJ/1N0G6ThlubBNkPwH4I3ezI
	 t7HyOOpA7QwCrKeoLWoAJIkndPCosM70kPI+kQnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 585/783] ASoC: codecs: pcm3168a: Allow for 24-bit in provider mode
Date: Tue, 27 May 2025 18:26:22 +0200
Message-ID: <20250527162536.965127787@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 7d92a38d67e5d937b64b20aa4fd14451ee1772f3 ]

As per codec device specification, 24-bit is allowed in provider mode.
Update the code to reflect that.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250203141051.2361323-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index fac0617ab95b6..6cbb8d0535b02 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -493,9 +493,9 @@ static int pcm3168a_hw_params(struct snd_pcm_substream *substream,
 		}
 		break;
 	case 24:
-		if (provider_mode || (format == SND_SOC_DAIFMT_DSP_A) ||
-		    		     (format == SND_SOC_DAIFMT_DSP_B)) {
-			dev_err(component->dev, "24-bit slots not supported in provider mode, or consumer mode using DSP\n");
+		if (!provider_mode && ((format == SND_SOC_DAIFMT_DSP_A) ||
+				       (format == SND_SOC_DAIFMT_DSP_B))) {
+			dev_err(component->dev, "24-bit slots not supported in consumer mode using DSP\n");
 			return -EINVAL;
 		}
 		break;
-- 
2.39.5



