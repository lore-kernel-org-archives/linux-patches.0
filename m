Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9913BA23B;
	Mon, 23 Mar 2026 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278853; cv=none; b=ndqTLonnQOnmLSd8bK1JoQx3dxtYV05fLqiL8mJm4dP/BQ6hZS1HRTOcrMVtj4mf4Df33N1TggZ7+ZjylwPuuRNiYep0er9Ht80nYCojHt1Ssjksz66D1uCTeSawF0Lx6i83vt+lASjfRJrlrQIORuk2lmPWeKtGQ6cOn2NqIG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278853; c=relaxed/simple;
	bh=Yjci8aRcdFyfJQnEi4umAhMaLMIqP4R8APMQavrOi1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K7D8054/q23Yxz7qUCTX2UkQK5bPhV1PhfBzh8PLkejVv6uJgCRKdJibmrN9MjkGiB7DkeboqSJGvqUa25OH4QiHBZEzbhrFZMAuEnIjUsSxyuArerflub732oQFBtaeqiEWVXk8ngrQhJrzMwP784ww4DtnAA0pFUik2tAJ4ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpnDROjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpnDROjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153F8C4CEF7;
	Mon, 23 Mar 2026 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278853;
	bh=Yjci8aRcdFyfJQnEi4umAhMaLMIqP4R8APMQavrOi1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpnDROjYSTl8HoVt8nMVazQMpoI26KsPZcQBGkg2B6wHCVFrjnn3peQNzvRIwOtzf
	 2u5Lq05QnCGJwABQ2ulXXlbGMouczy/OLaIvXRyqIYRxLwar58hSczqA6GfurK4j0g
	 MoI2bmLgvcPm0sZB9px68fz2fcTh5UOc9bLGmm+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6 440/567] platform/x86/amd/pmc: Add support for Van Gogh SoC
Date: Mon, 23 Mar 2026 14:46:00 +0100
Message-ID: <20260323134544.839967055@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit db4a3f0fbedb0398f77b9047e8b8bb2b49f355bb ]

The ROG Xbox Ally (non-X) SoC features a similar architecture to the
Steam Deck. While the Steam Deck supports S3 (s2idle causes a crash),
this support was dropped by the Xbox Ally which only S0ix suspend.

Since the handler is missing here, this causes the device to not suspend
and the AMD GPU driver to crash while trying to resume afterwards due to
a power hang.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4659
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20251024152152.3981721-2-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ Adjust context ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |    3 +++
 drivers/platform/x86/amd/pmc/pmc.h |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -294,6 +294,7 @@ static void amd_pmc_get_ip_info(struct a
 	switch (dev->cpu_id) {
 	case AMD_CPU_ID_PCO:
 	case AMD_CPU_ID_RN:
+	case AMD_CPU_ID_VG:
 	case AMD_CPU_ID_YC:
 	case AMD_CPU_ID_CB:
 		dev->num_ips = 12;
@@ -698,6 +699,7 @@ static int amd_pmc_get_os_hint(struct am
 	case AMD_CPU_ID_PCO:
 		return MSG_OS_HINT_PCO;
 	case AMD_CPU_ID_RN:
+	case AMD_CPU_ID_VG:
 	case AMD_CPU_ID_YC:
 	case AMD_CPU_ID_CB:
 	case AMD_CPU_ID_PS:
@@ -908,6 +910,7 @@ static const struct pci_device_id pmc_pc
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_PCO) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_RV) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_SP) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_VG) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M20H_ROOT) },
 	{ }
 };
--- a/drivers/platform/x86/amd/pmc/pmc.h
+++ b/drivers/platform/x86/amd/pmc/pmc.h
@@ -47,6 +47,7 @@ void amd_pmc_quirks_init(struct amd_pmc_
 #define AMD_CPU_ID_RN			0x1630
 #define AMD_CPU_ID_PCO			AMD_CPU_ID_RV
 #define AMD_CPU_ID_CZN			AMD_CPU_ID_RN
+#define AMD_CPU_ID_VG			0x1645
 #define AMD_CPU_ID_YC			0x14B5
 #define AMD_CPU_ID_CB			0x14D8
 #define AMD_CPU_ID_PS			0x14E8


