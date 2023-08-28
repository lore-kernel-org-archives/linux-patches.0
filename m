Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFDA8BE0
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2E0C433C7;
	Mon, 28 Aug 2023 10:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219821;
	bh=7yK52mSQixDEg609TzokxM0zKnE18DMRdF0PXUr+tD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTh21a4Jt4ToZd3JSccFMZA/ULzoBVhAqNDk7H9LyZt4aj9F22McDXddneijxNXpK
	 YL8Ecp4UGMlTAuOkWs2DG21IC9N8xq94xkhmPJ3k25/FNIH6VIpd2nKeDcBBlIA+l9
	 oxmrgNRfAI18wGDYKabtPeJVb5IJbc1T/vgO4ivQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Salvador <osalvador@suse.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 84/84] mm,hwpoison: fix printing of page flags
Date: Mon, 28 Aug 2023 12:14:41 +0200
Message-ID: <20230828101152.119646244@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Salvador <osalvador@suse.de>

commit 6696d2a6f38c0beedf03c381edfc392ecf7631b4 upstream.

Format %pG expects a lower case 'p' in order to print the flags.
Fix it.

Link: https://lkml.kernel.org/r/20210108085202.4506-1-osalvador@suse.de
Fixes: 8295d535e2aa ("mm,hwpoison: refactor get_any_page")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1928,7 +1928,7 @@ retry:
 			ret = -EBUSY;
 		}
 	} else if (ret == -EIO) {
-		pr_info("%s: %#lx: unknown page type: %lx (%pGP)\n",
+		pr_info("%s: %#lx: unknown page type: %lx (%pGp)\n",
 			 __func__, pfn, page->flags, &page->flags);
 	}
 


