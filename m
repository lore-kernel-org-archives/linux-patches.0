Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033372;
	b=YkEFQ0j90TYUzH22bCiSjz5yNOULu9Yi/JdoYOfZvBlsHAafK2sQZru1U6ICzkDPvnwz
	 CkpzbwlQ4qPXKUtvS8RzTmBQhISS3a1Ji3sf5yidnED/Ue8rrsZt69OFHSGCe1v+Bo5R3
	 7o3yQoKBYerwZUiIlA2NI1oT+EOy00wbZcQi95dGJzyZOOkf9kSpUcagc4dOM4GZkXHAK
	 pE3RTUfx4OIxyCl75MX7fx0Z46PyjfNYOf7r80zcxEQq/noupRNZ6gz9H/Sgid9yr04AG
	 6a4962p5b0maqaw3Rq1KF93zMmeM0i0piRkgK7Ev0YZErTYbJtEgqSSe2cEzprDk+cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9a3AwMhdopD3QK+WmNtsrfWMqmvcO3JEZyuo1mMY3dE=;
	b=sgmlhU7MM2GQVooDU5SyLgePUBaSQln7v6we/kgwm06dXclmuDMhlGLZQ0qcxk4wHvi4
	 inajuxuj0US0ePbAwQNL5tKmisQwzwKyKp9IHBJXLZfaWteGeBMdEBz5IHAMOlfxldIjS
	 32T+gvCs/xScHjbR3YwnxgL///a4+Q6AOFSa9fQKCC7LALaKSfMCpWajo8+pRafOtRJeM
	 7JFZFHLeS7zgvSCdvnJLSKvEMXX/pPos2gBOSrXS30Njvjacpm/uuWqk1l1TpF9N++GS1
	 bHP5IxBJf0jEtX99Wo7MkBto7E6ms5HP0FEA7Z6NLbkm0b8gcoxEmD8noZifNMYFJ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR4QxgA0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889C5606A325;
	Wed, 18 Nov 2026 20:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR4QxgA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963B81F000C5;
	Wed, 18 Nov 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033372;
	bh=9a3AwMhdopD3QK+WmNtsrfWMqmvcO3JEZyuo1mMY3dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR4QxgA0STvTGWLKCkrlCTLRY9Xta98p5/TLQd1lTmeqCwMFSQhAogQydsW5JgJe4
	 igp0DYzLBzjn/OswzVmecw+BJl/i4kV8msvVv0HnrCPgvihpEB0Ag5tgnCDIoHP2zd
	 GE5XzjO3bnK+CUmKpswrekixkkSa76YWRw7h0HRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Viktor Malik <vmalik@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 1746/1756] selftests/bpf: include limits.h needed for PATH_MAX directly
Date: Wed, 18 Nov 2026 16:04:33 +0100
Message-ID: <20261118150119.041710544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit cd7312a78f36e981939abe1cd1f21d355e083dfe upstream.

Constant PATH_MAX is used in function unpriv_helpers.c:open_config().
This constant is provided by include file <limits.h>.
The dependency was added by commit [1], which does not include
<limits.h> directly, relying instead on <limits.h> being included from
zlib.h -> zconf.h.
As it turns out, this is not the case for all systems, e.g. on
Fedora 41 zlib 1.3.1 is used, and there <limits.h> is not included
from zconf.h. Hence, there is a compilation error on Fedora 41.

[1] commit fc2915bb8bfc ("selftests/bpf: More precise cpu_mitigations state detection")

Fixes: fc2915bb8bfc ("selftests/bpf: More precise cpu_mitigations state detection")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/r/20250618093134.3078870-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/unpriv_helpers.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/bpf/unpriv_helpers.c
+++ b/tools/testing/selftests/bpf/unpriv_helpers.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <errno.h>
+#include <limits.h>
 #include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>


