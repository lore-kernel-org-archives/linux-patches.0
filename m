Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F01B2F32
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CNl8Hp4SH69dRDEI3CTQtAM/rG11ZgGlp/t1ojj+irE=; b=JmAiUE1cpilzqc5dKzALezwzHd
	ejaD2mbvbe87MGZp7CXJseZaOPzsDiwGEefFWgh6+ZwsnwXAXqK2dKwffdnkgRxwIAmPXwR0rfDEi
	oGoKor47o3ERNELgLVrJ9v24FylEjj3EqhcPXflPyqTsED2Vrq3fqYA4TnbDY5/83mfkUQBB7judk
	AjhFgFJiR6039P0zDj1ZgLpOy9Hs1SliSNConBE0ULyrX7DOhQQ0JCsy1mzEVdS3465f00cin5i5+
	nx5IqEcnQ8mT6ZoaaXESWUaynywQCqNyS5u2ib+4DSykssW04sL1IJ3dlgHRlhIBI+9DsLxf0h2sp
	FofxyPsQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamED-00Gdav-Sl; Fri, 10 Mar 2023 23:32:49 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: luto@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/2] x86: simplify sysctl registrations
Date: Fri, 10 Mar 2023 15:32:46 -0800
Message-Id: <20230310233248.3965389-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

These are trivial conversions to reduce more code and avoid API calls
that we are deprecating [0].

[0] https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     

Luis Chamberlain (2):
  x86: simplify one-level sysctl registration for abi_table2
  x86: simplify one-level sysctl registration for itmt_kern_table

 arch/x86/entry/vdso/vdso32-setup.c | 11 +----------
 arch/x86/kernel/itmt.c             | 11 +----------
 2 files changed, 2 insertions(+), 20 deletions(-)

-- 
2.39.1

