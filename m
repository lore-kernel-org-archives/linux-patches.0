Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D2B1D88AC;
	Mon,  6 Jan 2025 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179228; cv=none; b=fQ3UXZ+ZwKKrRGgxMt4I3nU7eRz07zxVXIe4e/6tH66UZsmjWzgWJHBqfENweA6nNZ1oDNLasMpVVO3tVFN1NhxztphQYW94G0h8URJ6KW4L1eR08kONN4AXHM4+xSyUcBffM34PPkHKOljl3arNKCksCJ570pTFIg06wGOv6hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179228; c=relaxed/simple;
	bh=Ude5wyPEZRM88mk+A1eT7ZAFgSUde46XvYYijZU3tA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6iHmrDOc8E1Bl2p8D6VvmrmzXnt01S4/y1Dlu9Z6dP8q975XWkD1bMQ9alll0OALJ8Dm6JLJHhgOGLcPY6KSN2F8YpwW9BShTpQYdHlp5zZ7ICs29wjhVt+BgfUxbzxH0TIVuA6jOXMsZI6zDpxfi8EKJiCCMEPdWa7oZF7x5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdchLh2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdchLh2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1176C4CED2;
	Mon,  6 Jan 2025 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179228;
	bh=Ude5wyPEZRM88mk+A1eT7ZAFgSUde46XvYYijZU3tA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdchLh2MvAJw4bFYKWtLj2j0FzueOAiuwYgSjSy//jG9TdoCl/7K2g9c3o9TRcHrP
	 LK/by6ck1pPx4AVVS3RMlChn1zSiNwlEYlikAf6cxbk+fDh2j3mo/nNkc3ll5JfF1q
	 7O6kXCVGWbxWM53gghE8hB2PXTXcOkVHy9POHThg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Preethi G <preethi.gurusiddalingeswaraswamy@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 68/93] RDMA/bnxt_re: Fix reporting hw_ver in query_device
Date: Mon,  6 Jan 2025 16:17:44 +0100
Message-ID: <20250106151131.270838981@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 7179fe0074a3c962e43a9e51169304c4911989ed ]

Driver currently populates subsystem_device id in the
"hw_ver" field of ib_attr structure in query_device.

Updated to populate PCI revision ID.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Preethi G <preethi.gurusiddalingeswaraswamy@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241211083931.968831-6-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index d0ed8e14e3da..563a0f37810d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -137,7 +137,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 
 	ib_attr->vendor_id = rdev->en_dev->pdev->vendor;
 	ib_attr->vendor_part_id = rdev->en_dev->pdev->device;
-	ib_attr->hw_ver = rdev->en_dev->pdev->subsystem_device;
+	ib_attr->hw_ver = rdev->en_dev->pdev->revision;
 	ib_attr->max_qp = dev_attr->max_qp;
 	ib_attr->max_qp_wr = dev_attr->max_qp_wqes;
 	ib_attr->device_cap_flags =
-- 
2.39.5



