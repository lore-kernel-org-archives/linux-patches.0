Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060885;
	b=1P/w3LwMsX9fpbUMqnPMEUT++RO2ULXndAU/La+KblOn3Ly7CWPldglMsOyeudu/+PrH
	 MIZbvUppCkVTYtzxB/VEZTe0sj+rhGYwhtNGe8oSXNlTfEIFhIw6OsfRum/Ebci8Gva0r
	 MBBIfOxioyJOpRGSwJ7khFvE2xZixOaRj33HIcVnt/ZC13XJV0/euhcdU9zBuOob8X8Ad
	 /bCJmNxhn/K3XTOxSPOTL7Jn7IEy2TLaDdcZ6Iv3Y4N5o7JG39RSpb4fOgAd2E44Fdvla
	 k+jwpjAAox6AH1oyewK92xuehDbMFUW64MdUEm3K9x+qnpPp1m9/u1kEq4MkLSuP36g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0VKRt4KEYESyXx6WAKEcfcYTVwO4jc2tjOrqe7RB45Q=;
	b=EJpD6YIaJXC51rd0tN/C2lzqYBBrAEG/wtHMtSbxbXf0Ilyp3l0FQ19DQ9uXyM1fwckQ
	 GrKcMATZTXCBwTOnAoqUEEjPJtMe4pmkFSMakQ1LXSOkAFTr/ngn9ApaR1f+jkikZkLRq
	 G5NyTax5K8tkYad9k2REEQdI/mdNM7o15zVpZHAY4ad7XNcVqJ3TCF33azpblorYD30q0
	 veNXQgI/4HEMEhnI2k/etBlMPZAq/usLyzmlyUNNDdV6BFzMty4HVr+kSAl9u17U+6Tks
	 K/aE0Kc3N5qVhskFC9qSJlqZoYzarQZX4ehu0r0AJd11Iosr8dl7qJEkH6lYwckfscg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ntQDJ7Rg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9558606A325;
	Thu, 19 Nov 2026 04:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ntQDJ7Rg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C161F000C4;
	Thu, 19 Nov 2026 04:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060885;
	bh=0VKRt4KEYESyXx6WAKEcfcYTVwO4jc2tjOrqe7RB45Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntQDJ7RgP8/XeVmJ0RkZcBUltLNvq4raztRiGV/MNZQY7zBeZH+SDcule93itu8Y6
	 g/BBNz32KQXffe2XI7fVevsykYOmWcNJMYw3m+vQiHfTAB0Nsj41iWtXgFs+v2IwA0
	 PQ22tjTl4OJAaEyL/zVn6AWSVKglJxxq7YkcUye8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1358/1848] ACPICA: Fix PCC OperationRegion command offsets
Date: Wed, 18 Nov 2026 15:56:36 +0100
Message-ID: <20261118150016.460572846@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 888dab4b04ea8725168c6d50d0bfb8057fccca18 ]

ACPI 6.3, section 5.5.2.4.7.3, states that the PCC Operation
Region is associated with the region of shared memory that follows the
PCC signature.

The generic and extended PCC shared memory layouts include the 4-byte
signature at offset 0, so their raw shared memory COMMAND fields are at
offsets 4 and 12 respectively. Since AML field offsets for the PCC
OperationRegion are relative to the region after that signature, ACPICA
must look for those COMMAND fields at OperationRegion offsets 0 and 8.

Adjust the generic and master subspace command checks to use those
OperationRegion-relative offsets. Otherwise writes to the COMMAND field
can fail to invoke the PCC address space handler at the offset described
by the PCC OperationRegion definition.

Link: https://github.com/open-acpica/acpica/pull/1205
Fixes: aa6ec56b574d ("ACPICA: ACPI 6.3: add PCC operation region support for AML interpreter")
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
[ rjw: Fixed the Fixes: tag ]
Link: https://patch.msgid.link/20260922144302.3847593-2-sudeep.holla@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exfield.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/exfield.c b/drivers/acpi/acpica/exfield.c
index b3230e511870a..ebf39a4cd852b 100644
--- a/drivers/acpi/acpica/exfield.c
+++ b/drivers/acpi/acpica/exfield.c
@@ -45,12 +45,13 @@ static const u8 acpi_protocol_lengths[] = {
 
 /*
  * The following macros determine a given offset is a COMD field.
- * According to the specification, generic subspaces (types 0-2) contains a
- * 2-byte COMD field at offset 4 and master subspaces (type 3) contains a 4-byte
- * COMD field starting at offset 12.
+ * According to the specification, the PCC OperationRegion begins after
+ * the PCC signature. The raw shared memory COMD offsets of 4 for generic
+ * subspaces (types 0-2) and 12 for master subspaces (type 3) therefore
+ * appear at OperationRegion offsets 0 and 8.
  */
-#define GENERIC_SUBSPACE_COMMAND(a)     (4 == a || a == 5)
-#define MASTER_SUBSPACE_COMMAND(a)      (12 <= a && a <= 15)
+#define GENERIC_SUBSPACE_COMMAND(a)     (0 == a || a == 1)
+#define MASTER_SUBSPACE_COMMAND(a)      (8 <= a && a <= 11)
 
 /*******************************************************************************
  *
-- 
2.53.0



