Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4A528A1CC;
	Fri, 10 Oct 2025 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102282; cv=none; b=do7+s7msWD3zS8N30pUPBiHpwpyx5C2E5gpPiVQz+RVi9m0PGVwkPj943z3RC3ff80jCbWXiboKX2ACCDD/ioaMwa96ybR+4l6kgBgBtPTi7Dn6K7YbaX9gAFtfojcnY6kWxCeEIMYXtFwU+zn8WHNu6ibs3ftvrQLCOp6YdP+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102282; c=relaxed/simple;
	bh=O6NK/5Es7WUJQ229HvLeMJeaIVIiOmm54n/8Ww5Mx1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUUGZwkkn60cfhkhpds1w0uMI9/sPtA89eA9Gw2aIrkdrLWCGDq7UCLGqQJx5naKUvysZAvRS1tA7JdDUZPmZsLE/msG+2In9E5h42bOB0G5uw2ZK07wc/9/Za8Sa7cHd+ohelWwVfGkolB2wkoeJj6gHKdbepsfPPJ7F81zdGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKTKlL8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKTKlL8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FF9C4CEF1;
	Fri, 10 Oct 2025 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102282;
	bh=O6NK/5Es7WUJQ229HvLeMJeaIVIiOmm54n/8Ww5Mx1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKTKlL8h6AKMX1LG8ZXYWO1wheppyVGilcu23/Lu4dpI8aV3HReDi20y6PojIwxwo
	 i9bNK+NpZ0VDrQ3OlDjutzxctfdrR5BZklcA/x8I+eL6OwAWo4nGEIpTVE23sc7qmj
	 33pt40A3RKaUNZgv8lox7tVwu2s7lYIJC+MHlj0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.17 18/26] driver core: faux: Set power.no_pm for faux devices
Date: Fri, 10 Oct 2025 15:16:13 +0200
Message-ID: <20251010131331.871707399@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 1ad926459970444af1140f9b393f416536e1a828 upstream.

Since faux devices are not supposed to be involved in any kind of
power management, set the no_pm flag for all of them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/6206518.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/faux.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/faux.c
+++ b/drivers/base/faux.c
@@ -155,6 +155,7 @@ struct faux_device *faux_device_create_w
 		dev->parent = &faux_bus_root;
 	dev->bus = &faux_bus_type;
 	dev_set_name(dev, "%s", name);
+	device_set_pm_not_required(dev);
 
 	ret = device_add(dev);
 	if (ret) {


