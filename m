Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A378333F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301126; cv=none; b=hMhVcSNDQqXxG5xy/6eV2Sz3vGaHWrUxN7wlTBoGX20ATWOYhKkSuLRjTznSRuZJnvrXJjwZ8q8dQ3XL58TQJ943ZwjEDYbxLnvxKPgrCS9pFyHemgVlg/dlexrtB2rCoRfYQ8NbzjhNyrEkN9zrtXHFOxX9WeBBP6JXs5uB8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301126; c=relaxed/simple;
	bh=F8Ybvyi6GeD2bc1+/+CcnyLiv8/CjxRPhCgmqh0qwCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKSz/0Y2cnOIureBSmAX6ghytsPop8teDXv7MzbEKyAqkr2joN8492QDF+TNshBEkb6vIjH5hCYalUGTfXvTB35TIh8Y0RwjeYdkH5jtRANRzbSNgRQjMGj/YYUT3mEax8Wzh8x6jzvmy0YWaxoWJ+SdGWSWbwSzYhO6X7KOR9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t14+yF/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t14+yF/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8913C19425;
	Sat, 28 Feb 2026 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301126;
	bh=F8Ybvyi6GeD2bc1+/+CcnyLiv8/CjxRPhCgmqh0qwCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t14+yF/sAocTIsxzTCMXEy3MqvAvBhGK0l76ncMK3OSudUgpVr9Nt3SMZ7jJkkWLU
	 ax8GVU7IetxIziFti/KEf96RvSpWTjYY3h6D8Uie3x77KJTOQsfc+0A1IqBOVkrOa4
	 YLvyaSceLuoKee+Qg9V5Ylleoco8rhKzGlfzxl/901Y0ebfXD3Ga6AqRyDh/OF6tx2
	 uQ5+j4f8s9xZsH3XgeueMY5nuaLrmvRdK2cVrKqjQNcFvZcqL+U4dAjyUsPefQ6OFI
	 n2SWWsJMamZE9iokRN4Fi9YoJN3p+74oWUG1RlOH6D0e7PYh1u0xPQHtVzreMHMLr5
	 kJrOWwJpx0Oow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Woodhouse <dwmw@amazon.co.uk>,
	Babis Chalios <bchalios@amazon.es>,
	Takahiro Itazuri <itazur@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/752] ptp: ptp_vmclock: add 'VMCLOCK' to ACPI device match
Date: Sat, 28 Feb 2026 12:39:56 -0500
Message-ID: <20260228174750.1542406-285-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit ed4d23ed469ca14d47670c0384f6ae6c4ff060a5 ]

As we finalised the spec, we spotted that vmgenid actually says that the
_HID is supposed to be hypervisor-specific. Although in the 13 years
since the original vmgenid doc was published, nobody seems to have cared
about using _HID to distinguish between implementations on different
hypervisors, and we only ever use the _CID.

For consistency, match the _CID of "VMCLOCK" too.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Babis Chalios <bchalios@amazon.es>
Tested-by: Takahiro Itazuri <itazur@amazon.com>
Link: https://patch.msgid.link/20260130173704.12575-6-itazur@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_vmclock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_vmclock.c b/drivers/ptp/ptp_vmclock.c
index b3a83b03d9c14..cbbfc494680c7 100644
--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -591,6 +591,7 @@ static int vmclock_probe(struct platform_device *pdev)
 
 static const struct acpi_device_id vmclock_acpi_ids[] = {
 	{ "AMZNC10C", 0 },
+	{ "VMCLOCK", 0 },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, vmclock_acpi_ids);
-- 
2.51.0

