Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597881DE3AA;
	Wed, 19 Mar 2025 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742400492; cv=none; b=LOXWoB2GjWOM66ALWZnEN5a+kebaN8eJzYchwzCE7Vsy3vPzCir50oqajiWvbvWZJeuLWVW15qYmrkb6TthmaqFqRlJBzUVVaz3xNWtMRs2hBKo+L/PswfkRQlyVpgsbdHCa6eaWBpAmzbFfNgUGowM9plCjrTh0Pvq5+ZXquo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742400492; c=relaxed/simple;
	bh=ZgQibqnYOqFsCMWXhLzNKeBk1b2KjH8VJddDDteh1cI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=VH/p625krh9bANaARJOgvhwJOv9uBIolnJwjx1Y3QROTH8iAsfLQijnekMP/AlRC865IfGYVBcN1B1l0OaHvcClovI+QTYH+uIxJEzh17hdbEIys1OBPFGjTuAQZepAvLpnM6cCBspQrtx16Ikw5cro0e3BD4Jbu+dTfATmkf2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7hn4knW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7hn4knW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B063C4CEE8;
	Wed, 19 Mar 2025 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742400491;
	bh=ZgQibqnYOqFsCMWXhLzNKeBk1b2KjH8VJddDDteh1cI=;
	h=From:Date:Subject:To:Cc:From;
	b=V7hn4knWJ6YXhzBccFogxrOttg65IlcaiZtOT4Q332gBSwu6eDswCj8ymLjyfweNN
	 fZiFjKzpmAVxH+e6/gc1/6cqONePhrRpSmLvQOmUUsMoi81OIyMlDydNzKiRVqyTvm
	 4kQuPTZXEBPBuLsM8Bhc54P5sh9fPjS40uSVY79YeFC7uARceDqmu/NZrcGWWdfLF3
	 HYFtZp3zNXQK8z20NnYXrvfXa3F8GpGwNbyuJ0GH/mBjIwCcRdBCGJ3snCWujK3A5I
	 V0kQvTbNLWv0bSAhaGPOffNqFSD8SYrWr0IM++c+CU7hXlEbPi3uJPAFijRVEqXz8a
	 rKfo7h8KWvJtw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 19 Mar 2025 09:08:01 -0700
Subject: [PATCH] i3c: master: svc: Fix implicit fallthrough in
 svc_i3c_master_ibi_work()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250319-i3c-fix-clang-fallthrough-v1-1-d8e02be1ef5c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAODr2mcC/x2MSwqAMAwFryJZG/BDKfUq4kJi2gaKSqsiiHc3u
 BzevHmgcBYuMFQPZL6kyLYqtHUFFOc1MMqiDF3TmaZvHUpP6OVGSrqin1M6Yt7OENF5Q5a8Yes
 c6H/PrOLfHqf3/QCnyO4qawAAAA==
X-Change-ID: 20250319-i3c-fix-clang-fallthrough-9f5c7cf5e799
To: Miquel Raynal <miquel.raynal@bootlin.com>, Frank Li <Frank.Li@nxp.com>, 
 Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Stanley Chu <yschu@nuvoton.com>, linux-i3c@lists.infradead.org, 
 imx@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1618; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ZgQibqnYOqFsCMWXhLzNKeBk1b2KjH8VJddDDteh1cI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOm3Xr/UcwnsnaaTeu/iZ+s1S65X16vqNQasCJwSI2v7Q
 0+zRSSto5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEwkXZ2RYcLcHRt+pF05Uhb3
 UNAmTM65y+P/XvkosfjtBuLP1J5kzWFkWFD0ccYyqVtTyy5OUOyqdOyV+dJ/lPP+gikK5rHSVw1
 EGQE=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/i3c/master/svc-i3c-master.c:596:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
    596 |         default:
        |         ^
  drivers/i3c/master/svc-i3c-master.c:596:2: note: insert 'break;' to avoid fall-through
    596 |         default:
        |         ^
        |         break;
  1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Fixes: 0430bf9bc1ac ("i3c: master: svc: Fix missing STOP for master request")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index e0cd3ce28b7f..85e16de208d3 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -593,6 +593,7 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+		break;
 	default:
 		break;
 	}

---
base-commit: 0430bf9bc1ac068c8b8c540eb93e5751872efc51
change-id: 20250319-i3c-fix-clang-fallthrough-9f5c7cf5e799

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

