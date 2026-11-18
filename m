Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030898;
	b=hqVsd4bwWGTOG9mZEgntIL9Z6Yokrx7eCDS4DNstz8T0FbYa9FnWbIi9PlLvTkqPwo4V
	 OoxXrcVyEOAXRZB9vLkp0JQKJcqItkPGaAOiYFHQclnU0Rvfi0MMxHXt/QUcr4BkX2KBA
	 Ov/FSYuHk3MrQLpt601YEqPqOPB4EIn/L2xdScCuHazHz9Zvn3H5rDKAWrlOqpysuFbGJ
	 /AEH3DQfEFXHt0NiO9/pF3yUdcxAeMYwwtYXbPEUC82ynKQ9T0i6qdMxegu1nlhGQ4kFh
	 2KAmquihpA8x9/q5ZGjyz9zyRdSDu/75Hfm1qD/5mDOTA7gdRf62BzzgIZw7pbNCfSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2sKZPjVwN1nhkhW0bL4+R54TIcddLGJM9EuehaMjENw=;
	b=YmgvNMDGS53MQ33OyI/bjzxATYO+xWpch2asj/G/1zvLVG9Hzqpamy+bTMTVuapsojPv
	 CPukZiZ+VtgHa38LR98UNSDA1H7KOrJ4llrNqpBOmvSf8CX4+2uR4fUGO+SgqlVzJxrN+
	 nCQSGySEiV8buogq6TwuPW3moIkbN/oVuqxS2/seS48J+CWwssm7g9KrjS+/uGVSsLTxU
	 DkaDUFpDYqFC5oVFOSaeHfsMS5Ja1k9MydI/AXKgl83r0HLje0EOtBIELIi4RjV1Z2LA0
	 7HqtifLLwp9u9qQyRbUC0Llhkggo/my9aTN4m8h9oozwV5Z9iUWEL/C3qyK4VowN2RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hp7oY4Hm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37DF606DD0A;
	Wed, 18 Nov 2026 19:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hp7oY4Hm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513241F000C4;
	Wed, 18 Nov 2026 19:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030897;
	bh=2sKZPjVwN1nhkhW0bL4+R54TIcddLGJM9EuehaMjENw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hp7oY4HmqwtpcFu0aRiCU1iqc1ZJWwUDj91EM884zWELjoruyPYE2vu+vh8OwYOjm
	 lmrhb1xIxr1yEHyv6Z08c8GMXGR5lRPiU+IV0UzHr4Ab6XO2ajOwn+xbfyxNVUODlY
	 O15JxMhHCph9zUkw87ik8sM50ybkUiMSpCEM/IKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0866/1756] wifi: carl9170: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:49:53 +0100
Message-ID: <20261118150043.794259054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



