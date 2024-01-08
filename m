Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD2853E2E;
	Mon,  8 Jan 2024 15:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Vis3cVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF859C433CB;
	Mon,  8 Jan 2024 15:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728693;
	bh=eDWJhVN3jts8+r7V/fldTzsXP1IoFouCTiTJCzvHbac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Vis3cVq1HXutJzFWfOUpooS5oqH8ku/Ur6dUUgwkxT1p73J6shYEXPRK9Zz6bVix
	 eVhYGldyakJsDcK/KD/6BdN17DoICFXNTE0yMrOtyE+ZhxSLGw9QvtCswSG+Y3iuvW
	 8MGRggBlfWRgKfZC7Mtv3LvL8lPEySAH7DoUJ6Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 6.1 150/150] Revert "interconnect: qcom: sm8250: Enable sync_state"
Date: Mon,  8 Jan 2024 16:36:41 +0100
Message-ID: <20240108153518.136303670@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Pundir <amit.pundir@linaro.org>

This reverts commit 3637f6bdfe2ccd53c493836b6e43c9a73e4513b3 which is
commit bfc7db1cb94ad664546d70212699f8cc6c539e8c upstream.

This resulted in boot regression on RB5 (sm8250), causing the device
to hard crash into USB crash dump mode everytime.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Link: https://lkft.validation.linaro.org/scheduler/job/7151629#L4239
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/sm8250.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -551,7 +551,6 @@ static struct platform_driver qnoc_drive
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);


