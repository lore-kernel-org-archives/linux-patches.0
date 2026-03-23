Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11FF38C41E;
	Mon, 23 Mar 2026 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275378; cv=none; b=ktVdn65K1U8JgvQk1hWey6Bfj8CZENgI8jVrV3nist+gPFezs4qtCS7x5HtC25ut6Zhlm5urVF5A+DTaFVx2+3AyrWMm3D2U2aNwRQ1APiICXFJcBxg6kFvEjChbVo0urxo3BYlKeV2q6BeGMQhXBG6i6faluFgb+5Fz1jsi2iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275378; c=relaxed/simple;
	bh=n2Ne/uY/LveVWCdf4h6rSEQH1WEAzcvjUD30tx2kWMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4odC+LsG3sv+FXFiAMuezD+Oy6xATuKyx6qhp+H928H8a6IgyLTC//dfBnvsAgKc7VqT/P9I42np3U7RYmRrPyuq7gEFCRf+tPNHlVFRZMOPjnekODhBYN2U685EFBtStjS+Y51xKWpWQNcOVc/7CAbqJhYiX09ftEV9AxAwEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhJRclxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhJRclxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE12C4CEF7;
	Mon, 23 Mar 2026 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275377;
	bh=n2Ne/uY/LveVWCdf4h6rSEQH1WEAzcvjUD30tx2kWMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhJRclxB/BC5M81YQ8tLx2lqN9estUP/uiajQ5hfAFRmPAR40bzUBxIwSl++Xc23v
	 AkKjh5R3qwz1i1+E1Nnpe09NvhJtaLuJApN7BeewFaedJ1AxmN2msJ0GMEs4LOXlME
	 kRQS6KZEeU6kh86jIQcYD/NBQCnB/PCco92BuYaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/460] ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()
Date: Mon, 23 Mar 2026 14:41:13 +0100
Message-ID: <20260323134528.577726235@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 70af3fbbebe54..6537644faf381 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1649,7 +1649,7 @@ acpi_status __init acpi_os_initialize(void)
 		 * Use acpi_os_map_generic_address to pre-map the reset
 		 * register if it's in system memory.
 		 */
-		void *rv;
+		void __iomem *rv;
 
 		rv = acpi_os_map_generic_address(&acpi_gbl_FADT.reset_register);
 		pr_debug("%s: Reset register mapping %s\n", __func__,
-- 
2.51.0



