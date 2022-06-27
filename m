Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DDF46BB
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 20:03:55 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-101e1a33fe3so14279026fac.11
        for <patches@lists.linux.dev>; Mon, 27 Jun 2022 13:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nzGLzW4ZtS4jruJMltFw2XA6BLWVzwJ4EyNXbTelzgY=;
        b=W46n2N5nMZBApIj8vLlHjyY8y5pHvjdBYst/vuLJ6sE2mEm/twshFceX/GX2LJ2EO6
         ZJg1wMNlOer2r28BRpqDp/m9acUrGJdmLSd8ZG6VW1x7yUDtmYgkuKfPVYhMbPOHOhQU
         +g2wO7u7B1msL7oiQkaYoXg5k0BRYSFj55oLVLqbuP5qF8cf4ZZu/wnC+7pBMK+m0A3o
         BXViuj4bPyhgHnmlCr/L73vdsvofW/xLDGkdcOyl5PawKk62u3Q9shQVpAwbm8koApa/
         vIO/Wjxo7G5lhUzwcZvWfeA+eHWQdZUZAlKjUUuhMxU+HUcr4Uw7wQqRM5R0IE3ctIXU
         10VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nzGLzW4ZtS4jruJMltFw2XA6BLWVzwJ4EyNXbTelzgY=;
        b=xL7QlAOCAYNcNJQyyYiSibk1w2pdtcIzRNer+c/LXzETyJA+0ICQ+Bzzxdv3wZGP/k
         AOP0n40JQxrOlGCEfGLLy+PhvjXAr8JljRWJ+jRMwOEe6ABek4JySlStC/MJ8pyIJ+5l
         BcEvgorAfYyvM0/v1k/VpJZCHBDLSQueYakHX78ZIuoTf1TsyHGBarv+mvBw1qxCib0P
         k2x1Q7OXcXAMUALHzYsKGhsMrLQCyQMeVmD2UoPrbUMFvCGHZgKIUE0mjU3lA8ywu/bm
         6+kvBeBaTRWgLK8ycw7dqPu/5Xy1Ifr9nIsOFl0sFdoVcH5trHUrUZdkUNREA1+67/Q5
         eEdA==
X-Gm-Message-State: AJIora9a+hwLqDiir6g1zEnk9CjtdFbacSqG9cRmS2zo7hOpzQAFKAh2
	ZifHiNgM8ha7otec9bMmSxKgbg==
X-Google-Smtp-Source: AGRyM1t/AoUXZf8AxsYnS9CJkUvmEW+W280zjqUJM2yNjTRfLf+/xFsMn1ZUA6a/oGOAOLqn72AcVw==
X-Received: by 2002:a05:6870:89a9:b0:101:d81d:e970 with SMTP id f41-20020a05687089a900b00101d81de970mr11368835oaq.43.1656360234143;
        Mon, 27 Jun 2022 13:03:54 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id m16-20020a4a9510000000b0041bdf977c6dsm6428729ooi.31.2022.06.27.13.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 13:03:52 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <sboyd@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <swboyd@chromium.org>
Cc: Alex Elder <elder@linaro.org>,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Taniya Das <quic_tdas@quicinc.com>,
	patches@lists.linux.dev,
	linux-clk@vger.kernel.org
Subject: Re: (subset) [PATCH] clk: qcom: rpmh: Add note about sleep/wake state for BCMs
Date: Mon, 27 Jun 2022 15:03:06 -0500
Message-Id: <165636016348.3080661.558126370799129810.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220517190949.2922197-1-swboyd@chromium.org>
References: <20220517190949.2922197-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 17 May 2022 12:09:49 -0700, Stephen Boyd wrote:
> The sleep/wake state doesn't need to be set here because of specific
> RPMh behavior that carries over the active state when sleep/wake state
> hasn't been modified. Add a note to the code so we aren't tempted to set
> the sleep/wake states.
> 
> 

Applied, thanks!

[1/1] clk: qcom: rpmh: Add note about sleep/wake state for BCMs
      commit: 29f66b625281a3026653fd33b710771a4ae394d2

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
