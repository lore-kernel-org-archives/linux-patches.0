Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2647F259B
	for <patches@lists.linux.dev>; Wed,  4 May 2022 17:21:31 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id n24so1817895oie.12
        for <patches@lists.linux.dev>; Wed, 04 May 2022 10:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wGaNEgkga2C3vR38cQjxSl3nf4BfaDAQqYW9Vv/BBTc=;
        b=PEfoXor+JdsqfPlN+A3GqSST7jD5o0bcF7nggWSaH6F54b6L4ub2nPZsEEL0/L8je6
         L4JS9CJXWZsNNZdMhgBhz8n/d1YQjBCcUoikb8NTH6h1ofErB23tOgwNHxn5sNy9bd4g
         ntydlC27R1G0Q0xUUUXK4+0O7HIoYEPFZkFa8VglaiHOo+ojUHG41As2Q925/PPtwt8C
         6iuIXGAuAWlSWr/laNZFzGfJAnj1iKhjkKwrm3tE7kBS4LgCeeJHHUMtWl70k+08eHIy
         qMJvomyu/rTkI/PjGmFUaHuimmIVCIwk6c3fZpoGkteqD/ynqbLr1fDQq2tqvz3Klae9
         nevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wGaNEgkga2C3vR38cQjxSl3nf4BfaDAQqYW9Vv/BBTc=;
        b=AIdzwuLMK7eGbQPzUyNvc7CxYrlTh7JHD6C9GuCHC1b+M3PLxqq71kJZu5qE+TBMXJ
         Q03xopWskHVJCaNZArjzfX18FMIubq2jU9lDddjWD7nITVFQWdRRMW+vTDlB8bHeYGpH
         QRaEefimBTGvzuim4+3Mp4SttupE/NfF2sRFXjFRHpZgUjz7sVRIDl/yqRWvrUZi83dY
         ThXaR4ky4lE8inYHWXSRxAPoczddJU5UTW+2VzpgIGWZwvuSaM1QhUAg5FBNu9TCelbp
         qswh2Z6Wyr08M0GoKHZSZFbVe6I9Dc+DCF2ycwu2eKcxwvjP4mWSFxkv1LnJ2LUgPaU8
         b6lA==
X-Gm-Message-State: AOAM533FqiWB0R/HsmzznMLpjRJrYL51N1I04r9L47zya4g/qeXy8Zb1
	/XVXYHwaPKHXF9irnlODqUrDcQ==
X-Google-Smtp-Source: ABdhPJwa6dp2UBzeU6Egf+BrynvyfLaVErlWkcSLlDE67ay70zmXc3sc2mENXNU1OiQ9R77IHyoDJQ==
X-Received: by 2002:a05:6808:1646:b0:2f7:50ea:85f3 with SMTP id az6-20020a056808164600b002f750ea85f3mr242567oib.137.1651684890264;
        Wed, 04 May 2022 10:21:30 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a7-20020a056870b14700b000ead8b89484sm5785452oal.5.2022.05.04.10.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 10:21:29 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Alex Elder <elder@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Doug Anderson <dianders@chromium.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Mike Tipton <quic_mdtipton@quicinc.com>
Subject: Re: (subset) [PATCH 3/2] arm64: dts: qcom: sc7180: Remove ipa interconnect node
Date: Wed,  4 May 2022 12:21:14 -0500
Message-Id: <165168485226.3730817.11676742538463355486.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220415005828.1980055-1-swboyd@chromium.org>
References: <20220412220033.1273607-1-swboyd@chromium.org> <20220415005828.1980055-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 14 Apr 2022 17:58:26 -0700, Stephen Boyd wrote:
> This device node is unused now that we've removed the driver that
> consumed it in the kernel. Drop the unused node to save some space.
> 
> 

Applied, thanks!

[3/3] arm64: dts: qcom: sc7180: Remove ipa interconnect node
      commit: 067bc653b85e466048914c48e46659a50a907fa6

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
