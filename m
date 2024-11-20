Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1B1C1F2B;
	Wed, 20 Nov 2024 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107585; cv=none; b=r1No7q9XF3UkU6LtNiKiEZDForesFysYc4iDHjzgWx8oIJ+hK9rPGJh1AgzhpkUpDXknLt1E2eSh93gpouFiXbXEVkwSFjsz+IkKVZWbesX4duWHrowv8bsIXkROOLk+cSoYCFKUHy3BwJzch+52/EJ8Eg3iILcmAr2TTYMy6MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107585; c=relaxed/simple;
	bh=2aWOiMDrWPazcOBMG4C9oJUAOcDYSVKOG9pLdan6OUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EV3LfyZ8MYCKPCsYzqxBnU10xEs6L9Q7+dh+Zc3CLRGbBtZEOKhoGgBfFzy+ojJdZKIeY0b+8LBmkof/ScvCprnKp98X/n9IWrsZvNFTZj8uxFbDpQ4WEGlhc/cMC+1DxS7WEPwP8E65eZbu2GsR6c4660toouZeBN1EEWP0UJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcmTgNK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcmTgNK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97C4C4CECD;
	Wed, 20 Nov 2024 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107584;
	bh=2aWOiMDrWPazcOBMG4C9oJUAOcDYSVKOG9pLdan6OUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcmTgNK9CAKDT7U2hrTZw6XrhrPv4s4/MI2U98LLRiFhAXia30BTHJadlDOdLt40t
	 qY60Ynid0mVBsVYawCFnRIYYbxsd7X4pTOmLmUkpOo+JRRfaCc9D6spfRbCA84OgZk
	 Zbl1ZLxhBC3ma+F+91tPyywKmGgKKhXw0vx+cdH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Motiejus=20Jak=C3=85`tys?= <motiejus@jakstys.lt>,
	SeongJae Park <sj@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Wladislav Wiebe <wladislav.kw@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/82] tools/mm: fix compile error
Date: Wed, 20 Nov 2024 13:56:37 +0100
Message-ID: <20241120125630.222366412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Motiejus JakÅ`tys <motiejus@jakstys.lt>

[ Upstream commit a39326767c55c00c7c313333404cbcb502cce8fe ]

Add a missing semicolon.

Link: https://lkml.kernel.org/r/20241112171655.1662670-1-motiejus@jakstys.lt
Fixes: ece5897e5a10 ("tools/mm: -Werror fixes in page-types/slabinfo")
Signed-off-by: Motiejus JakÅ`tys <motiejus@jakstys.lt>
Closes: https://github.com/NixOS/nixpkgs/issues/355369
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/mm/page-types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 2a4ca4dd2da80..69f00eab1b8c7 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -421,7 +421,7 @@ static void show_page(unsigned long voffset, unsigned long offset,
 	if (opt_file)
 		printf("%lx\t", voffset);
 	if (opt_list_cgroup)
-		printf("@%" PRIu64 "\t", cgroup)
+		printf("@%" PRIu64 "\t", cgroup);
 	if (opt_list_mapcnt)
 		printf("%" PRIu64 "\t", mapcnt);
 
-- 
2.43.0



