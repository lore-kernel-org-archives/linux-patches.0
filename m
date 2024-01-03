Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F31C283;
	Wed,  3 Jan 2024 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm+FwADC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63305C433C8;
	Wed,  3 Jan 2024 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301051;
	bh=/o0t0KvLGm4hOQ8/iBEtBSKochMl/OITxABXwO7MDb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm+FwADCTOoSxCpgQKRm2LB1kRBAXCrj9xrBVy+lEnYFjRHi9jZhVr09y+UzUJZry
	 jmgDUSRqk4ydHfDj3N/6SctPlobJKMqlATH6YIZY8tEvluiT3zgbLLnZLQ99yA7cWh
	 9KO/rb/0XYKTPqf+aZ504b/thBQULq5nHh12RI3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/100] ksmbd: use kzalloc() instead of __GFP_ZERO
Date: Wed,  3 Jan 2024 17:54:14 +0100
Message-ID: <20240103164859.819980807@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f87d4f85f43f0d4b12ef64b015478d8053e1a33e ]

Use kzalloc() instead of __GFP_ZERO.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index adc41b57b84c6..62c33d3357fe1 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -359,8 +359,8 @@ static int smb1_check_user_session(struct ksmbd_work *work)
  */
 static int smb1_allocate_rsp_buf(struct ksmbd_work *work)
 {
-	work->response_buf = kmalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
-			GFP_KERNEL | __GFP_ZERO);
+	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
+			GFP_KERNEL);
 	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 
 	if (!work->response_buf) {
-- 
2.43.0



