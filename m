Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044871;
	b=lLWuCs6JujEQGrWxb8lrJEnxvpXdLxbXpmaQHLCb9bnjZvHaLDRRcXXpHZnSWcWhm83b
	 gyiQQsu+/80tVIvb/N57x4abYwlv2B1vrLMDGWXKGE0ZYhvJrBGTAESBUmBdFDf+GiPka
	 XaOaZ/oez944Ux4tcX4e2bWr4pLKWHulM77E7FAO1+cEbsdZKeYBN4Sldw3j2rO4Agqj+
	 891nHrgbbPNXYcxOIQgwNmPi8GxtfFqmrZx2YuWvmKsn0OMRZ3NgbacXA0hO/mcHiUrHC
	 Nsr3tNl2coE8yxC5GAWUO1Cv09zul3ZVefLtrfoAvp+GrvRXod8COVnLXTnHiTL6pIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mSCRpXWRVBbCHNLyM0XjknxRf7lmcMyL3+PQv6sZvhI=;
	b=2pRM61s2+egPSIB+ZH4jI9D53rF5cFWnZjD8b0TJjZfh5Ka5SmxmKIpji6h8NA5A1LVv
	 ADIAIARZ1/pw0YtUBeFyOvWL5lw6baYZLZNYh5aQejpCic3KXGeq58uqYg0tOeJyxUbFs
	 t2u0+fY9kiB9Mi083HU7RrDpFQfeEsoE4ksSDKtufxBDyCOzBcqYGxA28CN+RSDVYbEJo
	 sMrHWcPb4TPx9jg38cDVFLsJt35AL2OEchm0Dtxa41hqyCa4Y37vPmfLl9E8CpDbxiwyL
	 bsD/bl6h155uyv6z2i+z5ZQasd/7VYM7D89LP2loAvoCiHbCuF2oI6lzudiyu5UlD2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cj/u7yZy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC658606A9EB;
	Wed, 18 Nov 2026 23:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj/u7yZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA7C1F000C4;
	Wed, 18 Nov 2026 23:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044870;
	bh=mSCRpXWRVBbCHNLyM0XjknxRf7lmcMyL3+PQv6sZvhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cj/u7yZyRaEjYk6ZUDMJn3Nby6uXWL2cIzkBbOm5nR+G752EitzEo5q/eeAman72N
	 VZagmBjOTtpAAUUzlumtKkOgXmL2xrxMUyrr60fOsHcjM4hv/orajSJlT132ZA7Dym
	 fnm94IJ0M3LEvaPc0SWJU/4jnaj+yW2GQ1P++5Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0719/2857] remoteproc: elf_loader: Bound the section header table
Date: Wed, 18 Nov 2026 15:29:13 +0100
Message-ID: <20261118150227.433540977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit b32177ead5f8925aa66ceed2bd533a85196f4f0c ]

The rproc_elf_sanity_check() only checks the image is big enough to hold
one section header. But find_table() walks e_shnum of them, and first
dereferences the header at e_shstrndx to locate the section name table.
Both fields are u16 and both come from the image, so an e_shstrndx of
65535 reads about 4 MB past the buffer.

The commit 9f9967fed9d0 ("soc: qcom: mdt_loader: Ensure we don't read
past the ELF header") added the same check to the MDT loader, and says
the header "is sanitized beforehand" under remoteproc. That is what this
patch makes true.

Check e_shoff against the image size first, so the two bounds can use
size_add() without an e_shoff above SIZE_MAX wrapping on 32-bit. The
bounds are separate because e_shnum may be zero while find_table() still
reads the e_shstrndx header.

Fixes: 400e64df6b23 ("remoteproc: add framework for controlling remote processors")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://lore.kernel.org/r/20260724025322.2341205-1-sammiee5311@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_elf_loader.c | 23 ++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 5a412d7b6e0be..39301b80d879f 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -46,8 +46,9 @@ int rproc_elf_sanity_check(struct rproc *rproc, const struct firmware *fw)
 	struct elf32_hdr *ehdr;
 	u32 elf_shdr_get_size;
 	u64 phoff, shoff;
+	size_t shend;
 	char class;
-	u16 phnum;
+	u16 phnum, shnum, shstrndx;
 
 	if (!fw) {
 		dev_err(dev, "failed to load %s\n", name);
@@ -90,9 +91,27 @@ int rproc_elf_sanity_check(struct rproc *rproc, const struct firmware *fw)
 	phoff = elf_hdr_get_e_phoff(class, fw->data);
 	shoff = elf_hdr_get_e_shoff(class, fw->data);
 	phnum =  elf_hdr_get_e_phnum(class, fw->data);
+	shnum = elf_hdr_get_e_shnum(class, fw->data);
+	shstrndx = elf_hdr_get_e_shstrndx(class, fw->data);
 	elf_shdr_get_size = elf_size_of_shdr(class);
 
-	if (fw->size < shoff + elf_shdr_get_size) {
+	/* keeps shoff in size_t range for the two bounds below */
+	if (shoff > fw->size) {
+		dev_err(dev, "Section header table is out of bounds\n");
+		return -EINVAL;
+	}
+
+	if (shnum) {
+		shend = size_add(size_mul(elf_shdr_get_size, shnum), shoff);
+		if (shend > fw->size) {
+			dev_err(dev, "Section headers are out of bounds\n");
+			return -EINVAL;
+		}
+	}
+
+	/* find_table() reads the header at shstrndx even with no sections */
+	shend = size_add(size_mul(elf_shdr_get_size, (size_t)shstrndx + 1), shoff);
+	if (shend > fw->size) {
 		dev_err(dev, "Image is too small\n");
 		return -EINVAL;
 	}
-- 
2.53.0



