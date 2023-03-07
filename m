Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16406BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE41C433D2;
	Tue,  7 Mar 2023 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213434;
	bh=WmeQqNMIn0d+Al//BZrKLExRSzZUo3r6VfBDLM4B2QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLvVnTAQHa5kX4wKerJu8FaT0Dfc0ERzYb0zbdvgyVMy+iqvhQFZnesrTQX72Taxb
	 k/NStZnk9+94vVK7K1o2+dRwgPRyYZtGAci9ORIx62HKAATDWzlnpx9hmeFs8ua3kz
	 BEdVhgQGSEpwCE7/N9V9eCRd+ig2hDGfEhgntunI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 476/885] usb: host: fsl-mph-dr-of: reuse device_set_of_node_from_dev
Date: Tue,  7 Mar 2023 17:56:50 +0100
Message-Id: <20230307170023.166167738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit e2ffae3ed92a9f768902c1cf82642c3a09cd0345 ]

This sets both of_node fields and takes a of_node reference as well.

Fixes: bb160ee61c04 ("drivers/usb/host/ehci-fsl: Fix interrupt setup in host mode.")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20230207110531.1060252-4-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fsl-mph-dr-of.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/fsl-mph-dr-of.c b/drivers/usb/host/fsl-mph-dr-of.c
index e5df175228928..46c6a152b8655 100644
--- a/drivers/usb/host/fsl-mph-dr-of.c
+++ b/drivers/usb/host/fsl-mph-dr-of.c
@@ -112,8 +112,7 @@ static struct platform_device *fsl_usb2_device_register(
 			goto error;
 	}
 
-	pdev->dev.of_node = ofdev->dev.of_node;
-	pdev->dev.of_node_reused = true;
+	device_set_of_node_from_dev(&pdev->dev, &ofdev->dev);
 
 	retval = platform_device_add(pdev);
 	if (retval)
-- 
2.39.2



