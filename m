Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B9FDF71;
	Wed,  5 Feb 2025 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767432; cv=none; b=fjA0EefNea3MXFrhXZRIHGqX3mvs/05TJZOixCRbq1WoDeqAYo2/FEQ/mxo/FR+cZMfNKBnObBogISBs3GatldqX+cW1OqICukju7SH2LZVA48Ulp57rJ9s8QLxyl58FUuW/dT7o14uXcnQckOxvwa8A8/mz5vhUXZDKrPkuCRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767432; c=relaxed/simple;
	bh=WX3SF22+tZWLyK7AReY9YfoAUOc9OAVCG7h9nPsibwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg3NT4CBo70y+wjoLyEhMXETsdTpPMayOm66ePLKTDAqGaL8hSaTaLdj4fNtNn+ksCvgyn1kETbLCWfP/62LuPaywWs/JOZKdygVIgdzylDktNFpt8vIcwAtLVSRIKSaLodf71wyElZtPkTWte4KJxFFLYdC8mjB1hJSXYYOIY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6hyQyLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6hyQyLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6CEC4CED1;
	Wed,  5 Feb 2025 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767432;
	bh=WX3SF22+tZWLyK7AReY9YfoAUOc9OAVCG7h9nPsibwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6hyQyLOWMifKf6B5vz2gAMCG/bA+EI+VTQx8tY2GG9z6kqg2Y0e9r2UmUaFRAHlU
	 tlUVmMiCizCdxBD+bNXahZYmLed/oH6YNgBuj0IzVZm5NeugJqsKUHSg59hcXjIML7
	 438DwL3WpknsxvLFQXbIZPAzF861hySCb8T1AS8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 456/590] tools/bootconfig: Fix the wrong format specifier
Date: Wed,  5 Feb 2025 14:43:31 +0100
Message-ID: <20250205134512.710049745@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



