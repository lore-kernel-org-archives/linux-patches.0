Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211664;
	b=h0vnZNqGvJrV6qNU+l5vSuqG/QFT3gzI3o3oD4ZulNSNrFMAF1PWCJFb80IGy2qWm1bz
	 YL5Pw7mxTzMtU4eLsXOEudc2Kv9BFMWJmcvK28Mh+k8J6M12NxQrKjppVTt95YQz2aYXM
	 UCbdQ2gR8LViE2c1PY0UGHyEy+U6Cgi7tb5rwpoGqZ17VXB6cZMOladQ2D3OZeQBJ/34k
	 mkb3XD/81YLi1wYP6RY9/kVYl/2amnCTP9md1Py/FJs76kRPOviMt7YEd7SOoAe2nWnG+
	 7E0RSOxpDLE+yYbEp7IVxjkvoNEC7j5TbV/C13WDNsZEdimQ2v7IGKLSWfFvNX+5qcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EE/+SvDQFB//7f8k3f7gdu9a9wKztkQ69/yXyOtfXXs=;
	b=IAefDYRa4PWmG+/0ABYN/BcekzTNiNSu0mZL15HpVp319vawy2XvBP6jMH9HkWbQ9NMH
	 AXkvxHzPI84wREV7TNylfNyjAb3uefPoZB2LTuC9HfEj6F8ZTBDzFAPSTt0qQhWuNDZ+1
	 3p6lHJ9PTK1ifvtC73piSzZ0AVPZC8Gtcptba6h+Zs4auq7W5keHgjq4L0bENVqm9a2MY
	 WDgAGLvX/5uMY6IdcNLDuPOTkjH6yydAXIDibggm+Qql2QzDwOvLHFq751egScbp3C+V7
	 LAV01pHNm2YcSWuk4c3CS1Azc9zyfaC1akilQX9pqkLklWq4DxRuN53JFqn0yD9dmzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+qsTmhe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45BD606A31D;
	Wed, 28 Oct 2026 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+qsTmhe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309401F01825;
	Wed, 28 Oct 2026 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211663;
	bh=EE/+SvDQFB//7f8k3f7gdu9a9wKztkQ69/yXyOtfXXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+qsTmhe9N1/A3xpERr/Ym02savR6/Z3jGGGcUYGCtosKV8RfzzQHjifBfkidV8kd
	 3QCtkB1gulccd/eZiV8kV1utgClQhT7ImqfV3Vq1epZodjBhN9vz226LsIaxOJLP3N
	 wraXcw+wKXSjX0wzfsNIfDqOd2KwS+SYUhdZFJz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/571] tty: add break_wait kernel-doc
Date: Wed, 28 Oct 2026 18:00:02 +0100
Message-ID: <20261028170018.822939237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b1a626978efdc..cccbadedf6e71 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -175,6 +175,7 @@ struct tty_operations;
  * @write_wait: concurrent writers are waiting in this queue until they are
  *		allowed to write
  * @read_wait: readers wait for data in this queue
+ * @break_wait: wait queue for timed breaks
  * @hangup_work: normally a work to perform a hangup (do_tty_hangup()); while
  *		 freeing the tty, (re)used to release_one_tty()
  * @disc_data: pointer to @ldisc's private data (e.g. to &struct n_tty_data)
-- 
2.53.0



