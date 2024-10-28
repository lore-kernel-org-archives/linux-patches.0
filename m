Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC038837;
	Mon, 28 Oct 2024 06:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098247; cv=none; b=Mjh6GAYg6vt2Y4DcFlPcufmJlXziPFxE4MZEgjLe5S691Q/48V15iX1pHJHpObigFJj6Q8QKEJLp1hMkrPZiUrUDVYvyo6GsahUVrOny67SWKV+qMBiB7ldznRaD+9OtX39A4YNh/DGol2bL+KGbyb2xRiViXXFvj6mWq3G8sag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098247; c=relaxed/simple;
	bh=257HunH8HrP1LIwaqAt/8FOINRRfp6LAU7mhSwtscl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GP/qtqa48t/HvoYQB438brZ5q5KZu+/X/voWlCzwyDlhGepgzC7Fh4Nhhmx8/Y8VVmMRg24BkJou+b+RM0OmXdCHJzuEWLTcbRXKYUIPwEo9X0O4aDhUNbCX8LgBO2HTKVN7uY71c+kPHW3vTQwpD6g57nO2DgAFsMWIiL+Ia6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBctouQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBctouQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F367CC4CECD;
	Mon, 28 Oct 2024 06:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098247;
	bh=257HunH8HrP1LIwaqAt/8FOINRRfp6LAU7mhSwtscl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBctouQ41I7WJI2kI1a0y1/2n9BIV2Hzs/lpiS84QiuUPy9qtZ571MpjXCpIvM+ou
	 URub0ahezkemAwC08ARBE1ZSYGhI1fFCZ6xzTrL1zSyeoFggSF8TPXlRyaRrOA9qoP
	 Am+TiUNj34tKqcXYagg6+h9JoEJe9bPWWYSXnp8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crag Wang <crag_wang@dell.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 135/261] platform/x86: dell-sysman: add support for alienware products
Date: Mon, 28 Oct 2024 07:24:37 +0100
Message-ID: <20241028062315.426067037@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crag Wang <crag_wang@dell.com>

[ Upstream commit a561509b4187a8908eb7fbb2d1bf35bbc20ec74b ]

Alienware supports firmware-attributes and has its own OEM string.

Signed-off-by: Crag Wang <crag_wang@dell.com>
Link: https://lore.kernel.org/r/20241004152826.93992-1-crag_wang@dell.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index 9def7983d7d66..40ddc6eb75624 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -521,6 +521,7 @@ static int __init sysman_init(void)
 	int ret = 0;
 
 	if (!dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Dell System", NULL) &&
+	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Alienware", NULL) &&
 	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "www.dell.com", NULL)) {
 		pr_err("Unable to run on non-Dell system\n");
 		return -ENODEV;
-- 
2.43.0



