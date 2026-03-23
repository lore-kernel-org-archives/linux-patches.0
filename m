Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E82284B36;
	Mon, 23 Mar 2026 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278263; cv=none; b=PqR/+83qyMOdAGPpxMGFh43nWCEWt+cEwQqE+lt52Iu5XhE1bLV546wxJOps7CM+bkL5Dy8kfqzwjp4qXwFMXcsu+uF4z7n2S11FryiGXuOjs30uNZuQV2YJZZkZcuknQQS5S0kcEG/chpjzJHtcB8Wyb/8Tc9IdlpINDKORr70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278263; c=relaxed/simple;
	bh=tfqQkNTlDyvl4rfmue+oW+EsJqZAlyw6S6QFYYCj8ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/sF8NmBiFfU7CcqY//UncVgG48fgjmZ22dDfu7FutMNgLMXGjTp8Q22tYcJiGUvlYxnT2PXYf53tLSYoquAgUFjVptPQyMnI0nAQgK/PKg24EVoZkkNu/gfM4ZO1Yd71TexE0HDltNL7ksD27ciYUNErAkSnxQKif+FoswKK9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nigxbni2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nigxbni2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8D3C4CEF7;
	Mon, 23 Mar 2026 15:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278262;
	bh=tfqQkNTlDyvl4rfmue+oW+EsJqZAlyw6S6QFYYCj8ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nigxbni2MXAezq839Pvfcr03IzcgPYHSM5r5tGKD4uGjMW42JlKm6UgItNlF7i4Po
	 FTAUTGWA2U2TJFq4xC6m0pO3VzVptMn9tr6bLYknfnmPwm1uwchkuIwrjRmPNOBG+H
	 Jd1/7tefI0i3F8ErfWpR7/vocx4QmOGl9Zxi7gJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/567] ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()
Date: Mon, 23 Mar 2026 14:42:52 +0100
Message-ID: <20260323134540.070678792@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f725813d0cce6..28527d246fc36 100644
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



