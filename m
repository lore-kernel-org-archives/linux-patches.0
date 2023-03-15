Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1234431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E8EC433D2;
	Wed, 15 Mar 2023 12:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883114;
	bh=IQKS+GKeMkD4VWf0S3rovvQFTc5uZNmJOyx+SS8Tr7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yF8Gr5yvs93p565PY6s6sewBcX0S/PGj3NmgX4WzHdUbWwSVpleyF43hCaTIP/RtM
	 QbIYd6DQpsX+8ZSFnN3tzR/WrfoT0qLHSaO6Dl3UcXun8bCXFTMOJ/Hh9pH88pS1dU
	 veGtEfpXnaOSsau+tJclvF61nwugv+kNdqXp4j9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/145] fs: dlm: fix log of lowcomms vs midcomms
Date: Wed, 15 Mar 2023 13:11:27 +0100
Message-Id: <20230315115739.717958805@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 3e54c9e80e68b765d8877023d93f1eea1b9d1c54 ]

This patch will fix a small issue when printing out that
dlm_midcomms_start() failed to start and it was printing out that the
dlm subcomponent lowcomms was failed but lowcomms is behind the midcomms
layer.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: aad633dc0cf9 ("fs: dlm: start midcomms before scand")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 10eddfa6c3d7b..a1b34605742fc 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -393,7 +393,7 @@ static int threads_start(void)
 	/* Thread for sending/receiving messages for all lockspace's */
 	error = dlm_midcomms_start();
 	if (error) {
-		log_print("cannot start dlm lowcomms %d", error);
+		log_print("cannot start dlm midcomms %d", error);
 		goto scand_fail;
 	}
 
-- 
2.39.2



