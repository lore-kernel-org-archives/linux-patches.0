Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193AAE4DF
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vwgcdlyuo+GJ5jvlI6ItnonZwvRm0XCG4SGb6jgIIUk=; b=dMTygatsLoA/2mFiksWRScl55F
	vdQLDay0b6L3bB/x+/odyMiMicp6eud00Iajv04D2ddWCyvWiafl9OIo5tou8FIOsvyLu16ZBB50x
	swGL2v8tqMw0P8jJEYy3/QzIRKcd88WHrFDx0Hv1gO8EwjgzhCItc5tQj3tyBcAWXcibMN7A1fcgA
	SMwQlmrB5SHEVnl6ReEcNznTdZurq/VPVJdZc9Pr6iaGLKObUHughlIWS1F9ChW5GGv5RfBNQ8vom
	VXqAaYigO9jd4r/iE6KHoTCdsFfRQOb4LmAAkwcxo/oeY0KwFQxHUMFl+uFQq94ITAjN2zgaZNmLM
	IvKM80xQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paluB-00GaJL-AJ; Fri, 10 Mar 2023 23:12:07 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: dhowells@redhat.com,
	linux-cachefs@redhat.com,
	jack@suse.com,
	jaharkes@cs.cmu.edu,
	coda@cs.cmu.edu,
	codalist@coda.cs.cmu.edu,
	anton@tuxera.com,
	linux-ntfs-dev@lists.sourceforge.net
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 4/5] coda: simplify one-level sysctl registration for coda_table
Date: Fri, 10 Mar 2023 15:12:05 -0800
Message-Id: <20230310231206.3952808-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310231206.3952808-1-mcgrof@kernel.org>
References: <20230310231206.3952808-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/coda/sysctl.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index fda3b702b1c5..a247c14aaab7 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -39,19 +39,10 @@ static struct ctl_table coda_table[] = {
 	{}
 };
 
-static struct ctl_table fs_table[] = {
-	{
-		.procname	= "coda",
-		.mode		= 0555,
-		.child		= coda_table
-	},
-	{}
-};
-
 void coda_sysctl_init(void)
 {
 	if ( !fs_table_header )
-		fs_table_header = register_sysctl_table(fs_table);
+		fs_table_header = register_sysctl("coda", coda_table);
 }
 
 void coda_sysctl_clean(void)
-- 
2.39.1

