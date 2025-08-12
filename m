Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C596BB5B;
	Tue, 12 Aug 2025 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024878; cv=none; b=mLwZ3AQGIE8/UtuKQnVb7Z5iA7kcEJH+ev8HCcGvaFspaIlhC/36/Ci5ma1qv8Ss0Y/y5X2EuRBil7Cd6Kgm4heyynvfW0PuUnSYuxeyoEmQ5FYjUk+UYbytvPUS0ul2iYPVqhj161XqTHiY10QbbTTjHZdO0m0dcs5gPeDYFeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024878; c=relaxed/simple;
	bh=O9G8mlGxNnGCL8MQbvfA3HwFedaBMY8ozJT76IaegR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oArMqXBUt6kHDkkIQkGjBpZltlGUmSz3zoxxlEu3PtgAhLveGSox4/UTvi+08fyBdz98UqIiYFOSIxxDPFUbKL1f6N7heplME4V1zFB87Ig6zCQU3+u63pbhGYQSiZ7PXQRyt9MPerxpmHH7Owyb4LRWDH/hwSSOqownuSlkEn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgjcWLA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgjcWLA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A31C4CEF0;
	Tue, 12 Aug 2025 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024878;
	bh=O9G8mlGxNnGCL8MQbvfA3HwFedaBMY8ozJT76IaegR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgjcWLA63zLt2E7HBg/q1DuX95DaLywQl74rb2lhM3Gju2vftVTM1OAeYx/VRsvSd
	 NYlfG9zq1MZd1SPvSNkHX33zPSo8FjJn24J5BcebIEIEHXhS9OD1I9YgjVWDJYj+7r
	 wHrcHBvt0mf/72H9JC6d9JJEgP+d0KfIxNjJUFrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 504/627] powerpc/eeh: Export eeh_unfreeze_pe()
Date: Tue, 12 Aug 2025 19:33:19 +0200
Message-ID: <20250812173447.872195130@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timothy Pearson <tpearson@raptorengineering.com>

[ Upstream commit e82b34eed04b0ddcff4548b62633467235672fd3 ]

The PowerNV hotplug driver needs to be able to clear any frozen PE(s)
on the PHB after suprise removal of a downstream device.

Export the eeh_unfreeze_pe() symbol to allow implementation of this
functionality in the php_nv module.

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/1778535414.1359858.1752615454618.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index ca7f7bb2b478..2b5f3323e107 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1139,6 +1139,7 @@ int eeh_unfreeze_pe(struct eeh_pe *pe)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(eeh_unfreeze_pe);
 
 
 static struct pci_device_id eeh_reset_ids[] = {
-- 
2.39.5



