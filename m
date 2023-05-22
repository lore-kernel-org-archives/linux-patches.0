Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6BD171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456C1C433EF;
	Mon, 22 May 2023 19:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783323;
	bh=GxD2ID5KVjq+cl2uQ1Hw2o5l7NRbIEZADlSPJtVSHac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyKv110frojzncjTkEaCplsOwuURQnaVvwTrLknllcwfJQzC9SaH3oHZv7vizNbp7
	 R2qKWevKZdMnIZwYjw+p3URluauROghE6wzdObaogWA9yZx2RkAcL8bqyGomFvK7I5
	 iPePUfGY6BZvXuJb/lupFzog4+mgQbKj0PMrb0lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Yen Chang <cc85nod@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 186/203] ksmbd: allocate one more byte for implied bcc[0]
Date: Mon, 22 May 2023 20:10:10 +0100
Message-Id: <20230522190400.163664397@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chih-Yen Chang <cc85nod@gmail.com>

commit 443d61d1fa9faa60ef925513d83742902390100f upstream.

ksmbd_smb2_check_message allows client to return one byte more, so we
need to allocate additional memory in ksmbd_conn_handler_loop to avoid
out-of-bound access.

Cc: stable@vger.kernel.org
Signed-off-by: Chih-Yen Chang <cc85nod@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -320,7 +320,8 @@ int ksmbd_conn_handler_loop(void *p)
 			break;
 
 		/* 4 for rfc1002 length field */
-		size = pdu_size + 4;
+		/* 1 for implied bcc[0] */
+		size = pdu_size + 4 + 1;
 		conn->request_buf = kvmalloc(size, GFP_KERNEL);
 		if (!conn->request_buf)
 			break;


