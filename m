Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B857D4B146;
	Wed, 20 Dec 2023 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5dbZhcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6E8C433C8;
	Wed, 20 Dec 2023 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088809;
	bh=xNTwZO1aDAn9l/G3m52HPoLILUZfKHPjYrmnJGtshi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5dbZhcPfFMrUpIdc3f/7IGxg/ZdKpSXaOX2V9/pPSikSMqy3HwVHbS0ROeleUg1V
	 lJtFi+JMlmFH9dlDRS0k01a7bpLLgOffDrdfL0fBVszyzqblnYQxXa5RFZss4HwpPI
	 Nnll1q3pXE27v8M79tErRGp65kzO7iJk4Wja4uDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 027/159] ksmbd: shorten experimental warning on loading the module
Date: Wed, 20 Dec 2023 17:08:12 +0100
Message-ID: <20231220160932.549126530@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit adc32821409aef8d7f6d868c20a96f4901f48705 ]

ksmbd is continuing to improve.  Shorten the warning message
logged the first time it is loaded to:
   "The ksmbd server is experimental"

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/server.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -590,7 +590,7 @@ static int __init ksmbd_server_init(void
 	if (ret)
 		goto err_crypto_destroy;
 
-	pr_warn_once("The ksmbd server is experimental, use at your own risk.\n");
+	pr_warn_once("The ksmbd server is experimental\n");
 
 	return 0;
 


