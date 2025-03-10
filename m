Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75B717CA12;
	Mon, 10 Mar 2025 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629038; cv=none; b=A0dPFSxhEkG317dfg1Ti9kVlaHtFEyTMh+5UxzFgJos04SybcAQOipIGV5Tnz02EjgtB2mgZKVPawFW2rbbQMYJAdkNmqy2JG5eaNalfWKAQ7HXWfORskN1ByLurFEk8HNy1MI/lF3+9RPsI/ow1AjD9NIeDoFZuxc/I0g/E048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629038; c=relaxed/simple;
	bh=XZk4Xd745tydzptiEyxYiFnPWlgJ0iBQCK3Sg1TbiBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9LbFsrHgPTSmfX6+wUnPmCmOUEMZmaNm53l+zCkrxvqYAL/4IbGSpSfpe539nJ5An0Fraoux1roPsm1UiH0dQrQ0OzQe7vXtG79LcC4ABxi7IV0bsGeftgRsSPu263BxOk1dxsrc9GqTO8i7PWYH/70OOI4bSIVexIbcq4Z34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCHJEq6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCHJEq6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73949C4CEE5;
	Mon, 10 Mar 2025 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629037;
	bh=XZk4Xd745tydzptiEyxYiFnPWlgJ0iBQCK3Sg1TbiBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCHJEq6LGOvpbVyuQbb5NuYh+VbMoD8MOA7vfn18z2Trr0/yiab0DgIf3KhBFWDjR
	 GKL+GWfUGB/dVFKM3SOvNijRKL7dbssY20yA4CrK2/hszgvNh6d9E9Bu2SbnbvAmr3
	 6gnja/Zsb9Sw1kMOqre1J4YOPh2BBLe3tji/Ojig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/620] tools/bootconfig: Fix the wrong format specifier
Date: Mon, 10 Mar 2025 18:00:02 +0100
Message-ID: <20250310170551.765820734@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fd67496a947f3..fc922cfdadaa6 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -225,7 +225,7 @@ static int load_xbc_from_initrd(int fd, char **buf)
 	/* Wrong Checksum */
 	rcsum = xbc_calc_checksum(*buf, size);
 	if (csum != rcsum) {
-		pr_err("checksum error: %d != %d\n", csum, rcsum);
+		pr_err("checksum error: %u != %u\n", csum, rcsum);
 		return -EINVAL;
 	}
 
@@ -393,7 +393,7 @@ static int apply_xbc(const char *path, const char *xbc_path)
 	printf("Apply %s to %s\n", xbc_path, path);
 	printf("\tNumber of nodes: %d\n", ret);
 	printf("\tSize: %u bytes\n", (unsigned int)size);
-	printf("\tChecksum: %d\n", (unsigned int)csum);
+	printf("\tChecksum: %u\n", (unsigned int)csum);
 
 	/* TODO: Check the options by schema */
 	xbc_destroy_all();
-- 
2.39.5



