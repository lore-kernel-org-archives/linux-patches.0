Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F071EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852A0C433C7;
	Tue, 25 Jul 2023 10:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282179;
	bh=GZQE/dUV8fdTiQPsmFVhYmZtTkdqJkiPLIUXQKPkJ84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VniHKW/bk3J0OH6jyP11Ac2QBtFPNeU1Nt3sIlnXSSmY3X07kLpQYVV47iEnT21R7
	 V9jQrXUKQ9NrddHoEt4TVmsHp2OlWVfKWcAbFH0lQmMBnZ5jfdN1uAFEuLe2GL8ln7
	 W5sAwFXilPMchCc0rrMx7hxxu9s+bdpLkpfnhJ1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 008/227] maple_tree: fix node allocation testing on 32 bit
Date: Tue, 25 Jul 2023 12:42:55 +0200
Message-ID: <20230725104515.136899892@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit ef5c3de5211b5a3a8102b25aa83eb4cde65ac2fd upstream.

Internal node counting was altered and the 64 bit test was updated,
however the 32bit test was missed.

Restore the 32bit test to a functional state.

Link: https://lore.kernel.org/linux-mm/CAMuHMdV4T53fOw7VPoBgPR7fP6RYqf=CBhD_y_vOg53zZX_DnA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230712173916.168805-2-Liam.Howlett@oracle.com
Fixes: 541e06b772c1 ("maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/radix-tree/maple.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -206,9 +206,9 @@ static noinline void check_new_node(stru
 				e = i - 1;
 		} else {
 			if (i >= 4)
-				e = i - 4;
-			else if (i == 3)
-				e = i - 2;
+				e = i - 3;
+			else if (i >= 1)
+				e = i - 1;
 			else
 				e = 0;
 		}


