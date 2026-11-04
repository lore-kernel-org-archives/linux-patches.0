Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829425;
	b=QTzOj5Yp7BELW0oL9zapqFiGT2F4WfpfAG12EVeRExultLx9KCToDEJsTtP8fIfLrpfB
	 kNcOQzug+TO+xMTGw35upCg9IJZc30r8fSrqDl1NKnKMOLbCrSonH/P3/UPoOY/dOSceY
	 b2C1yPb7XCvJJYjnHNZHv/Tb0rJ0i+uLLz47Q3LYTqJw9uj1Np4sMQUdtkPExvR9gBH7I
	 HK9KWaBvq2fufDSy3pcFISvvo6nDgikIqopbtvlOkJ1T81k24OY1dhLuTXPd1tUP8KHG7
	 0faJquY66O09/t0g4Tq9oDHGSyyYdX/1itOIt0Ll0JqZTEUTz6yEOBIF6DoFcMdk0Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0ZvbkBdHT4UCaVm64ZqoKfdXz+m+GtK7SmQ7Jw0ixxk=;
	b=f/YuH/4kfHtn8s5QfAdyJ8+XBnEE7l3xLDraMi0IjNnmPxtzoJFv0WEwYR26OU3p04Wq
	 hjRsvzEfvqnItYA/BmFvbx1sA415Xv6wyL42FJ+8Da6YtPnuOj1qY4ZOSlmLwu6Wl7g4a
	 8K7AjC8VzQkuz5jJ/GNNwHB2mCm5urH73A1DjbbIE5Y4u7AvGkH9ifcg8RKlOpaVvbC/D
	 7qFMi/QgNFlhe6x8iCfuu0fN33+LYuHUuyGhsVjB4U58wEiOmxEH6gICucuyrCXqahTrs
	 uYOZVdlgejzHfhbpfbh+JULa7Dce7PLQ+EdFkjdAy3CTgRpQw2jANMhfYpAKtHSZVkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oITMkcci;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75F606A85D;
	Wed,  4 Nov 2026 21:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oITMkcci
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C49B1F00A15;
	Wed,  4 Nov 2026 21:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829424;
	bh=0ZvbkBdHT4UCaVm64ZqoKfdXz+m+GtK7SmQ7Jw0ixxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oITMkcci9CBpnAgDAYN3MKBO+F/+CWysB20VfvxaHvIbHTfSO2Qog6YyjURwAnGuU
	 BOb5gNP9XuC7kDF7N3xMqO1XESqErCOSe/eXURxH62GpbR4vQ4kDu0X1BGlWPycu6x
	 QD1cOqL7gAnGsagaSsVgSx1dl4FTMGoC6xs555xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muralidhara M K <muralidhara.mk@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0118/1005] platform/x86/amd/hsmp: Validate ACPI UID before parsing socket index
Date: Wed,  4 Nov 2026 15:57:31 -0500
Message-ID: <20261104211046.970228409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muralidhara M K <muralidhara.mk@amd.com>

[ Upstream commit 4c7d1b4cd75a775326e6802608440f7642284ea6 ]

hsmp_get_uid() passed the device UID directly to kstrtou16(uid + 2)
without checking it.  A NULL UID or one shorter than three characters
would dereference a NULL pointer or read past the end of the string.

Reject such UIDs with -EINVAL before stripping the "ID" prefix.

Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260625123337.886435-3-muralidhara.mk@amd.com
Link: https://patch.msgid.link/20260629155634.1807598-2-muralidhara.mk@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/hsmp/acpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/amd/hsmp/acpi.c b/drivers/platform/x86/amd/hsmp/acpi.c
index d0b74d243ce4c..674be31654776 100644
--- a/drivers/platform/x86/amd/hsmp/acpi.c
+++ b/drivers/platform/x86/amd/hsmp/acpi.c
@@ -21,6 +21,7 @@
 #include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/string.h>
 #include <linux/sysfs.h>
 #include <linux/uuid.h>
 
@@ -78,6 +79,8 @@ static inline int hsmp_get_uid(struct device *dev, u16 *sock_ind)
 	 * bytes to integer.
 	 */
 	uid = acpi_device_uid(ACPI_COMPANION(dev));
+	if (!uid || strlen(uid) < 3)
+		return -EINVAL;
 
 	return kstrtou16(uid + 2, 10, sock_ind);
 }
-- 
2.53.0



