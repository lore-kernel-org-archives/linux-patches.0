Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2537E6
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 22:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=G6+Cn89Ag9qW4eqhjNdBjQ8YmvxCStNR3LV0by4fV3k=; b=zZ1WSST/cH7QUvz9Ds/P3tCfmS
	aXovpVr04NxN011cTjexoffPvMNsDAXeLnFb2ESZvEGwTDiRDMnKB+i1OGzvwTvRfgbPbgAmTQTiw
	a4aNFYjBGKYWs8dhy7emo/sUV+6x4/gPDECYnG1LoSX7bD+tzc4cMnxYOljDC8yG534hFNSonbZla
	mbJriUQ9wxbcTg1zq4NYNaJorwtPTzysGbGmvEZ8tNJj4P2EyLyz4PSGkvq6HiQfIUwt1x1Rks9Wn
	RTYa2BK4EsqM7uLDUMTJn4Msv0ghJNfq8pOwKPSohOS9vNKyaMrBjqShQtALB64KNaJ7oUqIep6W5
	upTCPD7w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1palhD-00GYlR-2Z; Fri, 10 Mar 2023 22:58:43 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: chuck.lever@oracle.com,
	jlayton@kernel.org,
	trond.myklebust@hammerspace.com,
	anna@kernel.org,
	linux-nfs@vger.kernel.org
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: nfs/lockd: simplify sysctl registration
Date: Fri, 10 Mar 2023 14:58:39 -0800
Message-Id: <20230310225842.3946871-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This is just following the work of the same sysctl registration [0] I
just emailed you patches for sunprc but for nfs and lockd.

Feel free to pick up or let me know if you want me to take them through
my tree. I haven't even finished compile testing all these yet, but they
are pretty trivial.

I'm just dropping netdev on this series as its purely nfs/lockd stuff.

[0] https://lkml.kernel.org/r/20230310225236.3939443-1-mcgrof@kernel.org

Luis Chamberlain (3):
  lockd: simplify two-level sysctl registration for nlm_sysctls
  nfs: simplify two-level sysctl registration for nfs4_cb_sysctls
  nfs: simplify two-level sysctl registration for nfs_cb_sysctls

 fs/lockd/svc.c      | 20 +-------------------
 fs/nfs/nfs4sysctl.c | 21 ++-------------------
 fs/nfs/sysctl.c     | 20 +-------------------
 3 files changed, 4 insertions(+), 57 deletions(-)

-- 
2.39.1

