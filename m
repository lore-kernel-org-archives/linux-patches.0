Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66037EC;
	Fri,  1 Dec 2023 00:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sP7uaHMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C706DC433C7;
	Fri,  1 Dec 2023 00:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701390155;
	bh=0sskqPdOiwxsrAXv+xHq1vHKwLqnoYarlJMhWh98XH0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sP7uaHMoi08ja3mz/UZitvk+/DOMuNLB6jKBtzo6aeYWawwxlL79r8ZB9eJRQfd7g
	 jbVlgh28gx9uP0hz/Os8CD9x6rROgCqLQ+4jgc++2Ya+KqvmeURcrsT62eZHzcS+++
	 U45bkECmX3TAgBRLj7T8PNf3act1RWDSuL28WIobneazbaQSXvqZxdXzixpjlL3meN
	 TpTRyGf4vkRiJlBYKAQuzYq1JAsGLTRQRp5oWWOOSRtODRCuet3YrUIbPWfRLLi6ie
	 uOgAJLZiEIT0Eauj1OKFs32ckd7z35wJMCVS3AoUhu1H8C7w0AHYmxCIZPqgLDe+of
	 476YQdSFckJ0w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 17:22:32 -0700
Subject: [PATCH 1/2] s390/dasd: Remove dasd_stats_generic_show()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-s390-missing-prototypes-v1-1-799d3cf07fb7@kernel.org>
References: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
In-Reply-To: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
To: akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
 agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, 
 linux-s390@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, sth@linux.ibm.com, 
 hoeppner@linux.ibm.com
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1228; i=nathan@kernel.org;
 h=from:subject:message-id; bh=0sskqPdOiwxsrAXv+xHq1vHKwLqnoYarlJMhWh98XH0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZ6p5xbL1fhVft8Nv269TyP93XpFyyn93bqdfnyej2Y
 0nhrcu7O0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEWssZ/vCrGdwxVg+4Ilzb
 mCOm94zbVo091ufrrSzDZ9cFjSZ92cHI8MHuenlcQm1SX4+Y3O7XLok1T9dMM/T2rhLWrHKo7JD
 iBAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

With CONFIG_DASD_PROFILE=n, there is a warning that
dasd_stats_generic_show() is missing a prototype:

  drivers/s390/block/dasd.c:1109:5: warning: no previous prototype for 'dasd_stats_generic_show' [-Wmissing-prototypes]
   1109 | int dasd_stats_generic_show(struct seq_file *m, void *v)
        |     ^~~~~~~~~~~~~~~~~~~~~~~

This function has been unused since its introduction in
commit 4fa52aa7a82f ("[S390] dasd: add enhanced DASD statistics
interface"), remove it to clear up the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: sth@linux.ibm.com
Cc: hoeppner@linux.ibm.com
---
 drivers/s390/block/dasd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 833cfab7d877..7327e81352e9 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1106,12 +1106,6 @@ static void dasd_statistics_removeroot(void)
 	return;
 }
 
-int dasd_stats_generic_show(struct seq_file *m, void *v)
-{
-	seq_puts(m, "Statistics are not activated in this kernel\n");
-	return 0;
-}
-
 static void dasd_profile_init(struct dasd_profile *profile,
 			      struct dentry *base_dentry)
 {

-- 
2.43.0

