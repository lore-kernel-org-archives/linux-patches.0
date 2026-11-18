Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029131;
	b=ZFcPACuh8OvWcBdPfzhQ4Okn7hpCkjrqNMD7WLNn82saDnp/WUa97cTFmA7nyQXNA9Su
	 dPXmQ36yoTUypohoQ1QGgbC0rhoX2OdyzeIt7FA/ndh4/MIt2kumAecPEUzJX5nOKQnVt
	 pI6LuBAV/DtSHrGIt8I1ghYvS1zr5hZTV4iG3s0LVtmRI5SzwiXV4b2RdtJbdk6TG4WuN
	 wvYdqdgBDJH0Ync8Epq3RPpg7+AYIoBmchhtFVRuPUeqqzxVZ5k+Y1K5Ytce8DNTRiwxz
	 ZdbbftLQgxUEqKI44WjgeFFDEzfJJEd8USCSu4ghM2MqRPwy32U9PjDiIBOMw07ZG7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ilAcfPti4jryNlIVXnbj+4xzdz/zzqhbiUvbICKoP1c=;
	b=iIYegXnbrTIgtq+aTX+UhJH7FBE9ZfNm0RncmgvDKXJ0/16Qmg92nrimfePDNAmr/7yu
	 HppRKXegLaTqpTljR3MzQa7DHo5jLqcqSEsSQv4zJbvUyHbGhXTBdlZ1AcFtVL4t6nXOV
	 zKM3WZDu+5noxfVDoO3X7Zg0LWXVqjrp9Cj03WtrIcfAq+r4AzhfjHX5T0WnUNGcajWpe
	 zVP9HsqlIs//zu7I9aYnqsd1oMzVZR+Av8qDYR+hgBhPguLKosowbShTNA17go+QJgJpZ
	 hQwOpiKCZ3kzExDYy9vHzjE/6ASNfc0mVrk0Pi1HTHwPNRXpYcoxII2ye0MSX2ds0Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V140j5Hm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5E606A31C;
	Wed, 18 Nov 2026 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V140j5Hm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F4E1F000C4;
	Wed, 18 Nov 2026 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029131;
	bh=ilAcfPti4jryNlIVXnbj+4xzdz/zzqhbiUvbICKoP1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V140j5HmvwdjT5uqlvo3YAEYzohUJRbDUprtAPvmy9IgSNgkwD5aAvMkroyjHznky
	 cWEuHWfo67nfRj+D1cd650APkgWY/KSck6j0KHaRMQ/avqGSX+PuF7xVxqSMDrkjav
	 F2UlLznYspbnC5Epytte3lng7hDawiAf9PMJjWIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0241/1756] ACPI: extlog: Validate elog record length before walking sections
Date: Wed, 18 Nov 2026 15:39:28 +0100
Message-ID: <20261118150017.925688712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit e1fd582a8134150aa10c1f0286dbce00cf63b086 ]

extlog_print() copies a fixed ELOG_ENTRY_LEN (4096) bytes from the elog
record into elog_buf, then walks the sections using the firmware-controlled
data_length. Nothing keeps data_length inside the buffer, so a malformed
record walks the section pointer past elog_buf and reads adjacent memory.
Unlike the GHES paths, extlog never calls cper_estatus_check().

Reject a record longer than ELOG_ENTRY_LEN and run cper_estatus_check()
before walking the sections. The length test alone is not enough: a wrapped
length reads back short and passes it, which cper_estatus_check() catches
via the header check added earlier. Drop a malformed record with
NOTIFY_DONE and without MCE_HANDLED_EXTLOG, since extlog did not consume
it.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260714231835.303081-1-dave.jiang@intel.com?part=6
Fixes: f6ec01da40e4 ("ACPI: extlog: Handle multiple records")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-4-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index ca87a09391359..9d59b5f54b3d8 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -159,6 +159,15 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
 	tmp = (struct acpi_hest_generic_status *)elog_buf;
 
+	/*
+	 * Bound the length before cper_estatus_check() walks the sections: it
+	 * iterates over data_length, which is not yet known to fit elog_buf.
+	 * cper_estatus_check_header() then rejects a length that wrapped, which
+	 * the bound cannot see.
+	 */
+	if (cper_estatus_len(tmp) > ELOG_ENTRY_LEN || cper_estatus_check(tmp))
+		return NOTIFY_DONE;
+
 	if (!ras_userspace_consumers()) {
 		print_extlog_rcd(NULL, tmp, cpu);
 		goto out;
-- 
2.53.0



