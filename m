Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBD81DF75A;
	Tue, 26 Aug 2025 14:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218164; cv=none; b=R0S601yLx5pLczQ21l7yt7lntv1/W1gP1u7unKg9YLu0uYSmhAMSiDmvEeCsUfj8kBLlHfATqjrr4b50omy4RmfazYjgFno9q3doGHOGFWSVJm3RxIPULOfKxr67m1z9AD1zy2F+XaDbdFPyzNoolFCy8U/DhdLCmROUWVfOnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218164; c=relaxed/simple;
	bh=L4JRMBmXirp8xTqTZTafH2njaHIh37v9CWD5mtUg16A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6LVJDNfAthZrkyYx0UwEjeFAuFKZoxGt6X6FYAN+qLA6oA4xv/JVC4ZTZjOzVDmWPENqM6UVxPepNNxXyQmhGUCoOw21Q0BgM8RvMvH+kfdeHEU1rN8iyxz5deQpt/zoY/W2mUX9QGY4egNfJnXLxrGUdsBO9A+vE6nGlgMmu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epAVdvwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epAVdvwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7A3C4CEF1;
	Tue, 26 Aug 2025 14:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218164;
	bh=L4JRMBmXirp8xTqTZTafH2njaHIh37v9CWD5mtUg16A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epAVdvwxqB32DLDjKuvlxaEmaoZwx4JMFIombPSsGDLa62eMqBPFshXfjcu+3DtDm
	 cmJUQ/HJLAVpPbLDJigK8ZMg9OgGT+GUpJS6evJVGhRUKfUdJF9xsWjCrzCH/X+tZy
	 qNBP4/eK5GqodMY7hqSYW4lE//qF/sHfQvAyIyl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/523] x86/mce/amd: Add default names for MCA banks and blocks
Date: Tue, 26 Aug 2025 13:10:28 +0200
Message-ID: <20250826110934.767282857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit d66e1e90b16055d2f0ee76e5384e3f119c3c2773 ]

Ensure that sysfs init doesn't fail for new/unrecognized bank types or if
a bank has additional blocks available.

Most MCA banks have a single thresholding block, so the block takes the same
name as the bank.

Unified Memory Controllers (UMCs) are a special case where there are two
blocks and each has a unique name.

However, the microarchitecture allows for five blocks. Any new MCA bank types
with more than one block will be missing names for the extra blocks. The MCE
sysfs will fail to initialize in this case.

Fixes: 87a6d4091bd7 ("x86/mce/AMD: Update sysfs bank names for SMCA systems")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250624-wip-mca-updates-v4-3-236dd74f645f@amd.com
[ adapted get_name() function signature ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1215,13 +1215,20 @@ static const char *get_name(unsigned int
 	}
 
 	bank_type = smca_get_bank_type(bank);
-	if (bank_type >= N_SMCA_BANK_TYPES)
-		return NULL;
 
 	if (b && bank_type == SMCA_UMC) {
 		if (b->block < ARRAY_SIZE(smca_umc_block_names))
 			return smca_umc_block_names[b->block];
-		return NULL;
+	}
+
+	if (b && b->block) {
+		snprintf(buf_mcatype, MAX_MCATYPE_NAME_LEN, "th_block_%u", b->block);
+		return buf_mcatype;
+	}
+
+	if (bank_type >= N_SMCA_BANK_TYPES) {
+		snprintf(buf_mcatype, MAX_MCATYPE_NAME_LEN, "th_bank_%u", bank);
+		return buf_mcatype;
 	}
 
 	if (smca_banks[bank].hwid->count == 1)


