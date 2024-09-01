Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532C6183090;
	Sun,  1 Sep 2024 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207872; cv=none; b=Xd1kAVr8D7pi0DdxHubmiW+/hSBVy7KZRslfWw57HKU6oqYDCUtk/JRY1er4KnHpXJl404PjPELOqn1YnMsR3tCZyTY/hdW3TyJLhdrrzb11ry0UEC2fwTFgWy6cMFUyFqggRTIjrp24KOhWYpJZCdHk31/gpuhYmMZNZ4XFVwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207872; c=relaxed/simple;
	bh=cbNlr86IkxW47XF07SypRkAvqGprWgmhZZSzX1iD3EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLF/RjeYu/+0DB/AgifVys0Fv0/IpX2Ji4iLfDom8jfwOk1APeApZdNb5GFj6tSvCxBBt7NvZUGevgA1aNoAIzy6SlAUZ43hiBerRwTRAmnvZale2RF+4HZ8AUnWy/AxrQv+c0akYYFO8XI7uxg3AD5ZUHEOcu6f20Oj9JVNhcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2g0+E/jM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g0+E/jM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD2FC4CEC3;
	Sun,  1 Sep 2024 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207872;
	bh=cbNlr86IkxW47XF07SypRkAvqGprWgmhZZSzX1iD3EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2g0+E/jM+xvzQT5oRiRl5UMcAtLMDZD3XI5RfLonzHm3sRIqk8zTyhpHpHEMYlAMe
	 dgS3KJDrg0uN7cxD31YZmQhgs/eF7aeL2XkgEL66Co48Cf7iHeIT8+GbRMZl256WxE
	 TVg1wC7McEjOBfRfkBmygq5dkwmFNq1YszCVXHfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 4.19 95/98] usb: core: sysfs: Unmerge @usb3_hardware_lpm_attr_group in remove_power_attributes()
Date: Sun,  1 Sep 2024 18:17:05 +0200
Message-ID: <20240901160807.280589104@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -689,6 +689,7 @@ static int add_power_attributes(struct d
 
 static void remove_power_attributes(struct device *dev)
 {
+	sysfs_unmerge_group(&dev->kobj, &usb3_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &usb2_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &power_attr_group);
 }


