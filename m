Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446DC30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74EBC433C7;
	Wed, 20 Sep 2023 12:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212775;
	bh=R46tYynO955qG8HGv1RcFDHWdLpLHDYVGlUdoLqe2Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgj/IpmQgEEUbN/jSfwzKZW3vKmr71tv54MmrOaZX7JYY5fSqXky8v0REDdbfCLWg
	 GVVMAMdP3vk0a2fphxxAocFBOQPLIHgjEP97z58m3WKyHlJ90p7tOPrqSHtYfjX6Tt
	 1hItAd0v3LLaB+qUCisgyFLP01b9pVWQs0pIjLWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 5.4 014/367] fsi: master-ast-cf: Add MODULE_FIRMWARE macro
Date: Wed, 20 Sep 2023 13:26:31 +0200
Message-ID: <20230920112858.877561324@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

From: Juerg Haefliger <juerg.haefliger@canonical.com>

commit 3a1d7aff6e65ad6e285e28abe55abbfd484997ee upstream.

The module loads firmware so add a MODULE_FIRMWARE macro to provide that
information via modinfo.

Fixes: 6a794a27daca ("fsi: master-ast-cf: Add new FSI master using Aspeed ColdFire")
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Link: https://lore.kernel.org/r/20230628095039.26218-1-juerg.haefliger@canonical.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fsi/fsi-master-ast-cf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/fsi/fsi-master-ast-cf.c
+++ b/drivers/fsi/fsi-master-ast-cf.c
@@ -1438,3 +1438,4 @@ static struct platform_driver fsi_master
 
 module_platform_driver(fsi_master_acf);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FW_FILE_NAME);


