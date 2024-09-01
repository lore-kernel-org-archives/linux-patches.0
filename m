Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A798C183CD4;
	Sun,  1 Sep 2024 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209092; cv=none; b=AlCgmm2XPiGT0ms3kEBNx8Um6adBSo/Njozw1bYAol9l5trKULnHaDnyi++2V8Gu7i4RqgIbLvEPkYg+vM42JF0pE1f5iJNyYzwAhVrBthvw5BOifqXFXE7UXyse2gykuzpzdUYUTK9cFek6MRQhRIzR/BCj1HWsd6+LWKNI4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209092; c=relaxed/simple;
	bh=vQcEaRKQrNEUo+zlZuF+3HKUxss8v+sM2z718yUmHHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz4DiSBmMJxNq3CAHi8ugtfvvHvkgqM1fDq6Bb5st1f1lRNlIy0LCRzlI3VD3j/eksrpachq6H3TNGq7ngbMl1XmLLr06+0VdZwRclXDmm3ugEyY1JxXzYFkCbXdd8Tft2YwmXIr4RPx+EexItca8t9gd7kMn8bV7DuOo82c6Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBnAeEUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBnAeEUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3113AC4CEC3;
	Sun,  1 Sep 2024 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209092;
	bh=vQcEaRKQrNEUo+zlZuF+3HKUxss8v+sM2z718yUmHHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBnAeEUv7t4Xenvg8nDJ2B5wJx2TiLiqLF3iwRYUxftu/ZJPHPNVizJvus1IdBDBX
	 +7EWTXqcouEFYjvr55VHyN68Nbs7azND9LCAHdAOgxmM9OS4F8emn+6BHtiQKCVorg
	 hS8yx+nhkRoYUn4rD7JEo0ubJJ7HK1HK3s7fSH6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.4 132/134] usb: core: sysfs: Unmerge @usb3_hardware_lpm_attr_group in remove_power_attributes()
Date: Sun,  1 Sep 2024 18:17:58 +0200
Message-ID: <20240901160815.044042059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -690,6 +690,7 @@ static int add_power_attributes(struct d
 
 static void remove_power_attributes(struct device *dev)
 {
+	sysfs_unmerge_group(&dev->kobj, &usb3_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &usb2_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &power_attr_group);
 }


