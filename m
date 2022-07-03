Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCF31FA0
	for <patches@lists.linux.dev>; Sun,  3 Jul 2022 03:58:00 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-10bd7fbc0ddso2842451fac.1
        for <patches@lists.linux.dev>; Sat, 02 Jul 2022 20:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6WhkiinZderBeOJxHsAhGfuvlGN4jQvGr3mcVEnHC/E=;
        b=ROXm6HUBUB7+4plaT3RCm8eT5gipo0vfdLYpNdFJa1V2G+GeOtlT4L00JY4EI/cASY
         dZOd6BG+lXaLnds4EmGjnO/aYIVWIMxeo8688Z9Nc5ixYdjs68gta/BuiMCYhTfYoBmL
         e2uiQjgrQq+jGdh0l9qTWjijwrPUtA5u/Bq1u16YQ+fLFv9iqGBfGbynkkXr1B++LCh5
         vF9HmS896miL00jmRNnoMvJZfaR1lQkCIn8ZSAhjdgm3VriN5DA3iiFniLUopXg6Oeuo
         vgjchV4RBkLF75hyTSx0nbFT3QJ5QWOvRsA2VVNACGuGn6t9M25oxAPu+uGXBUN0giWm
         Sosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6WhkiinZderBeOJxHsAhGfuvlGN4jQvGr3mcVEnHC/E=;
        b=P14LflfbOlWs3OWTMkK0P4vlGwv6hKxzpo+FaW7vE+zz3mHO6QRN/I/bUtkQSAXUkv
         KFmPEfW2QCcR3NalgD1EwdcBFLURy/aCbvK+WOP6GUEJpUEDJEqPw581ysg2iTWFhvk5
         XiPDpQt6EU4VEflpRO8btfYmGWDBrRg5fVMGA8m9ruiwK6utcV3eT3CcmsVFWzxrhYSu
         xI0tBmQq0rU0g6Dhis4Myneji59W/L8j0+qrgVLgiwAfPO27m+yQzadtP/ojd1QV6Rzw
         q0epHMQMy2ga8VOPRvEdeX1nRtt9Cjnn2F6QLvAEP6FkmmEqFDNA2B/ZKWLlr+Ir4XTz
         88VA==
X-Gm-Message-State: AJIora95cfJ5nDMaLFbFKYzA0kV/vJVLPlov71vRlrzSeVhadI/3ndhG
	KOajAieVucP5ECYwXYuqxIU8yg==
X-Google-Smtp-Source: AGRyM1u2LewnM4ouvLaAci96M2trkkiVNULlUbxt5GHFcPZ1EuMGmiG9/MZFHVVWP3R3fwybWoPlAQ==
X-Received: by 2002:a05:6870:c988:b0:106:3435:11e5 with SMTP id hi8-20020a056870c98800b00106343511e5mr13551815oab.172.1656820679905;
        Sat, 02 Jul 2022 20:57:59 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 25-20020aca0f19000000b0032e5d0b5d5fsm12965910oip.58.2022.07.02.20.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 20:57:59 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>,
	Andy Gross <agross@kernel.org>
Cc: patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Benson Leung <bleung@chromium.org>
Subject: Re: (subset) [PATCH v2] arm64: dts: qcom: sc7180-trogdor: Split out keyboard node and describe detachables
Date: Sat,  2 Jul 2022 22:56:52 -0500
Message-Id: <165682055972.445910.5367240737082379491.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220627212802.3593012-1-swboyd@chromium.org>
References: <20220627212802.3593012-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 27 Jun 2022 14:28:02 -0700, Stephen Boyd wrote:
> Trogdor devices that have a detachable keyboard still have a
> non-detachable keyboard input device present because we include the
> cros-ec-keyboard.dtsi snippet in the top-level sc7180-trogdor.dtsi file
> that every variant board includes. We do this because the
> keyboard-controller node also provides some buttons like the power
> button and volume buttons. Unfortunately, this means we register a
> keyboard input device that doesn't do anything on boards with a
> detachable keyboard.
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: qcom: sc7180-trogdor: Split out keyboard node and describe detachables
      commit: a10b760b7402563661fa305882b181a75a1d4894

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
