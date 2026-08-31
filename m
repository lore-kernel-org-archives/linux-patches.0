Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DD64BD0F0;
	Mon, 31 Aug 2026 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184910; cv=none; b=aLjfroFx+HbX5gCpIdJ1L9hdAnigrHI0UfxRkb4yFmWhnvCScJ7YYzA3L1cs5eNNkm7GvOYPh608M+yaR3m3U5YAPa/vMCUt0WebjFYILXRQQqOz7JV1b0siubIoImil6JTVxIqk7V1TVfEUh9uyxBXbvruhxUjjhUsbeQDekvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184910; c=relaxed/simple;
	bh=7uDWBhhezHtZGRAzZOGklU2TDU0kFnjOsdN3QKuYtmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQPZupUJdOZMI/pO5AIOz1fc0vhpqAImJrMy5hGz7eq0N9nVHTkCrbAX4nBAl1PxKmK2Elm2Ig6xsPF8s5KDbnOMbZIy7S7iydUaC6+ilqO0Oe+iyVIASAA6t/Zs+HHdxUbNdV68KsxpBnzHoEKzOit4fmmgXTO0qvkuSLmNggQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wnac7QTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wnac7QTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905AD1F00A3D;
	Mon, 31 Aug 2026 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184908;
	bh=+9DJ/fqHBr0awkjLwZ0GvEhXqonbNWpccBkG23H9LTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wnac7QTHl7m7cxWaAG+2Z7kjY8KCpmjNgc4SO2E+HdB9tWLmzIKOzzniAPqmKt2Ha
	 HIhpXitNGnPSW3rWGnX0/JlEd58XM19qD5qvfGeyfdVp0FHWGXWuNav5xl2IWuu0aY
	 AErhoXzDxo+M9CEdGqpANkv9CG8b0+DaxdHKsPr8=
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
Subject: [PATCH 6.1 62/92] fpga: dfl: fme: add error handling
Date: Mon, 31 Aug 2026 15:35:00 +0200
Message-ID: <20260831133402.890050898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


