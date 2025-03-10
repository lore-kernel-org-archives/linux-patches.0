Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2751618DB24;
	Mon, 10 Mar 2025 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628332; cv=none; b=fFqoLnrGRlfmeHImkTDryOSO0JSg8YSvRNjQ16gRRMt9cCQxr914ywBllvI6tANFNgelWQ9ROklTZ8o9AYZjN+ZH+fiauqfOV4mx/XDtIKDIx4B7b4BnrYLYQtj4zXC/ZUW2Y14Ve6SBQfyu8SQ6FNQcu2CP5O3LYH7XND7alXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628332; c=relaxed/simple;
	bh=GnIbLZEeQfN2A503wMlxVQSb5bignW3/P8JKpzisdBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u11WbukASoClG/Ctq2UCxIeUm+xltqYZlV4cvNmO7jP9qaV3SX+r6jZjHEp5DB26yBfvwvTx8BzntGTquneE9OMHEqkTJllQVNoeAi3agvdsNgruymczPLn3JMxem7eJTfsDQLFBoNcpTmsBh65TUiwFK47qfbKrGyHOSLpMHzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIcfRtpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIcfRtpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F82C4CEE5;
	Mon, 10 Mar 2025 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628332;
	bh=GnIbLZEeQfN2A503wMlxVQSb5bignW3/P8JKpzisdBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIcfRtpett3SyR25CZdltUpHEc2m6nQ9h9LNwL4WG3wtKmDKpZdNjF4YBexiid0Gj
	 sZxsIKqZTUrvzDIJ5Cu4QOYogCkpC2hFOJkcOMg2lgECpqi3E+ZgrQ3E0PfiFOVL5C
	 lGjb18ER9GujN52zgKmcooG2I8pJxFdLQWFkBH18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 008/109] Revert "of: reserved-memory: Fix using wrong number of cells to get property alignment"
Date: Mon, 10 Mar 2025 18:05:52 +0100
Message-ID: <20250310170427.878723063@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -105,12 +105,12 @@ static int __init __reserved_mem_alloc_s
 
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


