Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034507;
	b=m8saIIbNjSVIKuhNRyKgcNjanAJ2lkg4DH7C8c7R4qvQvBJTvr2PkrjCQdQLagtKS7X3
	 6xT14rleAhdrkmqIrzclqOVd36/kCg5EjitO39O4OcseTNxOl8zNjiUlqepN7w+BERcPu
	 V25+K2nM/fr4gT+/W5JLUzd0zbe0O2KbAkNKl7NjedaMt0m+N3EGlEbjZvOXvw/xPSiK4
	 8Z9KF3TwhB1CSVxNBr/rZB6JN8upgTVJjKp6Ssc399wI8aMWjx+4FG+rULbgutAf2czLI
	 VZd2oShXz6XvLUNwqUQeSVM+rJrd72rObBy2cTrnMIvxGGmBLK7t/+YerHFga7vDvzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87HPaWIHuBIBLBPEF8cL2QE00pCan9KDk6ReGCoc4G4=;
	b=ot+zWL+EC15ImZi6of9GiqCrfj3cmkVdbiErBchZCoBTT77PgRU+bdr/51hoOY+4JMSN
	 5FCsRMN1f/GzpE7i/racNo8II4LQum5S7HYi/zhB3v8/y/Fer2UZXdTNB0A/vDOy7+LJj
	 EPLD9FlQiez1SrShD8ZSMD3EbIOdq7gi8xfIixYSWhARMw8Kj+AdjLEmJkZo+zERBrZLb
	 cR1AjE4Kxi1bb8XIx9AjrFCTeMVRImyMCxvck/JBPU8ixME+sj4b+BqvP/LLN2y1OhJOm
	 241l/rFh1QRUg3aFLc83gZNIGMBtFKii1rAqD0J9F6Snlrvb7npqKyPL4Vk6Wr0ZeNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ermsjqmc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0816606A31C;
	Wed, 18 Nov 2026 20:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ermsjqmc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23CC1F000C4;
	Wed, 18 Nov 2026 20:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034507;
	bh=87HPaWIHuBIBLBPEF8cL2QE00pCan9KDk6ReGCoc4G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ermsjqmc/xW8een6u9b/aAxjMidK8WAbDOUfM1yq0YqtkfXO6nwOzNh2Sov3cxCRX
	 8vGG2j+R1HoarDmAUJjs7IK9qctEIRO3AjsHOGcCxtKH6AxxZU1ivA4X7qnvVCiZ8E
	 yYFyRqej10uKfi5j1youataNFxj0+ztmVf1ToRrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0395/3318] module: Factor out elf_validity_ehdr
Date: Wed, 18 Nov 2026 15:16:57 +0100
Message-ID: <20261118150328.225562138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Maurer <mmaurer@google.com>

[ Upstream commit 90f8f312db720dbabec7c6258ef580b50129cc21 ]

Factor out verification of the ELF header and document what is checked.

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 9a5ff4568932 ("module: validate string table section types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 70 +++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index ac528fbb62824..3ee2d1538af07 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1655,6 +1655,50 @@ static int validate_section_offset(struct load_info *info, Elf_Shdr *shdr)
 	return 0;
 }
 
+/**
+ * elf_validity_ehdr() - Checks an ELF header for module validity
+ * @info: Load info containing the ELF header to check
+ *
+ * Checks whether an ELF header could belong to a valid module. Checks:
+ *
+ * * ELF header is within the data the user provided
+ * * ELF magic is present
+ * * It is relocatable (not final linked, not core file, etc.)
+ * * The header's machine type matches what the architecture expects.
+ * * Optional arch-specific hook for other properties
+ *   - module_elf_check_arch() is currently only used by PPC to check
+ *   ELF ABI version, but may be used by others in the future.
+ *
+ * Return: %0 if valid, %-ENOEXEC on failure.
+ */
+static int elf_validity_ehdr(const struct load_info *info)
+{
+	if (info->len < sizeof(*(info->hdr))) {
+		pr_err("Invalid ELF header len %lu\n", info->len);
+		return -ENOEXEC;
+	}
+	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0) {
+		pr_err("Invalid ELF header magic: != %s\n", ELFMAG);
+		return -ENOEXEC;
+	}
+	if (info->hdr->e_type != ET_REL) {
+		pr_err("Invalid ELF header type: %u != %u\n",
+		       info->hdr->e_type, ET_REL);
+		return -ENOEXEC;
+	}
+	if (!elf_check_arch(info->hdr)) {
+		pr_err("Invalid architecture in ELF header: %u\n",
+		       info->hdr->e_machine);
+		return -ENOEXEC;
+	}
+	if (!module_elf_check_arch(info->hdr)) {
+		pr_err("Invalid module architecture in ELF header: %u\n",
+		       info->hdr->e_machine);
+		return -ENOEXEC;
+	}
+	return 0;
+}
+
 /*
  * Check userspace passed ELF module against our expectations, and cache
  * useful variables for further processing as we go.
@@ -1684,30 +1728,10 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	unsigned int num_info_secs = 0, info_idx;
 	unsigned int num_sym_secs = 0, sym_idx;
 
-	if (info->len < sizeof(*(info->hdr))) {
-		pr_err("Invalid ELF header len %lu\n", info->len);
-		goto no_exec;
-	}
+	err = elf_validity_ehdr(info);
+	if (err < 0)
+		return err;
 
-	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0) {
-		pr_err("Invalid ELF header magic: != %s\n", ELFMAG);
-		goto no_exec;
-	}
-	if (info->hdr->e_type != ET_REL) {
-		pr_err("Invalid ELF header type: %u != %u\n",
-		       info->hdr->e_type, ET_REL);
-		goto no_exec;
-	}
-	if (!elf_check_arch(info->hdr)) {
-		pr_err("Invalid architecture in ELF header: %u\n",
-		       info->hdr->e_machine);
-		goto no_exec;
-	}
-	if (!module_elf_check_arch(info->hdr)) {
-		pr_err("Invalid module architecture in ELF header: %u\n",
-		       info->hdr->e_machine);
-		goto no_exec;
-	}
 	if (info->hdr->e_shentsize != sizeof(Elf_Shdr)) {
 		pr_err("Invalid ELF section header size\n");
 		goto no_exec;
-- 
2.53.0



