Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040928;
	b=YuV4X1UlISc8AQboENVTiI+aim3/o47F56bvdgqCt589vELvCOxez3b5BOjEGUj0p8j7
	 cHDLm86V+o/pJW/GVbIGfqNAhrucOpZ6IaFuahG7JPBwlXoVCGsQKyxfm5krkDpwHtGWQ
	 7IlYv660J5uh2woZe7cavMPbuqxNjd2G2bTMlHEu2cM+XPIteTNTLewhVybrg8rdTFBNy
	 HcgG1crK17+vLsUGiC2avL4LHWFJMKjPsicCz0h36As9Jny/AqjQqlqFs+7ogNpjqgG45
	 paFCdRVJlyQyf53qvZ5py3aZ7Z3aWlET0fs+geVdLH9UiF3OcpzuyoJrZ2DRrQp0KNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MjE9oJth3DNa/kYQi8ccThvWCvDUmzzD0otvLo/ba2o=;
	b=vy0IlOVD6CeSH+y1e7oNM6LEh6fMtMtSSGc3BIrA0waRIBSyHGdIDpqB2vPPcgahQCcp
	 mWtTgWmk1hI1AYJUwGVq6YueLcMBhX0aeNpzcKPXhbUTlM/TD7Nm2ivE7ujkMsA4kz0Xx
	 GpmqsKXwRzJqVF/cAzkqMKu48GY2wk77OCZ4RShYfTNWpsuwhUsBE89qIHnNk/MkOj+L8
	 H8tMH+/hgJ/O8h05LA6sqxnx3QkW+i6aNIt3D4FUTntoPbeiCac3HPVmZPMhJ+IGz5cO6
	 +d3nkqt74wyhUt4Nh3O7OPOmz634uUJ/j1Y4CSnOPVq3Xcp39KIRihEE3RJKcRVgEbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13hAk79t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A564606A31C;
	Wed, 18 Nov 2026 22:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13hAk79t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B75D1F000C4;
	Wed, 18 Nov 2026 22:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040928;
	bh=MjE9oJth3DNa/kYQi8ccThvWCvDUmzzD0otvLo/ba2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13hAk79tEFiHR3z3WDG56uxEt+mze84hZ0815IsPpUIeEvAu3C7ckHmd/YZDZRVoQ
	 CE8PCwPxxPUPHDctPadSM1EVQ+7Vnc74I+rz7hchR5gVxjdLWkS8uIwncJJD5LKc98
	 IKfMWnsVdct/1kERwZd7vJJaTyXkd7OlrI4DqX38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2589/3318] wifi: carl9170: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:53:31 +0100
Message-ID: <20261118150438.849428284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit ece30e1daf6a9c95d6f9d0518534a0b9c8c7fd42 ]

The "buf" buffer comes from the user.  We use it to store a number or
two so it doesn't need to be large.  It gets passed to sscanf() in the
write functions such as carl9170_debugfs_erp_write().  Ensure that
buffer is NUL terminated.

This is debugfs so it's root only.

Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Acked-by: Jeff Johnson <jjohnson@kernel.org>
Link: https://patch.msgid.link/674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index bb40889d7c720..6bbcca46358cf 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -121,7 +121,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!count)
 		return 0;
 
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 
 	ar = file->private_data;
@@ -134,7 +134,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!dfops->write)
 		return -ENOSYS;
 
-	buf = vmalloc(count);
+	buf = vmalloc(count + 1);
 	if (!buf)
 		return -ENOMEM;
 
@@ -142,6 +142,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 		err = -EFAULT;
 		goto out_free;
 	}
+	buf[count] = '\0';
 
 	if (mutex_trylock(&ar->mutex) == 0) {
 		err = -EAGAIN;
-- 
2.53.0



