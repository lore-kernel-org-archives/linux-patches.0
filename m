Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DD5BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFE8C433C8;
	Mon, 19 Jun 2023 10:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171987;
	bh=pGeDjDxZN8oJ4o7LYABuFyi3Kc23NvPqjI1ccz+uNHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQbLJvXfsSjptRhDfNECCbxhViagBnuE8ifsjqqOWKobipPRmHusEkGkVSBjRvizP
	 +qxvTC4zPcEQgPfXYc0pJqTsRt1AVsNeseWCeAaIUm3kGp32NqvdIeubA6Sp3e36uh
	 fS6WnGaUhEc7InY1a0HSiV9HDM2j/x5kKdFHcDAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 61/64] net: Remove unused inline function dst_hold_and_use()
Date: Mon, 19 Jun 2023 12:30:57 +0200
Message-ID: <20230619102135.973794266@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
References: <20230619102132.808972458@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 0b81882ddf8ac2743f657afb001beec7fc3929af upstream.

All uses of dst_hold_and_use() have
been removed since commit 1202cdd66531 ("Remove DECnet support
from kernel"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -236,12 +236,6 @@ static inline void dst_use_noref(struct
 	}
 }
 
-static inline void dst_hold_and_use(struct dst_entry *dst, unsigned long time)
-{
-	dst_hold(dst);
-	dst_use_noref(dst, time);
-}
-
 static inline struct dst_entry *dst_clone(struct dst_entry *dst)
 {
 	if (dst)


