Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F32D416139;
	Thu, 30 Jul 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422875; cv=none; b=SrcKFaU5exu2VWG7NkHOb1PiUyLX02kbGoX5qlWpmAvVcahOGOAO15kNrMPITaPJBeu1Qs0tDU1+Dwib84I1sh4yVx5yrVrBiOd66K1jSf+gsbI62Fbzj44ExaC5rACn6iuUIfzN3z8k/ws9XJtKD0twX7EnOLHNhLOSjuJz0Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422875; c=relaxed/simple;
	bh=xyDrJWAroaJe0pwBvPEdRRmkAsDQAhCVOwtntCtp7Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+EvBvNbi26CVIVicMkfxVtsQaiQV1th2nNbI4UfiwFjY95UB+clbYqY2nSKYovLqZPAKb7SWuCKNAM7hN/8Q+GslQOjCymUZ8+n0dGq4pz0xVFi3r6RKEnlH3TjKHR2dC9Vp7LltHQ8vloTwh0JuFyYmzATJZ3T1+HZRJ9o+0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSa24lSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSa24lSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB521F000E9;
	Thu, 30 Jul 2026 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422873;
	bh=fJyfMZ2IJuBRpmAzZcXkHLY4JrHJZGA2HJSGm8FBeXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSa24lSJSzXqeft/WYPEUt132F1tvRlqtXgiATgh2CbsA/8HPLsFJqmBurOw5nnNO
	 gWU6vIfZ0qOP4r2gQpeuN7kg5BCpB9UFmFFLSlHW+fwUDhUY5UFFX/Kx20CLMuZRb7
	 nOS0ElhpfU0XwTliQC1GHkAsgSw9aGEOvTGH5WF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH 7.1 585/744] selftests: ntsync: correct CONFIG_NTSYNC name
Date: Thu, 30 Jul 2026 16:14:18 +0200
Message-ID: <20260730141456.717990056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit f97752cfe511c1ed9933057455c73aaac07d6517 upstream.

The config fragment for these tests defines CONFIG_WINESYNC, which
refers to an earlier name for the ntsync driver before it was merged
[1]. Correct it to define CONFIG_NTSYNC instead.

[1] https://lore.kernel.org/all/f4cc1a38-1441-62f8-47e4-0c67f5ad1d43@codeweavers.com/

Fixes: 7f853a252cde ("selftests: ntsync: Add some tests for semaphore state.")
Cc: stable <stable@kernel.org>
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Link: https://patch.msgid.link/20260609175505.19632-1-enelsonmoore@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/ntsync/config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/drivers/ntsync/config
+++ b/tools/testing/selftests/drivers/ntsync/config
@@ -1 +1 @@
-CONFIG_WINESYNC=y
+CONFIG_NTSYNC=y


