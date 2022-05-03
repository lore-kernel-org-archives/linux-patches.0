Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5BE33E7
	for <patches@lists.linux.dev>; Tue,  3 May 2022 20:42:15 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id 7so11012852pga.12
        for <patches@lists.linux.dev>; Tue, 03 May 2022 13:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9sH2w/vVTdfqCz9W7ywvi2pyU3dj2/u0WQnJwqpg8dQ=;
        b=TsVPkF5lorasvG1c2y3HR37wwKZGRSaeSe8PsNwNLlK2wi5Bosh8OI+CNya7EG9Y+u
         hlQIkf+UrhTi6GFmf6u+1ZfSEvNA1YPyjKpWKXYmIfdnnXqkNqVbZQR0YW6n2Vzg4Z8e
         ktwBeYTBB86K88SKuYlb7OF+aibShxishTBzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9sH2w/vVTdfqCz9W7ywvi2pyU3dj2/u0WQnJwqpg8dQ=;
        b=noTeyy2K+40l23NYQKUTvA1EWF4ZEI9czgI/TxSlnoh10LmR6f6p4c6Dn1aOmO3zIo
         1isOSTovVdir4BY7aCyit45PVp2Cb1bosebc/RFckOvkSUGKb6gKZeRp/ljpsDhIQaE5
         NshJFfkGPY4L6qDMYe9bw/YIcM+I77yEaQ6J3t1SnllLRhvF63CspX0CSqvZStwRQH0v
         TaWTwBvT1Twp6LUySXZ0zi855jKI3SIcknAuTwXKY0DFqtAMt+fsxFTUeGJF+o3QUi/9
         dsjd8vOlvlYX6oGvT0KeOiF/uoL8BgcC9BnmsCAxjC/SOLMEcmovONY+hY6pw7Z9Fox1
         myQw==
X-Gm-Message-State: AOAM533wKLNeP3PDBNHaxpoe57Y0enmyd4o01XNDHAk6osjbuMGqp7DH
	yE3JHZ6hEOUpYLjddu6ybn614w==
X-Google-Smtp-Source: ABdhPJyjndjP6OpzigAn1DCQYecLfzQxzacZHA2QxQ7hTlGtc3urBMYgF3okwc7M7hDK8vnnYzwa4w==
X-Received: by 2002:aa7:8258:0:b0:50d:d365:70c8 with SMTP id e24-20020aa78258000000b0050dd36570c8mr15890945pfn.50.1651610535103;
        Tue, 03 May 2022 13:42:15 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id x18-20020aa79192000000b0050dc76281e4sm6702081pfa.190.2022.05.03.13.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 13:42:14 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH v4 0/2] Input: cros-ec-keyb: Better matrixless support
Date: Tue,  3 May 2022 13:42:10 -0700
Message-Id: <20220503204212.3907925-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a followup to my previous patch[1] that skips keyboard registration
when the matrix properties aren't present. This adds a compatible string
for this scenario so we can ease existing DTBs over to the new design.

Changes from v3 (https://lore.kernel.org/r/20220503042242.3597561-1-swboyd@chromium.org):
 * s/register_keyboard/has_keyboard/
 * Pick up review tags
 * Indicate properties are required in example #2 in yaml file

Changes from v2 (https://lore.kernel.org/r/20220429233112.2851665-1-swboyd@chromium.org):
 * Drop rows/cols check now that compatible schema handles it
 * Make binding require rows,cols,keymap for cros-ec-keyb compatible

Changes from v1 (https://lore.kernel.org/r/20220427203026.828183-1-swboyd@chromium.org):
 * Better enforcement of properties in DT binding
 * Skip registration by means of adding compatible to device id list

Stephen Boyd (2):
  dt-bindings: google,cros-ec-keyb: Introduce switches only compatible
  Input: cros-ec-keyb - skip keyboard registration w/o cros-ec-keyb
    compatible

 .../bindings/input/google,cros-ec-keyb.yaml   | 87 +++++++++++++++++--
 drivers/input/keyboard/cros_ec_keyb.c         | 19 ++--
 2 files changed, 91 insertions(+), 15 deletions(-)

Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>

[1] https://lore.kernel.org/all/20220425210726.3813477-1-swboyd@chromium.org/

base-commit: 4352e23a7ff2f8a4ff229dd1283ed2f2b708ec51
-- 
https://chromeos.dev

