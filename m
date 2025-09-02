Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622B630E0F1;
	Tue,  2 Sep 2025 13:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820071; cv=none; b=TEX6BAQ5qXXOrV/rmf2RXo97r2Fys+VEjNBuYE5Dtucy43U61APXScwSJW325t5es30qSm3zzxv1Z/Wv2W3S/M+l7pkDPBMJpTLe1JRhyGPUoWN5hkmHk++xQHRHPZ7Gf/kXkXdveLmeJNSHBKPiUhiFHQAsi2cDJargcqrHr3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820071; c=relaxed/simple;
	bh=y2JcqRmH5Gb91nJLuiGgfMex9KLRf0kXSp8ap9e0Avk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U0G7dfqqnn9YYVd/zGH9GlqIKr2fxkKP2I5zYqDTIyWAjzmJZH6aH5vwb27bqfMiLrVzoiOavDjhJxU/KPqGGHf0de81vUhU5qWE5Ucn9k5pp3uANoJvLsIrfEOZ+zL4Ty6bjPhz8P0AaGNFY8MjBm/DVUuBeOwKxJaq5PQNGxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=123z/bWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="123z/bWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901DCC4CEED;
	Tue,  2 Sep 2025 13:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820071;
	bh=y2JcqRmH5Gb91nJLuiGgfMex9KLRf0kXSp8ap9e0Avk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=123z/bWn9xvIQ3n5zaYSGzYj5B9QOyxYOMtGmnf7cWW68CVcz9s0L+SxSCVN5LFwU
	 he7VTmitjbHKTrCKpjWZM90j+l5M4DyRsN7LdyW015gQHBYG5D8lWp4m77KuDEVT0A
	 KnvleYLbU7HzNXt2au4fUMr2OCBDRpzbfe4Bm6rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Brian Welty <brian.welty@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.12 84/95] drm/xe/vm: Clear the scratch_pt pointer on error
Date: Tue,  2 Sep 2025 15:21:00 +0200
Message-ID: <20250902131942.828625330@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 2b55ddf36229e0278c956215784ab1feeff510aa upstream.

Avoid triggering a dereference of an error pointer on cleanup in
xe_vm_free_scratch() by clearing any scratch_pt error pointer.

Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 06951c2ee72d ("drm/xe: Use NULL PTEs as scratch PTEs")
Cc: Brian Welty <brian.welty@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250821143045.106005-4-thomas.hellstrom@linux.intel.com
(cherry picked from commit 358ee50ab565f3c8ea32480e9d03127a81ba32f8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1402,8 +1402,12 @@ static int xe_vm_create_scratch(struct x
 
 	for (i = MAX_HUGEPTE_LEVEL; i < vm->pt_root[id]->level; i++) {
 		vm->scratch_pt[id][i] = xe_pt_create(vm, tile, i);
-		if (IS_ERR(vm->scratch_pt[id][i]))
-			return PTR_ERR(vm->scratch_pt[id][i]);
+		if (IS_ERR(vm->scratch_pt[id][i])) {
+			int err = PTR_ERR(vm->scratch_pt[id][i]);
+
+			vm->scratch_pt[id][i] = NULL;
+			return err;
+		}
 
 		xe_pt_populate_empty(tile, vm, vm->scratch_pt[id][i]);
 	}


