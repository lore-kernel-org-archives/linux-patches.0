Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422331FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C618C4339B;
	Fri,  3 Feb 2023 10:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419348;
	bh=CeJ2r+/LSNxIsohXanKRY9uSKANAWJGw/9fWllbpYtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5MgEeaG2J4t5l1tPHq9DpgfwPZY98WSSR50V37AHc+1YSnj8Uy5tGyej2HfKyoqP
	 HgCdxnXAHGpl9VxnIjOwGAOGhpArBKVvMWXM7frhGKTPPEGOm9WxaH3xENZqFHOS7B
	 ++UaLmFUlk2gENhYYZVUM6XWvRzGxBggYRp/xRxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Dokyung Song <dokyungs@yonsei.ac.kr>,
	Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
	Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/62] wifi: brcmfmac: fix up incorrect 4.14.y backport for brcmf_fw_map_chip_to_name()
Date: Fri,  3 Feb 2023 11:12:35 +0100
Message-Id: <20230203101014.663497180@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit bc45aa1911bf699b9905f12414e3c1879d6b784f which is commit
81d17f6f3331f03c8eafdacea68ab773426c1e3c upstream, the return value of the
error condition needs to be reworked to return a real error and not NULL.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Cc: Dokyung Song <dokyungs@yonsei.ac.kr>
Cc: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Cc: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/Y8gccXXyE30sbPSg@dev-arch.thelio-3990X
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -574,7 +574,7 @@ int brcmf_fw_map_chip_to_name(u32 chip,
 
 	if (chiprev >= BITS_PER_TYPE(u32)) {
 		brcmf_err("Invalid chip revision %u\n", chiprev);
-		return NULL;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < table_size; i++) {


