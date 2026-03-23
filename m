Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A7A3BF698;
	Mon, 23 Mar 2026 16:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282623; cv=none; b=H26Xm05r2NHpbc15Cf7Zx2L+/gUm6PY2mdKFdaHtSIh1ouJSAOsuG+/zlp4tezHN0d1FvSLbKPROzIdNrt2gGAhtmEGmRLnZ3y+UPTKRwjWe2duAgb7c6w0eya4fHfFV/hG+u5jihhx87rn5/FtSUCnLmBj+Ja4vQrogrDqEU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282623; c=relaxed/simple;
	bh=7WwfUp59ZieEOhEgWiY2Fp2IRwioMM0h54nwcI83kbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYSVI0UUr5odoPYtEg+7taOK5SyBW2HEZzMHhzJFfL3ETVdgein3nP5TfX6GMMzPX3dJ2MNDi3AqYBeVKT44Qv5RxK8EHHzkt8JJ+6snQ5rjh95jVu23Rw4zFQxTAupJOANvBEhbeFf37/5VSm0reByOkxl0OGtLoBTAsdra2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boXbiW7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boXbiW7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7821C4CEF7;
	Mon, 23 Mar 2026 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282623;
	bh=7WwfUp59ZieEOhEgWiY2Fp2IRwioMM0h54nwcI83kbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boXbiW7oEHPB/lb9vZtjuXzS3dPUbNJILGHJb8bteUhbTWk0kpr5OJWfVkXEonAkR
	 Lbu1DIOKltoqlAjandzT9VHS2xilCAV35VEtr4PhhqeA0YM8YxP3f78LgTErVeQazO
	 55odOSspCxTSiqj+O3tAaHcx2IdJEvPw4VFcS0nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/481] ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()
Date: Mon, 23 Mar 2026 14:42:50 +0100
Message-ID: <20260323134529.780941499@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 393815f57651101f1590632092986d1d5a3a41bd ]

The pointer returned from acpi_os_map_generic_address() is
tagged with __iomem, so make the rv it is returned to also
of void __iomem * type.

Fixes the following sparse warning:

drivers/acpi/osl.c:1686:20: warning: incorrect type in assignment (different address spaces)
drivers/acpi/osl.c:1686:20:    expected void *rv
drivers/acpi/osl.c:1686:20:    got void [noderef] __iomem *

Fixes: 6915564dc5a8 ("ACPI: OSL: Change the type of acpi_os_map_generic_address() return value")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
[ rjw: Subject tweak, added Fixes tag ]
Link: https://patch.msgid.link/20260311105835.463030-1-ben.dooks@codethink.co.uk
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3269a888fb7a9..d147c27bc6455 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1656,7 +1656,7 @@ acpi_status __init acpi_os_initialize(void)
 		 * Use acpi_os_map_generic_address to pre-map the reset
 		 * register if it's in system memory.
 		 */
-		void *rv;
+		void __iomem *rv;
 
 		rv = acpi_os_map_generic_address(&acpi_gbl_FADT.reset_register);
 		pr_debug("%s: Reset register mapping %s\n", __func__,
-- 
2.51.0



