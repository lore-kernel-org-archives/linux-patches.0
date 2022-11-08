Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8706E15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE95C433C1;
	Tue,  8 Nov 2022 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916193;
	bh=QS6Tfq9oIQvg+nlQ4fbYPI2hdNSOMFpfPrF7mpSfX68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqnOdwGS6MrKY92gib81zeBysZ+FjdFwXYIkMlvd+PBvxRnDwapYbZmnLJtaou33I
	 ba9dnq/dgOntkcGvu/2ribVG5qSdSbSVLcKHxo7J5HouQPbwJh4mf8Udsqzp5UFpT8
	 uD2knNkcB9K+u1LlXgjtQLfPgVT055ZI3N+A/U+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/144] firmware: arm_scmi: Suppress the drivers bind attributes
Date: Tue,  8 Nov 2022 14:39:28 +0100
Message-Id: <20221108133349.100292885@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit fd96fbc8fad35d6b1872c90df8a2f5d721f14d91 ]

Suppress the capability to unbind the core SCMI driver since all the
SCMI stack protocol drivers depend on it.

Fixes: aa4f886f3893 ("firmware: arm_scmi: add basic driver infrastructure for SCMI")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-2-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index e815b8f98739..2c1d5f943dd3 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2009,6 +2009,7 @@ MODULE_DEVICE_TABLE(of, scmi_of_match);
 static struct platform_driver scmi_driver = {
 	.driver = {
 		   .name = "arm-scmi",
+		   .suppress_bind_attrs = true,
 		   .of_match_table = scmi_of_match,
 		   .dev_groups = versions_groups,
 		   },
-- 
2.35.1



