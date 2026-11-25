Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619506;
	b=STJGXhPdynchXoUAnkyn6qbDRXDiqDaQzwDfR8X3FOIu1LkQstYOer0ZsWHpJqMuIHBb
	 CeLgIEwU9F68/Eb8cEuMadxETEUT4uq6i4UV+UowGWIjGpYfVV3AKMshUA1s33/q3P16P
	 CEz123p4G3+95cYtDf9aKiqv8hOFVNC3mz9kl7OhS71+n4bt3Uucu9Gb7Bw3Ojktp2dd5
	 V7JinYIbbang256LrgCXWlUvZ/9ynz1F7xVkfiJrCYkajdfzn560whBEQCQ8FyqjkUshv
	 MDEix65u5tglkPeALX4lIplM31Qcb3+Ap5Dk4/MsI40v4w2x/NqhI6L3vRIYpFVAfYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AX78zzMlb+Dhu3mMe2FjYD7OxBaAijzUjosYAFpAeU4=;
	b=RDkk1C7SnKi0TwDneCQYfShtB6VuttVAUO7A9X5mk/u8OttzbhQXAO5D6dGb/rpi4Wkd
	 393oo8gFbUTQubjibhb8/NxWPiNdoxSh0gFftZsUq0yIaVBhuNMQGO2+5yh9dl83O78dm
	 g3IksAf7pNbvicrLVpIDo2qKpW5be276/J95gxcTY9JaPDw1I2W7Q+kjDG/Xeu7FyHrfo
	 ed3wBMkTdGgibwoLwoqmH5KAopWD0PXNTvNk2V3zQnwJ8yHsiZ6DC8tz+2KaCQaiaBrN9
	 fRJijZPHTtsCNtM3Wx78lMmYaB2EUTE4bWiHitFBpouFWhm7xHf06I3xkV3vms2TSFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yx7gzr62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF52606A321;
	Wed, 25 Nov 2026 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yx7gzr62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1941F000C6;
	Wed, 25 Nov 2026 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619506;
	bh=AX78zzMlb+Dhu3mMe2FjYD7OxBaAijzUjosYAFpAeU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yx7gzr62Ju/9Uwopz8Q/g0V9FjeRKB3qC+vatE3ZYCzmUBY/GYgpLE5FLcgJShO1Q
	 UIoe5YvfdJu+tkXISX6NnpmnsN5HaH/p9W5xcpeMTGpW+eqjXgh/RhCLo3f+19+ESW
	 U3svjuS3ScJfTaCNzMcCxYZRdOpJEXUMX7aozA9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 7.3 0618/1005] liveupdate: check for duplicate session before growing block set
Date: Wed, 25 Nov 2026 15:32:36 +0100
Message-ID: <20261125143836.224211484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>

commit cc448e44f6e9fc83f1527f926f52ebfa5a3d1ce9 upstream.

luo_session_insert() grows the outgoing block set before checking for a
duplicate session name. On -EEXIST the new block stays in the set.

If the session count is an exact multiple of the per-block capacity (51
with 4K pages), that block stays empty. It is serialized with count 0,
which kho_block_set_restore() rejects in the next kernel:

  luo: Block contains invalid entry count: 0
  Kernel panic - not syncing: The incoming tree failed to initialize properly [-EINVAL], disabling live update

Check for the duplicate before growing the block set, as
luo_preserve_file() does with the token.

Fixes: 2a441a14c2c0 ("liveupdate: Remove limit on the number of sessions")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20261103153928.716753-1-christian.aurichzm@gmail.com
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/liveupdate/luo_session.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -177,16 +177,6 @@ static int luo_session_insert(struct luo
 	guard(rwsem_write)(&sh->rwsem);
 
 	/*
-	 * For outgoing we should make sure there is room in serialization array
-	 * for new session.
-	 */
-	if (sh == &luo_session_global.outgoing) {
-		err = kho_block_set_grow(&sh->block_set, sh->count + 1);
-		if (err)
-			return err;
-	}
-
-	/*
 	 * For small number of sessions this loop won't hurt performance
 	 * but if we ever start using a lot of sessions, this might
 	 * become a bottle neck during deserialization time, as it would
@@ -196,6 +186,17 @@ static int luo_session_insert(struct luo
 		if (!strncmp(it->name, session->name, sizeof(it->name)))
 			return -EEXIST;
 	}
+
+	/*
+	 * For outgoing we should make sure there is room in serialization array
+	 * for new session.
+	 */
+	if (sh == &luo_session_global.outgoing) {
+		err = kho_block_set_grow(&sh->block_set, sh->count + 1);
+		if (err)
+			return err;
+	}
+
 	list_add_tail(&session->list, &sh->list);
 	sh->count++;
 


