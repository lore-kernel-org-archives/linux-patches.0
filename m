Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA331DFD1;
	Sun,  1 Sep 2024 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210534; cv=none; b=opS8kJ0cF61xrRA3n6iDZvHgVtkhPckCgb6W1cxBcrrQVU4FZDE8W6vCppaq7i+rZV+mKKBABGEQ+0i6OAdga0Q5p7Sh5+4nS9cqnsu+pRzYNi0Laxevn1nOIZlhtK/B6BbaQDKvnnU5rlpgQBo+8pD2EtOXbG8NkwRcd9yJBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210534; c=relaxed/simple;
	bh=H8E6Uz3J4DSoKDEJefOtsEdujcD2a3rnHB6kEgMY03Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPIfXtdEgJl98Ljj/5mBpCaCP7Dc3QtMo8s3QYKeEsui0fJ63rYQ4HICbx0R+nhzQ0i1SzfQrSLSlbA2o0wYTQsK93YEyev8VpKj9GkQcpy73hyIKr/L5+H+7zpZM4qSq1ZnGnJ2mYBoLGFqLvVN/tvcsnpAsDvBQX2P0LRjBK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd64+mW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd64+mW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4487C4CEC3;
	Sun,  1 Sep 2024 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210534;
	bh=H8E6Uz3J4DSoKDEJefOtsEdujcD2a3rnHB6kEgMY03Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd64+mW040QcG/rjzo7m4fxTMArpU/IYU8sc2cciDT1mhnIAUdUa/ni5+iWQPbpTr
	 ncLJrL2rgmDaXMU2QRuDKIg1gE4O9al/JtMYfPxmK+RsrpIYsIYf9qd0vzTK6tmRLO
	 Dp7i1DHucPe9OVfM0xBHi+jWkafGt/DXXOs//U5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.15 208/215] usb: core: sysfs: Unmerge @usb3_hardware_lpm_attr_group in remove_power_attributes()
Date: Sun,  1 Sep 2024 18:18:40 +0200
Message-ID: <20240901160831.214238213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 3a8839bbb86da7968a792123ed2296d063871a52 upstream.

Device attribute group @usb3_hardware_lpm_attr_group is merged by
add_power_attributes(), but it is not unmerged explicitly, fixed by
unmerging it in remove_power_attributes().

Fixes: 655fe4effe0f ("usbcore: add sysfs support to xHCI usb3 hardware LPM")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240820-sysfs_fix-v2-1-a9441487077e@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -670,6 +670,7 @@ static int add_power_attributes(struct d
 
 static void remove_power_attributes(struct device *dev)
 {
+	sysfs_unmerge_group(&dev->kobj, &usb3_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &usb2_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &power_attr_group);
 }


