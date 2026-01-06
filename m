Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DA835F8B3;
	Tue,  6 Jan 2026 17:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721719; cv=none; b=mTjS7v6w6Nh/6Du4Jk03BTwLfXvwA6qn5Brz2mjEv6qtLul/7ke7V1N7iX/cctYGOk+EdREIaopMOwi2KyaMxNFU4MsDh2KoOUkf49UbxpJIaYEP7SkDIlbloxGK3ve9GsbT2hcUatELG3hz/60ykFqOezI+4EKlCLbqcSlUj50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721719; c=relaxed/simple;
	bh=aqlIgYrcM8IqI6ngK94b8Cf4beu2Q/J9igMzpRRnZXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvpsz7dvxyaFrgUsRMTlcrwauhpp9sj9cXvrVe+hI0zuQ7NwhTiQtQ3agksOD3HCneNAq15KLVNc0m4HBcFvIVzyVOlAYAVkFQqqhddUc1EfjTZIRgV8xR2kQN2n1OWxEHDCPij5V4n2sc7aHotdU2aOj+8g/F74I72rB67LE58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjyvZnMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjyvZnMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400D7C116C6;
	Tue,  6 Jan 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721718;
	bh=aqlIgYrcM8IqI6ngK94b8Cf4beu2Q/J9igMzpRRnZXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjyvZnMieSqOcIyuehxeI38rnTMy/YweEEuy5r0gxizo1737DIMdCITmLwElGxrrG
	 3i+ecosYIVHsW6mmmDKRVOgHgkLi7pHWL+TxrmpNqA5pzFvaR4N3lhtXrk/M9HDur4
	 1ypLKM95KY3VgPlGlgUUq7nnmBVdNh3+OIwJJDoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Sanjuan Garcia <dev-jorge.sanjuangarcia@duagon.com>,
	Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/312] mcb: Add missing modpost build support
Date: Tue,  6 Jan 2026 18:02:04 +0100
Message-ID: <20260106170549.664671272@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>

[ Upstream commit 1f4ea4838b13c3b2278436a8dcb148e3c23f4b64 ]

mcb bus is not prepared to autoload client drivers with the data defined on
the drivers' MODULE_DEVICE_TABLE. modpost cannot access to mcb_table_id
inside MODULE_DEVICE_TABLE so the data declared inside is ignored.

Add modpost build support for accessing to the mcb_table_id coded on device
drivers' MODULE_DEVICE_TABLE.

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Reviewed-by: Jorge Sanjuan Garcia <dev-jorge.sanjuangarcia@duagon.com>
Signed-off-by: Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20251202084200.10410-1-dev-josejavier.rodriguez@duagon.com
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/devicetable-offsets.c | 3 +++
 scripts/mod/file2alias.c          | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index d3d00e85edf7..0470ba7c796d 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -198,6 +198,9 @@ int main(void)
 	DEVID(cpu_feature);
 	DEVID_FIELD(cpu_feature, feature);
 
+	DEVID(mcb_device_id);
+	DEVID_FIELD(mcb_device_id, device);
+
 	DEVID(mei_cl_device_id);
 	DEVID_FIELD(mei_cl_device_id, name);
 	DEVID_FIELD(mei_cl_device_id, uuid);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index b3333560b95e..4e99393a35f1 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1110,6 +1110,14 @@ static void do_cpu_entry(struct module *mod, void *symval)
 	module_alias_printf(mod, false, "cpu:type:*:feature:*%04X*", feature);
 }
 
+/* Looks like: mcb:16zN */
+static void do_mcb_entry(struct module *mod, void *symval)
+{
+	DEF_FIELD(symval, mcb_device_id, device);
+
+	module_alias_printf(mod, false, "mcb:16z%03d", device);
+}
+
 /* Looks like: mei:S:uuid:N:* */
 static void do_mei_entry(struct module *mod, void *symval)
 {
@@ -1444,6 +1452,7 @@ static const struct devtable devtable[] = {
 	{"mipscdmm", SIZE_mips_cdmm_device_id, do_mips_cdmm_entry},
 	{"x86cpu", SIZE_x86_cpu_id, do_x86cpu_entry},
 	{"cpu", SIZE_cpu_feature, do_cpu_entry},
+	{"mcb", SIZE_mcb_device_id, do_mcb_entry},
 	{"mei", SIZE_mei_cl_device_id, do_mei_entry},
 	{"rapidio", SIZE_rio_device_id, do_rio_entry},
 	{"ulpi", SIZE_ulpi_device_id, do_ulpi_entry},
-- 
2.51.0



