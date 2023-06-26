Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71F134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FB8C433C8;
	Mon, 26 Jun 2023 18:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803732;
	bh=xFBDtI0eJXV50Of5xfPsY4FxA5omc/+439vJ3gAfG+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/uJColqYS/gUy2ezpXql+G3yQ2XaiXGEMAP9VGl8tNoFssApOLqdhiznJl5llBn9
	 GfXSP4vI3DZLZAbPqBdy3CXBI8dYr10zMoQyKrs+/ggkOAme8up9UbQ2x7H4J/r3lj
	 /kXxJXbjtJ7LMeiqo58hrvQbT388mSmmzPVSW3nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 151/199] scsi: target: iscsi: Remove unused transport_timer
Date: Mon, 26 Jun 2023 20:10:57 +0200
Message-ID: <20230626180812.247257311@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 98a8c2bf938a5973716f280da618077a3d255976 ]

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20230508162219.1731964-3-mlombard@redhat.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/target/iscsi/iscsi_target_core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 42f4a4c0c1003..4c15420e8965d 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -568,7 +568,6 @@ struct iscsit_conn {
 	struct iscsi_login	*login;
 	struct timer_list	nopin_timer;
 	struct timer_list	nopin_response_timer;
-	struct timer_list	transport_timer;
 	struct timer_list	login_timer;
 	struct task_struct	*login_kworker;
 	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
-- 
2.39.2



