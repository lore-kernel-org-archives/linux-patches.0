Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A021D335071;
	Fri, 17 Oct 2025 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715458; cv=none; b=nrDfjByMgcNrJXGedtH29NGBuKhecl71rfwF0flonGgS4gk/7DRB/NenPS6mr5dHankTTugt7NHyVSEgtq0jMVqXtVaZk15UhCccxgHsbz+/79IBig0vQA7QldOt/3pz+wrF4ADXC2javyngdSCmA6ROxJV+H7HGvS7nVYFNUlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715458; c=relaxed/simple;
	bh=dDhnwPrLtXDkzqI0KFFCQOzleH4MfejH4WvjucdcpRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPyef8q2J2KkdYrUENRHqVotHO0LqxO2XGvyH6XBc3wLzX9/4k8K2O57Sm3zvl4lcEdqRALXOOpPFpE/8B98SbZF6G66B2x1/hgxNXerXuMIMUWYZW1w7YNvk9b8agPlfpR2NCEgFYGVL10sc/RG4dsIWysNasM7s+biOYhFBNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfUPEXHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfUPEXHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25914C4CEFE;
	Fri, 17 Oct 2025 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715458;
	bh=dDhnwPrLtXDkzqI0KFFCQOzleH4MfejH4WvjucdcpRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfUPEXHqzOFmiLveJ6DtN62jCVdfWTMHJEdBS6K7yZrNR4O0Ohrw9Mp044gV4f3cM
	 wGq4hrcHWgdQXM+70EfBVVpiEgjHf422LJ1q5BORkumdJxPqRAvnAs7C67DbARMSjI
	 jVLFHpjDI/ymmPAotXAJTOesBW7vu1q9qYw60l48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	"Erim, Salih" <Salih.Erim@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 223/371] iio: xilinx-ams: Fix AMS_ALARM_THR_DIRECT_MASK
Date: Fri, 17 Oct 2025 16:53:18 +0200
Message-ID: <20251017145210.154592183@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 


