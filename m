Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5734A19E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA65C433D2;
	Wed,  7 Jun 2023 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170188;
	bh=6pgBzRyY6zxM5N/5wd8n8ptxAtgtPYjCtkr+Lx3NBPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUwh41H06Yj3FiosREg3IJOWaaDn9pe08aKbChBgz6rAgLyETdTECyo5o4u7dDcbc
	 q3WKwofn3g5RQKgDuCTtPMzc0V4NxZgFhQRApqYzNrjhs68IL5rR3LDfUMOQKgnZaI
	 BdPeV4nqRcC9Ie6JB7mo3RXchf5bw1hvZw2L2qPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <natechancellor@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 78/88] regulator: da905{2,5}: Remove unnecessary array check
Date: Wed,  7 Jun 2023 22:16:35 +0200
Message-ID: <20230607200901.667235984@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <natechancellor@gmail.com>

commit 5a7d7d0f9f791b1e13f26dbbb07c86482912ad62 upstream.

Clang warns that the address of a pointer will always evaluated as true
in a boolean context:

drivers/regulator/da9052-regulator.c:423:22: warning: address of array
'pdata->regulators' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        if (pdata && pdata->regulators) {
                  ~~ ~~~~~~~^~~~~~~~~~
drivers/regulator/da9055-regulator.c:615:22: warning: address of array
'pdata->regulators' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        if (pdata && pdata->regulators) {
                  ~~ ~~~~~~~^~~~~~~~~~

Link: https://github.com/ClangBuiltLinux/linux/issues/142
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/da9052-regulator.c |    2 +-
 drivers/regulator/da9055-regulator.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -421,7 +421,7 @@ static int da9052_regulator_probe(struct
 	config.dev = &pdev->dev;
 	config.driver_data = regulator;
 	config.regmap = da9052->regmap;
-	if (pdata && pdata->regulators) {
+	if (pdata) {
 		config.init_data = pdata->regulators[cell->id];
 	} else {
 #ifdef CONFIG_OF
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -612,7 +612,7 @@ static int da9055_regulator_probe(struct
 	config.driver_data = regulator;
 	config.regmap = da9055->regmap;
 
-	if (pdata && pdata->regulators) {
+	if (pdata) {
 		config.init_data = pdata->regulators[pdev->id];
 	} else {
 		ret = da9055_regulator_dt_init(pdev, regulator, &config,


