Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D05A4446F5;
	Mon, 31 Aug 2026 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183561; cv=none; b=kkkE5h6d6IvYKXZbUDBj/82zBsLv5nUAMwv9WEzFGgIzuez9hGWVFW3Vth7Y9OKSart5pLSFvyP5u3rVlnRw62/23HwfG+qqFkcqZEku9zZB4NFVpQdRMstLPto8ZZYvg+5EdgGLty/SJztH1PsJVJvQGNQfCIMHq9kTMyGZ5eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183561; c=relaxed/simple;
	bh=sLu2vDiL98F0rL+K91KSgn4zYSQZ9jhE7YUjbDCJTbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl2NyFjHFjos4oe9NWnHzr01I2MSKTzQVLgTV+Vk8oEPqQVT5M/HLVEQY1/iVG0cxwxEiyU/bha7uM5MyP6P/F1UKo2yxWUNPMHkTh3gJfdoWBL7lzjnstj8vmav/aemVyyp+wEYreS3XCNPsQIhFRjU7oo9N7pWCr1Y/td/j14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CYtRp4p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CYtRp4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D1C1F00A3F;
	Mon, 31 Aug 2026 13:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183560;
	bh=lL3T8a6haslJdTGhhMjh/TxYLiJe1XlkvJXzCId4TbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0CYtRp4pDDG4eMziiGBBoKruUbn7INQIINUtLq+CCvMXdp79lwRCV7XK+649WyyVV
	 dWrt4z2fkkCvFaG4/+GmusSb0NEAUxD70HCDLeCKidlGIr/CKUndrzSbLtc7UkS8Y5
	 BJGhZjsI2ikMas8gbFMPDuyPpvf2fQhxODgxdtWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 7.2 05/71] fpga: dfl: fme: add error handling
Date: Mon, 31 Aug 2026 15:33:30 +0200
Message-ID: <20260831133359.302315576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit b5ba63e247075087ab8a6a087622c762dc4172e9 upstream.

Add error handling to devm_kasprint in fme_perf_pmu_register().

Assisted-by: gkh_clanker_2000
Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
Cc: stable@kernel.org
Cc: Xu Yilun <yilun.xu@intel.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Yilun: Fix stable tag, add Fixes tag ]
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/2026070620-unwired-clay-f6cc@gregkh
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/dfl-fme-perf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/fpga/dfl-fme-perf.c
+++ b/drivers/fpga/dfl-fme-perf.c
@@ -925,6 +925,8 @@ static int fme_perf_pmu_register(struct
 				PERF_PMU_CAP_NO_EXCLUDE;
 
 	name = devm_kasprintf(priv->dev, GFP_KERNEL, "dfl_fme%d", pdev->id);
+	if (!name)
+		return -ENOMEM;
 
 	ret = perf_pmu_register(pmu, name, -1);
 	if (ret)


