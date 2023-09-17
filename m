Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C7F53B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE83FC433CA;
	Sun, 17 Sep 2023 19:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979239;
	bh=KtxwKeYgWZtvZKo590157D+mkITOvNs+tiXpn4WQsQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INuQk73X3LT4hdsODfcTLMsTgOaWfKJcuupECL7BzMQHwEl+3Dvm/8XNsUAfeLDAn
	 mcQeQ0pAiHrt+zh8i3hEtq2KM6VPIIygXgAGxdtfKFafhVC2+WdUfjtNZSjLPqzQNU
	 FiM6HJe19eIXur+bZz4ag7ZDuNRTd8OgGvfdf4es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao@huawei.com>,
	Mike Christie <michael.christie@oracle.com>,
	Lee Duncan <lduncan@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/406] scsi: iscsi: Rename iscsi_set_param() to iscsi_if_set_param()
Date: Sun, 17 Sep 2023 21:11:12 +0200
Message-ID: <20230917191106.940009120@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenchao Hao <haowenchao@huawei.com>

[ Upstream commit 0c26a2d7c98039e913e63f9250fde738a3f88a60 ]

There are two iscsi_set_param() functions defined in libiscsi.c and
scsi_transport_iscsi.c respectively which is confusing.

Rename the one in scsi_transport_iscsi.c to iscsi_if_set_param().

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
Link: https://lore.kernel.org/r/20221122181105.4123935-1-haowenchao@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 971dfcb74a80 ("scsi: iscsi: Add length check for nlattr payload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 092bd6a3d64a1..a22bc594b2d4a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2991,7 +2991,7 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 }
 
 static int
-iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
@@ -3940,7 +3940,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
-		err = iscsi_set_param(transport, ev);
+		err = iscsi_if_set_param(transport, ev);
 		break;
 	case ISCSI_UEVENT_CREATE_CONN:
 	case ISCSI_UEVENT_DESTROY_CONN:
-- 
2.40.1



