Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258D5FBFE
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8C3C433A8;
	Mon, 15 May 2023 17:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170743;
	bh=PtUCrSzPHvd+2QcPWiJI107GKnIltsBINNabPKx+0OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Bw93X2C9Q5VXTx7DstvKsCoOLlA2wFcI694ZOJJP6lum6brzB3aTwFNilxBOkNCq
	 MplYNMCUlgMFKs/7dB/huWjW+AY0DAJjAJYbJBCEXc4Y/yXB84Q4QGCRcdconKAsNB
	 agzlKkyOSk7FXbbSKfPHLkH2QLlqM5gp7+cV0M3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 228/239] ext4: bail out of ext4_xattr_ibody_get() fails for any reason
Date: Mon, 15 May 2023 18:28:11 +0200
Message-Id: <20230515161728.554775048@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit 2a534e1d0d1591e951f9ece2fb460b2ff92edabd upstream.

In ext4_update_inline_data(), if ext4_xattr_ibody_get() fails for any
reason, it's best if we just fail as opposed to stumbling on,
especially if the failure is EFSCORRUPTED.

Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -361,7 +361,7 @@ static int ext4_update_inline_data(handl
 
 	error = ext4_xattr_ibody_get(inode, i.name_index, i.name,
 				     value, len);
-	if (error == -ENODATA)
+	if (error < 0)
 		goto out;
 
 	BUFFER_TRACE(is.iloc.bh, "get_write_access");


