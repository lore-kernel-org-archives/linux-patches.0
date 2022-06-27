Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CA546A8
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 20:03:20 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id p8so14308948oip.8
        for <patches@lists.linux.dev>; Mon, 27 Jun 2022 13:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TZ8+R3M0S1nQaMEUYxJlIWhu0Gas0lB13VSI9mi3gCo=;
        b=jE9NBHIDH149VkRLhIk0yOTrQtpNiFaKNTUGDK89EhVFqEKC4abCikb/nksZMiAEsT
         PDSAwpHsp5Yek0S95rRDahLASN3U+sDCAz6qZlTsANiRMVrBrcXqals463swf2TiOKr1
         5AZCZe8m3u+jGC/GNgVhHgbvChx5BbL18SFS2+7KCiO3NljI3o6g+/bOe87gggHJnCu/
         LG1Cn6RSFhOTyv/ycAqKp/ayCeCgMgILVHRHqVbGRezAdJ59yC93ziKTJzR6Xz8x/0uM
         7GH4mlpCHuFO9QN1fyfSt1ylMQXp1PwT5WHYHlnKDCp1grBgD2cvqDrFjwZscvqrBOnP
         1ggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TZ8+R3M0S1nQaMEUYxJlIWhu0Gas0lB13VSI9mi3gCo=;
        b=J9MVwBY9w7oi1CqauAU0rQ0dJxQRxrtwuomQ7cOojwi9Fd8Da0RvU7NNIpNyWfu2y8
         y6nwx+Xv3BEO4hF1iLST15x0hGmMgeHq32V36E+jyUGqSrEVABlKc/zafSK/7tkDZydg
         g5hhkolHp2kW/zQwHn7na4Xif8ko+exrxcTyuG+83zGHwASBJ0TUWtVudz5SZebc2AEt
         IQAgWF2e1dsoIum/YcDF/DNWA6Ty9HvU0IcVOTuMyGnLNAkpJEmrcFgVW8dDaH9I4zhJ
         GexKqa548OHggqIyfWa0wDTWrM49y3O5V3Q9y+5p4KZDkILrs0oRP8w3j7HuRE/s1LUP
         bHVA==
X-Gm-Message-State: AJIora+Ix3pcMuYUrpOb+k/6KPF08dBo/RzmEapurz3r+uRqt8396mpM
	IzzC2xCxGOFau5z/DsTlvagc7Q==
X-Google-Smtp-Source: AGRyM1sirrNSgfMuD2r1cwuzZWm2Oqngu9wBvfSeMbPZ5IiVWM+Vhp6aZ5l2qx23ivcg184/EjcZ8A==
X-Received: by 2002:a05:6808:1648:b0:333:45ae:3777 with SMTP id az8-20020a056808164800b0033345ae3777mr12078448oib.4.1656360199747;
        Mon, 27 Jun 2022 13:03:19 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id m16-20020a4a9510000000b0041bdf977c6dsm6428729ooi.31.2022.06.27.13.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 13:03:19 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Rob Herring <robh+dt@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	"Joseph S . Barrera III" <joebar@chromium.org>,
	Andy Gross <agross@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Alexandru M Stan <amstan@chromium.org>,
	devicetree@vger.kernel.org,
	Julius Werner <jwerner@chromium.org>,
	linux-doc@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v4 1/5] dt-bindings: Document how Chromebooks with depthcharge boot
Date: Mon, 27 Jun 2022 15:02:40 -0500
Message-Id: <165636016348.3080661.58233739131121561.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 20 May 2022 14:38:41 -0700, Douglas Anderson wrote:
> This documents how many Chromebooks pick the device tree that will be
> passed to the OS and can help understand the revisions / SKUs listed
> as the top-level "compatible" in many Chromebooks.
> 
> 

Applied, thanks!

[1/5] dt-bindings: Document how Chromebooks with depthcharge boot
      commit: 59228d3b9060b0e5e6b37ceca078fd81a165cfc9
[2/5] dt-bindings: arm: qcom: Mention that Chromebooks use a different scheme
      commit: dbbccb3db122558b35ecb4c87a86bbad37c80862
[3/5] dt-bindings: arm: qcom: Add sc7180 Chromebook board bindings
      commit: 3b8bfe002c4ba633b48cc497238a69eb88346a60
[4/5] dt-bindings: arm: qcom: Add / fix sc7280 board bindings
      commit: 707b9b08789bf3312c9cf23c621ad942de9aa48c
[5/5] dt-bindings: arm: qcom: Add more sc7180 Chromebook board bindings
      commit: 5069fe941f76c9f37abc98636a7db33a5ac72840

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
