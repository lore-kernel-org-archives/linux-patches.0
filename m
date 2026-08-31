Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194D143935B;
	Mon, 31 Aug 2026 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184585; cv=none; b=fHN59u07qKNrEgiAUFPg/KLnnU/davTCbVs3MqNAs+/KawiILCQF3c7ePSkPombUCRAzbBmVCQ/zuA2yFANWm+gHPOM4eTutwC1ZfUg98AfB4QKgZWRDa4cDfOLESsSasbl/VC3jt5N6mSOOyDz6Gg0CTbr4lyi9NTH3mtn/FUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184585; c=relaxed/simple;
	bh=/0sz69ZCEX411nchuPTPMv6lwbIOCjfw5Zs5O/utMl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k113WitzfuB3Dt8mvDDODBdhAhbRiNH3sffbNG98MDDnr+CcUrFnzybYdA6ewmiv2rS8zpexbiQjvM3BvlFv/+si883z6P0xYapVIjowUXwZiONV9dUDiS4HKwxOW6FkXet2/UmAy47s+zsiav+fvJYBCCyei4ZEyDXa5H1jYds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJCub6as; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJCub6as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A48A1F000E9;
	Mon, 31 Aug 2026 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184583;
	bh=6BnLRLfpyMjnEFmeQJgdSQukDMwQ0oIgdCXP9Vxy/ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJCub6asnP3NptmLqf3LIF5LR7eyNJtkaOKhb091f+9qwmb9mlUCzpQgToCkUkBNR
	 uoVTKOPwNtPPWG44IngE6Y6muIShp3QjbdEKiQT3t+QSfesMikzk4vDHtfQY6PqFOb
	 clJLnKCSehaD+fA5NhqKcu/Wl//eRZEtpvuo9j2Y=
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
Subject: [PATCH 6.6 57/91] fpga: dfl: fme: add error handling
Date: Mon, 31 Aug 2026 15:34:45 +0200
Message-ID: <20260831133402.707493739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


