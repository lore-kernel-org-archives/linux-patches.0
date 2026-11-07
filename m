Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061670;
	b=nqjBmsC1t8Kc01vk+ytUxV1pIaK7P8sgI9cQLtFYthrNwRCttmhLGMVZ0BQx5TKPQ3xg
	 afPHiXc1qr9urbuHhel30oTMws0GNb68oSlGqT35SxX1YHPTzavUmBaj+p6kcprqP3jSE
	 dWsXMdtt7qi6w+DxYoY80caGDUzLEro2M/y9yAp3O2E0yPdBy065vkq+abks/VMadSS2A
	 /EXFX4Ff7pqg6ANAM7CxcumjUw211mfT+vW4/7GrTEh2Y4ft8F1PYVz7erkCKbiyZwzH/
	 7JW5M8dXvU2kRHNz1/vPwy7ytNAMRzS9mTscWcQgBG/orc4eCyzcRmkns5vTr4Qmjzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R77XQicfJFoez1BPxX7PZpcXS30hhq71OGwKW10+t44=;
	b=o1HJd+so0UiGtnTA6YyAOAR+fwo1k82atLaleCHH5dEA4P+tglhEwP3aDr2nZ+/3HwJG
	 RI25hWrb+8Q+n76dM+7HdTiKUZtYkxCNqkL8vvHUlHHhPjmsgvVk91YKpbCWl1ZWJSVsr
	 TAmRkMAPlmMSw6GvVoTRMbDi0fsymG8608tWZqnCUL/+99Zt+LXA6vLiiCg7od5nvnZQK
	 BJ+GsqueiNwv8KHEbaY0ChLBc7MwBvT+ksc8bTBJXeQ+ZL5Z7q7YPTg4H2kpIPLRDiMOb
	 S1IfnbUakdY8iXKthNn6iooopfEHUHEdpOhkiOzZXqJyv6pDuhvxfqV+nTIyWe1ofhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzbwQG5x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A7606A32C;
	Sat,  7 Nov 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzbwQG5x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334761F0089F;
	Sat,  7 Nov 2026 14:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061670;
	bh=R77XQicfJFoez1BPxX7PZpcXS30hhq71OGwKW10+t44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzbwQG5x6+ciD7/7A9d2/a0Oo5kAb0VsDMOWAPOetKcKvXa6rlhSV3sZH5HldCSNh
	 kEDJvSyNbf55VItoODd4/HOGqqGH6opwd/01zi+GW34zx6KxiLC8deXDzKEkoufS7D
	 7z1LNOFaSeXA4qYFdet8lecfdTP+fpftk3/MDVXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0725/1536] xfs: abort directory tree repair whenever dl->aborted is set
Date: Sat,  7 Nov 2026 08:45:41 -0500
Message-ID: <20261107135017.861228189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 4582327e7068194d55941b49dd66be211b9e3f90 upstream.

LOLLM observed that if the live update hooks for the directory tree
repair code ever fail, they'll set dl->aborted, but then the main repair
code path won't check it to exit early.  This can cause incorrect
repairs, so let's check for hook errors and abort the repair.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -575,6 +575,8 @@ xrep_dirtree_delete_path(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 
@@ -720,6 +722,11 @@ xrep_dirtree_adopt(
 		error = -ESTALE;
 		goto out_trans;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans;
+	}
 	error = xrep_dirtree_create_adoption_path(dl);
 	mutex_unlock(&dl->lock);
 	if (error)
@@ -780,6 +787,8 @@ xrep_dirtree_move_to_orphanage(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 


