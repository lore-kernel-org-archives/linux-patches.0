Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E5D100B8
	for <patches@lists.linux.dev>; Fri, 23 Jun 2023 17:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F51DC433CA;
	Fri, 23 Jun 2023 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687540017;
	bh=tdlAa1sxVJIiGALm28FCJ5TT+tzeTRQAZ+hrFFavsSE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NAr9r64mU50yq3JK+uiHFlI7BgRWsU2fLPyEWiiOPk+PdI4MkDyJOB0+9ZNG4j/wN
	 IXGC0aVqDlR/2RVTevGsUY5Yw1gjmf3oHXT97Ty0XEM3zAJHDUEoS7jvnMtBgbdJ/y
	 mkX1ABOv2p0G16UrAU7XgH3LB72hGv0KxofwmbU0=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 23 Jun 2023 13:06:38 -0400
Subject: [PATCH WIP v2 2/2] COPYING: rename Linux into Lunix
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230623-test-resend-prefixes-v2-2-72becbfc3fb1@linuxfoundation.org>
References: <20230623-test-resend-prefixes-v2-0-72becbfc3fb1@linuxfoundation.org>
In-Reply-To: <20230623-test-resend-prefixes-v2-0-72becbfc3fb1@linuxfoundation.org>
To: patches@lists.linux.dev
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
X-Mailer: b4 0.13-dev-87aac
X-Developer-Signature: v=1; a=openpgp-sha256; l=444;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=tdlAa1sxVJIiGALm28FCJ5TT+tzeTRQAZ+hrFFavsSE=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFKmXjTI+rjicNjCLZsrjm5kWb2plv+4uMOzgzIqV0xmX
 2JQ8t+l1lHKwiDGxSArpshSti92U1DhQw+59B5TmDmsTCBDGLg4BWAiF68x/Pc+brXQqKL/k3au
 wKKrGpU3JHbc+fiv4LAb03OBWi+jH/qMDA8kZVjX/4lJ1/AVEFw6e95Jl1ClGw6sx4sNDLXcfbN
 /cQMA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Bogus commit, ignore.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
 COPYING | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/COPYING b/COPYING
index a635a38ef940..de0eea085efa 100644
--- a/COPYING
+++ b/COPYING
@@ -1,4 +1,4 @@
-The Linux Kernel is provided under:
+The Lunix Kernel is provided under:
 
 	SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
 

-- 
2.41.0

