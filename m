Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029819;
	b=TrVGDQeGUQF9rA6rA9F70jxOmg0JRSHSxb7hlH9w91yFUHZtkMwCLi3rZFD1uU8mLizu
	 NAKyvrsGVzwdBC2pMgBMqb67E94zrbZt3IQ6j6dCDWexi0AKACPPiw4SFPbMlruSZZ7an
	 VSWHvTEwWz12/7xhYRbplshjhPwWGtiihtNIhkANCmkjRn/PGShP20lcsrTIc/nLROg/6
	 woqz45FOUlPsNvN/ffZcjEmOGtnlAxwA8zGSwYg8BpVKIt9j392R1QXORi2uhxAv5Y/W8
	 Mvdv8nUOliLqnBUoAJyVXqdH3Rr76rvCHF54zzY4W+W2E4Jdy1rRYsM/U5+sIyeUsLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2ivuGD8ZeikY4mNB8dxOvzw32aBzP8BZZje/RA2gYc=;
	b=XLHGWSiahVLndUex4Bq9ujXvfwzeb1nzdMIhOrYh6lX4j332MWSZE1faJ01McsS+ePoo
	 HdT+/weBN+z3Dqu6oQ+jQoNXfjbMlxCoJZRKUi1+hLqEDqeai50NZt+sEE0g64/pw5eM7
	 JFQVKl2wUtqyM0FuyRn8sQtvsrp0zirbq2fElibnLgf8pV/JA/99+FccvYubI35MCnzhR
	 5fzqDUC4qGudRDdVWt1I/6tb2hRXiiJohvVvGVKnlEYeTja10IXvMGIsonrSFdwX7fFen
	 P9VayEH55p+anmn4/z84VIZxP2CvG8NDhadfBc4v+ndUwqvXTr7/Idp3DvMWNcPNzyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kw100kvP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E39606A31C;
	Wed, 18 Nov 2026 19:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kw100kvP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B541F000C4;
	Wed, 18 Nov 2026 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029818;
	bh=M2ivuGD8ZeikY4mNB8dxOvzw32aBzP8BZZje/RA2gYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kw100kvPCTF+C3JWZ6UdF8hBeHEx6YkrVGzqdJm3P3GWWo8JreI2GaNI3sqiLvVKJ
	 vKNETrBEwZ5oR1wRQaNiqfhOtaZfvs9y1Ki8Z4HeBMWKJV2ZMtTqi9thSRViFsMW77
	 IU4tqeOd6qjRRbmBzXFORmqeNiIM1BvnQ5RExcDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0468/1756] ACPI: HMAT: preserve hmat_adist_nb notifier block
Date: Wed, 18 Nov 2026 15:43:15 +0100
Message-ID: <20261118150027.487373131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alejandro Lucero <alucerop@amd.com>

[ Upstream commit b1c75a77d494298b8dedf46062f2072239bbc33b ]

Remove __meminitdata from hmat_adist_nb declaration preserving it even
when CONFIG_MEMORY_HOTPLUG is not set. Otherwise further notifier
registrations using register_mt_adistance_algorithm() will find a
notifier chain likely corrupted.

This is the case when cxl_region_probe() calls
register_mt_adistance_algorithm() what can happen when CXL regions
are dynamically created at any time from Type3 device(s) or when a Type2
device is initialized at its driver probe.

Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260716181114.35962-2-alejandro.lucero-palau@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index c805d63df54ad..526ca27de0ca3 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -984,7 +984,7 @@ static int hmat_calculate_adistance(struct notifier_block *self,
 	return NOTIFY_STOP;
 }
 
-static struct notifier_block hmat_adist_nb __meminitdata = {
+static struct notifier_block hmat_adist_nb = {
 	.notifier_call = hmat_calculate_adistance,
 	.priority = 100,
 };
-- 
2.53.0



