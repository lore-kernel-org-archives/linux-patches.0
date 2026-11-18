Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024392;
	b=agMEQv3fiUwwBocNM4ZcYzDcfU7+WtLlo2e1FAYdyAeXm7Sv5+g+3CNBFfBCYqahMhiJ
	 l7ZnlrC6TRHFrSTderNVLuKktkA56IAM1OgnISUH2JJGpMC/hcVN16Grr6068daswbQ9r
	 Vm6MNvaQyQPnsWJaVbI38NV/Dub8syDDSflI2NOOQVG9djMi4JzrHhi3rtFGop3YRS8PS
	 YqaYNCDWwc9Ny8bdElWxIcM3fhHWS56mc44qF4ElFPA1mW3A45E1Oi9asnApePChpXl31
	 +x9P2TxTsKi2wkLRjgsf1JNi6VedD6Bp76eeDbwzh0OaA1GYOmOtbRblG1aTzxEKArw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x/WF93oY3bpKux8NWyOABIjDkgo7RroxjhihKYPNDks=;
	b=bO9YL9E2v6fS/fnMJy1WRd11hTfoGhgYPMkE+iwXHLxmpQSMeU2W537k0zfkwuRtVTXj
	 3E8WMRGLUrkjAiFeiiHGXp16ekQAa4YJBhvBSalOjXXSXlIXcVUa2ooh65C19uP+9um9V
	 PJWI4cpbbUIadXkeEIG9Ym7vRIzvpX4JgR9O1sDjwRq7HjQaq2JLSuvOr3hTLE1El3oko
	 pGGXIogkoV/ir1DBV4Kv6RejvNvt5XtK6p50e/qgSzbwNOcgZk7F8nvrH6grDidrsoO2s
	 S38Wqy7g3c3a/BoY9HyolS657uDfE5g1H6IVnQM6ZXF5qeMVXLHrUphnMlim9fLqnng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2YGeMKz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CF7606A32A;
	Wed, 18 Nov 2026 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2YGeMKz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAE51F000C4;
	Wed, 18 Nov 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024392;
	bh=x/WF93oY3bpKux8NWyOABIjDkgo7RroxjhihKYPNDks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2YGeMKzNklkwhrV7E9tMbcmWiJkEo261D/IN697u8e1DXy0iFnqMgwo+YSHINFSy
	 r6OUCSIHVr/24Ho2J2rB7UaSTtgAWgS7kKShQSJRBv/PBop5Z4UDD0nJhApGE/ZvTh
	 /TeL0JAd8V9sItZAKzUONzxdqwn/Ii9ARq4VM718=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Huang <wei.huang2@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0692/2151] PCI/TPH: Validate the firmware Steering Tag response
Date: Wed, 18 Nov 2026 15:40:27 +0100
Message-ID: <20261118150146.996720704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Huang <wei.huang2@amd.com>

[ Upstream commit 5c382ef425c875bf854d411fb0a45909878a233a ]

TPH _DSM returns an eight-byte Steering Tag information buffer.  Checking
only the ACPI object type allows a short firmware response to be read
beyond the end of its buffer.

For safety, require a non-NULL buffer containing the complete value before
copying it. Use memcpy() so that reading the response does not depend on
the alignment of the firmware buffer.

Fixes: d2e8a34876ce ("PCI/TPH: Add Steering Tag support")
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260924190543.3424792-1-wei.huang2@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/tph.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index c61456d24f61b..bfcd06675dbae 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -119,12 +119,14 @@ static acpi_status tph_invoke_dsm(acpi_handle handle, u32 cpu_uid,
 	if (!out_obj)
 		return AE_ERROR;
 
-	if (out_obj->type != ACPI_TYPE_BUFFER) {
+	if (out_obj->type != ACPI_TYPE_BUFFER ||
+	    out_obj->buffer.length < sizeof(st_out->value) ||
+	    !out_obj->buffer.pointer) {
 		ACPI_FREE(out_obj);
 		return AE_ERROR;
 	}
 
-	st_out->value = *((u64 *)(out_obj->buffer.pointer));
+	memcpy(&st_out->value, out_obj->buffer.pointer, sizeof(st_out->value));
 
 	ACPI_FREE(out_obj);
 
-- 
2.53.0



