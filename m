Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DA333987;
	Sun,  1 Sep 2024 16:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208047; cv=none; b=GQ1oMQ6C02f/mDVSucmhHnv6x2sAW4Y5pL2ZPFoUniQuk1yoM9MloWYJMdyMVk5J3k9uBUR2KF5BtRYZmfjgq6+cLEy4slQzqPbfVyB37DMIzp9R2nCpceLQIyRY6qQlitoO6OQ2yKiMqIsL0wQAe4/+GXQIwlia/QNyI81nN18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208047; c=relaxed/simple;
	bh=vjp+MH9gVkEr7NM2Ah7ChOET6QB/jNS4wU4Dr/8kfZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gi1JUGMab6Ch4dRwB26qtJKvz5CPmsAGx+aU3sgvaDk2RkTGCLOUU+nOtM4M7qFTkvXyLIccJgBHmm/mw0vqn4kN4T2D7XJ/hIGhnX3U0omDiXinOWdjXA2huISJ+Y/9o05Kju89reeOKjCLF71VvH54eulMiS2R2y6gBMugi68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9+orjHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9+orjHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC100C4CEC8;
	Sun,  1 Sep 2024 16:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208047;
	bh=vjp+MH9gVkEr7NM2Ah7ChOET6QB/jNS4wU4Dr/8kfZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9+orjHKNIv0Worw7X0QMqah3wFS9Dz16pQgpwhUJ3Q7ByTjzIEaZugijKBdYUJp3
	 fVWq8UpFO38uR9rlHxWYL7Q2XsUE7UGwFHIhHqb7Mtg0vosUiVHlFHT+fq8+k8PEoA
	 SBVIsL2HA7k2RdwpDJGYSWnN8jimNBaDgv3x9zJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 57/93] wifi: iwlwifi: fw: fix wgds rev 3 exact size
Date: Sun,  1 Sep 2024 18:16:44 +0200
Message-ID: <20240901160809.510005975@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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
index 2cda1dcfd059a..9943e2d21a8f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -867,22 +867,25 @@ int iwl_sar_get_wgds_table(struct iwl_fw_runtime *fwrt)
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



