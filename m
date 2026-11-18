Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060360;
	b=Bw32RO433Zh5adyLcQW5Ld8aM0rD8A5fcIYR44SrnXLPysAk+v76dQyn3A/57Bh9THfp
	 RS3cDzksZEir9uJq7YoA+/aVxC6ViXutSQzwnkXsPaBOPKCyd3I2EuS/BEM6LyH4LHHBf
	 DuBM5K4VZRTOgabCLBj3CvBtRylx5C0HtabTAITNID+Lfx6HPHzTzgpsPf9R1rEVCh+og
	 8/8WeocZC3GvcxLDOS5hZdzWbDz5M1FkMJQ7Wx//OdF5u9awkA9SodTfuUghCv7zF9ccR
	 OyqBIT5JQc+AtVPpsdEopNFSyWq9y22cWGyi/cxrkpio+Wt3Iyu7ylHNDAt/27JVWCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=leysDm8z6oJC1meb429QBh9SIftYFL+r2zkrtkJwvZw=;
	b=3vN2UShve53hFDQKnXPPqVaAagIxZCgyEVOBj1uvfNtvWRy/QYSbocYUKxPsCUKKOu0O
	 rgPgOXyDd+LqCW/EGEkgEuRhBPhXDoFIOE/2okCuAoS6NkYmY/PlZDUThzW14gSmxe4Sj
	 ximyUE/thW8F75uPptfiKmM1Usz7WOkqDjIG0jClKBuRoA3S2zSrtkzLNsg4Qcv9blF3d
	 kfq8n40NxnGC2QhMx5yOBL6WZxlv9b77soAaugFzcP1ezUqMYq/VuuxvMM5Qd58mxPd1A
	 Tdg6eQARx0k3Pz2bFtQzJ/P6Iz2eKZMeUySt3PKuhBrTUNnxV18NZ/dN7ZmmPQ2Odnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OXACw5e/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B4D606A325;
	Thu, 19 Nov 2026 03:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXACw5e/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814951F000C4;
	Thu, 19 Nov 2026 03:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060360;
	bh=leysDm8z6oJC1meb429QBh9SIftYFL+r2zkrtkJwvZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXACw5e/LmpvH98GActneojE9QL0scq6RvUWd5AfyzFfNjX+V8rUbKP91cRZdE+g6
	 rveP8mSR7kGXtRjCPvNxlakBSIgKm98lc3UBHcdJz4RG4atsK1CgvWCYZsjj/fATPu
	 IcNXDSnpHprc8urHuzkK4rQyo1nQB5crJDkNFDXY=
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
Subject: [PATCH 5.10 1171/1848] ACPI: extlog: Validate elog record length before walking sections
Date: Wed, 18 Nov 2026 15:53:29 +0100
Message-ID: <20261118150008.648748639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a84d5afd37c1..6384426847674 100644
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



