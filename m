Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2B3C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D37C433C7;
	Mon,  4 Sep 2023 18:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852511;
	bh=RNDQjnzLpoLo3zF0fL4VA4wTNUUvseUbCLvOw+/xXo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkF7KFE5sAdxloWyDUJYHcJDKWz3eJhhNHqbpX9EP5hULtgqZ3TkKLLrN/+1Dj6CY
	 1pAcyV7Ph3GEFoKHAeh3pdnufY8PpRplwjO9eHCnQIrk+gbF/PgDnhSKIZmUlZp7yb
	 zUI1uBG7Ntaix0sS/WTDUYT4M1L6G1FtCoU09Crk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 6.1 25/31] fsi: master-ast-cf: Add MODULE_FIRMWARE macro
Date: Mon,  4 Sep 2023 19:30:33 +0100
Message-ID: <20230904182948.218784642@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1441,3 +1441,4 @@ static struct platform_driver fsi_master
 
 module_platform_driver(fsi_master_acf);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FW_FILE_NAME);


