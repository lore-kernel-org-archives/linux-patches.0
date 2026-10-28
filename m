Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213546;
	b=a9dc5/HO4FkP+xdKz/Y+mcwvKh/RQd81kOi2+zlFlP8IVRMvmdqHRBR0P2PKjXaIOcTy
	 Uvv+XiiPpZ37fLqYGLvZ7XQ4yZ6/Boo4izK5ux3U4xRs6i9R4thEBp0iJngdVXiX+yRNU
	 5kJG/AAPJ43n4/lNGlTMiRXoSlQk+uEoPkNTGiOZEPuS6qDQZ/7WP78hyoO9EbC6LRJug
	 Eaq2RO715ckRh9phfkeaVi8tpk8ek++PKjRWKyPTyyjLhsNLWi2wiEs7lYE+mCMuAFUeE
	 vbvlWzs0BdoMhikSMOi/o+z+U87OM+YkTyCQOX5M/hCIZm3pHf5RtzVMBTCgaj+uqMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VCRl3pee+/lCM3xsbN4/zEVHaKFlrpyR1F1SpK3w+UQ=;
	b=JlDCjzuuPmpT/NHwlr4NnLIp1qhwckSN8R9dj8ysuCMY5jFbmYAwHi0sE9zLfpDKNzto
	 q4lEqgzJJru8uAdEyqAJNmc5dtZi6NUJqa3CACbHwqbaX5qMpXLTuxOa/A8LF1OnEDj7i
	 drhmPFvxjA8WTOmexd70pA3NExgs9uh4fGl0vHcKwW98FVwW2lo+RES7MxfgtAXJ1aCKY
	 PEvoVgMMN4pukscFTy/0k029lOAl1ErvHi6pmuuz0pIHSvUjlcqYsbtdB5E+qdyBdPRmA
	 kfn7MLwN4BEQi8TQ51D/uW6gTU/ssfSU6IZHPnV6LzApD1xpWFDHn7+BUWGvDVTYNYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7FsO1hF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864B3606A31A;
	Wed, 28 Oct 2026 18:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7FsO1hF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75E51F01825;
	Wed, 28 Oct 2026 18:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213546;
	bh=VCRl3pee+/lCM3xsbN4/zEVHaKFlrpyR1F1SpK3w+UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7FsO1hFBaX8m/zmm3kEzBVV3u7cGCKrCBQ6ipPNkSzSPeV4xVQVwQ3NEZruNAJ/V
	 wvbT+eWNI198oedTtjrDpPzUjrwOLWUPNN06mpCTEkvs9cLZaP8M+lQ9v7/f4Ypqo1
	 1frZ7VCAHSfFLXv7qnTPBwnoE+KuYMUJa1Fza6Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0545/1887] tty: add break_wait kernel-doc
Date: Wed, 28 Oct 2026 17:44:01 +0100
Message-ID: <20261028170511.763479649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5dad87615c9861cfa366ca984b52f581e861df20 ]

Add the missing kernel-doc description for the new break_wait field in
struct tty_struct.

Fixes: 845a2737e0f5 ("tty: abort break signalling on hangup")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/20d75a7a-2e7a-484f-a267-c21db82dd922@infradead.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260925094222.18303-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tty.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 37978b784312e..5bfdf02df9c75 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -173,6 +173,7 @@ struct tty_operations;
  * @write_wait: concurrent writers are waiting in this queue until they are
  *		allowed to write
  * @read_wait: readers wait for data in this queue
+ * @break_wait: wait queue for timed breaks
  * @hangup_work: normally a work to perform a hangup (do_tty_hangup()); while
  *		 freeing the tty, (re)used to release_one_tty()
  * @disc_data: pointer to @ldisc's private data (e.g. to &struct n_tty_data)
-- 
2.53.0



