Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370EC11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA27C433C7;
	Mon, 21 Aug 2023 19:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647754;
	bh=dzcozTXvGnjUIpfrfUUyUMbvvpEeD5z7KYXqCfLKq8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJyWlBRGWWbFgILuEl0sDPhuxxWwUIEiztYej4msIRWS6hI3f08saKCEpsN9oJLM7
	 VzPrLm4pvwV8Vjs7wB0WjH/AL4ojqWauof53RahaRsL1sTjzDqm4fittUslSdcGw5C
	 7pvko42Arv+1aN3og+gIBDEyxhN+fFCKPDhLVXEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 097/194] vdpa: Enable strict validation for netlinks ops
Date: Mon, 21 Aug 2023 21:41:16 +0200
Message-ID: <20230821194126.960253342@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

commit f46c1e1620c6bbc9aad5693082efd1b80822e97c upstream.

The previous patches added the missing nla policies that were required for
validation to work.

Now strict validation on netlink ops can be enabled. This patch does it.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Cc: stable@vger.kernel.org
Message-Id: <20230727175757.73988-9-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1182,37 +1182,31 @@ static const struct nla_policy vdpa_nl_p
 static const struct genl_ops vdpa_nl_ops[] = {
 	{
 		.cmd = VDPA_CMD_MGMTDEV_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = vdpa_nl_cmd_mgmtdev_get_doit,
 		.dumpit = vdpa_nl_cmd_mgmtdev_get_dumpit,
 	},
 	{
 		.cmd = VDPA_CMD_DEV_NEW,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = vdpa_nl_cmd_dev_add_set_doit,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = VDPA_CMD_DEV_DEL,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = vdpa_nl_cmd_dev_del_set_doit,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = VDPA_CMD_DEV_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = vdpa_nl_cmd_dev_get_doit,
 		.dumpit = vdpa_nl_cmd_dev_get_dumpit,
 	},
 	{
 		.cmd = VDPA_CMD_DEV_CONFIG_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = vdpa_nl_cmd_dev_config_get_doit,
 		.dumpit = vdpa_nl_cmd_dev_config_get_dumpit,
 	},
 	{
 		.cmd = VDPA_CMD_DEV_VSTATS_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = vdpa_nl_cmd_dev_stats_get_doit,
 		.flags = GENL_ADMIN_PERM,
 	},


