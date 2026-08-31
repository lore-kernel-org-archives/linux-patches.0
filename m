Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CF349503A;
	Mon, 31 Aug 2026 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185219; cv=none; b=UBRc0ycm4S28KWXp49Dr5Vf603iea9fj5zbKu/4gMrqVjW6nT2JK3HzgjOx+SkzeWWHxwLIXVNkSCiMLqR8DMq3tNL6rUbW48h2Sm7hHXtyUnNgieMtNPL2sTmOi5JI6RN+TYbFHDyXouaxCxlPi8dukra3ZuP9c5rakeE2I2eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185219; c=relaxed/simple;
	bh=UuQU1nvublEA5hr5tJ5orfZ9TXu3/LxxZ8PcnMLGZrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxs5rukhpOO983eTcs9zWJ9XRnUyWDyGFkuUSd7Aj1fTzL6RzC9s5qWhPy+KWa2k1wo+EfYbLNEEekVerblMbDe1+03NQ5O3993nzWdq0KJMf0IhOJkXcEGSt/+w7UHiaicS1jOZ23kXC/ajxclvpOmLGPJLs4dVH5uzE0c/WoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGMs/Qug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGMs/Qug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB2C1F00A3D;
	Mon, 31 Aug 2026 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185217;
	bh=rq+6qD24WhD93MiLpYcu/AddwCkxjFejuOyCagHjSbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGMs/QugZ/hav68auI7MnJeCvRkSOsvaSYnu/JoDvAiN7JEGWyx2YZ0a9MT4cYDcT
	 fQsU6FgIKoN6/d1TdeA5KMAp0ddMn7sv88B/lL8fWCV2aDMFiMPEcRqVlccYSLulXZ
	 uK7GCPTw+g+ohLrvyX4F41IojdlsS7Ry6+eFUXEc=
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
Subject: [PATCH 5.10 24/43] fpga: dfl: fme: add error handling
Date: Mon, 31 Aug 2026 15:35:32 +0200
Message-ID: <20260831133359.661576496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


