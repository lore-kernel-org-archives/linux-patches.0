Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676CB1DDA20;
	Wed, 19 Feb 2025 09:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956651; cv=none; b=NB32KWDw05fTcJ1BFPulxUXSMOYl3WCg1LuOgHhWn98gSxI4XQVa/ljBV1HyarlsBepGUuK7H2C23XtSLuQqlg7oh+zVO9iI+Q3Zx87cJ5JQPj5m6qoLyb8jwdBv9RlzQnEDieCqjE512ct/r/yIEqBGEnSKUnOPq3a0cQSsqVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956651; c=relaxed/simple;
	bh=GOVBkhckR9o4IqibJVhtMCsw7ipEldDMshHPPaod3p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+EjCDH6KkuiAqoVqxiRKvz4lPzsipBLk60iwHtXxRcdqxAbPUmVCLjeMGhicOade0vB6grcLO8canbu8hvUUdhct1MlbDNLp1bNmVujxGXe2Naxhm+DNJQDyqIpFoNPKCrINh8mA/6w87W+19gZ4sdAcrF16hZYv+zW/YxApTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfoHnfhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfoHnfhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F80C4CED1;
	Wed, 19 Feb 2025 09:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956651;
	bh=GOVBkhckR9o4IqibJVhtMCsw7ipEldDMshHPPaod3p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfoHnfhvyOZj2z87LR/MkI2MEsXTLvP7XXvgsqqRuoH3lkk9PB7eTg5NIgShi5Luv
	 fx9On5BjzCaZPkYWMBxhgNGSwLOCb/+kapn2vgtlMJvsOEsLxd97h3IBIcMjhJcGDj
	 DwniH/KhqbpQ4GIcAXSHbYmci/mVp3mReSG9rXZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/578] tools/bootconfig: Fix the wrong format specifier
Date: Wed, 19 Feb 2025 09:23:35 +0100
Message-ID: <20250219082701.358243290@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Yifan <luoyifan@cmss.chinamobile.com>

[ Upstream commit f6ab7384d554ba80ff4793259d75535874b366f5 ]

Use '%u' instead of '%d' for unsigned int.

Link: https://lore.kernel.org/all/20241105011048.201629-1-luoyifan@cmss.chinamobile.com/

Fixes: 973780011106 ("tools/bootconfig: Suppress non-error messages")
Signed-off-by: Luo Yifan <luoyifan@cmss.chinamobile.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 156b62a163c5a..8a48cc2536f56 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -226,7 +226,7 @@ static int load_xbc_from_initrd(int fd, char **buf)
 	/* Wrong Checksum */
 	rcsum = xbc_calc_checksum(*buf, size);
 	if (csum != rcsum) {
-		pr_err("checksum error: %d != %d\n", csum, rcsum);
+		pr_err("checksum error: %u != %u\n", csum, rcsum);
 		return -EINVAL;
 	}
 
@@ -395,7 +395,7 @@ static int apply_xbc(const char *path, const char *xbc_path)
 	xbc_get_info(&ret, NULL);
 	printf("\tNumber of nodes: %d\n", ret);
 	printf("\tSize: %u bytes\n", (unsigned int)size);
-	printf("\tChecksum: %d\n", (unsigned int)csum);
+	printf("\tChecksum: %u\n", (unsigned int)csum);
 
 	/* TODO: Check the options by schema */
 	xbc_exit();
-- 
2.39.5



