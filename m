Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98DB1E526;
	Thu, 15 Aug 2024 14:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731678; cv=none; b=LJGWSlXAu+F+SG2dI8TpR4OcWsoIN3hd2v8yhEgTiFyk3Q4FMvGqaNWUC6+1BXNsoBcBBOBDImlrZljXrPgCAcc94Dcx7dDDT1Nj+jGSOyQM4nK93kkg7Ts/FCH5F/J5NR5lwcG4IgDU395hBno7LJu5uQ2N/9/QJ16KQkA80xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731678; c=relaxed/simple;
	bh=pZC5wPhF3I/gAXK1F+L3x9mUAMdgbzRhjGpgSrO5duk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC0h52ziO8oaqBzhneBIkF+a3i875sXKWtxZWPj6s7e23tUQGXiyAl590peevsgDetu8borQUSnfJxF1hhpJibHwaADb+0wJ4tXeCD3RbeaP1Q2Rpq0aqU8tkJsJTo+RnY/2l8BQsARNsM8aTUwKDCKy/v/gRZrvr5NaziCMZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYB/AEcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYB/AEcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1800DC32786;
	Thu, 15 Aug 2024 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731678;
	bh=pZC5wPhF3I/gAXK1F+L3x9mUAMdgbzRhjGpgSrO5duk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYB/AEccilOgykwRDmygaIHqEQZWAiVlZEw4Kzy0IhMwQsPcGCFe7vJYni1fCh2l+
	 /2uv2bFPkcFtgzHzsUWGI4LrTUQhcMs6U4UvN8zEU0r+RuuwQxlj9NtG48bXGXRMKE
	 JrCXWlMB4xtcwoDhLGtB9e9tq+hKaAUust0vocWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/259] parport: Standardize use of printmode
Date: Thu, 15 Aug 2024 15:24:55 +0200
Message-ID: <20240815131909.040606805@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

[ Upstream commit a6abfdff4fe5dd19d1f1b37d72ba34cd4492fd4d ]

Standardize the define and the uses of printmode.

Miscellanea:

o Add missing statement termination ; where necessary

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/20200403134325.11523-8-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ab11dac93d2d ("dev/parport: fix the array out-of-bounds risk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/parport_gsc.c |  8 ++++++--
 drivers/parport/parport_pc.c  | 14 ++++++--------
 drivers/parport/procfs.c      |  6 +++++-
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 81082d5899b06..54963f5033fab 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -299,12 +299,16 @@ struct parport *parport_gsc_probe_port(unsigned long base,
 		p->dma = PARPORT_DMA_NONE;
 
 	pr_cont(" [");
-#define printmode(x) {if(p->modes&PARPORT_MODE_##x){pr_cont("%s%s",f?",":"",#x);f++;}}
+#define printmode(x)							\
+do {									\
+	if (p->modes & PARPORT_MODE_##x)				\
+		pr_cont("%s%s", f++ ? "," : "", #x);			\
+} while (0)
 	{
 		int f = 0;
 		printmode(PCSPP);
 		printmode(TRISTATE);
-		printmode(COMPAT)
+		printmode(COMPAT);
 		printmode(EPP);
 //		printmode(ECP);
 //		printmode(DMA);
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 4acf3d017a187..bf9fe2c025490 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2143,19 +2143,17 @@ struct parport *parport_pc_probe_port(unsigned long int base,
 
 	pr_cont(" [");
 
-#define printmode(x) \
-	{\
-		if (p->modes & PARPORT_MODE_##x) {\
-			pr_cont("%s%s", f ? "," : "", #x);	\
-			f++;\
-		} \
-	}
+#define printmode(x)							\
+do {									\
+	if (p->modes & PARPORT_MODE_##x)				\
+		pr_cont("%s%s", f++ ? "," : "", #x);			\
+} while (0)
 
 	{
 		int f = 0;
 		printmode(PCSPP);
 		printmode(TRISTATE);
-		printmode(COMPAT)
+		printmode(COMPAT);
 		printmode(EPP);
 		printmode(ECP);
 		printmode(DMA);
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 48804049d6972..e957beb94f142 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -213,7 +213,11 @@ static int do_hardware_modes(struct ctl_table *table, int write,
 		return -EACCES;
 
 	{
-#define printmode(x) {if(port->modes&PARPORT_MODE_##x){len+=sprintf(buffer+len,"%s%s",f?",":"",#x);f++;}}
+#define printmode(x)							\
+do {									\
+	if (port->modes & PARPORT_MODE_##x)				\
+		len += sprintf(buffer + len, "%s%s", f++ ? "," : "", #x); \
+} while (0)
 		int f = 0;
 		printmode(PCSPP);
 		printmode(TRISTATE);
-- 
2.43.0



