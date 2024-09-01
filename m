Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A3117B50B;
	Sun,  1 Sep 2024 16:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208586; cv=none; b=Z6puv0SNvFexDbiePOpYyLF95Fy/KnPJr9OcN2T3+0jqaI1NdS+bqIZFRUrRmcDkOVYyqRxOWIO2Z6DwPmtw8T0ewgw9OobinjF3DSGIgJv4yrYb808Q1rLMIXajWOB++2pxDkSJNfseJsDC6kqq/MT5zntC+LQvuG8zON0/lGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208586; c=relaxed/simple;
	bh=8t10Xm0J3LJ93l/x0WsRAErHVHoGQb96JVYYOs746Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNmaj0kLU3ixzxVSX49UPr4jD51P7qlBfWtexM22aM50z/xT5/aTxNV93IMs9GGGaLLMOJBKU9F8qrkaZXl3lLJBS1s7m0u78jIcfWy8A8BxvkGoTmjiZAS/fpxPDO2SSo3f//ixH1D1pj14uWf592sTbOLZlOYzFiSs81NdJNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CW/wC+YZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CW/wC+YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943FAC4CEC3;
	Sun,  1 Sep 2024 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208586;
	bh=8t10Xm0J3LJ93l/x0WsRAErHVHoGQb96JVYYOs746Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CW/wC+YZe2wYYFHF/8qrmUSy9XLhA8m3YfXcfEbto3bj/byueV7p7c/f8hFaWEDo9
	 xZ1e6UmNpzrfnkwsQg1xJFI5kR+O2Ew+aakxQBjaOOY07rpReC/AiWibBERyHnLnyt
	 rKT0ZStXULbzhZCD1PSQJRtehRkUVrXMjIslWg84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 096/149] wifi: iwlwifi: fw: fix wgds rev 3 exact size
Date: Sun,  1 Sep 2024 18:16:47 +0200
Message-ID: <20240901160821.072373960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit 3ee22f07a35b76939c5b8d17d6af292f5fafb509 ]

Check size of WGDS revision 3 is equal to 8 entries size with some header,
but doesn't depend on the number of used entries. Check that used entries
are between min and max but allow more to be present than are used to fix
operation with some BIOSes that have such data.

Fixes: 97f8a3d1610b ("iwlwifi: ACPI: support revision 3 WGDS tables")
Signed-off-by: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.cc71dfc67ec3.Ic27ee15ac6128b275c210b6de88f2145bd83ca7b@changeid
[edit commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index fa339791223b8..ba9e656037a20 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -724,22 +724,25 @@ int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt)
 				entry = &wifi_pkg->package.elements[entry_idx];
 				entry_idx++;
 				if (entry->type != ACPI_TYPE_INTEGER ||
-				    entry->integer.value > num_profiles) {
+				    entry->integer.value > num_profiles ||
+				    entry->integer.value <
+					rev_data[idx].min_profiles) {
 					ret = -EINVAL;
 					goto out_free;
 				}
-				num_profiles = entry->integer.value;
 
 				/*
-				 * this also validates >= min_profiles since we
-				 * otherwise wouldn't have gotten the data when
-				 * looking up in ACPI
+				 * Check to see if we received package count
+				 * same as max # of profiles
 				 */
 				if (wifi_pkg->package.count !=
 				    hdr_size + profile_size * num_profiles) {
 					ret = -EINVAL;
 					goto out_free;
 				}
+
+				/* Number of valid profiles */
+				num_profiles = entry->integer.value;
 			}
 			goto read_table;
 		}
-- 
2.43.0



