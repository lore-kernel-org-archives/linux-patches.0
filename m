Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060673;
	b=BriUev4Idje37Kux/tst7gQ5AVRorhivy+KZ1U2ul0Jz/UvPbBNPMGkMZXIgyjwiQNlN
	 V4OLeTFUs2THQAJTe7fWbkyAOudQauniNg3vehZjyTsG6c2lsetwbgSizNe5ayo5/fWiy
	 BGqUfRC5FlzxUMA7Y/M+Ih/IXsyqn5w/yvwMC4lzHSUYj8gcI+v3eRZLuInIn0XIpKIp9
	 OfsxASRi9SCjR18CrPrhSpkMsbbspVvta5BzEgnVlGaAwiTmBTKGHDOnBdF2EXb6jBCRX
	 upwlDv1ZVoloOSlxnb1Fu2KoFkiAwCHR79cQpxC8dIUy5C6WJ1412ogGJLlGzOvX0kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CMKcCbcOcd26bUWHPyiLhbXwI3CBah1aevsl6D/yCe0=;
	b=RW69u0bjdG5m1ci9hNAzVdKHXd/jSJrpdukKbCepFwnHvgOZg7RSlgB+wYVcZ0c0JR7G
	 nSn3KEYWFmZLSVhDJxsG3DwKsi6MsK2+Z0Gwffp5jNScuFdCT17Kp3PcpmRA1RIVRFj8Q
	 YuIHM/jwB4XZu8cq9KsWMb8qCTxGaxG4u4gc3AYijxC9Wp64gGK2zvvz6vcrKH08CaIQ9
	 eZ5bM2RtQ1g9j0r69IsJ8MZnC/Vk6xeuWZv1Bu7fvezNWRQvQVLJ33I0TKQYz+hOLqnod
	 0WoOybggeKhvldNyyGjhR74WBX6K6uDMKMdieIhkBNaQx7sUdOdu4OUEEX32OEm2E4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1x1CvJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BF8606A32A;
	Thu, 19 Nov 2026 03:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1x1CvJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9731F000C4;
	Thu, 19 Nov 2026 03:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060673;
	bh=CMKcCbcOcd26bUWHPyiLhbXwI3CBah1aevsl6D/yCe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1x1CvJyGJ9d4QuYzmukQmVQ2bpSv/cpD1ipqgnXWMgvfWIjGKHOi5QPOm56OPg7E
	 kEspcSZ43TbCGOFQN/zCfOLPR49/LCY69rP4CdO0AMuf9t7iPwhFz/JgF/YRfgThUJ
	 tsZPl5s6pFBROD0EyBd9aV7rdlNosHk3zc8FY+ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1281/1848] ACPI: CPPC: Validate the _CPC package header
Date: Wed, 18 Nov 2026 15:55:19 +0100
Message-ID: <20261118150013.240056683@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit fb345025f161d17fe7c8a6048c7e80e467fa8ddf ]

The _CPC NumEntries field includes every package element, including
NumEntries and Revision. acpi_cppc_processor_probe() nevertheless reads
those first two elements before checking that they exist and trusts
NumEntries when walking the remaining elements.

Reject packages with fewer than two elements and NumEntries values which
exceed the package count before accessing Revision or iterating over
register descriptors. Although the specification defines NumEntries as the
number of package elements, tolerate additional trailing elements because
ignoring them is safe and avoids rejecting padded firmware.

Revision is specified as a BYTE, but the parser assigns its 64-bit AML
Integer to an unsigned int before validating it. Reject values above U8_MAX
before conversion so, for example, 0x100000004 cannot truncate to revision
4.

Fixes: 337aadff8e45 ("ACPI: Introduce CPU performance controls using CPPC")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724134251.1632824-1-christian.loehle%40arm.com
Link: https://sashiko.dev/#/patchset/20260808082644.1251332-1-christian.loehle%40arm.com
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index b4cc61cd5d32e..741eafdaa8943 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -681,6 +681,11 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	}
 
 	out_obj = (union acpi_object *) output.pointer;
+	if (out_obj->package.count < 2) {
+		pr_debug("Unexpected _CPC package count (%u) for CPU:%d\n",
+			 out_obj->package.count, pr->id);
+		goto out_buf_free;
+	}
 
 	cpc_ptr = kzalloc(sizeof(struct cpc_desc), GFP_KERNEL);
 	if (!cpc_ptr) {
@@ -691,12 +696,15 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	/* First entry is NumEntries. */
 	cpc_obj = &out_obj->package.elements[0];
 	if (cpc_obj->type == ACPI_TYPE_INTEGER)	{
-		num_ent = cpc_obj->integer.value;
-		if (num_ent <= 1) {
-			pr_debug("Unexpected _CPC NumEntries value (%d) for CPU:%d\n",
-				 num_ent, pr->id);
+		if (cpc_obj->integer.value < 2 ||
+		    cpc_obj->integer.value > out_obj->package.count) {
+			pr_debug("Invalid _CPC NumEntries (%llu) for package count (%u) on CPU:%d\n",
+				 cpc_obj->integer.value, out_obj->package.count,
+				 pr->id);
 			goto out_free;
 		}
+
+		num_ent = cpc_obj->integer.value;
 	} else {
 		pr_debug("Unexpected entry type(%d) for NumEntries\n",
 				cpc_obj->type);
@@ -706,6 +714,12 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	/* Second entry should be revision. */
 	cpc_obj = &out_obj->package.elements[1];
 	if (cpc_obj->type == ACPI_TYPE_INTEGER)	{
+		if (cpc_obj->integer.value > U8_MAX) {
+			pr_debug("Invalid _CPC Revision (%llu) for CPU:%d\n",
+				 cpc_obj->integer.value, pr->id);
+			ret = -EINVAL;
+			goto out_free;
+		}
 		cpc_rev = cpc_obj->integer.value;
 	} else {
 		pr_debug("Unexpected entry type(%d) for Revision\n",
-- 
2.53.0



