Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9EF3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974F5C433EF;
	Tue,  7 Feb 2023 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775573;
	bh=cEdrSOKa4mOg4IORvVXfkEdUdYScvNnKVbVKW5AKf20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxhvYaHvVLpETyTjm/A+7hyh/Ol5D0ws3LBsbI/lmU+s6A9KBGMCe9y8fFRqr///l
	 17jFIXApBttLwBN57PeJt+q5kGHM26NuRi1/yL8FmGAJKSqeyBlpqviHJWIm73oxfS
	 0RHBlq26ug3bfO/9LaPP+w3FUCx1RDQUy4r9Qxl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 086/120] nvmem: qcom-spmi-sdam: fix module autoloading
Date: Tue,  7 Feb 2023 13:57:37 +0100
Message-Id: <20230207125622.403531231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 1ca7fca349316231bbaa68d16f819a08d683c5a7 upstream.

Add the missing module device table so that the driver can be autoloaded
when built as a module.

Fixes: 40ce9798794f ("nvmem: add QTI SDAM driver")
Cc: stable@vger.kernel.org	# 5.6
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-11-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/qcom-spmi-sdam.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -166,6 +166,7 @@ static const struct of_device_id sdam_ma
 	{ .compatible = "qcom,spmi-sdam" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sdam_match_table);
 
 static struct platform_driver sdam_driver = {
 	.driver = {


