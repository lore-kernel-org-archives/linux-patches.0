Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA11E3BB42
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/SJqLDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AD1C433C8;
	Wed, 15 Nov 2023 19:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077928;
	bh=nhRnCxo3iRsWWLLgM7Sug8JHgfzeHe/7Y+axY8sheno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/SJqLDWF8DsP+5nfePIz7Dln7MXedS+aohC1jyKjNtp4siAjH/hJo0Z+IqZyzEKI
	 v2i6M2Bv/qSH+9OuchXdmC921HwCo8NkkyDAvAr4qlsuxDvnMKHPPd9dYFYxS4UogB
	 x91OsUQCwavJaOE8PqCUJa8WQyH9H4EUd8M5Tepw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 599/603] x86/amd_nb: Use Family 19h Models 60h-7Fh Function 4 IDs
Date: Wed, 15 Nov 2023 14:19:04 -0500
Message-ID: <20231115191652.521143167@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 2a565258b3f4bbdc7a3c09cd02082cb286a7bffc upstream.

Three PCI IDs for DF Function 4 were defined but not used.

Add them to the "link" list.

Fixes: f8faf3496633 ("x86/amd_nb: Add AMD PCI IDs for SMN communication")
Fixes: 23a5b8bb022c ("x86/amd_nb: Add PCI ID for family 19h model 78h")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230803150430.3542854-1-yazen.ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_nb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -112,6 +112,9 @@ static const struct pci_device_id amd_nb
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M10H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M40H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M50H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M60H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M70H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_MI200_DF_F4) },


