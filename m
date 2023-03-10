Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC194E4E4
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=vxh+5loJXr3QOkEBXraKRrSEsoLxyjcuI0B+WEdhvrc=; b=ICn+4H1Gid6ISIQtmA0dRRbsb8
	TA5WsB7AvOCX+EZG9pAFvNij/xCRcRVffQ8DW1eKISqZhVdSweKez4Ce4x6bNBbtzrxAb3g/QEuQY
	Tgr2QdR77Rqua6uRpaqyFTZqzSdIsVTrMeEb8BmWcxEHuLzpriCVgZUTuzips3XFyZibgMPeH/JJG
	7AHXtJJ84yqwS7cGnh2ZAZre7hmo0fkKTYShqUS1WzB3bJkjmaooFmGGSreXLsWcb5IK6592fhuCN
	NLUCBWdbzyfO99+sFR9jKYhNMMC+dlHEnIFt5rF3WEDeMKkGshOoxh1DZjxsHRCEEpSrV6uM7y73S
	ls83Dbxw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamAN-00GcM6-0Y; Fri, 10 Mar 2023 23:28:51 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: mpe@ellerman.id.au,
	npiggin@gmail.com,
	christophe.leroy@csgroup.eu
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/2] ppc: simplify sysctl registration
Date: Fri, 10 Mar 2023 15:28:48 -0800
Message-Id: <20230310232850.3960676-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

We can simplify the way we do sysctl registration both by
reducing the number of lines and also avoiding calllers which
could do recursion. The docs are being updated to help reflect
this better [0].

[0] https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     

Luis Chamberlain (2):
  ppc: simplify one-level sysctl registration for
    powersave_nap_ctl_table
  ppc: simplify one-level sysctl registration for
    nmi_wd_lpm_factor_ctl_table

 arch/powerpc/kernel/idle.c                | 10 +---------
 arch/powerpc/platforms/pseries/mobility.c | 10 +---------
 2 files changed, 2 insertions(+), 18 deletions(-)

-- 
2.39.1

