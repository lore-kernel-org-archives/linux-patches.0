Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2895918E04F;
	Mon, 28 Oct 2024 06:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097739; cv=none; b=lg7dcQ3ta/3iDLjMdAu3uSvJfJ6Me8lesQVhtk0EEtk+ppZEIqL8HACJjjroQGiySPA170fbRuQ3Xr2K3anPhancZkYJndp9YmNTT8+jxnUiSGNNy1eWRsGXf8/8RZumskcHnZ8crhJ3fqBLdPMVNczx1QEsyaqPX8qhSHyGOZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097739; c=relaxed/simple;
	bh=Hr/a4N4XWgGFsI4wlk+aaRwIkojV1hQ/wPkI8/mg0XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXJvQnouuMrbFrNlm8eDb6c1ZuiWpL2MFNgzL6y3nnpcbSMwjL30BdnL7W/w/bHmWM4I/Ldc+9Ka729DeifKAlM7LDOq5fMNXWEnvEzbrQBDWpx86s+8ic75aDxGQQAOjLBZV61a8vTiBenbUTcyT9QqkQIzN131nQpxW1lfZI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpD7VFZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpD7VFZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE578C4CEC3;
	Mon, 28 Oct 2024 06:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097739;
	bh=Hr/a4N4XWgGFsI4wlk+aaRwIkojV1hQ/wPkI8/mg0XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpD7VFZbYU68VVFqE0KeeXH15ZHC2qSra7cnH8kenVtX2nvCWHxivIDiCiHegl3py
	 U2fNnF/ii5uUiyjtQ3+r/x4aqAHOkNooDvB3meMOPM/hdcvG8xFN3LY9J5B8nox2AJ
	 6pi9x+EhnY7dtxExZMKo4qj3sQVZs28xY3vUKQpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crag Wang <crag_wang@dell.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/208] platform/x86: dell-sysman: add support for alienware products
Date: Mon, 28 Oct 2024 07:25:06 +0100
Message-ID: <20241028062309.746079069@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b929b4f824205..af49dd6b31ade 100644
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



