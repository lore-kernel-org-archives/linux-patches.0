Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051165;
	b=KnHzMGa/Yzkh58HLY3MzQanE1/pYfQlvZBOmDhuEctu56t3IBZ1a9sPyms66KubCKDTt
	 ZGEgSaqFE4vvRtCpWsDTP4ByksSvbO+S5OMQkEGKZ05MgbyOSTrMiCIYc4r+H5ftdJD08
	 Bt/mOQGK0DG8FGUwq6BzFwF6agdGYNqG+CkENKIb7UkUZeBlHHm3w85oAWQ99DgQIVCKz
	 PmrpyRuKAbp8jlZTKUvFv/1Qen+8RsHyLmsoFiQ2YdptPg0Ohomj7De33yVj4hc69V4Ln
	 u0n/zxyBrRx+CWh7dYlmEVlNTAcSTSA9+vJfnXnUE3kqb5Qy/PI1F6zl6Mot6ik13+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jprh2D26++lNpIw5Jh38Ig3HKzgqkwIbXKnfuCsy07w=;
	b=vE3yHT8yZQ2scV7T2OwfTkJUn2jHAbk3AO2HtXiRjrj6Ok5btUQmE1kQX/Sh8OUPJPZ0
	 HvnHH7n78zP59Up0Jd/2JyOggcik5YBI3ys6xP5Bsxl8hZgk/dpRfD5wS1mMtJsXVZe2B
	 EU3XjfTXyiFp7BbxQ4ogFPwxH5HcueCPRfVPlW3gAgsLZ5NDItalbRoCD15tschHu2fpB
	 +Qi9s/YKs15ZITNs6n9EhmyXmqd30KDf1tkVpzfwmiM1kbihEAOsHpVeTggUat5FtVGhP
	 uPFcF4YzWTJ5qKPJ1ywK9peamjswh1Szeh6jal9PVUCdSRKruhxTtfZmGedxDLdYpGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOeSl0um;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C5E606A330;
	Thu, 19 Nov 2026 01:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOeSl0um
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327DC1F000C5;
	Thu, 19 Nov 2026 01:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051165;
	bh=Jprh2D26++lNpIw5Jh38Ig3HKzgqkwIbXKnfuCsy07w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOeSl0umfbad6yjy6DlQcvE6Xv3T2PlGbnBrMs1/V6MoZL21JGvtHSzqggjHVoofw
	 sqIB2OYJw9v0g8roOxY5l2OJQQrEdq6O/sbIkj+7fBzrRzTIO3B5qgJEkuapxz0NCA
	 8+Mzy99pF2cmiUeGba3PqRPjlCZQ/0mMAX8RNbL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Review <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0085/2214] tools/lib/api: Fix potential double-free from fdarray__grow()
Date: Wed, 18 Nov 2026 15:29:21 +0100
Message-ID: <20261118150013.392165379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit eadce0f46a1d066b812c7e5aa46a33711c78a755 ]

If the realloc for fda->entries succeeds but the realloc for fda->priv
fails, the error path frees the newly allocated entries.

However, fda->entries is neither updated to point to the new entries block
nor cleared to NULL. If realloc moved the allocation to a new block, the
old fda->entries pointer is now freed memory.

When fdarray__exit() is later called to clean up, it executes
free(fda->entries), which would trigger a double-free on that old pointer.

Reported-by: Sashiko Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20260710200150.11FE71F00A3A@smtp.kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fd/array.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index 5e6cb9debe37e..d49b560664a1f 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -31,7 +31,8 @@ int fdarray__grow(struct fdarray *fda, int nr)
 
 	priv = realloc(fda->priv, psize);
 	if (priv == NULL) {
-		free(entries);
+		/* this will be freed by fdarray__exit() */
+		fda->entries = entries;
 		return -ENOMEM;
 	}
 
@@ -50,7 +51,7 @@ struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
 
 	if (fda != NULL) {
 		if (fdarray__grow(fda, nr_alloc)) {
-			free(fda);
+			fdarray__delete(fda);
 			fda = NULL;
 		} else {
 			fda->nr_autogrow = nr_autogrow;
-- 
2.53.0



