Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445D9259D
	for <patches@lists.linux.dev>; Wed,  4 May 2022 17:21:32 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-edeb6c3642so1852139fac.3
        for <patches@lists.linux.dev>; Wed, 04 May 2022 10:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9uwOGnLYMEJR/9HVxcO1OnuSImbrqYL22DFR4CN456k=;
        b=kh2l6tCUfmXum7Viz5IbpjauRsyWy+uzfTkiP9KgnsQUkleUr4A6KD0Fe7X4vR5x1q
         KWopCu6yA3HGBZ1PE+2F4ru5MRJ1n6Ok3T2dOwRAUhCAuTsUWJkXK5BaNTl3Tq65rE0l
         VYU/2pnMkejXlkY+VqA38ZOHgEFHNUZE3RmHfqHZrK3NsxP0UjoyatuSS8su+i7JpWzk
         igX6QrQfKxO6QOGU+j+f0JexMpSIDTjTDtKQoN2mmQ1iTM763De2ptE4Xl2Du1h9/d2b
         YkF7ck96I8jcVIYoiESssMp9/8J7WRJljX/RhdiLkF3U3LkZWufAE1Dquc2yF+iC2J8F
         Ocrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uwOGnLYMEJR/9HVxcO1OnuSImbrqYL22DFR4CN456k=;
        b=7si0FC+UMTF5jbyBX1pEbcVS9Ol6Tq9i/4uazrK6fgIYwnNFTj0Ms0eS84DoNy/Hws
         p9Qvlaefl9O4374iHMepeWniGcR3nmdTmGHtxcWxePXh7JyF44aJx4TD60OKyLQEk3Nt
         SVZHkSJc+hO6lIsCPuRs0qiB7xV5a3UUbfCVOE/3n22KbKJ9ulZjX0Ndx6OnC1z+/+Kc
         11wbixud5MNzlKol948KoJc45biYzKoWkXoJcy8ph9v5GV8DJf+4I7UsiwSva1bmYcGf
         eD2h0jHMSEHpa4ZLJMB/QjQ/ed/e9FLlsYFkOZjuar2qat0mdVrt/Hlwj0bTWFpzzve/
         wckw==
X-Gm-Message-State: AOAM532wHn3GaNitWaxwH9RU7gXOOAPSKiHd8sMnq5sKz7VEDC3zsK3K
	zCtq02xLZq+6T7+C3+Lr+cqRew==
X-Google-Smtp-Source: ABdhPJw0NytvaSnOYdTa7GUSqGzJJxnqCVMGNXFaU+Bu60k1BERVeupvou3p01pEwFJ+Dhp7gFPtHw==
X-Received: by 2002:a05:6870:a910:b0:e6:dca:5fd3 with SMTP id eq16-20020a056870a91000b000e60dca5fd3mr264373oab.202.1651684891384;
        Wed, 04 May 2022 10:21:31 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a7-20020a056870b14700b000ead8b89484sm5785452oal.5.2022.05.04.10.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 10:21:30 -0700 (PDT)
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
Subject: Re: (subset) [PATCH 4/2] ARM: dts: qcom: sdx55: Remove ipa interconnect node
Date: Wed,  4 May 2022 12:21:15 -0500
Message-Id: <165168485227.3730817.7400663039437041029.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220415005828.1980055-2-swboyd@chromium.org>
References: <20220412220033.1273607-1-swboyd@chromium.org> <20220415005828.1980055-1-swboyd@chromium.org> <20220415005828.1980055-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 14 Apr 2022 17:58:27 -0700, Stephen Boyd wrote:
> This device node is unused now that we've removed the driver that
> consumed it in the kernel. Drop the unused node to save some space.
> 
> 

Applied, thanks!

[4/4] ARM: dts: qcom: sdx55: Remove ipa interconnect node
      commit: 02fbeb1649534d564b100a994b05d4eaa167ea19

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
