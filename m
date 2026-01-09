Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DB731A7EA;
	Fri,  9 Jan 2026 11:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959780; cv=none; b=mdAiBmfjsoqoqPNsjCk1D89iUt5o7sBT5pVCKKX/agLpwRekUwLxZcQhXAfRXg4l+H5gPNC6mdDj5bK5PLn3IZQT9uSES2JklfSZjdag23zXWPK2ql+2QqtHpq0Iw7wgoJ+DGj8kxd81jOaInVptRSc2teeJI5SE6EaENJp9xEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959780; c=relaxed/simple;
	bh=tj5rUDRT4ye/n8TecM8TzzZRDqrY0TC+NJ+QSEBBw6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGQ11J3sjY45jMtyJ/2GV4cOBq54aL8D6B+0PIxdV0f6d7RyFFryiTl1lOAWEC9sFgO639onpKa51VSUZkWgqedtPCGimtQNJtoDL3SezKt8otQwBrvg0kNA1Duzn4IabZ4YuRLwRa8NyWaIZ12rxf88365uRelAAmbHnZvc3bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6PYEQ8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6PYEQ8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989A4C4CEF1;
	Fri,  9 Jan 2026 11:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959780;
	bh=tj5rUDRT4ye/n8TecM8TzzZRDqrY0TC+NJ+QSEBBw6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6PYEQ8zsdy4zrGFKRU6dYIzgKvIT1F31xujgSFLdofP59EmfV1YliLPdS7CiBS83
	 Ma2ZndWLDpYbBUs6ueBphhv4jGg14dO2okkFjodZY/yOKIiqp4wqnqmcD93D3WiN/o
	 YXjy2GgKxFEWeDOOd6fVEt1dL93PuUAgY3jYiUq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/737] fs/ntfs3: out1 also needs to put mi
Date: Fri,  9 Jan 2026 12:35:10 +0100
Message-ID: <20260109112140.425751802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c45fec832b00..6ff10042a15f2 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1067,9 +1067,9 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 
 out2:
 	ni_remove_mi(ni, mi);
-	mi_put(mi);
 
 out1:
+	mi_put(mi);
 	ntfs_mark_rec_free(sbi, rno, is_mft);
 
 out:
-- 
2.51.0



