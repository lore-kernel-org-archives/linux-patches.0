Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017278;
	b=XkViDYnVb8Vz5TB+ORoH+NxhIdh04MUUeJC3RrWtohGewqc4FgiD+fwc8WTalrDCYyGO
	 mhhIShmHaaXpZvyL2d8Yrw1dSKffAhFkOh/sV/AXy5aBOOLpos4IEELhjNy1DKWvSLBT8
	 5wjQf6p7ZJEhbGOQpLOboCyWfN/MB7HAk/4kUP0Bd01/I0wgD0fdDVrDAG/laSfEUGM4I
	 lkPHjubu4Y2dcl/vPyxdEFiea2AiE4ZDPcLz2/jyFZ1pyZjbN/oSXCs6ZHh71WEiOB6i/
	 KOBfJVuncZEOYNtFJE139h/7S/GRdJXp4JTREID86dhZHLk9hqrc3guH793bT4r+20Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hc9OxtTTRPb8kIeIVaZ1Q1Rwx6Xu4kJ7CjFDEgCy1tg=;
	b=FPiOGnnKB0NZkWYIUMw0TU+QPdlaexUxrCIeDZ3TUFd4b7CA1tu08xrFsUnyUeAluXed
	 ebRbVLnvKKWMk4lhpeCWeXktKdY82qRmfTYXYTVUmXsihGeaZKVXDxwvusy4yUi6bVWvK
	 Tx+EzXIWAXtG8eSSn9j8e/od1d8ke+PRIt9AAoT/AWg5J6bzxRT0QEZiaKKw8BFSSF95s
	 Qv3bxDDSA1PvuZ6rogtVxPflOthdujx0znSSAX0HbJrCK5+dAN7NxAYC9nTZRIypi5ob5
	 ubP7n5XrIZBRR//ZkJPM2ZHDfr5T1w0MCdbP5x66qk6CWDAwHhk88lNNN7NhUX1mfvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtnwvUXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B15606A325;
	Wed, 18 Nov 2026 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtnwvUXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840541F000C4;
	Wed, 18 Nov 2026 15:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017278;
	bh=Hc9OxtTTRPb8kIeIVaZ1Q1Rwx6Xu4kJ7CjFDEgCy1tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtnwvUXOdLTVvn0MIZjWF6t6fsb6SKsFbhksgm4hp72d4S+a8RU742r52EKsIgs70
	 a2Ryy3/bW3bcOXKb+XzZuzBkhrT4gWqoDScVcrjboS6No9WF1fWiAL8dyoOHmIKEQU
	 ee+0vUbLvycRrzbnYxn9LV8zcoIXJqQRbXeDRf6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Huang <wei.huang2@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0786/2651] PCI/TPH: Validate the firmware Steering Tag response
Date: Wed, 18 Nov 2026 15:33:46 +0100
Message-ID: <20261118150316.185638097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 655ffd60e62f6..4d064b86befcc 100644
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



