Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36018183CA3;
	Sun,  1 Sep 2024 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209296; cv=none; b=nOlDn7O3PtrsJ69qGYY6kJZbPsMmKb9WImtj84ZuPZf/JQDU2dDlleSbjchL9bvNlTXmWhQKUOzD2D77R2E3P2AjzwM923WR2Xk2XalIK/z+xDtLydwY9l95hAOyL7SivF/6CP8D1qWWkOjEN6k0qHRtNUC9dWVBRfc9ROkqZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209296; c=relaxed/simple;
	bh=C6jpKMeBEsrTF2lnFDtWD4ppwjUYLfxTTxEUaVu0wi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi67xaYvK1cLeMOL8jeR4tFtpXLl7evbyTK/2NFAXuWxBDkniPSDTcx30nhtoqh3+/ld+fJNcxdF65ZjudbRvXQkBySdK3VJsP3GqMcHIT9zr+NDiOvgW1gWPur4YQ7SjlOu5+mYrjiPqiiGi3T9QWv9pSpOx6AJ4SlrqP9pc40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQoJF1m4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQoJF1m4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1536C4CEC3;
	Sun,  1 Sep 2024 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209296;
	bh=C6jpKMeBEsrTF2lnFDtWD4ppwjUYLfxTTxEUaVu0wi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQoJF1m4w9WJPX7pAUHtfuf6PDJ2XxHo/JuWda0TmOOc13ZdR05D19+Gw8+o9tyXo
	 GtkRtKHTUgZBwwnLACmx0ufJUIUoVRQtu0ItfAo9AMK5ZB39u/obrLHdw5uC6HKcna
	 9Y1GyTnE6hdXbt4FtXZD9FprZBK+vl8wi1OAYdzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.1 63/71] usb: core: sysfs: Unmerge @usb3_hardware_lpm_attr_group in remove_power_attributes()
Date: Sun,  1 Sep 2024 18:18:08 +0200
Message-ID: <20240901160804.264642019@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


