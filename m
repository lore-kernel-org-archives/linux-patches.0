Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E2F13FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccNKy5LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F41C433C8;
	Mon, 23 Oct 2023 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059230;
	bh=UmzkAKHVsg7J4tx8xLJjnwoBMvuiUeXPvCLKzj5xSN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccNKy5LSp486jJkM1O+h8ngZnJHXMvsLFK4jpISMP0fV2wq6LD/nSAqrFT463DDLi
	 Vbv+VahXtuAKDoVdW2w8Gq7CpFHNZJb6Se3w1Aqsf+Ld988RSFodNOPaMrGT2/q7rI
	 w9H+oGgHCbiQ6HwawjNcnCZqKcaulrAwFjv29r70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 107/241] accel/ivpu: Dont flood dmesg with VPU ready message
Date: Mon, 23 Oct 2023 12:54:53 +0200
Message-ID: <20231023104836.506164052@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit 002652555022728c42b5517c6c11265b8c3ab827 ]

Use ivpu_dbg() to print the VPU ready message so it doesn't pollute
the dmesg.

Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230925121137.872158-3-stanislaw.gruszka@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_drv.c b/drivers/accel/ivpu/ivpu_drv.c
index 8396db2b52030..09dee5be20700 100644
--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -303,7 +303,7 @@ static int ivpu_wait_for_ready(struct ivpu_device *vdev)
 	}
 
 	if (!ret)
-		ivpu_info(vdev, "VPU ready message received successfully\n");
+		ivpu_dbg(vdev, PM, "VPU ready message received successfully\n");
 	else
 		ivpu_hw_diagnose_failure(vdev);
 
-- 
2.40.1



