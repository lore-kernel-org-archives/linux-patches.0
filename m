Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B1331AF14;
	Mon, 18 Aug 2025 13:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522575; cv=none; b=bSSbtH/Au64ymUEMBW3VNapGD9v0zpYnjd/Wpi/CoOWa9lTrmLsGPj4C64v86HQF3S/H/7y+r9Oqvlg8UtGMbns1Y1s5yQslcQ7y3xWQVlSt9mM0lXu6Ix1UVUAebTy678PIH+69cOyjRu2KBr83I/RIhA3IG4SLczjziR0kjDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522575; c=relaxed/simple;
	bh=UI2ikD0Vpk6ZT5KKdb84nMlcdMwB27nsOlLjPO9qX2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1nSMJd+72fdnnPll2D5mmhi3LRI5bADPPKqxTqTyD/uyH7fNjDONtvswvIV4FOdVflaOCCjEVn1OjoYQL5xtZTV8ecjSGus9htKdnIaMrbRCKcbGKqOcDHyh3a+yn8IwGjswSzxbp8/+ja24bQSMfqml6BTBqRcK2G0+Snwkvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dk1CMaH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dk1CMaH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFDAC4CEEB;
	Mon, 18 Aug 2025 13:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522574;
	bh=UI2ikD0Vpk6ZT5KKdb84nMlcdMwB27nsOlLjPO9qX2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dk1CMaH6AXApjV9Hvcr1w34uYFrVUStu2V/wrd/wmSQmdy19bbPDrGkI+3QbRIEVx
	 BG/0O017fck+vjxkh8jJZkCeDV8tVFA+MYvLXEfDFVePCdo3INvL6/tC82yTJFtPnP
	 mW60WeCng5+tsrlA4yx++tS7dG/Um6AjyDtuutRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/444] tools/power turbostat: Fix build with musl
Date: Mon, 18 Aug 2025 14:46:21 +0200
Message-ID: <20250818124502.226413523@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit 6ea0ec1b958a84aff9f03fb0ae4613a4d5bed3ea ]

turbostat.c: In function 'parse_int_file':
    turbostat.c:5567:19: error: 'PATH_MAX' undeclared (first use in this function)
     5567 |         char path[PATH_MAX];
          |                   ^~~~~~~~

    turbostat.c: In function 'probe_graphics':
    turbostat.c:6787:19: error: 'PATH_MAX' undeclared (first use in this function)
     6787 |         char path[PATH_MAX];
          |                   ^~~~~~~~

Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Reviewed-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 8c876e9df1a9..9be6803ea10f 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -67,6 +67,7 @@
 #include <stdbool.h>
 #include <assert.h>
 #include <linux/kernel.h>
+#include <limits.h>
 
 #define UNUSED(x) (void)(x)
 
-- 
2.39.5



