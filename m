Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ED34BABA;
	Wed, 20 Dec 2023 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC4cVsdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58202C433C9;
	Wed, 20 Dec 2023 16:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088724;
	bh=O4oNFCQTIjeMJsRYveslehHsqJJCg80e2HvvQqDvkn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC4cVsdRgtoa9NzTY15GLuZqcuIeLvNhq5idXUz/wcgJp1ySMKaUdrip+m4c4AGtJ
	 9PZw8A2R57Vk+bIQVikC6ZsV2KeDYf22w4hi+G7a4h0EK/RcPq6Yq7bO3ZvqDthYvY
	 Fwsw7+F/PW0D17wMa/5ArZncmUjKKTibGm7qLqQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 028/159] ksmbd: Remove a redundant zeroing of memory
Date: Wed, 20 Dec 2023 17:08:13 +0100
Message-ID: <20231220160932.589327550@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 56b401fb0c506120f25c1b4feeb96d9117efe171 ]

fill_transform_hdr() has only one caller that already clears tr_buf (it is
kzalloc'ed).

So there is no need to clear it another time here.

Remove the superfluous memset() and add a comment to remind that the caller
must clear the buffer.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8602,7 +8602,7 @@ static void fill_transform_hdr(void *tr_
 	struct smb2_hdr *hdr = smb2_get_msg(old_buf);
 	unsigned int orig_len = get_rfc1002_len(old_buf);
 
-	memset(tr_buf, 0, sizeof(struct smb2_transform_hdr) + 4);
+	/* tr_buf must be cleared by the caller */
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
 	tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
 	tr_hdr->Flags = cpu_to_le16(0x01);


