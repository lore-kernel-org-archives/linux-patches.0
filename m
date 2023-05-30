Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7270A927
	for <patches@lists.linux.dev>; Tue, 30 May 2023 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8kZDmW7u1BAwE+M5sWH6dCUNdnC2eoBRZLZS/mk42z4=; b=FpoywbOee5kJx6j7BsroAWkapc
	C8vpYY7F0mBdwtR9djLjY1oi4UXRWCW8OjSs0qYtgy3atfS47cAhj6mhbBP+9J4UMCCCGohcAunY4
	x3yRDL/6/zJZPiqVxcqZt/lvFNyWOiruXvpDHPp3OcRvHq3KYyfv5qPULQO4qZ7x0XtVxU+9f4g/t
	3j4PhZWEuZaJzfz0C30Kmwbs2XobhTuO+/Z1F8dhsUUi2XKs3AaiVYC6l+ZhXWSX3GqWCJ+tJE6ll
	2dKpTX0UglWP6jBS25td4J+tS0IIfCWgk1/GgBEhZpcqMyjkHGv2nMMFvPJemJEF0NtJfV3in9ZiO
	uLb6Nv2Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q48mB-00FTri-0j;
	Tue, 30 May 2023 23:29:15 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: keescook@chromium.org,
	yzaikin@google.com,
	dhowells@redhat.com,
	jarkko@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	j.granados@samsung.com,
	brauner@kernel.org
Cc: ebiederm@xmission.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/2] sysctl: move umh and keys sysctls
Date: Tue, 30 May 2023 16:29:12 -0700
Message-Id: <20230530232914.3689712-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

If you look at kernel/sysctl.c there are two sysctl arrays which
are declared in header files but registered with no good reason now
on kernel/sysctl.c instead of the place they belong. So just do
the registration where it belongs.

The penalty of this is just 66 bytes for moving both registrations
to its own file, but soon we'll be removing all sysctl empty entries
at each array, and we've already done tons of cleanup on fs/proc/proc_sysctl.c
which saved us hundreds of bytes so we have few karma points.

With this, we no now only have two sysctl arrays left to start clearing
up the kernel one and the vm one.

Luis Chamberlain (2):
  sysctl: move umh sysctl registration to its own file
  sysctl: move security keys sysctl registration to its own file

 include/linux/key.h    |  3 ---
 include/linux/umh.h    |  2 --
 kernel/sysctl.c        |  5 -----
 kernel/umh.c           | 11 ++++++++++-
 security/keys/sysctl.c |  7 +++++++
 5 files changed, 17 insertions(+), 11 deletions(-)

-- 
2.39.2

