Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E180025EF89;
	Tue, 11 Mar 2025 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707433; cv=none; b=QRWQPTNiZ1zPyAh7dFB97Ep4gk59hAoybCdwbaMbvLfLcRXfLTRDYiLwzCpAc53cOFoR6RbYo+qwdLJ7qIHqW6wEcKmQt6ihSsBMBkTw5buF3R4bWuuG8nmNMnfzbAmP4vrkLEQ+Gel6czlvpAZC3tTeu+dd+X45v6EgElUG4KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707433; c=relaxed/simple;
	bh=/yRnkhh5FGzkWbhS6eFgxifnDpfOUW0Wx5uyDtWrHx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LU+hl5DQFXTCnzZ3Q+AJwCW8oC/RGZ8O9c1XbhxY1CQFbqaDxVnnFFFf6/KIPJF8p4ckGUDYKX4AnHFlFe0Vscx9wwaSskBkYA+yvGzq9MoDgUj/XLFO9IuW+WczaJuiD+tHvSjA+sASfJd7TzaT8kT8p/hp6N5AwFZUUVyXkTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2M0D0OR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2M0D0OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A1DC4CEE9;
	Tue, 11 Mar 2025 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707432;
	bh=/yRnkhh5FGzkWbhS6eFgxifnDpfOUW0Wx5uyDtWrHx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2M0D0ORVjmelLwdwjfLuh7GIyfzScGijbkM0AVQQizIvDbK2qSktpAaGG3RddYID
	 mjdi6TxneZpXN/4WhIvps9m2MpZa7DCpJTV596qGu5hdmkom562aWtp6AnlFcdsMpF
	 38Ql30klN9gp+dvt2iul1DdIxLzXGyPs2mwYen6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 388/462] Revert "of: reserved-memory: Fix using wrong number of cells to get property alignment"
Date: Tue, 11 Mar 2025 16:00:54 +0100
Message-ID: <20250311145813.671190950@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

commit 75f1f311d883dfaffb98be3c1da208d6ed5d4df9 upstream.

This reverts commit 267b21d0bef8e67dbe6c591c9991444e58237ec9.

Turns out some DTs do depend on this behavior. Specifically, a
downstream Pixel 6 DT. Revert the change at least until we can decide if
the DT spec can be changed instead.

Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_reserved_mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -94,12 +94,12 @@ static int __init __reserved_mem_alloc_s
 
 	prop = of_get_flat_dt_prop(node, "alignment", &len);
 	if (prop) {
-		if (len != dt_root_size_cells * sizeof(__be32)) {
+		if (len != dt_root_addr_cells * sizeof(__be32)) {
 			pr_err("invalid alignment property in '%s' node.\n",
 				uname);
 			return -EINVAL;
 		}
-		align = dt_mem_next_cell(dt_root_size_cells, &prop);
+		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
 	}
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;


