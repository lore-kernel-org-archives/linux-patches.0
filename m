Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035642;
	b=OvoUYXE83LhXNImdA8CAa/KN1vik2zVvPIpuH7CwoFRkdIAg9Wlbpq7t6mccT2KozYV7
	 YGvwCBMMfWqPXCP8DBlStiu8FQCd42gtQIeLnMpzUK5iqJBUG3OOsQsXlzkTfzRh1o34c
	 oC0ENjwI299y8uoZKjiJiTVl+hF/PDU1JmJBZgxKEzRGnzbzx8EGEtwcDJ2IxSaDgYp+6
	 HH0Ufc8c/P3fbJJ32dl6Sw/Mq6gpT2O3JEXtm+/x1FVOZvCCys7WNhBze2EerkGUA08r3
	 ZeUWyO+7ZFKns3JLl3CaJYxOJ4D5WRwdI038Gk7fsyRQd4tOuFOXkRnrO2icBXX+mpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oENXgpRQxBDgjzCzqS8zFxMrSs6NVOzXdY69lr+8DJI=;
	b=4rN1lp6+Nqz8fcSq6kIka2Hsr9ovWXcO0BCrk7c5tjem+GW5nuXBxH4dExaWdyZtpsrk
	 ajXgFC21oSyLM6TownOO0peiRyrRW+Ne7a3MOGnojmCnWMh10JaAaxNz5hOJm3NOCRIuY
	 MAQ47mH35NbbKYlxTdTpZCU2FzT/93qA+b9RLtzz8D//JJ6OF2dofXOE99Pw7LyiE/xq+
	 b/LPp5vPBh+UbkvLCEjz8yNyXwvbjAlCacP/od221/h9gGlux1uMazi5tDR+APtxYYll6
	 RpXrJwxzbe9v8DIc/73TzJdGZFzjOQ4IUDQO2FqEuqM9o/J1Q3QX+0rMTmozl4xVjEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbzoSEFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F822606A320;
	Wed, 18 Nov 2026 21:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbzoSEFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2BD1F000C4;
	Wed, 18 Nov 2026 21:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035642;
	bh=oENXgpRQxBDgjzCzqS8zFxMrSs6NVOzXdY69lr+8DJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbzoSEFLiIOIjQ9rxzodK+s0BTZEQBSx4g5DiavHD81Wt2kIqF0T7PvlwKQkcjgCY
	 oiToDbt7x+KzQsbsWuJfFm7D1DWT2SOjXhrd1TBoyzQXUrTgVaCjeIzeAi9w5MQvv+
	 kFaI3AmxVN9zqKeY+PbDL0ChM9Wndbk+eCONAd10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0775/3318] ovl: do not copy up a dentry that was removed
Date: Wed, 18 Nov 2026 15:23:17 +0100
Message-ID: <20261118150342.036820284@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no start_renaming_dentry() and LOOKUP_EXCL, fail with -EEXIST if
 the target of ovl_lookup_upper() is positive]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 1c2c1b1801eef..74028923aa511 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -758,6 +758,13 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (IS_ERR(upper))
 		goto cleanup;
 
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_positive(upper)) {
+		dput(upper);
+		goto cleanup;
+	}
+
 	err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
-- 
2.53.0



