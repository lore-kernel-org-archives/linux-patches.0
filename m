Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041FE336EEB;
	Fri, 17 Oct 2025 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714519; cv=none; b=qIPkrx5IdBThV4/VcB1S+4DDquEM2fP2quyizukzj1qijLiDzcZFVzBO8WYa9BMS+n7GId8gV9/mOL2k4fBfJGnHvCMX9Ukoj28qdPUXDTKeui+o6F0fjn9NfsrMT0s26LfOS+GamhuwVvBoS1TiLoSkADkBmucW3EBEH+9YnV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714519; c=relaxed/simple;
	bh=dKpb3rb6cFJoqRmIBtrzmhnY7jTKDTD1tldgka6JAvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nor0lYrhBklHxX7Do+kHRc7GfIeL/K2XexgfdZ21tul8GORhD1Lk1bPDmyGmJIRkqBcS+URFsEFrYj/fMkUUYoJ7jCmRE+I1cApg4XDDKW5mjXhmvzQ9qKSvusOJ0pI0RwwR58gNdtCn4hzCPRLbqVxSMGPnX7+NxEi6Is05pvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzZQ0qH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzZQ0qH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73814C4CEE7;
	Fri, 17 Oct 2025 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714518;
	bh=dKpb3rb6cFJoqRmIBtrzmhnY7jTKDTD1tldgka6JAvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzZQ0qH/YFpiwzcmWN1GPux9p4RdmkbuSCJ5d0z7DKNUxow4A2gQhjl5GntUULGwt
	 H1oE83/kujqmx3bioQX944wD0p+mHP/Iea8BOGxlIWWQI2TkUX7cmahCiOVwq+F/zr
	 dmfwy3VHP80Ejz5BCnjLCyWlIwA+XR8ONzyc3v8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	"Erim, Salih" <Salih.Erim@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 140/277] iio: xilinx-ams: Fix AMS_ALARM_THR_DIRECT_MASK
Date: Fri, 17 Oct 2025 16:52:27 +0200
Message-ID: <20251017145152.237283565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

commit 1315cc2dbd5034f566e20ddce4d675cb9e6d4ddd upstream.

AMS_ALARM_THR_DIRECT_MASK should be bit 0, not bit 1. This would cause
hysteresis to be enabled with a lower threshold of -28C. The temperature
alarm would never deassert even if the temperature dropped below the
upper threshold.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: O'Griofa, Conall <conall.ogriofa@amd.com>
Tested-by: Erim, Salih <Salih.Erim@amd.com>
Acked-by: Erim, Salih <Salih.Erim@amd.com>
Link: https://patch.msgid.link/20250715003058.2035656-1-sean.anderson@linux.dev
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-ams.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -118,7 +118,7 @@
 #define AMS_ALARM_THRESHOLD_OFF_10	0x10
 #define AMS_ALARM_THRESHOLD_OFF_20	0x20
 
-#define AMS_ALARM_THR_DIRECT_MASK	BIT(1)
+#define AMS_ALARM_THR_DIRECT_MASK	BIT(0)
 #define AMS_ALARM_THR_MIN		0x0000
 #define AMS_ALARM_THR_MAX		(BIT(16) - 1)
 


