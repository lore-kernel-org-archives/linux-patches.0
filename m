Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E0C15530C;
	Thu, 15 Jan 2026 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497541; cv=none; b=MMNRBQTpb/TiqLusQlSTgURQ70LPaBMo6ShJkxM9M/lIlb0DBtYnY/72Vpf39T/CYYri/3/0TaetmPMLjFNIDz9McBgdQzPh9hedi6qiksfdZ0X8le7P5UjF+jM4GC8qjSdcmoiCRqpjMx3burKzTxuKGtiFzBjENmbXOnIEo6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497541; c=relaxed/simple;
	bh=77IFAQfxsaSNsfolcIijZFXt/j8y4wBoYTrjEyBI+cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPB4XCeh8fEtWo1ETJWaqw8uRDXOM2y+Eu1kKHlc5CJSB18FiXt2kxJZi2qsTCJwm2uL1bQAVn8v/+xPufK5npUq8yXWaQ+po5o1QeqUCCTnlqoNm/fIgWUl0zJaBJURPAbDB+weJnYiy3b0XVvAcpe2XRjwnOKlJBksyMxLihE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAgvZ+Ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAgvZ+Ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D642C16AAE;
	Thu, 15 Jan 2026 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497541;
	bh=77IFAQfxsaSNsfolcIijZFXt/j8y4wBoYTrjEyBI+cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAgvZ+CtzBR4pUUrQoz1RU27hmcFgk7gD8uspWWQRMIiRhVR6OagI/9UkJ+q3lraf
	 17i44R6gXshq2ZnJCJa3x1gI69LXGF11ny0lQV56EATj6AP/sTZC21h6JKitlySNFy
	 HhvKCR7CiSD9vHgbXc9B+YdaR80LqOKOfb56yRAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/554] fs/ntfs3: out1 also needs to put mi
Date: Thu, 15 Jan 2026 17:43:03 +0100
Message-ID: <20260115164250.486624071@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 4d78d1173a653acdaf7500a32b8dc530ca4ad075 ]

After ntfs_look_free_mft() executes successfully, all subsequent code
that fails to execute must put mi.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 4db52dfde6328..89ee218706678 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1042,9 +1042,9 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 
 out2:
 	ni_remove_mi(ni, mi);
-	mi_put(mi);
 
 out1:
+	mi_put(mi);
 	ntfs_mark_rec_free(sbi, rno, is_mft);
 
 out:
-- 
2.51.0



