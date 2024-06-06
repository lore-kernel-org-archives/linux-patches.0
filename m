Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C3D1A256C;
	Thu,  6 Jun 2024 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683756; cv=none; b=cWqw5KNTTR8PY9im0/z4T2YiIzsVCc3KP7osXeZr3AlbUnA9fzSu31O9PxJ51tT9TiIo33baaP3QHocVFFSPQSteSB1fx314sgIJrrzWmtOm8OZvky0ZhxhlXOFNH12tf5OHseTgM8u6oEYSXfduyInhBCxUfS9DY/8ObLA8KpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683756; c=relaxed/simple;
	bh=+tEoGdcY96TJibO7dTnRy1YPlDlbDAbXdq+z0NN/zME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2BtiqrroN7ypEt6Y6iQ18loVZ4oSzA7YOs0N4u10YJBA6+/63vfFpjSr8frGQNc6E3UuXQVnGkSdvTo1GB0y/422R+RJ3NRgAf6FuTUfwUNzja6ztB4FOUqUcR943Z28ZEkWWeDeazvvQtlCQWEmSyhmxU3ijF1AW4wMWW07GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWXONfg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWXONfg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9C1C2BD10;
	Thu,  6 Jun 2024 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683755;
	bh=+tEoGdcY96TJibO7dTnRy1YPlDlbDAbXdq+z0NN/zME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWXONfg6517SdHOMNMONVCZb9C1J6CSKe9CwkSC8//fOSQn26a1dOa97R6p8ZEhJb
	 7S85kw3zcmYXooLYhBXwTE0ypTp6Jw0UyCDhg+h/du4S9Yqqk5CG2pIobCg/KEvGDg
	 SB4+Y4Yx7GCJIQ5pCdxRoTc2Lbh81zDdYnLX7tpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 728/744] powerpc/pseries/lparcfg: drop error message from guest name lookup
Date: Thu,  6 Jun 2024 16:06:40 +0200
Message-ID: <20240606131755.818389790@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f04bfea1a97bd..11d5208817b9d 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -357,8 +357,8 @@ static int read_dt_lpar_name(struct seq_file *m)
 
 static void read_lpar_name(struct seq_file *m)
 {
-	if (read_rtas_lpar_name(m) && read_dt_lpar_name(m))
-		pr_err_once("Error can't get the LPAR name");
+	if (read_rtas_lpar_name(m))
+		read_dt_lpar_name(m);
 }
 
 #define SPLPAR_MAXLENGTH 1026*(sizeof(char))
-- 
2.43.0



