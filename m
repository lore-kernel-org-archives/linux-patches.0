Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D715813C;
	Thu, 30 Nov 2023 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6y+/yz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9ECC433C7;
	Thu, 30 Nov 2023 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385104;
	bh=bDWsdsGQVTa25Vh2szzveTjrBmT9w1+541zhcJ5Hs8E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=C6y+/yz3CPBnIEdL9BEtMtniqkb2NxYKXzsDOTi+yUoR+XwtOIXrhskjizh0CcdjH
	 bsIyrjM8qH/836B3wvLTYgGiKdZTrkqmgCqpRs04jYPCW8aVzkcULsfXfGzGrKq0N8
	 bJGkBO92gTZxc6wI16TMlEmWnnVKXhUJ7CHbVK1cye/1OO+WQgkA0C9vdQkY6CYI9h
	 sV85QTUXkVNFrcbsK++YpZ3ZOY4GSSQgs0m8O+tpItHgAkXRjI0Po8zwyVzhFr/wke
	 CsWWUaR3eduZpZla1ZFJBWBYl2VklIKe3vs5pqjXTrhgRmWOKxogjdn27LM/aRm/B7
	 iYzz6ly45BHnQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:14 -0700
Subject: [PATCH 01/19] hexagon: uaccess: Remove clear_user_hexagon()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-1-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; i=nathan@kernel.org;
 h=from:subject:message-id; bh=bDWsdsGQVTa25Vh2szzveTjrBmT9w1+541zhcJ5Hs8E=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwr2bjAP++vA+5DrOt2dSTkHxFrZGm1xNh42mLy54r
 HwklFffUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACay6j4jw9tN1i9myn3u361y
 +X/E9U2cc5Wv6869zCb0OLNVgrttcwfDP4PzR7iU6t1+75bzeLAwfh43C5/Lt2eTXd5unuWlweT
 +hgkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/mm/uaccess.c:39:15: warning: no previous prototype for function 'clear_user_hexagon' [-Wmissing-prototypes]
     39 | unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
        |               ^
  arch/hexagon/mm/uaccess.c:39:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     39 | unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
        | ^
        | static
  1 warning generated.

This function appears to have been unused since it was introduced in
commit 7567746e1c0d ("Hexagon: Add user access functions"), so remove
it.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/mm/uaccess.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/hexagon/mm/uaccess.c b/arch/hexagon/mm/uaccess.c
index 650bca92f0b7..3204e9ba6d6f 100644
--- a/arch/hexagon/mm/uaccess.c
+++ b/arch/hexagon/mm/uaccess.c
@@ -35,11 +35,3 @@ __kernel_size_t __clear_user_hexagon(void __user *dest, unsigned long count)
 
 	return count;
 }
-
-unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
-{
-	if (!access_ok(dest, count))
-		return count;
-	else
-		return __clear_user_hexagon(dest, count);
-}

-- 
2.43.0

