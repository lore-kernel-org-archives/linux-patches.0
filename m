Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E1931815D;
	Tue, 17 Mar 2026 17:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767447; cv=none; b=UgYcd8n9k6JN1GSh+kBprHVWxDWV+EAAQlBB9aRnmGLfQltb3CeQtZ06ezQGZLXgx1P2Ic5vxZwf5XcVQaQUNFPJEZ9aaq6Q5y8W0KSem9nHxgFcZ/FnvE8A9UNKh1IP0j19Xt79nuwhKDf4rhw9t2UUntvPyg+84PtD3eFzt8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767447; c=relaxed/simple;
	bh=8yz1xnnzqmy0QxdCvo8yJHvkZee3MqSijopnVjpl7OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaMP1oOBx1E1IW/fj9OUMjAmDXOaf267P1uOYBmFKR2FA+Zke0sPZnZ6tywES9fW2kWYxk9Lfmx/JXKQbNfvYH7xPJFLpWImwqO8X/10bq/rZBFR4ipC7uY9xdDVjp5Mu5VePNOo/kkfp474GiYFVKma/yIgEdOAcUNGFk79zX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhE9PC7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhE9PC7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17BBC4CEF7;
	Tue, 17 Mar 2026 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767447;
	bh=8yz1xnnzqmy0QxdCvo8yJHvkZee3MqSijopnVjpl7OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhE9PC7FeQ1NRHXcwYxa5AKRZ6BOYG18XOg+rCmE2ZG8xCBApfXCDm+/Du02ucpMM
	 g9ml21Sac5wleh7inh+xhlTNPmuHW9eLmQH4uTwFSaq7drmtJYJuiVxeze2bvqh9FR
	 nzBJHpohelmouCahhvL6PkxT+BtHa76WJfClPLHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/333] ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()
Date: Tue, 17 Mar 2026 17:31:57 +0100
Message-ID: <20260317163002.635806785@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5ff343096ece0..fd3ac84b596fa 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1681,7 +1681,7 @@ acpi_status __init acpi_os_initialize(void)
 		 * Use acpi_os_map_generic_address to pre-map the reset
 		 * register if it's in system memory.
 		 */
-		void *rv;
+		void __iomem *rv;
 
 		rv = acpi_os_map_generic_address(&acpi_gbl_FADT.reset_register);
 		pr_debug("%s: Reset register mapping %s\n", __func__,
-- 
2.51.0



