Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073A8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43489C433D2;
	Tue, 28 Mar 2023 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015412;
	bh=Enun6d4xQjyUVhxu99y03YhiyEY1HIyer8NPEq/2RIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzG+73Nx7pcEpV2gw4twZmNKsCl/QLUF/pMtmunH9jDihpBn7G3JPUBPaylWXR7k3
	 mptbaU6gkovHpjR8dSRK7vOTuXWIOyYFsM3FCtY0OaoHV33pYB+/VQ9KQvJOvFHJ1Y
	 jNP4DfKS/pJdJ4Qe5/iyWZHNlK3lr1Wg6sssbunU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/224] efi/libstub: smbios: Use length member instead of record struct size
Date: Tue, 28 Mar 2023 16:40:35 +0200
Message-Id: <20230328142618.978873211@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 34343eb06afc04af9178a9883d9354dc12beede0 ]

The type 1 SMBIOS record happens to always be the same size, but there
are other record types which have been augmented over time, and so we
should really use the length field in the header to decide where the
string table starts.

Fixes: 550b33cfd4452968 ("arm64: efi: Force the use of ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/smbios.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/smbios.c b/drivers/firmware/efi/libstub/smbios.c
index 460418b7f5f5e..aadb422b9637d 100644
--- a/drivers/firmware/efi/libstub/smbios.c
+++ b/drivers/firmware/efi/libstub/smbios.c
@@ -36,7 +36,7 @@ const u8 *__efi_get_smbios_string(u8 type, int offset, int recsize)
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-	strtable = (u8 *)record + recsize;
+	strtable = (u8 *)record + record->length;
 	for (int i = 1; i < ((u8 *)record)[offset]; i++) {
 		int len = strlen(strtable);
 
-- 
2.39.2



