Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B463D8104;
	Wed, 20 May 2026 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296763; cv=none; b=ORJebXUciJh9y3wDlgjEW3xfPii46XEaIDJqyaM+juypLAAR2J2MBJXFOfBRL6dXH9kNlhno2l7GYB0ek4n89O1YNcl0EDsIS/iy8IK3E13vC7DpzzRHI1qYV3GGYHDXIRtITpWSnuO13M+SuvLAbS6IOfR9fr7/c1C6uk30UL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296763; c=relaxed/simple;
	bh=e6fh1cRSnnPEWYVS4abrnU/tZpxYph3YDm8It5dnhYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0Gvg22aJadnfwjfnj76ftrotA0gWrL8DbH8aCw14ImlADsbPFP5UpdXpx91tgeuTwnMT0MlcLEcf8fVg8qL8iUMGrQbDvYcuGFujgj+grWooIrVjbsqwbyELgwcbMBFHhWW4y7TrTuBwPh2CBJhVhXRNO1Ev4N8RiCVWvmbbdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cleES0d6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cleES0d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEA91F000E9;
	Wed, 20 May 2026 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296761;
	bh=AE1gpKVIZkP9xWqLUgHxGN3XUqI9ppb+rE/BAGJ6D/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cleES0d6ND4B9riU7yFldoSC0nhgfi9Llj0w3ObueBlBAwVxV6M/ZRe5dLr51PyeO
	 sCP4xqRJju3q6WT9ERbRo5zJgEAelyPW+NyUtIJgIQIzNMLv4lHyyZidwF7be32Muz
	 mRCdp4p+c6D5azNIlBC5Dl10up64ksE7mgpzRP2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0923/1146] ACPICA: Provide #defines for EINJV2 error types
Date: Wed, 20 May 2026 18:19:33 +0200
Message-ID: <20260520162209.128613273@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 1f6008538384453eb4c13a3d7ff9e37ee8aee6b9 ]

EINJV2 defined new error types by moving the severity (correctable,
uncorrectable non-fatal, uncorrectable fatal) out of the "type".

ACPI 6.5 introduced EINJV2 and defined a vendor defined error type
using bit 31. This was dropped in ACPI 6.6.

Link: https://github.com/acpica/acpica/commit/e82d2d2fd145
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260421150216.11666-2-tony.luck@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 0c00cfbcfcff ("ACPI: APEI: EINJ: Fix EINJV2 memory error injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/actbl1.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 4e15583e0d254..f72e00517eb3d 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -1386,6 +1386,12 @@ enum acpi_einj_command_status {
 #define ACPI_EINJ_CXL_MEM_FATAL             (1<<17)
 #define ACPI_EINJ_VENDOR_DEFINED            (1<<31)
 
+/* EINJV2 error types from EINJV2_GET_ERROR_TYPE (ACPI 6.6) */
+
+#define ACPI_EINJV2_PROCESSOR               (1)
+#define ACPI_EINJV2_MEMORY                  (1<<1)
+#define ACPI_EINJV2_PCIE                    (1<<2)
+
 /*******************************************************************************
  *
  * ERST - Error Record Serialization Table (ACPI 4.0)
-- 
2.53.0



