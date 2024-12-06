Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8044C14AD29;
	Fri,  6 Dec 2024 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496975; cv=none; b=A59f0QmIWUMpAZcsxzsEgGt32P6Peao+la/Ft/C647V3VHaKwH0rP9/WOeqYzj5YKStCgVnixd2e6pJBYC21fdaqW/G+KyXwBNuEdqvhGvzrQ3tmmUPVAqiHnxy+RTgXZ7ou9T8laE5uxsjXjS9JBOX8ME2jx5mh/2v1SZIrOMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496975; c=relaxed/simple;
	bh=m4I9FJrIIkmawz4VhrU1meu9Bm4w+g4f+Jhz55x0ZJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIf/jwlLaT01BMnNvfz62wZJ/Y8bymmH5Ascs7QiQKAb81kg7Q9tAhu7Earmzhfh91aPgLD8XMMECmGa3ZDgUQV+/g1nHptPABVVnZfaONe/PRVIWDth9zoW1c2KqEDKIozm8HrZuiknWuP4YYeregOIHUhr8+AhWnYssHfyhMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2W9lT9MU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2W9lT9MU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF077C4CED1;
	Fri,  6 Dec 2024 14:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496975;
	bh=m4I9FJrIIkmawz4VhrU1meu9Bm4w+g4f+Jhz55x0ZJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2W9lT9MU8WMVoStj7iSvEoITaSaYG4apuzy+myePcIx7yBzluL8xKIrxrfcuMpOUN
	 MEHk4Gc3JRAnphdKuJVU3DHb3cWsGK2IPSnSIdtgvTDmHMFgiueNWqmcDaMYfpxxBW
	 2d4oWrUZLKgRDTW5wN4cdAwAHsCzJ/8ukLBgB3cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org,
	Stephen Boyd <sboyd@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/676] um: Unconditionally call unflatten_device_tree()
Date: Fri,  6 Dec 2024 15:29:22 +0100
Message-ID: <20241206143658.938336026@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 221a819aa3ca5bbbc91ce425b3e8d9463b121d09 ]

Call this function unconditionally so that we can populate an empty DTB
on platforms that don't boot with a command line provided DTB.  There's
no harm in calling unflatten_device_tree() unconditionally. If there
isn't a valid initial_boot_params dtb then unflatten_device_tree()
returns early.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240217010557.2381548-4-sboyd@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: b2473a359763 ("of/fdt: add dt_phys arg to early_init_dt_scan and early_init_dt_verify")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/dtb.c  | 16 ++++++++--------
 drivers/of/unittest.c |  4 ----
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/um/kernel/dtb.c b/arch/um/kernel/dtb.c
index 484141b06938f..4954188a6a090 100644
--- a/arch/um/kernel/dtb.c
+++ b/arch/um/kernel/dtb.c
@@ -16,16 +16,16 @@ void uml_dtb_init(void)
 	void *area;
 
 	area = uml_load_file(dtb, &size);
-	if (!area)
-		return;
-
-	if (!early_init_dt_scan(area)) {
-		pr_err("invalid DTB %s\n", dtb);
-		memblock_free(area, size);
-		return;
+	if (area) {
+		if (!early_init_dt_scan(area)) {
+			pr_err("invalid DTB %s\n", dtb);
+			memblock_free(area, size);
+			return;
+		}
+
+		early_init_fdt_scan_reserved_mem();
 	}
 
-	early_init_fdt_scan_reserved_mem();
 	unflatten_device_tree();
 }
 
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 4f58345b5c683..7986113adc7d3 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -4017,10 +4017,6 @@ static int __init of_unittest(void)
 	add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
 
 	/* adding data for unittest */
-
-	if (IS_ENABLED(CONFIG_UML))
-		unittest_unflatten_overlay_base();
-
 	res = unittest_data_add();
 	if (res)
 		return res;
-- 
2.43.0



