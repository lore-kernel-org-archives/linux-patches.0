Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEF332C33A;
	Mon, 27 Oct 2025 18:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590677; cv=none; b=UICfX0qKHS02pfu464W9r7RZV2oOC9LwNH2XkAk6iNwF9u6ytRnc+M4zBxt7Jhx5IFJNLhQbr24m2Hw/UgMT8dWKQEI72yKFxHzpvrfVoJHX2ToY+irM8OKVCH5UyKXf3btkT6GAyntF07MjWp2mqbtbBS0LR5bmMtKkUJ1tej4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590677; c=relaxed/simple;
	bh=ghqDHMoPB0g64iqQoyEEHgOVxg6fKxrWoyWcrN5NFhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8G31EVXURLXfHKG/Vw7LHmT/v/TB4AxdBXTXQS2QLfW0iupOZ3vcMkSMIn7Lh03K49ogsDZq/vlqz0P7VHFdMj5TzytLVrntx4l8DZVSSo1tpytg/0DXkCZoMmRuvrS4xLOa3H0ZL1DgLyTA3Y56+gaxv2h2F1hsbFLthoflxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rpa26Qac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rpa26Qac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86B6C4CEFD;
	Mon, 27 Oct 2025 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590677;
	bh=ghqDHMoPB0g64iqQoyEEHgOVxg6fKxrWoyWcrN5NFhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rpa26Qac5lKgvejulJdU+lOlqfhzcYRN5+OmwQs7EWHB7yjacSnhQxRIS9Ki/qHNQ
	 5RR2FmrjfMeIDMN4LKUdx8bpW/GUFTWT1bR1nDaFsL3jhOMGgsE6ORhFDsXv+O1LSi
	 4YNIGjKswbX5PWV6bZ7N15kacqM8VwdhychQe7lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.4 106/224] drm/nouveau: fix bad ret code in nouveau_bo_move_prep
Date: Mon, 27 Oct 2025 19:34:12 +0100
Message-ID: <20251027183511.833189023@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

commit e4bea919584ff292c9156cf7d641a2ab3cbe27b0 upstream.

In `nouveau_bo_move_prep`, if `nouveau_mem_map` fails, an error code
should be returned. Currently, it returns zero even if vmm addr is not
correctly mapped.

Cc: stable@vger.kernel.org
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Fixes: 9ce523cc3bf2 ("drm/nouveau: separate buffer object backing memory from nvkm structures")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1122,7 +1122,7 @@ done:
 		nvif_vmm_put(vmm, &old_mem->vma[1]);
 		nvif_vmm_put(vmm, &old_mem->vma[0]);
 	}
-	return 0;
+	return ret;
 }
 
 static int


