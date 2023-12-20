Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B111482C9;
	Wed, 20 Dec 2023 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNL1DgTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8620BC433C8;
	Wed, 20 Dec 2023 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089014;
	bh=29O1fmihf3x69IyuQ0ev1+b4LPo4edzvxYhR/Wy/+sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNL1DgTTwLcjd9xcxFFTBPaf5RvEpbL+bBbUDmIuYXsMp5jGZT5JB2VUQlmh/j4si
	 k1tq9l5cL3eNZDVs+6KIRH50VBAuyD5rDik9VhbIDqwUYXJCBSHzV75BClvvgqQrZM
	 OPkGdMK9HB4CugMZppMpslrn7ni1BbKqcEJA+lI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 139/159] ksmbd: Remove unused field in ksmbd_user struct
Date: Wed, 20 Dec 2023 17:10:04 +0100
Message-ID: <20231220160937.822723492@linuxfoundation.org>
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

From: Cheng-Han Wu <hank20010209@gmail.com>

[ Upstream commit eacc655e18d1dec9b50660d16a1ddeeb4d6c48f2 ]

fs/smb/server/mgmt/user_config.h:21: Remove the unused field 'failed_login_count' from the ksmbd_user struct.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/mgmt/user_config.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ksmbd/mgmt/user_config.h
+++ b/fs/ksmbd/mgmt/user_config.h
@@ -18,7 +18,6 @@ struct ksmbd_user {
 
 	size_t			passkey_sz;
 	char			*passkey;
-	unsigned int		failed_login_count;
 };
 
 static inline bool user_guest(struct ksmbd_user *user)


