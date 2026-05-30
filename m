Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7483F17555;
	Sat, 30 May 2026 18:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165497; cv=none; b=YldOop+BhmpnljzLx7xKgmr67q+ZaYMgmvlQxEWqScp4RePdpQh0cpcu4tCgc3B8NdQ/1yWjL/FDao5hEvyU4Qu+NRL84ivrtY+mLn8DcUgUzlP0FSu+0jYVS6twgFft2T0XUJHT49TF2Q6ZbEf+g6U6llLeu37MNGZTf3DACak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165497; c=relaxed/simple;
	bh=C58atzpYPE360QQE4BguFKXhb80ShZ2T4Hn9jBcGnPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIbckTWt2P3P13evsuSpIEBiLpLnaFbVW4yCv1US+8wy7lKJNpAPzMhC3LPwmjKHbUHkf7oBVlByhlodDVvwwsH7Ex8Q39RO3Ufz9hAPaHgA/Y1VMiUr5z9AQ5LGfURyEF0rOms7RTgPGvTVrlJ3JxnpHy9puCywBfNHr/6RR/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZypNYVyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZypNYVyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99CC1F00893;
	Sat, 30 May 2026 18:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165496;
	bh=X04e7vKrO5U5bLJJ7d5HGbInkjDCHS4Auc5+oGR0/0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZypNYVycDl66KP2Lpy5CQvuCVvCfwb6r07O3CB75kyZIO52IixAtjujQ/XTiSl8of
	 MZDvUfDF1cGUFVOhj9AxW7WY5lRQhDwdPZvjjh4aZrbvLrnmlKk4zu0nCHjqJyDNFQ
	 kCR2fHVqe2SJkinA2JaG/ckhecHg39RRhBa2w7gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/589] ACPI: property: Constify stubs for CONFIG_ACPI=n case
Date: Sat, 30 May 2026 17:59:07 +0200
Message-ID: <20260530160226.334699224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 5c1a72a0fbe1b02c3ce0537f85f92ea935e0beec upstream.

There is a few stubs that left untouched during constification of
the fwnode related APIs. Constify three more stubs here.

Fixes: 8b9d6802583a ("ACPI: Constify acpi_bus helper functions, switch to macros")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 9c184dbceba47..c5b51d8dcbe18 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -753,7 +753,7 @@ static inline bool is_acpi_device_node(struct fwnode_handle *fwnode)
 	return false;
 }
 
-static inline struct acpi_device *to_acpi_device_node(struct fwnode_handle *fwnode)
+static inline struct acpi_device *to_acpi_device_node(const struct fwnode_handle *fwnode)
 {
 	return NULL;
 }
@@ -763,12 +763,12 @@ static inline bool is_acpi_data_node(struct fwnode_handle *fwnode)
 	return false;
 }
 
-static inline struct acpi_data_node *to_acpi_data_node(struct fwnode_handle *fwnode)
+static inline struct acpi_data_node *to_acpi_data_node(const struct fwnode_handle *fwnode)
 {
 	return NULL;
 }
 
-static inline bool acpi_data_node_match(struct fwnode_handle *fwnode,
+static inline bool acpi_data_node_match(const struct fwnode_handle *fwnode,
 					const char *name)
 {
 	return false;
-- 
2.53.0



