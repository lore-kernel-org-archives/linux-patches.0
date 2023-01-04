Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CD0AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FDFC433D2;
	Wed,  4 Jan 2023 16:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848927;
	bh=Kl5iSmtRJUndElxBOqXquGz9V0nuSOxCcm/TGlYEoXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmxEUKe9eCgnT1jZpFdm7puI9pXo/HfANJKzRyC/zM1BQRITXlYTxyq3WVbMNIIW2
	 CvTeFS8ajklnywodIRn9ZaVRQ20g+65xaCzR4yHMKmRsS47rSJ5IVg0X7596/OpSRF
	 6fHUmjez/a3LF7Qdv3ba02b3+2E7f7kKlQ6DRxnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 105/207] cifs: set correct tcon status after initial tree connect
Date: Wed,  4 Jan 2023 17:06:03 +0100
Message-Id: <20230104160515.238171534@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

commit b248586a49a7729f73c504b1e7b958caea45e927 upstream.

cifs_tcon::status wasn't correctly updated to TID_GOOD after initial
tree connect thus staying at TID_NEW as long as it was connected.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2602,6 +2602,7 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
+	tcon->status = TID_GOOD;
 
 	/* schedule query interfaces poll */
 	INIT_DELAYED_WORK(&tcon->query_interfaces,


