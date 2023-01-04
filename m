Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D5CAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB1DC433F0;
	Wed,  4 Jan 2023 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849126;
	bh=3DkUk8eoE+2U/AM6ITA7Epiw5Jk91N0GFUzZv0dBMkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdshHrnY5BMaFDSH/oyd+0PBFEQEN/4GGcmiSXKlDZmzAjGwJVq6gCJU0iZ6EzXD/
	 v0qLd+SY0o10H6VQ4l9PrasRiSLt3CWw1G2hLY1aAKjeBAQWoTMEVxc2f3Db1QIF2p
	 N8H2Mi1RvXjY0CAyP/JRannn1LfQxZd0uS/9jULY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.1 114/207] efi: Add iMac Pro 2017 to uefi skip cert quirk
Date: Wed,  4 Jan 2023 17:06:12 +0100
Message-Id: <20230104160515.518997445@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aditya Garg <gargaditya08@live.com>

commit 0be56a116220f9e5731a6609e66a11accfe8d8e2 upstream.

The iMac Pro 2017 is also a T2 Mac. Thus add it to the list of uefi skip
cert.

Cc: stable@vger.kernel.org
Fixes: 155ca952c7ca ("efi: Do not import certificates from UEFI Secure Boot for T2 Macs")
Link: https://lore.kernel.org/linux-integrity/9D46D92F-1381-4F10-989C-1A12CD2FFDD8@live.com/
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/platform_certs/load_uefi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -35,6 +35,7 @@ static const struct dmi_system_id uefi_s
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMacPro1,1") },
 	{ }
 };
 


