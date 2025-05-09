Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF9269AEE;
	Fri,  9 May 2025 10:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746788287; cv=none; b=OJN+wSE0Kmz8HG0fbGqhC7NalYaW/RfVtpCRB/JXsYLlh447Y/bQIIZtusaEFbVnSmJhFgG2xaUj+9ypqZWH5vzDk6TBfjdytHbMStTeZFIt0IveHi4Eyvm/USQoPGAcSrB2xJERynkV8050U0mmB1D9sUqAS1INExgMAMRDQkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746788287; c=relaxed/simple;
	bh=Ob37pOMqnXBZIHadN4tX/Ro7PwfUMbXIaw5YzlFxD6k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=uSqsmhpAJ/dm7aoLuDN67Unfdl1jMLE5qKD2Ubk2QF/qpOEwwyVVIhUkTp3B+XkzjSD1QgkD6iHs6WmVv0b0xRhaXKRrjKbkx/0Yb/oRe004ciskJLl3k0mBk0AjwGCQNUOaUyCpoA3hsGLaDIHlINPfVymQKH5+RHMA41MEjKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOH4Ha+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOH4Ha+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8D4C4CEE4;
	Fri,  9 May 2025 10:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746788287;
	bh=Ob37pOMqnXBZIHadN4tX/Ro7PwfUMbXIaw5YzlFxD6k=;
	h=From:Date:Subject:To:Cc:From;
	b=KOH4Ha+bXDRPcAccfce8JgYpzjoB9IckPltJqufP6ipaYC7wV2znMKVDfSWxpB2X4
	 aP+nREyXBRC8wgB4TeWgNzvF+zJQgx3BBOAvlggQPGcKcUL0obkiznaY7Tu2oUjxJl
	 oW1+DyJo4+FeSmliyd57DtJ6pSvET01XOEKk0L9E5+0DYYxjqEQgFsfRrRVggn/Dsu
	 tCc/IoLuAfVN1kJrkgiicKrV5DNEpAXHo5vOKEYsXPh2T9Cv3Mvl40ri6cMFALetuh
	 vebZmGXf+UFUEStB+ev3JxhFOP/BO9T31Uxk4Z4UVg7x1bCzpzYhT3xE7Wu/pR+NVp
	 06rSPppUH+X6g==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 09 May 2025 11:58:01 +0100
Subject: [PATCH] platform: mellanox: nvsw-sn2200: Fix .items in
 nvsw_sn2201_busbar_hotplug
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250509-nvsw-sn2200-fix-items-busbar-hotplug-v1-1-8844fff38dc8@kernel.org>
X-B4-Tracking: v=1; b=H4sIALnfHWgC/x2NQQqDQAwAvyI5NxBDt7V+pXhYNWrArrJRK4h/d
 /E4MMwcYBJVDMrsgCibmk4hQf7IoBl86AW1TQxM7MjRB8Nmf7TATISd7qiL/Azr1WofcZiWeVx
 7fPPLEZEvnm0HKTVHSe69+VbneQHKAcObdgAAAA==
X-Change-ID: 20250509-nvsw-sn2200-fix-items-busbar-hotplug-7265000a84df
To: Hans de Goede <hdegoede@redhat.com>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
 Vadim Pasternak <vadimp@nvidia.com>
Cc: Michael Shych <michaelsh@nvidia.com>, 
 platform-driver-x86@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1716; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Ob37pOMqnXBZIHadN4tX/Ro7PwfUMbXIaw5YzlFxD6k=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmy9/eyhrKrSD968/nb4dx0b+6z6pPyfJnzxBc3z3jqP
 0Xl34XzHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiM+cyMry7/ObnNMmcG5/+
 7/qTy6K00WmeHcPafTuuMaia3e08HybF8E9ldu0Dk+s/tk5jyTRe9pzrA+8Knd/uAYt+KByX87D
 lC2MFAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/platform/mellanox/nvsw-sn2201.c:531:32: error: variable 'nvsw_sn2201_busbar_items' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
    531 | static struct mlxreg_core_item nvsw_sn2201_busbar_items[] = {
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~

nvsw_sn2201_busbar_items is only used in ARRAY_SIZE(), which uses
sizeof(), so this variable is only used at compile time. It appears that
this may be a copy and paste issue, so use nvsw_sn2201_busbar_items as
the .items member in nvsw_sn2201_busbar_hotplug, clearing up the
warning.

Fixes: 56b0bb7f9069 ("platform: mellanox: nvsw-sn2200: Add support for new system flavour")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/platform/mellanox/nvsw-sn2201.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/nvsw-sn2201.c b/drivers/platform/mellanox/nvsw-sn2201.c
index 8c31189a94dd..db31c8bf2255 100644
--- a/drivers/platform/mellanox/nvsw-sn2201.c
+++ b/drivers/platform/mellanox/nvsw-sn2201.c
@@ -551,7 +551,7 @@ static struct mlxreg_core_item nvsw_sn2201_busbar_items[] = {
 
 static
 struct mlxreg_core_hotplug_platform_data nvsw_sn2201_busbar_hotplug = {
-	.items = nvsw_sn2201_items,
+	.items = nvsw_sn2201_busbar_items,
 	.count = ARRAY_SIZE(nvsw_sn2201_busbar_items),
 	.cell = NVSW_SN2201_SYS_INT_STATUS_OFFSET,
 	.mask = NVSW_SN2201_CPLD_AGGR_BUSBAR_MASK_DEF,

---
base-commit: 3c415b1df95c06ae4f9bdb166541ab366b862cc2
change-id: 20250509-nvsw-sn2200-fix-items-busbar-hotplug-7265000a84df

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

