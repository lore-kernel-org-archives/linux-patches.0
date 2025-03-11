Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0FD846D;
	Tue, 11 Mar 2025 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706576; cv=none; b=FE1IWaORwHXFsCWyXlzgc1GMqw59uPuUoelk4ulTQwJ82qdHcy3Cc+hDt5dxhR5//er9W5L37RjizAqmC4bOTMZ6I2SFvfEKpjJmL857W5gek8hsMycPyx88LAg9yh+kktNUkVGzVCy9aCqVGse7W91txFtsvQqoHWsrevhEIB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706576; c=relaxed/simple;
	bh=VVwmEQb+GvOfZlCxmr93QSh0GiJqLTK+9Wmk+0Gw838=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCnvZlknwdqUA/yP1oMcO7UY/uCsFmNpfkgVBc8/uvnU+r6rxRi453/OVdFOL+rUrcXtPBtr3d6GtHCH2xpkQfSmfuEwLEjpRLEefZRbCyojMFBYzGLjgrLCedVGXP4IvKb3HsY45cFkcJFq66SDEl9XoNTdeFKKmQy0ctFcMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvyTADf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvyTADf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98E7C4CEE9;
	Tue, 11 Mar 2025 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706576;
	bh=VVwmEQb+GvOfZlCxmr93QSh0GiJqLTK+9Wmk+0Gw838=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvyTADf+ZDlpBV4ZcIHTSWUlDjcASe+xh5uhPaZ18nO1+tn8ih9cJTD0vPOYxWl0m
	 VcJTdavDdNnVoheaycUpDLDul/nj/yHHB3yY+TzsEoN6P85q07ljXk5jkLiR1tKwtr
	 8tDSB+sq7M4iKY3v94OSIPlmoxlATygsH6A0+3HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/462] tools/bootconfig: Fix the wrong format specifier
Date: Tue, 11 Mar 2025 15:56:01 +0100
Message-ID: <20250311145802.107726853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6cd6080cac04c..365c022fb7cdd 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -207,7 +207,7 @@ static int load_xbc_from_initrd(int fd, char **buf)
 	/* Wrong Checksum */
 	rcsum = checksum((unsigned char *)*buf, size);
 	if (csum != rcsum) {
-		pr_err("checksum error: %d != %d\n", csum, rcsum);
+		pr_err("checksum error: %u != %u\n", csum, rcsum);
 		return -EINVAL;
 	}
 
@@ -375,7 +375,7 @@ static int apply_xbc(const char *path, const char *xbc_path)
 	printf("Apply %s to %s\n", xbc_path, path);
 	printf("\tNumber of nodes: %d\n", ret);
 	printf("\tSize: %u bytes\n", (unsigned int)size);
-	printf("\tChecksum: %d\n", (unsigned int)csum);
+	printf("\tChecksum: %u\n", (unsigned int)csum);
 
 	/* TODO: Check the options by schema */
 	xbc_destroy_all();
-- 
2.39.5



