Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7C232A3E6;
	Mon, 18 Aug 2025 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526196; cv=none; b=ZwJ8bSp62peh9phVPQ0oNW0/sYico0nITGsJBdcb+8DJtKT9VrMSNE6MDxdSPPH+tj/eXJrSi6NaWyPFgtdX5K+ulO8g2ouZcj1FQmUp106hZj6m2u1ukh1rJJf1JUTdYjlld3Nav5R5GPXY4pYtSBPRydQ5M03lDWBPCno0/Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526196; c=relaxed/simple;
	bh=lcIt3U3hdr1xD8vN5hqyFuLToEuHFEaj5/QjYGTa65w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS727Rk0HtolpsxEwb2MDUm14i6NqW4ug4+cg7hpTF+sLLkbAmHFGuvye7tfOPvgNBq8byMGc4ID+YJz0dsrHNp+oC4JnqbcHRJH2fCUaP4zLdi+UrqQkZP53aNGIRacC+inSE+Lu51zhzq2/ia57X0wVrFWQkj7rduy/EW9CT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bi1lPtYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bi1lPtYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1614C4CEF1;
	Mon, 18 Aug 2025 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526195;
	bh=lcIt3U3hdr1xD8vN5hqyFuLToEuHFEaj5/QjYGTa65w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi1lPtYFhBXT0SFjgAx//9rQoh3Wla2Epbg69dUV2mZXNrgV3/+FgJaF0/HzKzW7Y
	 0qxNVcjWJAGtDC+sj35EZlg2ZhCEfo81WVRekbh06xzn8OR4rTit2/5CXA1ZVHIoYq
	 H3CblxH8PV36GOOozsim9fOKrDDzH11ogupvpesM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 453/570] tools/power turbostat: Fix build with musl
Date: Mon, 18 Aug 2025 14:47:20 +0200
Message-ID: <20250818124523.269728858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 291c98b5d209..9eb8e8a850ec 100644
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



