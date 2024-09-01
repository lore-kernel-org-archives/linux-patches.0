Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6D1DFD1;
	Sun,  1 Sep 2024 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209801; cv=none; b=WxmjB8FXoIBrfUGlIEofkdb08C6gRMYhSi29UlU1gmfRO+mpdZr9kq/Hj+S84hkcavcbHjcTpxAyuKT4NoQzb6id//47XSIMpqh1CsvAmMYwRWNP+1ftZvEkh9NrWaQo+MPu3DpQs4ZUUzyn+laxKmfSlcsf5b2l17SB06zavBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209801; c=relaxed/simple;
	bh=FXUbYqUkYjNEnUKFeiIqcibTN8O7jOF50ktXi0kxYZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGR7CuS24kZrgpkuvy/3U5SFK7sPNNnlcumrhzasBFrl8PJ4bnVJLFvIBk0OLsdvcQILipfVGn8/kwbhSFrqm3s9zkerdCIQh2dl3pIETddYkc4i2sb9mjPfkW1yN3iGpOIJbY2R14Hsw9wH4F4ksZcuQRSozxxgFxQoSrfyLCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ljk/DytE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ljk/DytE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEBFC4CEC3;
	Sun,  1 Sep 2024 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209801;
	bh=FXUbYqUkYjNEnUKFeiIqcibTN8O7jOF50ktXi0kxYZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ljk/DytExLJOD/1+jTmKaqxuajHfNRs0NAiDb0EZf+d0u/zAWZz6jg8h72Xaag3oA
	 vTrTFpV9BeiNjBVNhY6/l5pwcEpWjSWXLuYFhRCi201A0W38bE0YEThFbIBLFNDj+v
	 bOCkCyItRZjt7l/xbHPxIUgdgsW0wlPVwxoaG1Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.10 149/151] usb: core: sysfs: Unmerge @usb3_hardware_lpm_attr_group in remove_power_attributes()
Date: Sun,  1 Sep 2024 18:18:29 +0200
Message-ID: <20240901160819.719007501@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -667,6 +667,7 @@ static int add_power_attributes(struct d
 
 static void remove_power_attributes(struct device *dev)
 {
+	sysfs_unmerge_group(&dev->kobj, &usb3_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &usb2_hardware_lpm_attr_group);
 	sysfs_unmerge_group(&dev->kobj, &power_attr_group);
 }


