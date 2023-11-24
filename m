Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BCD2E84A;
	Fri, 24 Nov 2023 19:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCYdv+f2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662B6C433C7;
	Fri, 24 Nov 2023 19:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852932;
	bh=0ySxmypLtQ1Tj1hyZ+3VoHO1HHr55klHF5Jzlx4dk10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCYdv+f2PtD/D+rSM0hPpJ2zqXWhmzX+BedMs7i5yJPFqoA4tPS3rFTvUfQaTgZ1Z
	 z1eIt0TqHvcVnFak7TCAHW6BL+Pec/3HdEXFo4lxWFLTEWs4+jP9DwU51CXozORDl+
	 sibZDFAZVNlkzlHNEG7/IcOS1rl9tyNWhQRM9n/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 181/193] ext4: correct return value of ext4_convert_meta_bg
Date: Fri, 24 Nov 2023 17:55:08 +0000
Message-ID: <20231124171954.396582625@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 48f1551592c54f7d8e2befc72a99ff4e47f7dca0 upstream.

Avoid to ignore error in "err".

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20230826174712.4059355-4-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1918,9 +1918,7 @@ static int ext4_convert_meta_bg(struct s
 
 errout:
 	ret = ext4_journal_stop(handle);
-	if (!err)
-		err = ret;
-	return ret;
+	return err ? err : ret;
 
 invalid_resize_inode:
 	ext4_error(sb, "corrupted/inconsistent resize inode");


