Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5259B25E818;
	Tue, 11 Mar 2025 15:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706149; cv=none; b=CQsM06G1LfWgXoR+p0MCNKyynwjxhMQzNe/Iwioa6GTCwNbR4nYere/bX1npQMnfEmzI1ogX//CjSAlWtz6wduZ9yrANVRqFSxVdHQBLBZUS1UNqHjr5tnWBg9ODCs/uFf/sNc1kA4lIrzmHzZd6EYH5IU1/t5ROlTfCwUXfg+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706149; c=relaxed/simple;
	bh=HkvljbijVOE2x2lp/P5OoY4VLegOxoN0XOxXQwTIyUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1iBBpbnTuq7gCNcsbdI/nddE1MOaaoT6aKAfZiEBy/i1/YmUZkKWJlsL6vmtbrWP6AxKm5tzNEZRAx7jbV6JYQKUXX15EELjnWZx2E4MoMJNdBp96YgtmvuJxj435IBtnG968SfKjrE9Oq3x6/aqvO9vSMkbFL81pIlXogmcJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3Z7E+kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3Z7E+kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB97C4CEED;
	Tue, 11 Mar 2025 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706149;
	bh=HkvljbijVOE2x2lp/P5OoY4VLegOxoN0XOxXQwTIyUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3Z7E+kz93tcA47slAINjqmvUQxd8NmtSrVNs86fEgfhkzOO/B+wGpDt9ZywH+UXL
	 WXGR2/Ep/I/HxxNNJDEwTSmW4muCvDC/4+ckBwAoKpyG2FYYY3u5PIr5OWEc0K/GlL
	 IEyiGXUM5Oq95ke7MC4A7nII/gSgZVvVyjreu9T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 279/328] Revert "of: reserved-memory: Fix using wrong number of cells to get property alignment"
Date: Tue, 11 Mar 2025 16:00:49 +0100
Message-ID: <20250311145726.005219872@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -96,12 +96,12 @@ static int __init __reserved_mem_alloc_s
 
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
 
 	/* Need adjust the alignment to satisfy the CMA requirement */


