Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0436218E03A;
	Mon, 28 Oct 2024 06:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096930; cv=none; b=LGqlU1cO/6K/2Ntzi8s1Fh031G7eys69llk5VjQAico+qbVOUAqF0d84YbcMGWiRck1HTfnDw374OARSDri4NGWNlmdet0FElUfB+r2q+FAdKWXjnF5fO/pnfwv05cfwYgD/t5/KJi2Cpe8kibzpW54vFFr5HzLjYpRTsmkkzOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096930; c=relaxed/simple;
	bh=b8UauKl+zaHHhHOcabPOnBXITxSUG3jU5WwqKbZg0N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmC3FQGzn/f3O/oVLNvT5JvZCstqGBP+p+Wj75el5Md9YT9r5ZUX2KUY2BGCSAyz8i1pFcCnU1OJ02okkZZiDn97ebDwpvz3fJbr/vSfT5fxwzazYJERRjJ9MlZ1SW+4pdN77h9GUaj+EtSrUvrBrQI13kRY0dm5Aweb+/dmusc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hzq6zCuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hzq6zCuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBAAC4CEC3;
	Mon, 28 Oct 2024 06:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096929;
	bh=b8UauKl+zaHHhHOcabPOnBXITxSUG3jU5WwqKbZg0N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hzq6zCuBznVpnSdFEovopwCIPWao7UwCHbBoIVXMnlSDoDakwmq7JRMXVMif4Ke7u
	 J8o77ullXisM5ykgMWreXUYl6/gr2oCGtOs6zklKfCRWaWsNR2b+DHOcUbnYDEAJjw
	 MAoMD2k30/jYsN9ktQeoodQp25DVlVUma7PO+Akk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crag Wang <crag_wang@dell.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/80] platform/x86: dell-sysman: add support for alienware products
Date: Mon, 28 Oct 2024 07:25:29 +0100
Message-ID: <20241028062253.981556375@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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
index 907fde53e95c4..47f8c5a63343d 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -524,6 +524,7 @@ static int __init sysman_init(void)
 	int ret = 0;
 
 	if (!dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Dell System", NULL) &&
+	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "Alienware", NULL) &&
 	    !dmi_find_device(DMI_DEV_TYPE_OEM_STRING, "www.dell.com", NULL)) {
 		pr_err("Unable to run on non-Dell system\n");
 		return -ENODEV;
-- 
2.43.0



