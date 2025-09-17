Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB02E337EB9;
	Wed, 17 Sep 2025 12:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113014; cv=none; b=mK7glXOtbuHGtdkZpSY03FF5xDSdehvsv/VJ0vYLAOb5Za0KvP1yXuoRiZn80vz8f0rtrd09XBv+xER8N7qzVEZpDNGUTRTpb+ZhDwPp6ZT54N2BzE7048G8Ir2pJzbZUmj5YnQDGi0H1CPDUIxnnxs6F6sFtJk5anZjTzg4CJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113014; c=relaxed/simple;
	bh=a173u39txA8CIJuYov26t6tlsRg+24z1UAfKVRp65Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJNo7lNq8KbGSabZ1cE45xBAJ85jrKLESnaK2dU+iCrEv3GuRqpfpQfNUp/faRlTw89DhqaHP6uaXBBYGAqg/XNXonmqd6KTf1IHGWXo5LR+zGgotSTKxQ6ukZ1iqSbXsQqvWQqNOCL77D4Yig3vnmYP/02ELSHwVtalXzLUOFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kijPvpex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kijPvpex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B43C4CEF0;
	Wed, 17 Sep 2025 12:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113014;
	bh=a173u39txA8CIJuYov26t6tlsRg+24z1UAfKVRp65Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kijPvpexx6uLBiRoJBPWUxZunfA5vT0Hc7N7GsW9toWbBS1sLbUOCcDNDxYR7pt+J
	 1jPe5IYOKZalg8ARJg+1WY4TTzpC1RCYSRlPDbshRJxmP3Jg8rlYJHyU79F4W0XxnA
	 RDnXh2GaZNSGSU06kUZ0oQrn/NLEWf2Qz409DHvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 143/189] drm/xe/configfs: Dont touch survivability_mode on fini
Date: Wed, 17 Sep 2025 14:34:13 +0200
Message-ID: <20250917123355.362429937@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 7934fdc25ad642ab3dbc16d734ab58638520ea60 ]

This is a user controlled configfs attribute, we should not
modify that outside the configfs attr.store() implementation.

Fixes: bc417e54e24b ("drm/xe: Enable configfs support for survivability mode")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250904103521.7130-1-michal.wajdeczko@intel.com
(cherry picked from commit 079a5c83dbd23db7a6eed8f558cf75e264d8a17b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_survivability_mode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_survivability_mode.c b/drivers/gpu/drm/xe/xe_survivability_mode.c
index 1f710b3fc599b..5ae3d70e45167 100644
--- a/drivers/gpu/drm/xe/xe_survivability_mode.c
+++ b/drivers/gpu/drm/xe/xe_survivability_mode.c
@@ -40,6 +40,8 @@
  *
  *	# echo 1 > /sys/kernel/config/xe/0000:03:00.0/survivability_mode
  *
+ * It is the responsibility of the user to clear the mode once firmware flash is complete.
+ *
  * Refer :ref:`xe_configfs` for more details on how to use configfs
  *
  * Survivability mode is indicated by the below admin-only readable sysfs which provides additional
@@ -146,7 +148,6 @@ static void xe_survivability_mode_fini(void *arg)
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
 	struct device *dev = &pdev->dev;
 
-	xe_configfs_clear_survivability_mode(pdev);
 	sysfs_remove_file(&dev->kobj, &dev_attr_survivability_mode.attr);
 }
 
-- 
2.51.0



