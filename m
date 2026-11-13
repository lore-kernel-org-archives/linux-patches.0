Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591624;
	b=3FuZVS2PvFLvqyU2fnQ1zyAZJQrZvoUAtKsbAysOtXAHPI2P8LtmdJ2Gong6uAvvAW0a
	 LWkP+mHpOZXLMO9cTWX0WGA7aoNWBIVdXfjl2RvAeoDVC6Jc8kxAoykfNM0NTlw0i63aA
	 y5VhkHoYLw38J5OwUWLrrbkBsxa2qXpkbGeyM5Gevs7th8A5Cw6z71bNy1aeYGDok4yHv
	 qGIheikMcQTA9yt7/s77mpC2HZKPosoOTrfBiOrhw3NTdZbybldUfZ2ny03PPACXY0b/r
	 W96bk/b8u0heqQB6oZemJaZQXxyC0BFdtZ+ONkJ7qNM0TNX0ab6rBrawsvcmmhcz0Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rvZoCaCg8Xco1yqImhuFk1hugQ7Nzkd2CJj1tKKED8g=;
	b=xbpG+UaxmQC7g3TE7f8zpeX0PS9XKiUWQw+I2qsC0rE0343CLnX0qHV+YwMkXwFP/3L7
	 S1L2/QeEmljIRzmxDfNVadLxRqezWsZic83Ww7xUlnYjrONE6rX2aQdmpavT20iDHDOt3
	 RbHIlYtOShCfLXpvNzcNmPCwZt7qIx8ET2iXlibOMlDCJ2Cn0zqY+T7K2UifcMspaYqZ6
	 AhxDX/J+TkdWtC5XYUZwIQZexQUKeEuO5LO17Jw2UYNtjc2Y95M9bGB2hiv2VFdFF6SAN
	 Vf7aoDtISNpUdFNQiBeMMwkhI4WdlbCE7epIfXinpn+pVOdcN3rlGFc3TVy85023erQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eY3NT869;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2307A606E664;
	Fri, 13 Nov 2026 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eY3NT869
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D0F1F000C4;
	Fri, 13 Nov 2026 17:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591624;
	bh=rvZoCaCg8Xco1yqImhuFk1hugQ7Nzkd2CJj1tKKED8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eY3NT869BY8lA9aXwfCFd+KK4QYDJcUHBXXydkm8fRUtJy+sLr10Fss51udCdas/E
	 IPZh5rvL1n7IclHDIYCyY/Hao7P7EXAJsCdnfWXKs9Ff1zw2wzXkZiI/ZLWGq561CR
	 IcTkqdmAk76oNvTWjRiGIJg0rYbzUwF9RELaFut8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 664/670] platform/x86/amd/pmf: Add AMDI0112 ACPI ID
Date: Fri, 13 Nov 2026 10:53:48 -0500
Message-ID: <20261113153834.395397349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 325bcc126cf7a512a0e2da0efddad665f69badac ]

The AMDI0112 ID is used to bind the PMF driver to some platforms.
It doesn't have any Linux side code changes relative to the most
similar AMDI0105.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260826163611.2268377-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: adjusted ACPI ID table context due to the missing AMDI0109 entry ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index 496fea1389fca..2039c9d90f87f 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -467,6 +467,7 @@ static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0105", 0},
 	{"AMDI0107", 0},
 	{"AMDI0108", 0},
+	{"AMDI0112", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.53.0



