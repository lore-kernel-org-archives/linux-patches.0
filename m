Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868A88F7D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40F8C433C7;
	Sun, 16 Jul 2023 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538915;
	bh=RAvgsEaqm68eJ7PoDQkHtgyVk0mvsOy9jipLUsWw9Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWYdluvHtD92IkkSFu6GKNGCu4MRdgXW5p81Qu5ejmiTdTM2cCvJGvMqvAdlMZGWn
	 L19U0Zt6VLUIEQlL5tIoNyDFbA7rHhN0k/MzAboF5lPV1rLgsrLjKWqldK3fvIVgvK
	 jkjQlN9COh8GkzvWTYbC/wTWMo/jUIRwDoPFDTLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 594/800] usb: misc: eud: Fix eud sysfs path (use qcom_eud)
Date: Sun, 16 Jul 2023 21:47:27 +0200
Message-ID: <20230716195002.898226117@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

[ Upstream commit f16135918b5f8b510db014ecf0a069e34c02382e ]

The eud sysfs enablement path is currently mentioned in the
Documentation as:
  /sys/bus/platform/drivers/eud/.../enable

Instead it should be:
  /sys/bus/platform/drivers/qcom_eud/.../enable

Fix the same.

Fixes: 9a1bf58ccd44 ("usb: misc: eud: Add driver support for Embedded USB Debugger(EUD)")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Link: https://lore.kernel.org/r/20230517211756.2483552-2-bhupesh.sharma@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-driver-eud | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-eud b/Documentation/ABI/testing/sysfs-driver-eud
index 83f3872182a40..2bab0db2d2f0f 100644
--- a/Documentation/ABI/testing/sysfs-driver-eud
+++ b/Documentation/ABI/testing/sysfs-driver-eud
@@ -1,4 +1,4 @@
-What:		/sys/bus/platform/drivers/eud/.../enable
+What:		/sys/bus/platform/drivers/qcom_eud/.../enable
 Date:           February 2022
 Contact:        Souradeep Chowdhury <quic_schowdhu@quicinc.com>
 Description:
-- 
2.39.2



