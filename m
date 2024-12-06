Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62709149E1A;
	Fri,  6 Dec 2024 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498433; cv=none; b=Tv84/Ng1mbc5TBG4Vxg/EOGU4udClqwYNnMcMtwJmTCfPHZlJ+zPuvxXF/wWUsy0B1DDsITWF2boT4h0Sc4zAmAfVwP2e0Vi8z1wRSVN64ysDpjoQL2gyQrSpkf+ow7/bLMWaHHKy64dMMJAWk7EEKxZe56L09OsPJtwxT2Txbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498433; c=relaxed/simple;
	bh=nGBWT6cM14ETN0lvB9vyZT6jJMtln3mRta3O1JR+VxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PicTykBeVwOXhTZdezrgw1b01bjeIanp18D/pRYpbWXTTPDh9Dpz28PpgiMrzV4vZfzwYul6TJi3oMRFRQCgDei8B5EzWlnPLc+4NsoaYxdgIRWry1T/+NfnFOf0endqJ44nIZY1t6ijfF7fqJ6AP27I21oct4exZ+ncTaOpk3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kd+PWLwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kd+PWLwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4251C4CEDF;
	Fri,  6 Dec 2024 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498433;
	bh=nGBWT6cM14ETN0lvB9vyZT6jJMtln3mRta3O1JR+VxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kd+PWLwdBNrUY0cE5jMuITmT97+FTC25Xh46ri2izkfeXHt9cK7VEFvs9LAvbfPr6
	 0krSQKUa6M6URTmHO/t6nkwkcPvxNUFasu8BDGnQ8+lngLlv5iuRU8YxnEatbCzOl4
	 2okoR8cTSQRUwdMPM1HfsEooStJa5rhLvliGeEBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 582/676] modpost: remove MEM_INIT_SECTIONS macro
Date: Fri,  6 Dec 2024 15:36:41 +0100
Message-ID: <20241206143716.102563639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 473a45bb35f080e31cb4fe45e905bfe3bd407fdf ]

ALL_XXXINIT_SECTIONS and MEM_INIT_SECTIONS are the same.
Remove the latter.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: bb43a59944f4 ("Rename .data.unlikely to .data..unlikely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 7e88e6437540e..e43862cd002e2 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -805,7 +805,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 	".pci_fixup_enable", ".pci_fixup_resume", \
 	".pci_fixup_resume_early", ".pci_fixup_suspend"
 
-#define ALL_XXXINIT_SECTIONS MEM_INIT_SECTIONS
+#define ALL_XXXINIT_SECTIONS ".meminit.*"
 
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS
@@ -819,7 +819,6 @@ static void check_section(const char *modname, struct elf_info *elf,
 		".coldtext", ".softirqentry.text"
 
 #define INIT_SECTIONS      ".init.*"
-#define MEM_INIT_SECTIONS  ".meminit.*"
 
 #define EXIT_SECTIONS      ".exit.*"
 
-- 
2.43.0



