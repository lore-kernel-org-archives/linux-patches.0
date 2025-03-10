Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349D8232367;
	Mon, 10 Mar 2025 17:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626573; cv=none; b=IjLvQXAa1VaaI0O+NuLcIYrb+ftNY7Pff2Xrmjci9UNrGHzL+6Em4jKYQHkWMlprWyQ8bPLcwQPgSnbhg+rhFWSSmBViBflHDloGdNUmfwRoJbT+nhu1jspz320oMSbsWi4uFbaNU3Qp06u0D0ruI0RE/DqpAUMkuAZkYwAm2Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626573; c=relaxed/simple;
	bh=0pPobXUKYXhdR3tL6TOq33YD00+kySJc1PoiYgBQZMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbuuwYfYZPqf6XeaR+iEHQQIgTNIz+FDe8fJTssbhE3W4lpEBApKegWbOSEyrfEA0cdPpXPr87ePiTJexfBtDKi14e96QrWoYKbPGnfLC2QKYwZfNDci1G6qR3RDr6CYr47iOb9re+XJxjUoqMcwrLRFRl/s95Y6d8RyGeZF0/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rABz2MUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rABz2MUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD4AC4CEE5;
	Mon, 10 Mar 2025 17:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626573;
	bh=0pPobXUKYXhdR3tL6TOq33YD00+kySJc1PoiYgBQZMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rABz2MUccZEQLIhUTEnyxcOlcZ3fhVUKQ7f4f62siLH+g1qdbvxSLmxZBPf35SU6W
	 vuyMOvlufmYuvTWj5/w8K4VOi8qIUeiQR65yGF0AMIDe+pXuthoWBBiO0KS48UGAnr
	 aVeDuArT7CNr8mbacTvY9Z8N8a/8ppGcJhexPe8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.13 007/207] Revert "of: reserved-memory: Fix using wrong number of cells to get property alignment"
Date: Mon, 10 Mar 2025 18:03:20 +0100
Message-ID: <20250310170448.046914952@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -415,12 +415,12 @@ static int __init __reserved_mem_alloc_s
 
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


