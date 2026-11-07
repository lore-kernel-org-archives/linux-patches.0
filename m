Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064750;
	b=cfEFbYJB+fVrL7PGRH+p2opP1WrrKpxlm8WSe/a5NFcX4IkeTNGseswx8hs87fWZN0pl
	 e6F8CPeABpcUeSc6EGZSBILSH046JA45KhTc4Xww2zpc4FnU9GBoisgKX3GthFZnkyTsE
	 NMwouqZAmBSz1rE9kdpP99Wjrg76+f8XdsMttaZeNREBhixjqr52C8NqRXnuiSIg/B1+k
	 ctVYccRMeYheWLcqS6wkn5QcUbaVGrBbQ9zILCyregZ2HhomRSorhVOoQG0J6ZY3Zpbg3
	 wlmOlqTLwZ2OXT96+LJe0O80dJ2n+uFEiUFbkevgpjpGER2nEDrLMImHB3awvWe6SKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HLcMBcU5eYXkgg7WBCptmcn5yPDmtLxLwiitrwiHBWo=;
	b=dSrf8cpHi62euUsJXqKURKFl4fI8CLq+hjwOt7nOtfhjhk0/UxNMQ0TkOJwAMMjW4Ut9
	 hq16ZM2RGdYXdHIzawixe0CN/Xl2j7xKt/2aqPprHKYcEBk1aZrMJKAGLC3VvRryFTY6m
	 LDNPeyIC35LAKxxA7F94TvO0IFUqiO8Q5nWSgPJhoDMEqQPlIE+DyhI/1bTYOq1yH/ote
	 mH9zJpQgg0RibytXbVxWPjN38bsnUoln49a2C+ZlymMFPp9aE45E1mJsuHWb/feAomKC2
	 k/DCwAUH/9pHQMHgP9QEEyHJFkz5G3mYxH6P3kHTphcBl9jjHcy0oTBy0NHmYpAu6GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQotAmfU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7592B606A334;
	Sat,  7 Nov 2026 15:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQotAmfU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259321F008A1;
	Sat,  7 Nov 2026 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064750;
	bh=HLcMBcU5eYXkgg7WBCptmcn5yPDmtLxLwiitrwiHBWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQotAmfUTDqExq/I4g/3Tt+bQLwY7W7i7G1RvG2Kt+s/nmdLPtdyEspNUcDuB1zOT
	 uqj//HM4Ub8rVC9UNKYL+lZ32esHW3czEzob+yMBWCEtKxELGy1oIO1AFkbTEFLZFv
	 mkDum7ezBx9AuA/lZ4rgLDGaZdM2LrGoi0t9jkk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0724/1257] f2fs: allow empty strings for journaled quota options
Date: Sat,  7 Nov 2026 08:50:20 -0500
Message-ID: <20261107134959.259469469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit 0354a04b8c34e26cc66d0f43785d388163b6bacc ]

Commit 2a3db1e02ce0 ("f2fs: allow empty mount string for
Opt_usr|grp|projjquota") added support for passing usrjquota,
grpjquota and prjjquota as flags to disable journaled quotas.

However, it also replaced fsparam_string_empty() with fsparam_string(),
which rejects an empty string. As of now, mount(2) and
fsconfig(FSCONFIG_SET_STRING) reject usrjquota=, grpjquota= and
prjjquota= with EINVAL, although these forms are still documented in
Documentation/filesystems/f2fs.rst.

The issue can be reproduced on an F2FS device with:

    mount -t f2fs -o usrjquota= /dev/loop5 /mnt/f

Before this commit, the command succeeds. Afterwards, it fails with
EINVAL and logs "f2fs: Bad value for 'usrjquota'".
The same failure occurs when remounting to clear a quota file name.

This patch will restore fsparam_string_empty() for the three options
while retaining the flag entries, so both forms are accepted.

Fixes: 2a3db1e02ce0 ("f2fs: allow empty mount string for Opt_usr|grp|projjquota")
Cc: stable@vger.kernel.org # 7.1+
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 7a7348b59f97e..0278f2f193fbc 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -338,11 +338,11 @@ static const struct fs_parameter_spec f2fs_param_specs[] = {
 	fsparam_flag("usrquota", Opt_usrquota),
 	fsparam_flag("grpquota", Opt_grpquota),
 	fsparam_flag("prjquota", Opt_prjquota),
-	fsparam_string("usrjquota", Opt_usrjquota),
+	fsparam_string_empty("usrjquota", Opt_usrjquota),
 	fsparam_flag("usrjquota", Opt_usrjquota),
-	fsparam_string("grpjquota", Opt_grpjquota),
+	fsparam_string_empty("grpjquota", Opt_grpjquota),
 	fsparam_flag("grpjquota", Opt_grpjquota),
-	fsparam_string("prjjquota", Opt_prjjquota),
+	fsparam_string_empty("prjjquota", Opt_prjjquota),
 	fsparam_flag("prjjquota", Opt_prjjquota),
 	fsparam_flag("nat_bits", Opt_nat_bits),
 	fsparam_enum("jqfmt", Opt_jqfmt, f2fs_param_jqfmt),
-- 
2.53.0



