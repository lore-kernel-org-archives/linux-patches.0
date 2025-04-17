Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228E82522AC;
	Thu, 17 Apr 2025 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914970; cv=none; b=AfsrtsC4LVkHenieCz0vOm2zfCzhwR0EOrzH82u0FenC6NWB1I6qdJxBhm/QnpOe0FZq6dEGVF3B92kKTjbKDP2LBPE78wlYj0ZViZCDjNTVLmehG/L99ah7XsX9FwZGIt3M1gTfCZyMlx6n1waoaYfyfkadyASuMEEwLO901HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914970; c=relaxed/simple;
	bh=ShEmewK/nv23bKMwgvP8o06SeIaJoWXTrGVxZtK3kgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pXMEAEjvJWWWt1DFV25m+4XDuE4505f6YNvt5G9e8CjuTvtKL58eyjGEgJ50e/dwaHyMTstT+LuNe8YxY5iVz5IwLassm3O1K6Pq1b9C3wAGKfXAANgaY5ygWG2ZfRJpFnCNr7oN9v/FG3xTxn53Czpoijv8GMju5L9/4K3K1Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8M0tJ2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8M0tJ2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F83EC4CEE4;
	Thu, 17 Apr 2025 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914969;
	bh=ShEmewK/nv23bKMwgvP8o06SeIaJoWXTrGVxZtK3kgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8M0tJ2HtSxC05Fg+lRpv6H8k2dhNzmDKlkh5XBy35jnjqaggVUuEXce2uR4lZGmf
	 AaVZpcIZQSMfOBafJG3E/Wn+XXMRxz8ZYGSERAyfTxtLWC6AKPMaes96azJv15yteu
	 5dwHqdgxYWpjEi9ic09l7a3ocLOvEQNwXwU+c8jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.13 373/414] landlock: Prepare to add second errata
Date: Thu, 17 Apr 2025 19:52:11 +0200
Message-ID: <20250417175126.464178560@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 6d9ac5e4d70eba3e336f9809ba91ab2c49de6d87 upstream.

Potentially include errata for Landlock ABI v5 (Linux 6.10) and v6
(Linux 6.12).  That will be useful for the following signal scoping
erratum.

As explained in errata.h, this commit should be backportable without
conflict down to ABI v5.  It must then not include the errata/abi-6.h
file.

Fixes: 54a6e6bbf3be ("landlock: Add signal scoping")
Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318161443.279194-5-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/errata.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/security/landlock/errata.h
+++ b/security/landlock/errata.h
@@ -63,6 +63,18 @@ static const struct landlock_erratum lan
 #endif
 #undef LANDLOCK_ERRATA_ABI
 
+#define LANDLOCK_ERRATA_ABI 5
+#if __has_include("errata/abi-5.h")
+#include "errata/abi-5.h"
+#endif
+#undef LANDLOCK_ERRATA_ABI
+
+#define LANDLOCK_ERRATA_ABI 6
+#if __has_include("errata/abi-6.h")
+#include "errata/abi-6.h"
+#endif
+#undef LANDLOCK_ERRATA_ABI
+
 /*
  * For each new erratum, we need to include all the ABI files up to the impacted
  * ABI to make all potential future intermediate errata easy to backport.


