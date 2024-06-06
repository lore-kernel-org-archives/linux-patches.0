Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D981991B6;
	Thu,  6 Jun 2024 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683650; cv=none; b=syj4xktXj5vmJ5gQrG+W7iIFVFwvFZP0VD6yoIZc5gdacHQrZVQIZSBUr14ALoe/Fh9STH7bdeEC1+YvBqP2JENrxMe9wPyoHeVivh/pcCb8BVJoqwzBOwZ2misYrpL9znh8V0CnMVr+HSSSySaMRtr9T7fnV42kY+x5XjYZYIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683650; c=relaxed/simple;
	bh=fGGUS/rZmWjEkAnm/u1wFjCjFW2qMmlFbPVDYCe1on4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRAl24dfhRiTz5BrdIg4qhbxY3rKknETKCKkMTm/MXYzxo9TnMQSePTzEwnWwE0D2TkvLJJFBkDfWg3mTDfWs5mSy7rFeSgV/EuNiOxIgi1zzJBEVj511UMdeB1ACmI1nQFYRZtzsfWf9Y8qd3CilA/wkRDsacqWB6ALQhTwEts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNocxA2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNocxA2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C3EC2BD10;
	Thu,  6 Jun 2024 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683650;
	bh=fGGUS/rZmWjEkAnm/u1wFjCjFW2qMmlFbPVDYCe1on4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNocxA2LbzSn5cado1IUyVvE9Yz97LBlis+MU1DnYj64ITTgKjBsgTsmNslYOtiuM
	 UcF+t1X3txMhTf7iUSmYMt1KB6UKkpa0ZX/JpPJRlVxAKUu/XkRNLIWzIVewqQPXoq
	 bIlsmUylfPrIW3f5ySNWv5IEpAUvo9x1OT6nr+oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 469/473] powerpc/pseries/lparcfg: drop error message from guest name lookup
Date: Thu,  6 Jun 2024 16:06:38 +0200
Message-ID: <20240606131715.188603629@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 12870ae3818e39ea65bf710f645972277b634f72 ]

It's not an error or exceptional situation when the hosting
environment does not expose a name for the LP/guest via RTAS or the
device tree. This happens with qemu when run without the '-name'
option. The message also lacks a newline. Remove it.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: eddaa9a40275 ("powerpc/pseries: read the lpar name from the firmware")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240524-lparcfg-updates-v2-1-62e2e9d28724@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index ca10a3682c46e..a0364028f5ef1 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -393,8 +393,8 @@ static int read_dt_lpar_name(struct seq_file *m)
 
 static void read_lpar_name(struct seq_file *m)
 {
-	if (read_rtas_lpar_name(m) && read_dt_lpar_name(m))
-		pr_err_once("Error can't get the LPAR name");
+	if (read_rtas_lpar_name(m))
+		read_dt_lpar_name(m);
 }
 
 #define SPLPAR_CHARACTERISTICS_TOKEN 20
-- 
2.43.0



