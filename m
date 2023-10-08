Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C5DC8DE
	for <patches@lists.linux.dev>; Sun,  8 Oct 2023 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dD3bFjzy"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5041cc983f9so4384496e87.3
        for <patches@lists.linux.dev>; Sun, 08 Oct 2023 07:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696773688; x=1697378488; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFG+HbWkCL5q3sRytHz2EUARFUhHTNpTPTS/2TGCkYs=;
        b=dD3bFjzyBDe/IqkfxjYfngIyJ1a3LO0DTrDasvvdtYbcCJrThQp9nC0pUWCZX88Knd
         XlHW7uHTMSwpDR8ULm2Yj3unN1StUN3rbiZlxcy3E4FmwqEsDPbmOuxAH7n6SKitrmx3
         JNRW1pid15I3meOPYO1DYw5WkeonQMgUW28A4yu52wbJens6KFkX0LkthzwlF5gFshtk
         3OvjVe51fazapxsXpKpV7KvEW50QmSDZg+VE+vcVgR835AImlv43ZjUtvxVcQDtCdw/M
         FtT12SPjnWqaXXAIrjeIInSZtvSrMiC/l1Hh3QCV/wtkr6tKulxh/5VepmIBFD8zpxGj
         OZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696773688; x=1697378488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFG+HbWkCL5q3sRytHz2EUARFUhHTNpTPTS/2TGCkYs=;
        b=JLGVvA3RsCCFExYzPH8FQVtpgduF1tytTqmAh+cv61YCWMEjV3L2gBPQHbIgiAgmfg
         CGRIUqU00YVt4pSQnhaJoR9ElwhmMQhahv/R+UGK/99WAFTeian56JrFEGKFc1n7A2Mr
         ssBrkKtAvI9sDMdubKLh0JGUm/7uTGRMWws7Bpzo8Wq3Fp+rTUeWazlYD459hAog5vxi
         sAMKSSdezvllidFnXTIFxJ7mHDczIUH6ilfePkR9eOQehYwIQx0/RkpZvhm2Mxc1CrO/
         CjnMyYO6q8h4bEWvl9qZb5vyoonGwXN+GF/U6auVCQaDQ73qpyjPcG/KJwrJWbzYFQ6q
         jKAw==
X-Gm-Message-State: AOJu0YxiPTXufFZJ+elmLdSgwSVvttywBaU40d8iIP24GIvXIQUIEDc8
	6hGyfRoD0QHEjspxTP3/zBzQaQ==
X-Google-Smtp-Source: AGHT+IF9SR2eKmWzelixific7kPQBmMahRChh7MHMDUtBo/o+iJKla32qvo/C/wtuhmKyiBSevln/w==
X-Received: by 2002:a05:6512:31d0:b0:4ff:a04c:8a5b with SMTP id j16-20020a05651231d000b004ffa04c8a5bmr13427692lfe.47.1696773688103;
        Sun, 08 Oct 2023 07:01:28 -0700 (PDT)
Received: from umbar.unikie.fi ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id q14-20020ac24a6e000000b00504211d2a73sm1080455lfp.230.2023.10.08.07.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Oct 2023 07:01:27 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org
Subject: Re: [PATCH 0/2] drm/msm/dp: More DPCD cleanups
Date: Sun,  8 Oct 2023 17:01:19 +0300
Message-Id: <169677306905.2570646.16231496941138431299.b4-ty@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230906181226.2198441-1-swboyd@chromium.org>
References: <20230906181226.2198441-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 06 Sep 2023 11:12:24 -0700, Stephen Boyd wrote:
> This is a follow-on to this series[1]. I can resend the whole pile if
> desired.
> 
> [1] https://lore.kernel.org/r/20230829184735.2841739-1-swboyd@chromium.org
> 
> Stephen Boyd (2):
>   drm/msm/dp: Inline dp_display_is_sink_count_zero()
>   drm/msm/dp: Remove error message when downstream port not connected
> 
> [...]

Applied, thanks!

[1/2] drm/msm/dp: Inline dp_display_is_sink_count_zero()
      https://gitlab.freedesktop.org/lumag/msm/-/commit/fb48250ca919
[2/2] drm/msm/dp: Remove error message when downstream port not connected
      https://gitlab.freedesktop.org/lumag/msm/-/commit/e117fd68f973

Best regards,
-- 
Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
