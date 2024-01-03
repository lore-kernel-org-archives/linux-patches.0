Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0276B1BDE9;
	Wed,  3 Jan 2024 16:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B02HFAg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B64C433C7;
	Wed,  3 Jan 2024 16:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301023;
	bh=NggYCZjo2btjVkyrPfyndi3XJdZyNOOkC69eKn572tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B02HFAg2m44+79n7wtTByS8ensrj2Nx92avyuMhKxzgBHW9KyJDnd7JEKZiqfcX5Y
	 x08ZldeFnuhLteLgWJ10PVcBcPzlQ6YX48hxLly1ah+vNwP5uOZW2K2XODpujYuMOY
	 +LbwiHC93KO56/MW5Y4+GQcGTBDlvqs97MzWMma4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/100] ksmbd: Fix spelling mistake "excceed" -> "exceeded"
Date: Wed,  3 Jan 2024 17:53:59 +0100
Message-ID: <20240103164857.699786929@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 7a17c61ee3b2683c40090179c273f4701fca9677 ]

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index e885e0eb0dc35..ffbf14d024191 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -345,7 +345,7 @@ int ksmbd_conn_handler_loop(void *p)
 			max_allowed_pdu_size = SMB3_MAX_MSGSIZE;
 
 		if (pdu_size > max_allowed_pdu_size) {
-			pr_err_ratelimited("PDU length(%u) excceed maximum allowed pdu size(%u) on connection(%d)\n",
+			pr_err_ratelimited("PDU length(%u) exceeded maximum allowed pdu size(%u) on connection(%d)\n",
 					pdu_size, max_allowed_pdu_size,
 					READ_ONCE(conn->status));
 			break;
-- 
2.43.0



