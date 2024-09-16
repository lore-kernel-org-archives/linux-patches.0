Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBBF159571;
	Mon, 16 Sep 2024 12:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488304; cv=none; b=I+LusH6G+h8hcJj57qS5qHAuLMA4DOWRm4f8BQLc6KD67jQR7HbFrzK5OpJtqlZFWaFf6IvSybf00xciTyuaU/LCJI1NJ+/MQGrpdpMpn8io2+QnDQ9+VySLOMu6Ow0RAY3qLI6waXRuXdVTFC3ZmylrtfrOGmEGsGUEHxFO1GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488304; c=relaxed/simple;
	bh=KmYgaJO8GqAec7gULTF/ccVi7db2CdSUVxE0L67nYno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C87Jg06KFkn4Eg0R0w10ziRB30SloDGOzrtZ8n/5ymDBoRUvtdRs6X2J0sqrBHwSYXO+lNYn+f3rwdFC9u0GCoLEvF6mqu/OXIHPKQ/Yh2yjXmiqMi3piPKuO4/13tAqlKZqmNvnr9r24d0GAQ1agajgpUhmdFDurniFitpDi8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkaC7+iI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkaC7+iI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3103EC4CEC4;
	Mon, 16 Sep 2024 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488304;
	bh=KmYgaJO8GqAec7gULTF/ccVi7db2CdSUVxE0L67nYno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkaC7+iIOO1nCiv/PeV+GYLyQ3KeXQqbptTeLXcciGiXwqOOmOVUZ2lnMlita3yTp
	 JEEBoMCSnADrE5y0WJ+7wH2DRNc112Uq+nKU7eYdsnOZb7nYFq0MQzXB0f7aDaCqzo
	 kxJkWtO5CeKAL68Vkn7vpC38REdmlJGmfnZnKDf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 040/121] smb/server: fix return value of smb2_open()
Date: Mon, 16 Sep 2024 13:43:34 +0200
Message-ID: <20240916114230.456841118@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 2186a116538a715b20e15f84fdd3545e5fe0a39b ]

In most error cases, error code is not returned in smb2_open(),
__process_request() will not print error message.

Fix this by returning the correct value at the end of smb2_open().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0687083bcc3f..adfd6046275a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3714,7 +3714,7 @@ int smb2_open(struct ksmbd_work *work)
 	kfree(name);
 	kfree(lc);
 
-	return 0;
+	return rc;
 }
 
 static int readdir_info_level_struct_sz(int info_level)
-- 
2.43.0



