Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5221CCB32;
	Tue,  8 Oct 2024 12:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392040; cv=none; b=MsWajaOW099Qyk0nUvDOYZJ8lpv59Wc5MLzkmieiEZpq70gzhVePnAdSsxahnO0MieKwBtxbKFNNDbIMDW16SHnb6CUG1Dr0jdS5xCmRUdcyhif88FqDOUBYfoeiENT9Za1ia3W5nfEqb62jE6kjTChvkwSyIxbbgPmVKAdoALU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392040; c=relaxed/simple;
	bh=FK1SCjel2tCIfilDCDBOffgDWfXUbFbDjwd43aIIgzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYW6WVNeunLTIUPqRrojD6M2K6kk/8FLAlf/UZ4tIBZcw89zz3UrQQPX/3AzCNKLzCsKfaMSksxq37jVgTHAHJwiHy3bq02SbS96nLN2iHylM45hHkSnmXnP4u7NaqRawhKcRmSpdOfGA9V8ENxyboHO28Kb0vf9ZZYsO5ajSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/RVGacn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/RVGacn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12719C4CEC7;
	Tue,  8 Oct 2024 12:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392040;
	bh=FK1SCjel2tCIfilDCDBOffgDWfXUbFbDjwd43aIIgzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/RVGacndxvqG2plAQ5N8R7MDTbAINyiqvYGhemp4yloBo+7TAROx73qCWMm31Uqb
	 FLurARXq+ZVkGiRQTgZl5bF9O/WNIIZa8F1fXQHRp+7+Bc6g3Bn9P/HXYPXxy5moet
	 fcPHXIQq06zS0mIkeVU/bv7viHwjlcwB0W0CE1WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 298/558] platform/x86: lenovo-ymc: Ignore the 0x0 state
Date: Tue,  8 Oct 2024 14:05:28 +0200
Message-ID: <20241008115714.047984002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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
index e0bbd6a14a89c..bd9f95404c7cb 100644
--- a/drivers/platform/x86/lenovo-ymc.c
+++ b/drivers/platform/x86/lenovo-ymc.c
@@ -43,6 +43,8 @@ struct lenovo_ymc_private {
 };
 
 static const struct key_entry lenovo_ymc_keymap[] = {
+	/* Ignore the uninitialized state */
+	{ KE_IGNORE, 0x00 },
 	/* Laptop */
 	{ KE_SW, 0x01, { .sw = { SW_TABLET_MODE, 0 } } },
 	/* Tablet */
-- 
2.43.0



