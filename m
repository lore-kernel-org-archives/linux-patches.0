Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EB74B144;
	Wed, 20 Dec 2023 16:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8aALIFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174CFC433C7;
	Wed, 20 Dec 2023 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088831;
	bh=rXaKxsgUYqRVqelXEJNQ6P3iFPQnXU2dAlcjr8v+754=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8aALIFJ0T0q8c2UOxGBo0vlMzsnr5VhdY0gWo71K2HKa4t6J2JpQphqE+6lIHHLw
	 jO7B2JSgWaa9QazJw/gqDg2z492pWe6lQ7Isak/HAlzIH9GiHqLfBbJukYyuyrPlgC
	 6mxvl6NyYTKb8Gna65nQFfxABgZ4pPzckX0gEmOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 075/159] ksmbd: Fix spelling mistake "excceed" -> "exceeded"
Date: Wed, 20 Dec 2023 17:09:00 +0100
Message-ID: <20231220160934.874433188@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 7a17c61ee3b2683c40090179c273f4701fca9677 ]

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -312,7 +312,7 @@ int ksmbd_conn_handler_loop(void *p)
 			max_allowed_pdu_size = SMB3_MAX_MSGSIZE;
 
 		if (pdu_size > max_allowed_pdu_size) {
-			pr_err_ratelimited("PDU length(%u) excceed maximum allowed pdu size(%u) on connection(%d)\n",
+			pr_err_ratelimited("PDU length(%u) exceeded maximum allowed pdu size(%u) on connection(%d)\n",
 					pdu_size, max_allowed_pdu_size,
 					conn->status);
 			break;


