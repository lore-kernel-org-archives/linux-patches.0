Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2AD1DF27A;
	Tue,  8 Oct 2024 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393520; cv=none; b=lc6tBKTwCMf+9pe5Uy7G8YS70FRAIinhuHZNYg9yYNgwffcaq1r7GHpNpGXRza2zynHUwH3GoYnIOd/TmGsEGblNw3DLZndx3GhupgId18323xkuUV08y6IdJR/M9DA3xt4mI87Q9zifzxjlmlVNSw4K3RC3wuvSYLro/7WNWnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393520; c=relaxed/simple;
	bh=VMZsKRIoxL8/jjVx9eDJuCBAiNxQZbQ84eMQ6zo7+O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnGCSf/UecC2zKZsd2b97xumDS6UnmQ6TTRZaC8ofgxkds7O41KhKYcB2XY/vR0bPylrx4BFr05B7hQ2nxvUHeMnm+1T+FmZ+erw4VqjPl+QbgOVSXyawLH6jmeKHpHQidYbnpuAXNApmPHl3DgAiiO3n7P3VXo0e1/j4J0I7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3z/wu10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3z/wu10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F105BC4CEC7;
	Tue,  8 Oct 2024 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393520;
	bh=VMZsKRIoxL8/jjVx9eDJuCBAiNxQZbQ84eMQ6zo7+O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3z/wu10Ewcjo2DmlQP7g9WZjOHNgVs2+oX/NGkJjVBOufjoWR4JeIeEud1VlYVx0
	 hdNCEgW4FOMCfRUc/vjltEy5i+lRsFhUJJQ+grtEIXkXhNbcLPeR+7zSp1bsYInz/G
	 bxk5ASbYrtHjzKFsDRYi3ClGt9DE+LK3PRF9FhGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/386] platform/x86: lenovo-ymc: Ignore the 0x0 state
Date: Tue,  8 Oct 2024 14:07:01 +0200
Message-ID: <20241008115636.344266519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit d9dca215708d32e7f88ac0591fbb187cbf368adb ]

While booting, Lenovo 14ARB7 reports 'lenovo-ymc: Unknown key 0 pressed'
warning. This is caused by lenovo_ymc_probe() calling lenovo_ymc_notify()
at probe time to get the initial tablet-mode-switch state and the key-code
lenovo_ymc_notify() reads from the firmware is not initialized at probe
time yet on the Lenovo 14ARB7.

The hardware/firmware does an ACPI notify on the WMI device itself when
it initializes the tablet-mode-switch state later on.

Add 0x0 YMC state to the sparse keymap to silence the warning.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/08ab73bb74c4ad448409f2ce707b1148874a05ce.1724340562.git.soyer@irl.hu
[hdegoede@redhat.com: Reword commit message]
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo-ymc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/lenovo-ymc.c b/drivers/platform/x86/lenovo-ymc.c
index e1fbc35504d49..ef2c267ab485c 100644
--- a/drivers/platform/x86/lenovo-ymc.c
+++ b/drivers/platform/x86/lenovo-ymc.c
@@ -78,6 +78,8 @@ static void lenovo_ymc_trigger_ec(struct wmi_device *wdev, struct lenovo_ymc_pri
 }
 
 static const struct key_entry lenovo_ymc_keymap[] = {
+	/* Ignore the uninitialized state */
+	{ KE_IGNORE, 0x00 },
 	/* Laptop */
 	{ KE_SW, 0x01, { .sw = { SW_TABLET_MODE, 0 } } },
 	/* Tablet */
-- 
2.43.0



