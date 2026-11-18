Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019719;
	b=mHoULnJOccHuVAsusWvmJwzU7MFGuoqDM2VAXjdBEODS+weVi3Nd8yThBpS2NzCGP1fB
	 QGqKeHVktl7CWGS7HEcKtajBksJ/MSmmjCNCdHRN5n5amv75MtCpwZv28lP87kIyii+C9
	 Ur6Rw3wU8AQ7K7hFv7nMIEfcQYROJ0/gptaMQeUPuN2H6C0DrW7BHArts1rGzMRfnIPVb
	 aNsAktvVx6SWoTLq8QMLjUAahU8b2W0BjsHRQgPjsxv1UJBIcg8CWcPIwfVzqBMHQSTyB
	 sOPGnAdD0V35gouRKWk8e04xWNQZLSRfCdync4vr9fSBIL/g/Y+M+J6sQP0YXJr960Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yePNK3/j9thFDpiAiOuDSynra+CJs0kUlMfjF3T8TA8=;
	b=2UWRmL8EARGSFyYfkpYgs0LiZ2YcBXNAa1Wb698qK2b/zXlpt9zbomKGVH2WNZJpeRnD
	 6ACZq+txTKznFS6UXhjTogpJtOu7kBgf2e7YbSaSi9Q4VssFHqiVdhtcQgrxa0jnLMPPf
	 ELvSbUup5YG7WFGOcGvzb9522Rvsm/DTsucmfXQcEXQlkaWlY9ReTmTFFQNK4s/58gnj8
	 WCaGn9Ibl5omm+wEaO9QqXqSGUJHzsBxXAZtDC0omQKxNCjzCahgM3G29KuHTGENISKx0
	 rltL0udCdXhLoVDmvb0Bgf1kNjh3H8vz2niM+ZeG2wPfXOKUZbAJ5+1BdjAd8fdHDRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UviyqiVW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44884606A320;
	Wed, 18 Nov 2026 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UviyqiVW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947001F000C4;
	Wed, 18 Nov 2026 16:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019719;
	bh=yePNK3/j9thFDpiAiOuDSynra+CJs0kUlMfjF3T8TA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UviyqiVWxwAVyAS5Pb32yxkPc9ixeLneicZg//chn1WJsogNPAJW0Du8V2hm2gyTn
	 qgceJ3baB7aJapV1Qv+45DMXiCea5yAcnrGJCngr1r4Ab8+MSecxEWYJfu7Ua8y5M+
	 JTqLtpZWfvk+Xaf7QwKODIuHXustYUQ/JX9dz6PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1695/2651] platform/x86/amd/pmc: clear devm-managed pointers on remove to prevent stale reuse
Date: Wed, 18 Nov 2026 15:48:55 +0100
Message-ID: <20261118150348.687168692@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit c9ba86f5411730ebd333d94b9e1aa8f652dc743f ]

The driver stores its state in a single file-scope static struct
amd_pmc_dev, which is reused on every bind. Its regbase, smu_virt_addr,
stb_virt_addr and fch_virt_addr members are MMIO mappings created with
devm_ioremap().

On unbind the driver core unmaps these mappings, but it does not clear
the pointers in the static struct. Since the struct is not freed, the
members keep pointing at the now-unmapped addresses.

On the next bind, the probe path re-maps a region only when its pointer
is still NULL, so the stale pointer is reused and the following
memcpy_fromio()/ioread32() touches freed MMIO, causing use-after-unmap
crash. Clear these pointers in amd_pmc_remove() so the next probe re-maps
them instead of reusing stale ones.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Fixes: 156ec4731cb22b ("platform/x86: amd-pmc: Add AMD platform support for S2Idle")
Link: https://patch.msgid.link/20260929155609.1712638-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 038b05e36b65a..c2ca56ef3d4ee 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -957,6 +957,10 @@ static void amd_pmc_remove(struct platform_device *pdev)
 	pci_dev_put(dev->rdev);
 	if (IS_ENABLED(CONFIG_AMD_MP2_STB))
 		amd_mp2_stb_deinit(dev);
+	dev->regbase = NULL;
+	dev->smu_virt_addr = NULL;
+	dev->stb_virt_addr = NULL;
+	dev->fch_virt_addr = NULL;
 }
 
 static const struct acpi_device_id amd_pmc_acpi_ids[] = {
-- 
2.53.0



