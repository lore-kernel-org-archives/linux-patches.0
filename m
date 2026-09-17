Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB0A4E3224;
	Thu, 17 Sep 2026 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664044; cv=none; b=DAG2eEmHn/KR1364+6wbyRYfz9aRY8hMemlwGG/huRR9jbkewNLwDa54olQzY+1wierobkM4OU2SKRfBVWy5oqzyxMLRh86sNjnIem93uYOInM85Ip1D+7jTpjYQZdfhu8hlEEvVq+tPflLMR2TvBfu9A8eMguv8XSVMxUReGhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664044; c=relaxed/simple;
	bh=GBmj4fOVEgOcF8gWXi2Cm6xzHGXsi5l0B1r5UV06NT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCwPx+C5iUVUVm+1ia4H8B6OTt58jDcLaeWeEaPkYhJxo+JKg2yiulbpNztHmppRfvdG0rLXjbLorikjhI9wotJVhCMiVKSNTcXJqR7lVdWnBOGXFOf6qWOSQhIL4SvVCzXWlnKVr07Vs4uyM6bVhaK+irNwxdPgCl6GBZ32MG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwkxiD7B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwkxiD7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09C61F00893;
	Thu, 17 Sep 2026 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664043;
	bh=925J4vCmU1fIpHCMVKDIM9nP5Im32CLZVlzmi87sq9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwkxiD7Bqm6/KdwhMHrkwYWoFpIlKB0uKzuuH6TCswD4khDgmVzpHK6nmampAIz+P
	 ALZaea5sKDbZ+D2BmTwVSGe5nfDp0XNAAlEd6UR5WbfEAl15wp6RPDrQ6FD3/a3oEu
	 nVHVnRZkjD0ZKH38q2yaCv9nzPiSocqxd6PeoYGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Compostella <jeremy.compostella@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0213/1250] wifi: iwlwifi: pcie: fix ACPI DSM check
Date: Thu, 17 Sep 2026 16:00:08 +0100
Message-ID: <20260917151557.901344645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7b2b86fd7030abe8330f57ed1faf54ea214eb872 ]

The acpi_check_dsm() function expects a bitmap of function
IDs to check for, not a single value. Evidently, on many
platforms function 1 exists so checking for 2 succeeded,
but it's wrong, we need to check correctly for function 2.
Fix that.

Reported-by: Jeremy Compostella <jeremy.compostella@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260512082114.81c4022ae602.Id3f575944ee6b87634cfb976d7334eac227d18a6@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index b003abf1fe2ce..0c920e3d6c5e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -2044,7 +2044,7 @@ iwl_trans_pcie_call_prod_reset_dsm(struct pci_dev *pdev, u16 cmd, u16 value)
 						 0xDD, 0x26, 0xB5, 0xFD);
 
 	if (!acpi_check_dsm(ACPI_HANDLE(&pdev->dev), &dsm_guid, ACPI_DSM_REV,
-			    DSM_INTERNAL_FUNC_PRODUCT_RESET))
+			    BIT(DSM_INTERNAL_FUNC_PRODUCT_RESET)))
 		return ERR_PTR(-ENODEV);
 
 	return iwl_acpi_get_dsm_object(&pdev->dev, ACPI_DSM_REV,
-- 
2.53.0



