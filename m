Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380A43568EC;
	Tue, 26 Aug 2025 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216716; cv=none; b=cKQ6CdU/8KQBW8irSASIKyKo6Pe3mUnoWNuHjY1yXQEsLdpAxNunDEejXRp7Ss6fndrRy1W/q6UvmzDNMAXMvyEzDOLK8XIoPtcOwlP+Do7SXgTPq0Agxxh1xRhozIRN3GRUnGvWCZ8bzz8IWVmZ8Zd0UXvw1Noq4Wan9FMvG4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216716; c=relaxed/simple;
	bh=3z42hS9Pn4lS1M+EvHyKcdjl8XYanoexL7Q/fsLrP7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdvfmDQW5L1lWv+jWF0KEsxq+Z/jhj2n4uqL8ndIy0ycmT602wjmr9gNjAPZ1OJ2+WL+BgfmFuGlTIV5ZYYjrNhZ8V5E04f9uw6HaEGnKK0YR6v7/EurayiLc+ACV2OKjrmUNR+pz/3PB91L8KdzQlJYSTBKBlWjdRbb8tZ5AlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbqBA16/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbqBA16/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB91DC4CEF1;
	Tue, 26 Aug 2025 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216716;
	bh=3z42hS9Pn4lS1M+EvHyKcdjl8XYanoexL7Q/fsLrP7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbqBA16/P7ROJmn0c6HV0WTNGrmIrs0jwx6m2+L4BMw4e/krL5ci8KLmvXJg8EIB0
	 3Vhxnuv94++85sX/iDGQyihzAoPoLhDCGVOFSgf4kZ6IrsFHcBsi6DerBa+nc5BWLC
	 eLhuDVdgX5o2LmzzBvEFwbPXeEI4AZX6VaqBUCm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 517/644] x86/mce/amd: Add default names for MCA banks and blocks
Date: Tue, 26 Aug 2025 13:10:08 +0200
Message-ID: <20250826110959.319195269@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1228,13 +1228,20 @@ static const char *get_name(unsigned int
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


